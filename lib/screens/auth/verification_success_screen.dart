import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/common/custom_button.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = AppStateProvider.of(context).authProvider;
    final user = authProvider.user;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Student Verification Approved!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Welcome to the circular campus marketplace.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              CampusBadge(university: user?.university ?? 'Stanford University'),
              const SizedBox(height: 36),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'BUY, SELL, BORROW & EXCHANGE resources',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Direct on-campus pickup spots',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Department: ${user?.department ?? "Computer Science"}',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              CustomButton(
                text: 'Enter Campus Marketplace',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
                },
                icon: Icons.storefront_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
