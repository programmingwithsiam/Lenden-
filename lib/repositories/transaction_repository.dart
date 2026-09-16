import 'package:uuid/uuid.dart';
import '../core/services/local_db_service.dart';
import '../core/services/sync_service.dart';
import '../models/transaction_model.dart';
import 'customer_repository.dart';

/// All transaction ("পাওনা" / "জমা") CRUD goes through here.
///
/// CRITICAL RULE: a customer's balance is NEVER stored as a free-standing
/// number that can drift. Every time a transaction is added, edited, or
/// deleted, we recompute the customer's balance from scratch as the sum
/// of every non-deleted transaction's signed amount. This guarantees the
/// balance can never become incorrect, no matter how many edits happen.
class TransactionRepository {
  final SyncService syncService;
  final CustomerRepository customerRepository;
  static const _uuid = Uuid();

  TransactionRepository({
    required this.syncService,
    required this.customerRepository,
  });

  List<TransactionModel> getAllForCustomer(String customerId, {bool includeDeleted = false}) {
    final box = LocalDbService.transactionBox;
    final list = box.values
        .map((e) => TransactionModel.fromMap(
              Map<dynamic, dynamic>.from(e),
              pendingSync: (e as Map)['pendingSyncLocal'] == true,
            ))
        .where((t) => t.customerId == customerId && (includeDeleted || !t.isDeleted))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<TransactionModel> getAll({bool includeDeleted = false}) {
    final box = LocalDbService.transactionBox;
    final list = box.values
        .map((e) => TransactionModel.fromMap(
              Map<dynamic, dynamic>.from(e),
              pendingSync: (e as Map)['pendingSyncLocal'] == true,
            ))
        .where((t) => includeDeleted || !t.isDeleted)
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  TransactionModel? getById(String id) {
    final data = LocalDbService.transactionBox.get(id);
    if (data == null) return null;
    return TransactionModel.fromMap(
      Map<dynamic, dynamic>.from(data),
      pendingSync: (data as Map)['pendingSyncLocal'] == true,
    );
  }

  Future<TransactionModel> addTransaction({
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
    final now = DateTime.now().millisecondsSinceEpoch;
    final txn = TransactionModel(
      id: _uuid.v4(),
      customerId: customerId,
      type: type,
      amountPoysha: amountPoysha,
      product: product.trim(),
      quantity: quantity.trim(),
      description: description.trim(),
      paymentMethod: paymentMethod,
      date: date,
      note: note.trim(),
      createdAt: now,
      updatedAt: now,
    );
    await _saveLocal(txn, pending: true);
    await syncService.enqueue(entity: 'transaction', id: txn.id);
    await _recalculateCustomerBalance(customerId);
    return txn;
  }

  Future<TransactionModel> updateTransaction(
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
    final updated = txn.copyWith(
      type: type,
      amountPoysha: amountPoysha,
      product: product?.trim(),
      quantity: quantity?.trim(),
      description: description?.trim(),
      paymentMethod: paymentMethod,
      date: date,
      note: note?.trim(),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveLocal(updated, pending: true);
    await syncService.enqueue(entity: 'transaction', id: updated.id);
    await _recalculateCustomerBalance(updated.customerId);
    return updated;
  }

  Future<void> deleteTransaction(String id) async {
    final existing = getById(id);
    if (existing == null) return;
    final deleted = existing.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveLocal(deleted, pending: true);
    await syncService.enqueue(entity: 'transaction', id: id);
    await _recalculateCustomerBalance(existing.customerId);
  }

  Future<void> _recalculateCustomerBalance(String customerId) async {
    final txns = getAllForCustomer(customerId);
    final balance = txns.fold<int>(0, (sum, t) => sum + t.signedAmountPoysha);
    await customerRepository.recalculateBalance(customerId, balance);
  }

  Future<void> _saveLocal(TransactionModel txn, {required bool pending}) async {
    final map = txn.toMap();
    map['pendingSyncLocal'] = pending;
    await LocalDbService.transactionBox.put(txn.id, map);
  }

  // ------------------------- Reports helpers ---------------------------

  List<TransactionModel> getForDateRange(DateTime start, DateTime end) {
    final startMs = DateTime(start.year, start.month, start.day).millisecondsSinceEpoch;
    final endMs = DateTime(end.year, end.month, end.day, 23, 59, 59).millisecondsSinceEpoch;
    return getAll().where((t) => t.date >= startMs && t.date <= endMs).toList();
  }
}
