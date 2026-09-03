import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/impact_stats_model.dart';
import '../../models/user_model.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/impact/impact_card.dart';
import '../../providers/app_state_provider.dart';

class ProfileImpactScreen extends StatelessWidget {
  const ProfileImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = AppStateProvider.of(context).authProvider;
    final themeProvider = AppStateProvider.of(context).themeProvider;
    final user = authProvider.user ?? UserModel.mockUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile & Impact'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Avatar & Identity
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                user.name.isNotEmpty ? user.name[0] : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            CampusBadge(university: user.university),
            const SizedBox(height: 16),

            // Rating & Activity Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                const SizedBox(width: 4),
                Text(
                  '${user.trustRating} Trust Rating',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                const Text('•'),
                const SizedBox(width: 16),
                Text(
                  '${user.totalTransactions} Circulations',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Personal Impact Stats
            const ImpactCard(stats: ImpactStatsModel.mockCampusImpact),
            const SizedBox(height: 24),

            // Settings & Profile Options
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: const Text('My Shared Resources'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bookmark_outline_rounded),
                    title: const Text('Saved Resources'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('Student Verification Settings'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.studentVerification);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.red),
                    title: const Text('Log Out', style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
