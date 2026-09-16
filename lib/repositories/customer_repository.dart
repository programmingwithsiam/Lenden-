import 'package:uuid/uuid.dart';
import '../core/services/local_db_service.dart';
import '../core/services/sync_service.dart';
import '../models/customer_model.dart';

/// All customer CRUD goes through here. Every write:
/// 1. Saves to local Hive box immediately (works offline).
/// 2. Enqueues the record for background sync to Firebase.
///
/// UI never talks to Firebase directly for customers - it always reads
/// from this repository, which reads from local Hive (instant, offline-safe).
class CustomerRepository {
  final SyncService syncService;
  static const _uuid = Uuid();

  CustomerRepository({required this.syncService});

  List<CustomerModel> getAll({bool includeDeleted = false}) {
    final box = LocalDbService.customerBox;
    final list = box.values
        .map((e) => CustomerModel.fromMap(
              Map<dynamic, dynamic>.from(e),
              pendingSync: (e as Map)['pendingSyncLocal'] == true,
            ))
        .where((c) => includeDeleted || !c.isDeleted)
        .toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  CustomerModel? getById(String id) {
    final data = LocalDbService.customerBox.get(id);
    if (data == null) return null;
    return CustomerModel.fromMap(
      Map<dynamic, dynamic>.from(data),
      pendingSync: (data as Map)['pendingSyncLocal'] == true,
    );
  }

  List<CustomerModel> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAll();
    return getAll().where((c) {
      return c.name.toLowerCase().contains(q) || c.phone.contains(q);
    }).toList();
  }

  /// Creates a new customer. Only [name] is required per product spec.
  Future<CustomerModel> addCustomer({
    required String name,
    String phone = '',
    String address = '',
    String note = '',
    String photoUrl = '',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final customer = CustomerModel(
      id: _uuid.v4(),
      name: name.trim(),
      phone: phone.trim(),
      address: address.trim(),
      note: note.trim(),
      photoUrl: photoUrl,
      createdAt: now,
      updatedAt: now,
      balancePoysha: 0,
    );
    await _saveLocal(customer, pending: true);
    await syncService.enqueue(entity: 'customer', id: customer.id);
    return customer;
  }

  Future<CustomerModel> updateCustomer(
    CustomerModel customer, {
    String? name,
    String? phone,
    String? address,
    String? note,
  }) async {
    final updated = customer.copyWith(
      name: name?.trim(),
      phone: phone?.trim(),
      address: address?.trim(),
      note: note?.trim(),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveLocal(updated, pending: true);
    await syncService.enqueue(entity: 'customer', id: updated.id);
    return updated;
  }

  /// Soft-deletes so the deletion also syncs across devices.
  Future<void> deleteCustomer(String id) async {
    final existing = getById(id);
    if (existing == null) return;
    final deleted = existing.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveLocal(deleted, pending: true);
    await syncService.enqueue(entity: 'customer', id: id);
  }

  /// Recomputes and persists the cached balance for a customer based on
  /// the given signed sum (called by TransactionRepository after any
  /// add/edit/delete of a transaction, so balance is ALWAYS correct).
  Future<void> recalculateBalance(String customerId, int newBalancePoysha) async {
    final existing = getById(customerId);
    if (existing == null) return;
    final updated = existing.copyWith(
      balancePoysha: newBalancePoysha,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveLocal(updated, pending: true);
    await syncService.enqueue(entity: 'customer', id: customerId);
  }

  Future<void> _saveLocal(CustomerModel customer, {required bool pending}) async {
    final map = customer.toMap();
    map['pendingSyncLocal'] = pending;
    await LocalDbService.customerBox.put(customer.id, map);
  }
}
