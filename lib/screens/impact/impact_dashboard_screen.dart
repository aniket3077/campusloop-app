import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/impact/metric_card_widget.dart';

class ImpactDashboardScreen extends StatefulWidget {
  const ImpactDashboardScreen({super.key});

  @override
  State<ImpactDashboardScreen> createState() => _ImpactDashboardScreenState();
}

class _ImpactDashboardScreenState extends State<ImpactDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = AppStateProvider.of(context);
      final user = appState.authProvider.user ?? UserModel.mockUser;
      final txs = appState.transactionProvider.transactions;

      appState.analyticsProvider.refreshAnalytics(
        user.id,
        user.university,
        txs,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateProvider.of(context);
    final analyticsProvider = appState.analyticsProvider;
    final user = appState.authProvider.user ?? UserModel.mockUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusLoop Impact Dashboard'),
      ),
      body: ListenableBuilder(
        listenable: analyticsProvider,
        builder: (context, _) {
          final impact = analyticsProvider.activeImpact;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.eco_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Circular Impact Metrics',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Calculated live from real campus marketplace transactions.',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Scope Selector Tabs
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ImpactScope>(
                    segments: const [
                      ButtonSegment(value: ImpactScope.user, label: Text('My Impact')),
                      ButtonSegment(value: ImpactScope.campus, label: Text('Campus')),
                      ButtonSegment(value: ImpactScope.total, label: Text('Global')),
                    ],
                    selected: {analyticsProvider.activeScope},
                    onSelectionChanged: (set) {
                      analyticsProvider.setScope(set.first);
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Campus Badge Info
                Center(
                  child: CampusBadge(
                    university: analyticsProvider.activeScope == ImpactScope.user
                        ? '${user.name}\'s Personal Metrics'
                        : (analyticsProvider.activeScope == ImpactScope.campus
                            ? '${user.university} Campus'
                            : 'All Enrolled Universities'),
                  ),
                ),
                const SizedBox(height: 20),

                if (analyticsProvider.isLoading || impact == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  // 2-Column Grid for Reusable Metric Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                    children: [
                      // Card 1: Money Saved
                      MetricCardWidget(
                        title: 'Money Saved',
                        value: '\$${impact.moneySaved.toStringAsFixed(0)}',
                        icon: Icons.savings_rounded,
                        color: const Color(0xFF059669),
                        subtitle: 'Direct Savings',
                      ),

                      // Card 2: Items Reused
                      MetricCardWidget(
                        title: 'Items Reused',
                        value: '${impact.itemsReused}',
                        icon: Icons.loop_rounded,
                        color: AppColors.primary,
                        subtitle: 'Circular Economy',
                      ),

                      // Card 3: Successful Transfers
                      MetricCardWidget(
                        title: 'Successful Transfers',
                        value: '${impact.successfulTransfers}',
                        icon: Icons.task_alt_rounded,
                        color: const Color(0xFF0284C7),
                        subtitle: 'Completed',
                      ),

                      // Card 4: Waste Avoided
                      MetricCardWidget(
                        title: 'Waste Avoided',
                        value: '${impact.wasteAvoidedKg.toStringAsFixed(0)} kg',
                        icon: Icons.delete_sweep_rounded,
                        color: const Color(0xFF16A34A),
                        subtitle: 'Landfill Saved',
                      ),

                      // Card 5: Borrow Transactions
                      MetricCardWidget(
                        title: 'Borrow Transactions',
                        value: '${impact.borrowTransactions}',
                        icon: Icons.repeat_rounded,
                        color: AppColors.badgeBorrow,
                        subtitle: 'Shared Access',
                      ),

                      // Card 6: Donations
                      MetricCardWidget(
                        title: 'Donations',
                        value: '${impact.donations}',
                        icon: Icons.volunteer_activism_rounded,
                        color: AppColors.badgeDonate,
                        subtitle: 'Free Gifted',
                      ),

                      // Card 7: Exchanges
                      MetricCardWidget(
                        title: 'Exchanges',
                        value: '${impact.exchanges}',
                        icon: Icons.swap_horiz_rounded,
                        color: AppColors.badgeExchange,
                        subtitle: 'Student Trade',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sustainability Insights Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.85),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.nature_people_rounded, color: Color(0xFF89F8C7), size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Campus Sustainability Progress',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'By circulating ${impact.itemsReused} textbooks, lab components, and digital resources, your campus community has prevented ${impact.wasteAvoidedKg.toStringAsFixed(0)} kg of waste and saved students \$${impact.moneySaved.toStringAsFixed(0)}.',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
