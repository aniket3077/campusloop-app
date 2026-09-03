import 'package:flutter/material.dart';

class PickupQrWidget extends StatelessWidget {
  final String transactionId;
  final String qrData;
  final double size;

  const PickupQrWidget({
    super.key,
    required this.transactionId,
    required this.qrData,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2),
      ),
      child: CustomPaint(
        painter: QrPatternPainter(
          color: theme.colorScheme.primary,
          data: qrData,
        ),
      ),
    );
  }
}

class QrPatternPainter extends CustomPainter {
  final Color color;
  final String data;

  QrPatternPainter({required this.color, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Corner finder blocks
    _drawCornerMarker(canvas, paint, const Offset(0, 0), size.width * 0.28);
    _drawCornerMarker(canvas, paint, Offset(size.width * 0.72, 0), size.width * 0.28);
    _drawCornerMarker(canvas, paint, Offset(0, size.height * 0.72), size.width * 0.28);

    // Data grid simulation
    const gridSize = 7;
    final step = size.width / (gridSize + 2);

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        // Skip corner finder zones
        if ((r < 3 && c < 3) || (r < 3 && c > 3) || (r > 3 && c < 3)) continue;

        if ((r + c + data.length) % 2 == 0) {
          final rect = Rect.fromLTWH(
            (c + 1) * step + step * 0.1,
            (r + 1) * step + step * 0.1,
            step * 0.8,
            step * 0.8,
          );
          canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), paint);
        }
      }
    }
  }

  void _drawCornerMarker(Canvas canvas, Paint paint, Offset offset, double markerSize) {
    // Outer square
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx, offset.dy, markerSize, markerSize),
        const Radius.circular(6),
      ),
      paint,
    );

    // Inner white gap
    final whitePaint = Paint()..color = Colors.white;
    final innerGap = markerSize * 0.2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx + innerGap / 2, offset.dy + innerGap / 2, markerSize - innerGap, markerSize - innerGap),
        const Radius.circular(4),
      ),
      whitePaint,
    );

    // Inner filled dot
    final dotSize = markerSize * 0.4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx + (markerSize - dotSize) / 2, offset.dy + (markerSize - dotSize) / 2, dotSize, dotSize),
        const Radius.circular(3),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
