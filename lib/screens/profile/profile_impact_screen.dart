import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/impact_stats_model.dart';
import '../../models/report_model.dart';
import '../../models/transaction_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/common/logout_dialog.dart';
import '../../widgets/impact/impact_card.dart';
import '../../widgets/marketplace/resource_card.dart';
import '../trust/report_screen.dart';

class ProfileImpactScreen extends StatefulWidget {
  const ProfileImpactScreen({super.key});

  @override
  State<ProfileImpactScreen> createState() => _ProfileImpactScreenState();
}

class _ProfileImpactScreenState extends State<ProfileImpactScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateProvider.of(context);
    final authProvider = appState.authProvider;
    final themeProvider = appState.themeProvider;
    final resourceProvider = appState.resourceProvider;
    final txProvider = appState.transactionProvider;
    final trustProvider = appState.trustProvider;

    final user = authProvider.user ?? UserModel.mockUser;

    // Filtered data for profile tabs
    final myListings = resourceProvider.resources
        .where((r) => r.sellerId == user.id || r.sellerName == user.name)
        .toList();

    final completedTxs = txProvider.completedTransactions;

    final borrowHistory = txProvider.transactions
        .where((t) => t.transactionType == TransactionType.borrow)
        .toList();

    final donationHistory = txProvider.transactions
        .where((t) => t.transactionType == TransactionType.donate)
        .toList();

    final reviews = trustProvider.userRatings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile & Trust'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
          ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
            tooltip: 'Log Out',
            onPressed: () => LogoutDialog.show(context),
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'logout') {
                LogoutDialog.show(context);
              } else if (val == 'report') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportScreen(
                      type: ReportType.user,
                      targetId: user.id,
                      targetTitle: user.name,
                    ),
                  ),
                );
              } else if (val == 'block') {
                trustProvider.blockUser('current_user', user.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${user.name} has been blocked.')),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'report', child: Text('Report User')),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Avatar & Identity with tap-to-edit
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.editProfile);
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF0284C7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 44,
                              backgroundColor: theme.colorScheme.primary,
                              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                              child: user.avatarUrl == null
                                  ? Text(
                                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
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
                      '${user.department} • ${user.academicYear}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      user.email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        CampusBadge(
                          university: user.university,
                          isVerified: user.isVerifiedStudent,
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.editProfile);
                          },
                          icon: const Icon(Icons.edit_outlined, size: 14),
                          label: const Text('Edit Profile', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => LogoutDialog.show(context),
                          icon: const Icon(Icons.logout_rounded, size: 14, color: Color(0xFFDC2626)),
                          label: const Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Rating & Stats Counters
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('Rating', '${trustProvider.averageRating.toStringAsFixed(1)} ★', Icons.star_rounded),
                        _buildStatColumn('Listings', '${myListings.length}', Icons.inventory_2_rounded),
                        _buildStatColumn('Completed', '${completedTxs.length}', Icons.task_alt_rounded),
                        _buildStatColumn('Circulations', '${user.itemsCirculated}', Icons.loop_rounded),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Personal Impact Dashboard Summary
                    const ImpactCard(stats: ImpactStatsModel.mockCampusImpact),
                  ],
                ),
              ),
            ),

            // Profile Section Tabs
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Items Listed'),
                    Tab(text: 'Completed Trades'),
                    Tab(text: 'Borrow History'),
                    Tab(text: 'Donations'),
                    Tab(text: 'Reviews & Feedback'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Items Listed Grid
            myListings.isEmpty
                ? const Center(child: Text('No active listings.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: myListings.length,
                    itemBuilder: (context, index) {
                      final item = myListings[index];
                      return ResourceCard(
                        resource: item,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.resourceDetail, arguments: item);
                        },
                      );
                    },
                  ),

            // Tab 2: Completed Transactions
            _buildTransactionTabList(completedTxs, 'No completed trades yet.'),

            // Tab 3: Borrow History
            _buildTransactionTabList(borrowHistory, 'No borrow history recorded.'),

            // Tab 4: Donation History
            _buildTransactionTabList(donationHistory, 'No donation records found.'),

            // Tab 5: Received Student Reviews
            reviews.isEmpty
                ? const Center(child: Text('No student reviews received yet.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final r = reviews[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(r.raterName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                              Text('${r.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Item: ${r.resourceTitle}', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                              if (r.feedback != null) ...[
                                const SizedBox(height: 4),
                                Text('"${r.feedback}"', style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                              ],
                              const SizedBox(height: 4),
                              Text(Formatters.formatRelativeTime(r.createdAt), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF006C4C)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTransactionTabList(List<TransactionModel> txs, String emptyMessage) {
    if (txs.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: txs.length,
      itemBuilder: (context, index) {
        final tx = txs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(tx.resourceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('Mode: ${tx.transactionType.name.toUpperCase()} • ${tx.pickupLocation}'),
            trailing: Text(Formatters.formatCurrency(tx.resourcePrice), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
