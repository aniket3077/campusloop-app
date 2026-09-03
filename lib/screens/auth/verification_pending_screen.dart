import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = AppStateProvider.of(context).authProvider;
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Under Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.badgeBorrow.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                size: 64,
                color: AppColors.badgeBorrow,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'College Verification Pending',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              'Your enrolment details at ${user?.university ?? "your college"} are currently under review by campus moderators. We ensure 100% verified student safety.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.verifiedBadge, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'College Email: Verified (${user?.collegeDomain})',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.pending_actions, color: AppColors.badgeBorrow, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Student ID Document: Pending Approval',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            CustomButton(
              text: 'Check Status / Refresh',
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.verificationSuccess);
              },
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
