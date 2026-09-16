import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/share_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../l10n/app_localizations.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_provider.dart';
import '../customers/add_edit_customer_screen.dart';
import '../transactions/add_transaction_screen.dart';

enum _TypeFilter { all, due, payment }

class CustomerLedgerScreen extends StatefulWidget {
  final String customerId;
  const CustomerLedgerScreen({super.key, required this.customerId});

  @override
  State<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  _TypeFilter _filter = _TypeFilter.all;
  final _searchController = TextEditingController();
  static final _dateFmt = DateFormat('dd MMM yyyy');
  static final _timeFmt = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final l10n = AppLocalizations.of(context)!;
    final customer = app.customerById(widget.customerId);

    if (customer == null) {
      return Scaffold(body: Center(child: Text(l10n.customerNotFound)));
    }

    var transactions = app.transactionsForCustomer(customer.id);
    if (_filter == _TypeFilter.due) {
      transactions = transactions.where((t) => t.isDue).toList();
    } else if (_filter == _TypeFilter.payment) {
      transactions = transactions.where((t) => t.isPayment).toList();
    }
    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      transactions = transactions
          .where((t) => t.product.toLowerCase().contains(q) || t.description.toLowerCase().contains(q))
          .toList();
    }

    final isDue = customer.balancePoysha > 0;
    final isAdvance = customer.balancePoysha < 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: l10n.shareReceipt,
            onPressed: () => ShareService.shareCustomerStatementPdf(
              customer: customer,
              transactions: app.transactionsForCustomer(customer.id),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditCustomerScreen(customer: customer)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (customer.phone.isNotEmpty)
                  Row(children: [const Icon(Icons.phone, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(customer.phone)]),
                if (customer.address.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey), const SizedBox(width: 6), Expanded(child: Text(customer.address))]),
                ],
                const SizedBox(height: 12),
                Text(
                  isAdvance ? l10n.advanceBalance : l10n.currentDue,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                Text(
                  CurrencyFormatter.formatPoysha(customer.balancePoysha.abs()),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDue ? AppTheme.danger : (isAdvance ? AppTheme.success : Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: AppTheme.danger, side: const BorderSide(color: AppTheme.danger)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddTransactionScreen(customer: customer, initialType: AppConstants.typeDue)),
                        ),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.due),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddTransactionScreen(customer: customer, initialType: AppConstants.typePayment)),
                        ),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.payment),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.searchProductOrDescription,
                      prefixIcon: Icon(Icons.search, size: 20),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<_TypeFilter>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (v) => setState(() => _filter = v),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: _TypeFilter.all, child: Text(l10n.all)),
                    PopupMenuItem(value: _TypeFilter.due, child: Text(l10n.onlyDue)),
                    PopupMenuItem(value: _TypeFilter.payment, child: Text(l10n.onlyPayment)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? EmptyState(icon: Icons.receipt_long_outlined, message: l10n.noCustomerTransactions)
                : ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  cacheExtent: 700,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    itemCount: transactions.length,
                    itemBuilder: (context, i) {
                      final t = transactions[i];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.96, end: 1),
                        duration: Duration(milliseconds: 180 + (i.clamp(0, 5) * 25)),
                        curve: Curves.easeOutCubic,
                        builder: (context, scale, child) => Transform.scale(
                          scale: scale,
                          alignment: Alignment.topCenter,
                          child: child,
                        ),
                        child: _TransactionTile(
                          txn: t,
                          onTap: () => _showTransactionActions(context, t, customer.name),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showTransactionActions(BuildContext context, TransactionModel t, String customerName) {
    final app = context.read<AppProvider>();
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.ios_share),
              title: Text(l10n.shareReceipt),
              onTap: () {
                Navigator.pop(ctx);
                final customer = app.customerById(t.customerId)!;
                ShareService.shareTransactionReceipt(customer: customer, txn: t);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sms_outlined),
              title: Text(l10n.shareViaSms),
              enabled: app.customerById(t.customerId)?.phone.isNotEmpty ?? false,
              onTap: () {
                Navigator.pop(ctx);
                final customer = app.customerById(t.customerId)!;
                ShareService.shareTransactionViaSms(customer: customer, txn: t);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_outlined, color: Color(0xFF159A8C)),
              title: Text(l10n.shareViaWhatsApp),
              enabled: app.customerById(t.customerId)?.phone.isNotEmpty ?? false,
              onTap: () {
                Navigator.pop(ctx);
                final customer = app.customerById(t.customerId)!;
                ShareService.shareTransactionViaWhatsApp(customer: customer, txn: t);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: Text(l10n.downloadPdf),
              onTap: () async {
                Navigator.pop(ctx);
                final customer = app.customerById(t.customerId)!;
                await ShareService.downloadCustomerStatementPdf(
                  customer: customer,
                  transactions: app.transactionsForCustomer(customer.id),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.editTransaction),
              onTap: () {
                Navigator.pop(ctx);
                final customer = app.customerById(t.customerId)!;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTransactionScreen(customer: customer, editTransaction: t)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppTheme.danger),
              title: Text(l10n.deleteTransaction, style: const TextStyle(color: AppTheme.danger)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showConfirmDialog(
                  context,
                  title: AppLocalizations.of(context)!.deleteTransactionTitle,
                  message: AppLocalizations.of(context)!.deleteTransactionMessage,
                  confirmLabel: AppLocalizations.of(context)!.deleteTransaction,
                );
                if (confirmed) {
                  await app.deleteTransaction(t.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel txn;
  final VoidCallback onTap;
  const _TransactionTile({required this.txn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(txn.date);
    final dateFmt = DateFormat('dd MMM yyyy');
    final timeFmt = DateFormat('hh:mm a');
    final color = txn.isDue ? AppTheme.danger : AppTheme.success;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(txn.isDue ? Icons.arrow_upward : Icons.arrow_downward, color: color, size: 18),
        ),
        title: Text(
            txn.product.isNotEmpty
              ? txn.product
              : (txn.isDue ? AppLocalizations.of(context)!.due : AppLocalizations.of(context)!.payment),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dateFmt.format(date)} • ${timeFmt.format(date)}', style: const TextStyle(fontSize: 12)),
            if (txn.description.isNotEmpty) Text(txn.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (txn.pendingSync)
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(AppLocalizations.of(context)!.syncPending, style: TextStyle(fontSize: 10.5, color: AppTheme.warning)),
              ),
          ],
        ),
        isThreeLine: txn.description.isNotEmpty || txn.pendingSync,
        trailing: Text(
          CurrencyFormatter.formatPoysha(txn.amountPoysha),
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
