import 'package:flutter/material.dart';
import '../../models/impact_stats_model.dart';
import '../../core/theme/app_colors.dart';

class ImpactCard extends StatelessWidget {
  final ImpactStatsModel stats;

  const ImpactCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.eco_rounded,
                color: Color(0xFF89F8C7),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Campus Circular Impact',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Live Stats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem(
                value: '${stats.co2SavedKg.toStringAsFixed(0)} kg',
                label: 'CO₂ Saved',
                icon: Icons.cloud_done_rounded,
              ),
              _buildDivider(),
              _buildMetricItem(
                value: '\$${stats.moneySavedUsd.toStringAsFixed(0)}',
                label: 'Money Saved',
                icon: Icons.savings_rounded,
              ),
              _buildDivider(),
              _buildMetricItem(
                value: '${stats.itemsReused}',
                label: 'Items Reused',
                icon: Icons.loop_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF89F8C7), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}
