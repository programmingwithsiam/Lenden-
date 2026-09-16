import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/validators.dart';
import '../../l10n/app_localizations.dart';
import '../../models/customer_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final CustomerModel customer;
  final String initialType;
  final TransactionModel? editTransaction; // non-null when editing

  const AddTransactionScreen({
    super.key,
    required this.customer,
    this.initialType = AppConstants.typeDue,
    this.editTransaction,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late final TextEditingController _amount;
  late final TextEditingController _product;
  late final TextEditingController _quantity;
  late final TextEditingController _description;
  late final TextEditingController _note;
  String _paymentMethod = AppConstants.paymentMethods.first;
  late DateTime _dateTime;
  bool _saving = false;

  bool get _isEdit => widget.editTransaction != null;

  @override
  void initState() {
    super.initState();
    final t = widget.editTransaction;
    _type = t?.type ?? widget.initialType;
    _amount = TextEditingController(
        text: t != null ? CurrencyFormatter.poyshaToTaka(t.amountPoysha).toString() : '');
    _product = TextEditingController(text: t?.product ?? '');
    _quantity = TextEditingController(text: t?.quantity ?? '');
    _description = TextEditingController(text: t?.description ?? '');
    _note = TextEditingController(text: t?.note ?? '');
    _paymentMethod = t?.paymentMethod.isNotEmpty == true ? t!.paymentMethod : AppConstants.paymentMethods.first;
    _dateTime = t != null ? DateTime.fromMillisecondsSinceEpoch(t.date) : DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _product.dispose();
    _quantity.dispose();
    _description.dispose();
    _note.dispose();
    super.dispose();
  }

  bool get _isDue => _type == AppConstants.typeDue;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(picked.year, picked.month, picked.day, _dateTime.hour, _dateTime.minute);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_dateTime));
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, picked.hour, picked.minute);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amountTaka = CurrencyFormatter.parseInput(_amount.text);
    if (amountTaka == null || amountTaka <= 0) return;

    setState(() => _saving = true);
    final app = context.read<AppProvider>();
    final amountPoysha = CurrencyFormatter.taakaToPoysha(amountTaka);

    try {
      if (_isEdit) {
        await app.updateTransaction(
          widget.editTransaction!,
          type: _type,
          amountPoysha: amountPoysha,
          product: _product.text,
          quantity: _quantity.text,
          description: _description.text,
          paymentMethod: _isDue ? '' : _paymentMethod,
          date: _dateTime.millisecondsSinceEpoch,
          note: _note.text,
        );
      } else {
        await app.addTransaction(
          customerId: widget.customer.id,
          type: _type,
          amountPoysha: amountPoysha,
          product: _product.text,
          quantity: _quantity.text,
          description: _description.text,
          paymentMethod: _isDue ? '' : _paymentMethod,
          date: _dateTime.millisecondsSinceEpoch,
          note: _note.text,
        );
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = _isDue ? AppTheme.danger : AppTheme.success;
    final dateFmt = DateFormat('dd MMM yyyy');
    final timeFmt = DateFormat('hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.customer.name} — ${_isDue ? l10n.addDue : l10n.addPayment}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_isEdit)
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Text(l10n.due),
                      selected: _isDue,
                      selectedColor: AppTheme.danger.withOpacity(0.18),
                      onSelected: (_) => setState(() => _type = AppConstants.typeDue),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: Text(l10n.payment),
                      selected: !_isDue,
                      selectedColor: AppTheme.success.withOpacity(0.18),
                      onSelected: (_) => setState(() => _type = AppConstants.typePayment),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amount,
              validator: Validators.amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accentColor),
              decoration: InputDecoration(labelText: l10n.amountRequired, prefixText: '৳ '),
            ),
            const SizedBox(height: 14),
            if (_isDue) ...[
              TextFormField(
                controller: _product,
                decoration: InputDecoration(labelText: l10n.productOptional),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _quantity,
                decoration: InputDecoration(labelText: l10n.quantityOptional),
              ),
              const SizedBox(height: 14),
            ] else ...[
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(labelText: l10n.paymentMethod),
                items: AppConstants.paymentMethods
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _paymentMethod = v ?? _paymentMethod),
              ),
              const SizedBox(height: 14),
            ],
            TextFormField(
              controller: _description,
              maxLines: 2,
              decoration: InputDecoration(labelText: l10n.descriptionOptional),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(dateFmt.format(_dateTime)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time, size: 16),
                    label: Text(timeFmt.format(_dateTime)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _note,
              maxLines: 2,
              decoration: InputDecoration(labelText: l10n.noteOptional),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_isDue ? l10n.saveDue : l10n.savePayment),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
