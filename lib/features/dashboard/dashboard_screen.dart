import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/sync_status_badge.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../customers/add_edit_customer_screen.dart';
import '../customers/customer_list_screen.dart';
import '../customers/select_customer_screen.dart';
import '../ledger/customer_ledger_screen.dart';
import '../transactions/add_transaction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final userName = app.currentUser?.displayName?.split(' ').first ?? '';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName.isNotEmpty ? '${l10n.welcomeBack}, $userName' : l10n.appName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              l10n.businessOverview,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SyncStatusBadge(status: app.syncStatus),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await app.syncService?.pushPendingChanges();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isWide ? 32 : 16,
                10,
                isWide ? 32 : 16,
                28,
              ),
              children: [
                _BalanceCard(app: app),
                const SizedBox(height: 18),
                _QuickActions(app: app, isWide: isWide),
                const SizedBox(height: 24),
                _RecentTransactions(app: app),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final AppProvider app;

  const _BalanceCard({required this.app});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final balance = app.totalReceivablePoysha - app.totalAdvancePoysha;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF173F5F),
            const Color(0xFF159A8C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173F5F).withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.currentBalance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            CurrencyFormatter.formatPoysha(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${l10n.totalCustomers}: ${app.totalCustomers}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.16),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _BalanceMiniStat(
                  icon: Icons.arrow_upward_rounded,
                  label: l10n.received,
                  value: CurrencyFormatter.formatPoysha(app.totalReceivablePoysha),
                ),
              ),
              Container(
                width: 1,
                height: 38,
                color: Colors.white.withValues(alpha: 0.16),
              ),
              Expanded(
                child: _BalanceMiniStat(
                  icon: Icons.arrow_downward_rounded,
                  label: l10n.owed,
                  value: CurrencyFormatter.formatPoysha(app.totalAdvancePoysha),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceMiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BalanceMiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 17,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final AppProvider app;
  final bool isWide;

  const _QuickActions({
    required this.app,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.quickActions,
          subtitle: l10n.quickActionsSubtitle,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: isWide ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: isWide ? 1.7 : 1.5,
          children: [
            _ActionCard(
              icon: Icons.person_add_alt_1_rounded,
              title: l10n.newCustomer,
              subtitle: l10n.createCustomer,
              color: AppTheme.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddEditCustomerScreen(),
                  ),
                );
              },
            ),
            _ActionCard(
              icon: Icons.add_card_rounded,
              title: l10n.addDue,
              subtitle: l10n.trackDues,
              color: AppTheme.danger,
              onTap: () => _pickCustomerThenAdd(
                context,
                AppConstants.typeDue,
              ),
            ),
            _ActionCard(
              icon: Icons.payments_rounded,
              title: l10n.addPayment,
              subtitle: l10n.logPayment,
              color: AppTheme.success,
              onTap: () => _pickCustomerThenAdd(
                context,
                AppConstants.typePayment,
              ),
            ),
            _ActionCard(
              icon: Icons.search_rounded,
              title: l10n.findCustomer,
              subtitle: l10n.searchQuickly,
              color: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerListScreen(
                      autoFocusSearch: true,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickCustomerThenAdd(
    BuildContext context,
    String type,
  ) async {
    final customer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectCustomerScreen(),
      ),
    );

    if (customer != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddTransactionScreen(
            customer: customer,
            initialType: type,
          ),
        ),
      );
    }
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatefulWidget {
  final AppProvider app;

  const _RecentTransactions({required this.app});

  @override
  State<_RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<_RecentTransactions> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final app = widget.app;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.recentTransactions,
          subtitle: l10n.latestActivity,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (app.recentTransactions.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerListScreen(),
                      ),
                    );
                  },
                  child: Text(l10n.seeAll),
                ),
              IconButton(
                tooltip: _isExpanded ? l10n.hide : l10n.show,
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: AnimatedRotation(
                  turns: _isExpanded ? 0 : 0.5,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(Icons.keyboard_arrow_up_rounded),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (!_isExpanded)
          const SizedBox.shrink()
        else if (app.recentTransactions.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.45),
              ),
            ),
            child: EmptyState(
              icon: Icons.receipt_long_outlined,
              message: l10n.noTransactions,
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.45),
              ),
            ),
            child: Column(
              children: [
                ...app.recentTransactions.take(6).map((t) {
                  final customer = app.customerById(t.customerId);
                  final isDue = t.isDue;
                  final color = isDue ? AppTheme.danger : AppTheme.success;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        onTap: () {
                          if (customer != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerLedgerScreen(
                                  customerId: customer.id,
                                ),
                              ),
                            );
                          }
                        },
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDue ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            color: color,
                            size: 19,
                          ),
                        ),
                        title: Text(
                          customer?.name ?? l10n.unknownCustomer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            t.product.isNotEmpty
                                ? t.product
                                : t.description.isNotEmpty
                                    ? t.description
                                    : isDue
                                        ? l10n.due
                                        : l10n.payment,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormatter.formatPoysha(t.amountPoysha),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isDue ? l10n.due : l10n.payment,
                              style: TextStyle(
                                fontSize: 10,
                                color: color.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (t != app.recentTransactions.take(6).last)
                        Divider(
                          height: 1,
                          indent: 70,
                          endIndent: 14,
                          color: theme.dividerColor.withValues(alpha: 0.5),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
