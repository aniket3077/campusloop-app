import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import 'campus_badge.dart';
import 'logout_dialog.dart';

class CampusDrawer extends StatelessWidget {
  const CampusDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateProvider.of(context);
    final authProvider = appState.authProvider;
    final themeProvider = appState.themeProvider;
    final user = authProvider.user ?? UserModel.mockUser;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Student Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primary,
                        backgroundImage: user.avatarUrl != null
                            ? NetworkImage(user.avatarUrl!)
                            : null,
                        child: user.avatarUrl == null
                            ? Text(
                                user.name.isNotEmpty ? user.name[0] : 'U',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Close Menu',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CampusBadge(
                    university: user.university,
                    isVerified: user.isVerifiedStudent,
                  ),
                ],
              ),
            ),

            // Navigation Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: const Text('My Listings'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.myListings);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: const Text('Transaction History'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.transactions);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_download_outlined),
                    title: const Text('Digital Marketplace'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.digitalMarketplace);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.eco_outlined),
                    title: const Text('Impact Dashboard'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.impactDashboard);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('Student ID Verification'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.collegeVerification);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Edit Student Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  ),

                  const Divider(),

                  // Dark Mode Switch
                  SwitchListTile(
                    secondary: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                    ),
                    title: const Text('Dark Mode'),
                    value: themeProvider.isDarkMode,
                    onChanged: (val) {
                      themeProvider.toggleTheme(val);
                    },
                  ),

                  const Divider(),

                  // Prominent Log Out Tile
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFDC2626),
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: const Text(
                      'Sign out of your CampusLoop student account',
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      LogoutDialog.show(context);
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'CampusLoop v1.0.0 • Circular Campus Economy',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
