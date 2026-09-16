class Validators {
  Validators._();

  /// Customer name is the only mandatory field for a customer.
  static String? customerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'কাস্টমারের নাম আবশ্যক';
    }
    if (value.trim().length < 2) {
      return 'সঠিক নাম দিন';
    }
    return null;
  }

  /// Phone number is optional, but if entered must look like a valid
  /// Bangladeshi mobile number (11 digits, starts with 01).
  static String? phoneOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final cleaned = value.replaceAll(RegExp(r'\s|-'), '');
    final regex = RegExp(r'^01[3-9]\d{8}$');
    if (!regex.hasMatch(cleaned)) {
      return 'সঠিক মোবাইল নম্বর দিন (যেমন: 01712345678)';
    }
    return null;
  }

  /// Amount must be a positive number (0 not allowed for a transaction).
  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'পরিমাণ আবশ্যক';
    }
    final cleaned = value.replaceAll(',', '').trim();
    final parsed = double.tryParse(cleaned);
    if (parsed == null) {
      return 'সঠিক সংখ্যা দিন';
    }
    if (parsed <= 0) {
      return 'পরিমাণ অবশ্যই শূন্যের বেশি হতে হবে';
    }
    return null;
  }
}
