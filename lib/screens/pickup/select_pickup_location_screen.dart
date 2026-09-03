import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../models/pickup_location_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import 'pickup_qr_verification_screen.dart';

class SelectPickupLocationScreen extends StatefulWidget {
  final TransactionModel transaction;

  const SelectPickupLocationScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<SelectPickupLocationScreen> createState() => _SelectPickupLocationScreenState();
}

class _SelectPickupLocationScreenState extends State<SelectPickupLocationScreen> {
  late PickupLocationModel _selectedLocation;
  DateTime _pickupDateTime = DateTime.now().add(const Duration(hours: 2));
  DateTime _expectedReturnDate = DateTime.now().add(const Duration(days: 14));
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = PickupLocationModel.adminConfiguredLocations.first;
  }

  Future<void> _selectPickupTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _pickupDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: this.context,
        initialTime: TimeOfDay.fromDateTime(_pickupDateTime),
      );
      if (time != null) {
        setState(() {
          _pickupDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _selectReturnDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedReturnDate,
      firstDate: _pickupDateTime.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null) {
      setState(() => _expectedReturnDate = picked);
    }
  }

  void _onConfirmLocation() async {
    setState(() => _isSubmitting = true);

    final provider = AppStateProvider.of(context).transactionProvider;
    final updatedTx = widget.transaction.copyWith(
      status: TransactionStatus.scheduledForPickup,
      pickupTime: _pickupDateTime,
      expectedReturnDate: widget.transaction.transactionType == TransactionType.borrow
          ? _expectedReturnDate
          : null,
    );

    await provider.updateStatus(widget.transaction.id, TransactionStatus.scheduledForPickup);
    setState(() => _isSubmitting = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PickupQrVerificationScreen(transaction: updatedTx),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBorrow = widget.transaction.transactionType == TransactionType.borrow;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Campus Pickup Spot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Header Summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory_2_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.transaction.resourceTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          'Mode: ${widget.transaction.transactionType.name.toUpperCase()} • ${Formatters.formatCurrency(widget.transaction.resourcePrice)}',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Designated Campus Pickup Spots',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Select an admin-configured, safe meeting spot on campus.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),

            // Admin-Configured Locations List
            ...PickupLocationModel.adminConfiguredLocations.map((loc) {
              final isSelected = _selectedLocation.id == loc.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                  ),
                  title: Row(
                    children: [
                      Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      if (loc.isDefault) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Popular', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(loc.description, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(loc.operatingHours, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => setState(() => _selectedLocation = loc),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Meeting Date & Time Selector
            Text(
              'Pickup Meeting Time',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectPickupTime(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_available_rounded, size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      '${_pickupDateTime.month}/${_pickupDateTime.day}/${_pickupDateTime.year} at ${_pickupDateTime.hour}:${_pickupDateTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Spacer(),
                    const Icon(Icons.edit_calendar_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // For Borrowing Flow: Expected Return Date
            if (isBorrow) ...[
              Text(
                'Expected Return Date (Borrowing Flow)',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.amber.shade900),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _selectReturnDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade400),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.assignment_return_rounded, size: 20, color: Colors.amber.shade900),
                      const SizedBox(width: 12),
                      Text(
                        'Return by: ${_expectedReturnDate.month}/${_expectedReturnDate.day}/${_expectedReturnDate.year}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.amber.shade900),
                      ),
                      const Spacer(),
                      const Icon(Icons.edit_calendar_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            CustomButton(
              text: 'Confirm Pickup Location & Generate QR',
              onPressed: _onConfirmLocation,
              isLoading: _isSubmitting,
              icon: Icons.qr_code_2_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
