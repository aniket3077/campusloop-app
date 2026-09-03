import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_state_provider.dart';
import '../../services/backend_api_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/pickup/pickup_qr_widget.dart';
import 'pickup_completed_screen.dart';

class PickupQrVerificationScreen extends StatefulWidget {
  final TransactionModel transaction;

  const PickupQrVerificationScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<PickupQrVerificationScreen> createState() => _PickupQrVerificationScreenState();
}

class _PickupQrVerificationScreenState extends State<PickupQrVerificationScreen> {
  bool _isScanningMode = false;
  bool _isVerifying = false;

  void _onVerifyQr() async {
    setState(() => _isVerifying = true);

    // Call real backend cryptographic QR verification endpoint
    final qrData = widget.transaction.id;
    final result = await BackendApiService.verifyPickupQr(
      transactionId: widget.transaction.id,
      qrCode: qrData,
    );

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (result['success'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error']?.toString() ?? 'QR verification failed')),
      );
      return;
    }

    final provider = AppStateProvider.of(context).transactionProvider;
    final isBorrow = widget.transaction.transactionType == TransactionType.borrow;
    final nextStatus = isBorrow ? TransactionStatus.borrowed : TransactionStatus.completed;

    final updatedTx = widget.transaction.copyWith(
      status: nextStatus,
      borrowStartDate: isBorrow ? DateTime.now() : null,
    );

    await provider.updateStatus(widget.transaction.id, nextStatus);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PickupCompletedScreen(transaction: updatedTx),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tx = widget.transaction;
    final isBorrow = tx.transactionType == TransactionType.borrow;

    return Scaffold(
      appBar: AppBar(
        title: const Text('On-Campus Pickup QR Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Mode Segmented Switch
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Show My QR'), icon: Icon(Icons.qr_code_rounded)),
                ButtonSegment(value: true, label: Text('Scan QR Code'), icon: Icon(Icons.qr_code_scanner_rounded)),
              ],
              selected: {_isScanningMode},
              onSelectionChanged: (set) => setState(() => _isScanningMode = set.first),
            ),
            const SizedBox(height: 24),

            if (!_isScanningMode) ...[
              // Show QR Code
              Text(
                'Show QR Code to Student at Pickup Spot',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'When you meet at ${tx.pickupLocation}, let the other student scan this code to confirm transfer.',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              PickupQrWidget(
                transactionId: tx.id,
                qrData: 'campusloop://pickup?txId=${tx.id}&type=${tx.transactionType.name}',
                size: 210,
              ),
              const SizedBox(height: 24),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pickup Spot:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(tx.pickupLocation, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Meeting Time:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            tx.pickupTime != null
                                ? '${tx.pickupTime!.month}/${tx.pickupTime!.day} @ ${tx.pickupTime!.hour}:${tx.pickupTime!.minute.toString().padLeft(2, '0')}'
                                : 'Scheduled',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (isBorrow && tx.expectedReturnDate != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Expected Return Date:', style: TextStyle(fontSize: 12, color: Colors.amber)),
                            Text(
                              '${tx.expectedReturnDate!.month}/${tx.expectedReturnDate!.day}/${tx.expectedReturnDate!.year}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else ...[
              // QR Code Scanner View Simulation
              Text(
                'Scan Student\'s QR Code',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text('Align the QR code within the frame to verify transaction transfer.', textAlign: TextAlign.center),
              const SizedBox(height: 24),

              Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.primary, width: 3),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner_rounded, size: 100, color: theme.colorScheme.primary.withValues(alpha: 0.6)),
                    const Positioned(
                      bottom: 12,
                      child: Text('Scanning for CampusLoop QR...', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            CustomButton(
              text: _isScanningMode ? 'Confirm QR Verification Scan' : 'Confirm On-Campus Transfer',
              onPressed: _onVerifyQr,
              isLoading: _isVerifying,
              icon: Icons.verified_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
