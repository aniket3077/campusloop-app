import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';

class StudentVerificationScreen extends StatelessWidget {
  const StudentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Student Verification Status')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.verifiedBadge.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_sharp,
                size: 64,
                color: AppColors.verifiedBadge,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Verified Stanford Student',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You are connected to the Stanford University campus marketplace. All listings, chats, and pickups are verified student-to-student.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            CustomButton(
              text: 'Explore Campus Marketplace',
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
              },
              icon: Icons.storefront_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
