import '../core/constants/app_constants.dart';

/// A single ledger entry: either a "due" (পাওনা) or a "payment" (জমা).
class TransactionModel {
  final String id;
  final String customerId;
  final String type; // AppConstants.typeDue or typePayment
  final int amountPoysha; // always positive; sign decided by `type`
  final String product;
  final String quantity;
  final String description;
  final String paymentMethod; // only relevant for payment type
  final int date; // epoch millis of the transaction's date/time (user-editable)
  final String note;
  final int createdAt;
  final int updatedAt;
  final bool pendingSync;
  final bool isDeleted;

  const TransactionModel({
    required this.id,
    required this.customerId,
    required this.type,
    required this.amountPoysha,
    this.product = '',
    this.quantity = '',
    this.description = '',
    this.paymentMethod = '',
    required this.date,
    this.note = '',
    required this.createdAt,
    required this.updatedAt,
    this.pendingSync = false,
    this.isDeleted = false,
  });

  bool get isDue => type == AppConstants.typeDue;
  bool get isPayment => type == AppConstants.typePayment;

  /// Signed effect on customer balance: due increases balance, payment decreases it.
  int get signedAmountPoysha => isDue ? amountPoysha : -amountPoysha;

  TransactionModel copyWith({
    String? type,
    int? amountPoysha,
    String? product,
    String? quantity,
    String? description,
    String? paymentMethod,
    int? date,
    String? note,
    int? updatedAt,
    bool? pendingSync,
    bool? isDeleted,
  }) {
    return TransactionModel(
      id: id,
      customerId: customerId,
      type: type ?? this.type,
      amountPoysha: amountPoysha ?? this.amountPoysha,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pendingSync: pendingSync ?? this.pendingSync,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'type': type,
      'amountPoysha': amountPoysha,
      'product': product,
      'quantity': quantity,
      'description': description,
      'paymentMethod': paymentMethod,
      'date': date,
      'note': note,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isDeleted': isDeleted,
    };
  }

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map, {bool pendingSync = false}) {
    return TransactionModel(
      id: map['id']?.toString() ?? '',
      customerId: map['customerId']?.toString() ?? '',
      type: map['type']?.toString() ?? AppConstants.typeDue,
      amountPoysha: (map['amountPoysha'] as num?)?.toInt() ?? 0,
      product: map['product']?.toString() ?? '',
      quantity: map['quantity']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      paymentMethod: map['paymentMethod']?.toString() ?? '',
      date: (map['date'] as num?)?.toInt() ?? 0,
      note: map['note']?.toString() ?? '',
      createdAt: (map['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (map['updatedAt'] as num?)?.toInt() ?? 0,
      pendingSync: pendingSync,
      isDeleted: map['isDeleted'] == true,
    );
  }
}
