import 'dart:io';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/customer_model.dart';
import '../../models/transaction_model.dart';
import '../constants/app_constants.dart';
import '../utils/currency_formatter.dart';

class ShareService {
  ShareService._();

  static final DateFormat _dateFmt = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFmt = DateFormat('hh:mm a');

  /// Builds a plain-text receipt for a single transaction and opens the
  /// native Android share sheet (WhatsApp, Messenger, SMS, Email, etc.)
  static Future<void> shareTransactionReceipt({
    required CustomerModel customer,
    required TransactionModel txn,
  }) async {
    await Share.share(_transactionReceiptText(customer: customer, txn: txn));
  }

  static Future<void> shareTransactionViaSms({
    required CustomerModel customer,
    required TransactionModel txn,
  }) async {
    if (customer.phone.isEmpty) return;
    final uri = Uri(
      scheme: 'sms',
      path: customer.phone,
      queryParameters: {'body': _transactionReceiptText(customer: customer, txn: txn)},
    );
    await launchUrl(uri);
  }

  static Future<void> shareTransactionViaWhatsApp({
    required CustomerModel customer,
    required TransactionModel txn,
  }) async {
    if (customer.phone.isEmpty) return;
    final phone = customer.phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse(
      'https://wa.me/${phone.replaceFirst('+', '')}?text=${Uri.encodeComponent(_transactionReceiptText(customer: customer, txn: txn))}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static String _transactionReceiptText({
    required CustomerModel customer,
    required TransactionModel txn,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(txn.date);
    final buffer = StringBuffer();
    buffer.writeln(AppConstants.appName);
    buffer.writeln('--------------------');
    buffer.writeln('Customer: ${customer.name}');
    if (customer.phone.isNotEmpty) buffer.writeln('Phone: ${customer.phone}');
    buffer.writeln('');
    buffer.writeln('Date: ${_dateFmt.format(date)}');
    buffer.writeln('Time: ${_timeFmt.format(date)}');
    buffer.writeln('');
    if (txn.product.isNotEmpty) buffer.writeln('পণ্য: ${txn.product}');
    if (txn.quantity.isNotEmpty) buffer.writeln('পরিমাণ: ${txn.quantity}');
    if (txn.isDue) {
      buffer.writeln('পাওনা: ${CurrencyFormatter.formatPoysha(txn.amountPoysha)}');
    } else {
      buffer.writeln('জমা: ${CurrencyFormatter.formatPoysha(txn.amountPoysha)}');
      if (txn.paymentMethod.isNotEmpty) buffer.writeln('মাধ্যম: ${txn.paymentMethod}');
    }
    if (txn.description.isNotEmpty) buffer.writeln('বিবরণ: ${txn.description}');
    buffer.writeln('');
    buffer.writeln('বর্তমান বাকি: ${CurrencyFormatter.formatPoysha(customer.balancePoysha)}');
    buffer.writeln('--------------------');

    return buffer.toString();
  }

  /// Generates a full customer statement as a PDF and opens the native
  /// share sheet with the PDF file attached.
  static Future<void> shareCustomerStatementPdf({
    required CustomerModel customer,
    required List<TransactionModel> transactions,
  }) async {
    final file = await _createCustomerStatementPdf(
      customer: customer,
      transactions: transactions,
    );
    await Share.shareXFiles(
      [XFile(file.path)],
      text: '${customer.name} - Statement',
    );
  }

  static Future<void> downloadCustomerStatementPdf({
    required CustomerModel customer,
    required List<TransactionModel> transactions,
  }) async {
    final file = await _createCustomerStatementPdf(
      customer: customer,
      transactions: transactions,
    );
    await OpenFilex.open(file.path);
  }

  static Future<File> _createCustomerStatementPdf({
    required CustomerModel customer,
    required List<TransactionModel> transactions,
  }) async {
    final doc = pw.Document();
    final totalDue = transactions
        .where((t) => t.isDue)
        .fold<int>(0, (s, t) => s + t.amountPoysha);
    final totalPaid = transactions
        .where((t) => t.isPayment)
        .fold<int>(0, (s, t) => s + t.amountPoysha);

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            AppConstants.appNameEn,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Divider(),
          pw.Text('Customer: ${customer.name}'),
          if (customer.phone.isNotEmpty)
            pw.Text('Phone: ${customer.phone}'),
          if (customer.address.isNotEmpty)
            pw.Text('Address: ${customer.address}'),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Due: ${CurrencyFormatter.formatPoysha(totalDue)}',
              ),
              pw.Text(
                'Total Paid: ${CurrencyFormatter.formatPoysha(totalPaid)}',
              ),
            ],
          ),
          pw.Text(
            'Current Balance: ${CurrencyFormatter.formatPoysha(customer.balancePoysha)}',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Date', 'Type', 'Details', 'Amount'],
            data: transactions.map((t) {
              final date = DateTime.fromMillisecondsSinceEpoch(t.date);
              final typeLabel = t.isDue ? 'Due' : 'Payment';
              final details =
                  t.product.isNotEmpty ? t.product : t.description;

              return [
                _dateFmt.format(date),
                typeLabel,
                details,
                CurrencyFormatter.formatPoysha(t.amountPoysha),
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/statement_${customer.name}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(bytes);

    return file;
  }
}
