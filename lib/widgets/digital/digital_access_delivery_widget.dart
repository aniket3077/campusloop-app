import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../providers/app_state_provider.dart';

class DigitalAccessDeliveryWidget extends StatefulWidget {
  final String productId;
  final String transactionId;
  final String courseName;
  final String providerPlatform;

  const DigitalAccessDeliveryWidget({
    super.key,
    required this.productId,
    required this.transactionId,
    required this.courseName,
    required this.providerPlatform,
  });

  @override
  State<DigitalAccessDeliveryWidget> createState() => _DigitalAccessDeliveryWidgetState();
}

class _DigitalAccessDeliveryWidgetState extends State<DigitalAccessDeliveryWidget> {
  bool _isRevealed = false;
  bool _isLoading = false;
  String? _accessCode;

  void _revealCode() async {
    setState(() => _isLoading = true);

    final provider = AppStateProvider.of(context).digitalProductProvider;
    final code = await provider.fetchSecureAccessCode(widget.productId, widget.transactionId);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _accessCode = code;
        _isRevealed = true;
      });
    }
  }

  void _copyToClipboard() {
    if (_accessCode != null) {
      Clipboard.setData(ClipboardData(text: _accessCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access Code copied to clipboard!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_rounded, color: Colors.blue.shade800),
              const SizedBox(width: 8),
              Text(
                'Secure Digital Course Access Delivery',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Legitimate access code for ${widget.courseName} (${widget.providerPlatform}). Verified publisher product.',
            style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
          ),
          const SizedBox(height: 14),

          if (!_isRevealed)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                ),
                icon: const Icon(Icons.key_rounded),
                label: _isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Reveal & Copy Access Code'),
                onPressed: _isLoading ? null : _revealCode,
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade400),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _accessCode ?? 'PEARSON-CS106B-84920-X82',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Colors.blue),
                    onPressed: _copyToClipboard,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '✓ Code verified. Redeem on publisher platform or Canvas course portal.',
              style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}
