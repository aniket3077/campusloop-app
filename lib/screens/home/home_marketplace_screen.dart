import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/impact_stats_model.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/resource_type_chip.dart';
import '../../widgets/impact/impact_card.dart';
import '../../widgets/marketplace/category_selector.dart';
import '../../widgets/marketplace/resource_card.dart';
import '../../providers/app_state_provider.dart';

class HomeMarketplaceScreen extends StatelessWidget {
  const HomeMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resourceProvider = AppStateProvider.of(context).resourceProvider;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.loop_rounded, color: Color(0xFF006C4C)),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CampusBadge(university: 'Stanford', isCompact: true),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: resourceProvider,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              // Search & Filter Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    onChanged: (val) => resourceProvider.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search textbooks, lab gear, notes...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),

              // Impact Summary Card Banner
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ImpactCard(stats: ImpactStatsModel.mockCampusImpact),
                ),
              ),

              // Category Selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CategorySelector(
                    selectedCategory: resourceProvider.selectedCategory,
                    onCategorySelected: (cat) => resourceProvider.setCategory(cat),
                  ),
                ),
              ),

              // Resource Type Filter Chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: AppConstants.resourceTypes.length,
                    itemBuilder: (context, index) {
                      final type = AppConstants.resourceTypes[index];
                      final isSelected = resourceProvider.selectedType == type;
                      return ResourceTypeChip(
                        resourceType: type,
                        isSelected: isSelected,
                        onTap: () => resourceProvider.setResourceType(type),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Grid of Academic Resources
              if (resourceProvider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (resourceProvider.resources.isEmpty)
                SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.search_off_rounded,
                    title: 'No Academic Resources Found',
                    message: 'Try adjusting your search query or selecting a different category.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      resourceProvider.setCategory('All Categories');
                      resourceProvider.setResourceType('All Types');
                      resourceProvider.setSearchQuery('');
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final resource = resourceProvider.resources[index];
                        return ResourceCard(
                          resource: resource,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.resourceDetail,
                              arguments: resource,
                            );
                          },
                        );
                      },
                      childCount: resourceProvider.resources.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}
