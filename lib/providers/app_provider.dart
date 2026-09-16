import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../core/services/local_db_service.dart';
import '../core/services/sync_service.dart';
import '../models/customer_model.dart';
import '../models/transaction_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/customer_repository.dart';
import '../repositories/transaction_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// The single source of truth for the whole app's data + auth state.
///
/// Kept intentionally as one provider (rather than many small ones) so a
/// non-expert maintainer only has one place to look for "how does data flow
/// through this app".
class AppProvider extends ChangeNotifier {
  final AuthRepository authRepository = AuthRepository();

  AuthStatus authStatus = AuthStatus.unknown;
  User? currentUser;
  bool isNewUser = false;

  CustomerRepository? customerRepository;
  TransactionRepository? transactionRepository;
  SyncService? syncService;

  List<CustomerModel> customers = [];
  List<TransactionModel> allTransactions = [];

  String syncStatus = AppConstants.syncStatusSynced;
  String? authErrorMessage;
  bool isSigningIn = false;

  AppProvider() {
    authRepository.authStateChanges.listen(_handleAuthChange);
  }

  Future<void> _handleAuthChange(User? user) async {
    if (user == null) {
      await _teardownSession();
      currentUser = null;
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    currentUser = user;
    isNewUser = authRepository.isFirstTimeUserSession;
    await _setupSession(user.uid);
    authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> _setupSession(String uid) async {
    await LocalDbService.openUserBoxes(uid);

    syncService = SyncService(uid: uid);
    syncService!.onRemoteDataChanged = () {
      _refreshCustomers();
      _refreshTransactions();
      notifyListeners();
    };
    syncService!.syncStatus.addListener(_onSyncStatusChanged);
    await syncService!.start();

    customerRepository = CustomerRepository(syncService: syncService!);
    transactionRepository = TransactionRepository(
      syncService: syncService!,
      customerRepository: customerRepository!,
    );

    _refreshCustomers();
    _refreshTransactions();
  }

  Future<void> _teardownSession() async {
    syncService?.syncStatus.removeListener(_onSyncStatusChanged);
    syncService?.dispose();
    syncService = null;
    customerRepository = null;
    transactionRepository = null;
    customers = [];
    allTransactions = [];
    await LocalDbService.closeUserBoxes();
  }

  void _onSyncStatusChanged() {
    syncStatus = syncService?.syncStatus.value ?? AppConstants.syncStatusSynced;
    notifyListeners();
  }

  void _refreshCustomers() {
    customers = customerRepository?.getAll() ?? [];
  }

  void _refreshTransactions() {
    allTransactions = transactionRepository?.getAll() ?? [];
  }

  // ------------------------------- Auth ---------------------------------

  Future<bool> signInWithGoogle() async {
    isSigningIn = true;
    authErrorMessage = null;
    notifyListeners();
    try {
      await authRepository.signInWithGoogle();
      isSigningIn = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSigningIn = false;
      authErrorMessage = e.toString();
      debugPrint('LOGIN ERROR: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }

  // ----------------------------- Customers -------------------------------

  Future<CustomerModel?> addCustomer({
    required String name,
    String phone = '',
    String address = '',
    String note = '',
  }) async {
    if (customerRepository == null) return null;
    final c = await customerRepository!.addCustomer(
      name: name,
      phone: phone,
      address: address,
      note: note,
    );
    _refreshCustomers();
    notifyListeners();
    return c;
  }

  Future<void> updateCustomer(CustomerModel customer,
      {String? name, String? phone, String? address, String? note}) async {
    if (customerRepository == null) return;
    await customerRepository!.updateCustomer(customer,
        name: name, phone: phone, address: address, note: note);
    _refreshCustomers();
    notifyListeners();
  }

  Future<void> deleteCustomer(String id) async {
    if (customerRepository == null) return;
    await customerRepository!.deleteCustomer(id);
    _refreshCustomers();
    _refreshTransactions();
    notifyListeners();
  }

  List<CustomerModel> searchCustomers(String query) {
    return customerRepository?.search(query) ?? [];
  }

  // ---------------------------- Transactions ------------------------------

  List<TransactionModel> transactionsForCustomer(String customerId) {
    return transactionRepository?.getAllForCustomer(customerId) ?? [];
  }

  Future<void> addTransaction({
    required String customerId,
    required String type,
    required int amountPoysha,
    String product = '',
    String quantity = '',
    String description = '',
    String paymentMethod = '',
    required int date,
    String note = '',
  }) async {
    if (transactionRepository == null) return;
    await transactionRepository!.addTransaction(
      customerId: customerId,
      type: type,
      amountPoysha: amountPoysha,
      product: product,
      quantity: quantity,
      description: description,
      paymentMethod: paymentMethod,
      date: date,
      note: note,
    );
    _refreshCustomers();
    _refreshTransactions();
    notifyListeners();
  }

  Future<void> updateTransaction(
    TransactionModel txn, {
    String? type,
    int? amountPoysha,
    String? product,
    String? quantity,
    String? description,
    String? paymentMethod,
    int? date,
    String? note,
  }) async {
    if (transactionRepository == null) return;
    await transactionRepository!.updateTransaction(
      txn,
      type: type,
      amountPoysha: amountPoysha,
      product: product,
      quantity: quantity,
      description: description,
      paymentMethod: paymentMethod,
      date: date,
      note: note,
    );
    _refreshCustomers();
    _refreshTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    if (transactionRepository == null) return;
    await transactionRepository!.deleteTransaction(id);
    _refreshCustomers();
    _refreshTransactions();
    notifyListeners();
  }

  // ----------------------------- Dashboard --------------------------------

  int get totalCustomers => customers.length;

  int get totalReceivablePoysha =>
      customers.where((c) => c.balancePoysha > 0).fold(0, (s, c) => s + c.balancePoysha);

  int get totalAdvancePoysha => customers
      .where((c) => c.balancePoysha < 0)
      .fold(0, (s, c) => s + c.balancePoysha.abs());

  bool _isToday(int ms) {
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  List<TransactionModel> get todayTransactions =>
      allTransactions.where((t) => _isToday(t.date)).toList();

  int get todayCollectionPoysha => todayTransactions
      .where((t) => t.isPayment)
      .fold(0, (s, t) => s + t.amountPoysha);

  int get todayDuePoysha =>
      todayTransactions.where((t) => t.isDue).fold(0, (s, t) => s + t.amountPoysha);

  List<TransactionModel> get recentTransactions {
    final list = List<TransactionModel>.from(allTransactions);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.take(10).toList();
  }

  CustomerModel? customerById(String id) {
    try {
      return customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return customerRepository?.getById(id);
    }
  }
}
