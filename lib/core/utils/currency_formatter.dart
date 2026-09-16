import 'package:intl/intl.dart';

/// Handles all money formatting/parsing.
///
/// IMPORTANT: All amounts are stored internally as integer "poysha"
/// (1 Taka = 100 poysha) to avoid floating point rounding errors.
/// UI always converts to/from Taka for display and input.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _bdFormat = NumberFormat.decimalPattern('en_IN');

  /// Converts a Taka amount (double, e.g. from a text field) into
  /// safe integer poysha for storage.
  static int taakaToPoysha(double taka) {
    return (taka * 100).round();
  }

  /// Converts stored integer poysha back into Taka (double) for math/display.
  static double poyshaToTaka(int poysha) {
    return poysha / 100.0;
  }

  /// Formats integer poysha directly into a display string like "৳ ১,২৫,৫০০".
  /// Uses Bangladesh-style (lakh/crore) grouping via en_IN pattern, prefixed with ৳.
  static String formatPoysha(int poysha) {
    final taka = poyshaToTaka(poysha);
    return formatTaka(taka);
  }

  /// Formats a Taka double into a display string with ৳ symbol and
  /// Bangladesh-style thousand/lakh separators. Shows no decimals if whole.
  static String formatTaka(double taka) {
    final isWhole = taka == taka.roundToDouble();
    final formatted = isWhole
        ? _bdFormat.format(taka.round())
        : NumberFormat('#,##0.00', 'en_IN').format(taka);
    return '৳$formatted';
  }

  /// Parses user input text (e.g. "1500" or "1,500.50") into a safe double.
  /// Returns null if invalid or negative.
  static double? parseInput(String input) {
    final cleaned = input.replaceAll(',', '').replaceAll('৳', '').trim();
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null || value < 0) return null;
    return value;
  }
}
