import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/customer_model.dart';
import '../../providers/app_provider.dart';
import 'add_edit_customer_screen.dart';

/// Simple picker screen: search + select a customer, returns the selected
/// [CustomerModel] via Navigator.pop. Used by dashboard's "+ পাওনা যোগ করুন"
/// and "+ টাকা জমা" quick actions.
class SelectCustomerScreen extends StatefulWidget {
  const SelectCustomerScreen({super.key});

  @override
  State<SelectCustomerScreen> createState() => _SelectCustomerScreenState();
}

class _SelectCustomerScreenState extends State<SelectCustomerScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final customers = _controller.text.isEmpty ? app.customers : app.searchCustomers(_controller.text);

    return Scaffold(
      appBar: AppBar(title: const Text('কাস্টমার নির্বাচন করুন')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'নাম বা ফোন নম্বর দিয়ে খুঁজুন',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: customers.isEmpty
                ? EmptyState(
                    icon: Icons.people_outline,
                    message: 'কোনো কাস্টমার নেই',
                    buttonLabel: '+ নতুন কাস্টমার তৈরি করুন',
                    onButtonPressed: () async {
                      final newCustomer = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()),
                      );
                      if (newCustomer != null && context.mounted) {
                        Navigator.pop(context, newCustomer);
                      }
                    },
                  )
                : ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, i) {
                      final c = customers[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?')),
                        title: Text(c.name),
                        subtitle: c.phone.isNotEmpty ? Text(c.phone) : null,
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
