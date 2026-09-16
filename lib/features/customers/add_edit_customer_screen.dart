import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../l10n/app_localizations.dart';
import '../../models/customer_model.dart';
import '../../providers/app_provider.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final CustomerModel? customer; // null = adding new
  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _note;
  bool _saving = false;

  bool get _isEdit => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.customer?.name ?? '');
    _phone = TextEditingController(text: widget.customer?.phone ?? '');
    _address = TextEditingController(text: widget.customer?.address ?? '');
    _note = TextEditingController(text: widget.customer?.note ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final app = context.read<AppProvider>();
    try {
      if (_isEdit) {
        await app.updateCustomer(
          widget.customer!,
          name: _name.text,
          phone: _phone.text,
          address: _address.text,
          note: _note.text,
        );
        if (mounted) Navigator.pop(context);
      } else {
        final created = await app.addCustomer(
          name: _name.text,
          phone: _phone.text,
          address: _address.text,
          note: _note.text,
        );
        if (mounted) Navigator.pop(context, created);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteCustomerTitle,
      message: l10n.deleteCustomerMessage(widget.customer!.name),
      confirmLabel: l10n.deleteCustomerConfirm,
    );
    if (confirmed && mounted) {
      await context.read<AppProvider>().deleteCustomer(widget.customer!.id);
      if (mounted) {
        Navigator.pop(context); // close edit screen
        Navigator.pop(context); // close ledger screen if opened from there
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.edit : l10n.newCustomer),
        actions: [
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              validator: Validators.customerName,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.customerNameRequired,
                hintText: l10n.customerNameHint,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phone,
              validator: Validators.phoneOptional,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.phoneOptional,
                hintText: '01XXXXXXXXX',
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _address,
              decoration: InputDecoration(
                labelText: l10n.addressOptional,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _note,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.noteOptional,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_isEdit ? l10n.save : l10n.newCustomer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
