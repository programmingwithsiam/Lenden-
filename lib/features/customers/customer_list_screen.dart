import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../l10n/app_localizations.dart';
import '../../models/customer_model.dart';
import '../../providers/app_provider.dart';
import '../ledger/customer_ledger_screen.dart';
import 'add_edit_customer_screen.dart';

enum _SortOption { recent, nameAsc, balanceDesc }

class CustomerListScreen extends StatefulWidget {
  final bool autoFocusSearch;
  const CustomerListScreen({super.key, this.autoFocusSearch = false});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final _searchController = TextEditingController();
  _SortOption _sort = _SortOption.recent;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final l10n = AppLocalizations.of(context)!;
    List<CustomerModel> customers = _searchController.text.isEmpty
        ? app.customers
        : app.searchCustomers(_searchController.text);

    customers = List.from(customers);
    switch (_sort) {
      case _SortOption.nameAsc:
        customers.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _SortOption.balanceDesc:
        customers.sort((a, b) => b.balancePoysha.compareTo(a.balancePoysha));
        break;
      case _SortOption.recent:
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerList),
        actions: [
          PopupMenuButton<_SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => _sort = v),
            itemBuilder: (_) => [
              PopupMenuItem(value: _SortOption.recent, child: Text(l10n.recent)),
              PopupMenuItem(value: _SortOption.nameAsc, child: Text(l10n.nameAZ)),
              PopupMenuItem(value: _SortOption.balanceDesc, child: Text(l10n.highestDue)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditCustomerScreen())),
        icon: const Icon(Icons.person_add_alt_1),
        label: Text(l10n.newCustomer),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              autofocus: widget.autoFocusSearch,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.searchCustomerByNameOrPhone,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchController.clear()),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: customers.isEmpty
                ? EmptyState(
                    icon: Icons.people_outline,
                    message: _searchController.text.isNotEmpty
                        ? l10n.noCustomersFound
                        : l10n.noCustomersYet,
                      buttonLabel: _searchController.text.isEmpty ? '+ ${l10n.newCustomer}' : null,
                    onButtonPressed: _searchController.text.isEmpty
                        ? () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()))
                        : null,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
                    itemCount: customers.length,
                    itemBuilder: (context, i) {
                      final c = customers[i];
                      final isDue = c.balancePoysha > 0;
                      final isAdvance = c.balancePoysha < 0;
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primary.withOpacity(0.12),
                            child: Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: c.phone.isNotEmpty ? Text(c.phone) : null,
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isAdvance
                                    ? CurrencyFormatter.formatPoysha(c.balancePoysha.abs())
                                    : CurrencyFormatter.formatPoysha(c.balancePoysha),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDue ? AppTheme.danger : (isAdvance ? AppTheme.success : Colors.grey),
                                ),
                              ),
                              Text(
                                isDue ? l10n.due : (isAdvance ? l10n.advance : l10n.clearBalance),
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CustomerLedgerScreen(customerId: c.id)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
