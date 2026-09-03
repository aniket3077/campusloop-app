import 'package:flutter/material.dart';

class CampusLoopLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showActionTagline;

  const CampusLoopLogoWidget({
    super.key,
    this.size = 180,
    this.showText = true,
    this.showActionTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback in case asset is loading or missing
            return Image.asset(
              'assets/images/logo.jpg',
              width: size,
              height: size,
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}
