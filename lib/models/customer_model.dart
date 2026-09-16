/// A customer in the shop owner's ledger.
///
/// [balancePoysha] is a DERIVED, cached value (not the source of truth).
/// The real balance is always computed from the sum of that customer's
/// transactions, but we cache it here for fast list rendering.
class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String note;
  final String photoUrl;
  final int createdAt; // epoch millis
  final int updatedAt; // epoch millis
  final int balancePoysha; // cached: positive = customer owes shop (due)

  /// Local-only flag: true if this record has local changes not yet
  /// pushed to Firebase Realtime Database.
  final bool pendingSync;

  /// Soft-delete flag so deletions can sync correctly across devices.
  final bool isDeleted;

  const CustomerModel({
    required this.id,
    required this.name,
    this.phone = '',
    this.address = '',
    this.note = '',
    this.photoUrl = '',
    required this.createdAt,
    required this.updatedAt,
    this.balancePoysha = 0,
    this.pendingSync = false,
    this.isDeleted = false,
  });

  CustomerModel copyWith({
    String? name,
    String? phone,
    String? address,
    String? note,
    String? photoUrl,
    int? updatedAt,
    int? balancePoysha,
    bool? pendingSync,
    bool? isDeleted,
  }) {
    return CustomerModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      balancePoysha: balancePoysha ?? this.balancePoysha,
      pendingSync: pendingSync ?? this.pendingSync,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// Converts to a plain map for Firebase Realtime Database / Hive storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'note': note,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'balancePoysha': balancePoysha,
      'isDeleted': isDeleted,
    };
  }

  factory CustomerModel.fromMap(Map<dynamic, dynamic> map, {bool pendingSync = false}) {
    return CustomerModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
      photoUrl: map['photoUrl']?.toString() ?? '',
      createdAt: (map['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (map['updatedAt'] as num?)?.toInt() ?? 0,
      balancePoysha: (map['balancePoysha'] as num?)?.toInt() ?? 0,
      pendingSync: pendingSync,
      isDeleted: map['isDeleted'] == true,
    );
  }
}
