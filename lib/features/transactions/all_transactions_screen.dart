import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../ledger/customer_ledger_screen.dart';

enum _RangeFilter { today, week, month, all }

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  _RangeFilter _range = _RangeFilter.all;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final l10n = AppLocalizations.of(context)!;
    var transactions = List.from(app.allTransactions);

    final now = DateTime.now();
    if (_range == _RangeFilter.today) {
      transactions = transactions.where((t) {
        final d = DateTime.fromMillisecondsSinceEpoch(t.date);
        return d.year == now.year && d.month == now.month && d.day == now.day;
      }).toList();
    } else if (_range == _RangeFilter.week) {
      final weekAgo = now.subtract(const Duration(days: 7));
      transactions = transactions.where((t) => t.date >= weekAgo.millisecondsSinceEpoch).toList();
    } else if (_range == _RangeFilter.month) {
      transactions = transactions.where((t) {
        final d = DateTime.fromMillisecondsSinceEpoch(t.date);
        return d.year == now.year && d.month == now.month;
      }).toList();
    }

    final dateFmt = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.filterAllTransactions),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _chip(l10n.today, _RangeFilter.today),
                  _chip(l10n.thisWeek, _RangeFilter.week),
                  _chip(l10n.thisMonth, _RangeFilter.month),
                  _chip(l10n.all, _RangeFilter.all),
                ],
              ),
            ),
          ),
        ),
      ),
      body: transactions.isEmpty
          ? EmptyState(icon: Icons.receipt_long_outlined, message: l10n.noTransactionsInPeriod)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              itemCount: transactions.length,
              itemBuilder: (context, i) {
                final t = transactions[i];
                final customer = app.customerById(t.customerId);
                final color = t.isDue ? AppTheme.danger : AppTheme.success;
                return Card(
                  child: ListTile(
                    onTap: customer != null
                        ? () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => CustomerLedgerScreen(customerId: customer.id)))
                        : null,
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.12),
                      child: Icon(t.isDue ? Icons.arrow_upward : Icons.arrow_downward, color: color, size: 18),
                    ),
                    title: Text(customer?.name ?? l10n.unknownCustomer, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${dateFmt.format(DateTime.fromMillisecondsSinceEpoch(t.date))}${t.product.isNotEmpty ? ' • ${t.product}' : ''}'),
                    trailing: Text(
                      CurrencyFormatter.formatPoysha(t.amountPoysha),
                      style: TextStyle(fontWeight: FontWeight.bold, color: color),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _chip(String label, _RangeFilter value) {
    final selected = _range == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _range = value),
      ),
    );
  }
}
