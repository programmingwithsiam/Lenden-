import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'dashboard/dashboard_screen.dart';
import 'customers/customer_list_screen.dart';
import 'transactions/all_transactions_screen.dart';
import 'reports/reports_screen.dart';
import 'settings/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    CustomerListScreen(),
    AllTransactionsScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navLabels = [
      l10n.dashboard,
      l10n.customers,
      l10n.transactions,
      l10n.reports,
      l10n.settings,
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: navLabels[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_alt_outlined),
            selectedIcon: const Icon(Icons.people_alt_rounded),
            label: navLabels[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: navLabels[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart_rounded),
            label: navLabels[3],
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: navLabels[4],
          ),
        ],
      ),
    );
  }
}
