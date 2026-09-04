import 'package:flutter/material.dart';

class BarcodeScannerDialog extends StatefulWidget {
  final String currentId;

  const BarcodeScannerDialog({
    super.key,
    required this.currentId,
  });

  static Future<String?> show(BuildContext context, {String currentId = ''}) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BarcodeScannerDialog(currentId: currentId),
    );
  }

  @override
  State<BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<BarcodeScannerDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _laserAnimation;

  final List<String> _sampleStudentIds = const [
    '38706',
    'MIT-2024-38706',
    'STU-94021',
    'CS-2024-8891',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(String barcode) {
    Navigator.pop(context, barcode);
  }

  @override
  Widget build(BuildContext context) {
    final detectedId = widget.currentId.isNotEmpty ? widget.currentId : '38706';

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Color(0xFF38BDF8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'I-Card Barcode Scanner',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            const Text(
              'Align the barcode or QR code on your student ID card within the frame below:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // Scanner Viewfinder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Corner markers
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFF38BDF8), width: 3),
                          left: BorderSide(color: Color(0xFF38BDF8), width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFF38BDF8), width: 3),
                          right: BorderSide(color: Color(0xFF38BDF8), width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF38BDF8), width: 3),
                          left: BorderSide(color: Color(0xFF38BDF8), width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF38BDF8), width: 3),
                          right: BorderSide(color: Color(0xFF38BDF8), width: 3),
                        ),
                      ),
                    ),
                  ),

                  // Center Barcode Graphic Simulation
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.barcode_reader,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 64,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID: $detectedId',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Animated Red/Cyan Laser Scan Line
                  AnimatedBuilder(
                    animation: _laserAnimation,
                    builder: (context, _) {
                      return Positioned(
                        top: 200 * _laserAnimation.value,
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.8),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Instant Scan Confirmation Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  'Confirm Barcode: $detectedId',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onPressed: () => _onBarcodeDetected(detectedId),
              ),
            ),
            const SizedBox(height: 12),

            // Quick Selection of Other ID formats
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: _sampleStudentIds
                  .where((id) => id != detectedId)
                  .map((id) => ActionChip(
                        label: Text(
                          id,
                          style: const TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.white24),
                        ),
                        onPressed: () => _onBarcodeDetected(id),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
