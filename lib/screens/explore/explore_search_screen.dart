import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/discovery/filter_bottom_sheet.dart';
import '../../widgets/discovery/sort_bottom_sheet.dart';
import '../../widgets/marketplace/resource_card.dart';

class ExploreSearchScreen extends StatefulWidget {
  const ExploreSearchScreen({super.key});

  @override
  State<ExploreSearchScreen> createState() => _ExploreSearchScreenState();
}

class _ExploreSearchScreenState extends State<ExploreSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resourceProvider = AppStateProvider.of(context).resourceProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace Search & Discovery'),
      ),
      body: ListenableBuilder(
        listenable: resourceProvider,
        builder: (context, _) {
          final items = resourceProvider.resources;

          return Column(
            children: [
              // Search Bar & Filter Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (val) => resourceProvider.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'Search by item name, category, or description...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  resourceProvider.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Filter & Sort Bar
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.tune_rounded, size: 18),
                            label: const Text('Filter Options'),
                            onPressed: () => FilterBottomSheet.show(context, resourceProvider),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.sort_rounded, size: 18),
                            label: const Text('Sort By'),
                            onPressed: () => SortBottomSheet.show(context, resourceProvider),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Transaction Type Quick Filter Chips
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: AppConstants.resourceTypes.length,
                  itemBuilder: (context, index) {
                    final type = AppConstants.resourceTypes[index];
                    final isSelected = resourceProvider.selectedType == type;
                    final color = type == 'All Types'
                        ? theme.colorScheme.primary
                        : Formatters.getResourceTypeColor(type);

                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (_) => resourceProvider.setResourceType(type),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : color,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        selectedColor: color,
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Search Results Grid
              Expanded(
                child: resourceProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.search_off_rounded,
                            title: 'No Matching Resources Found',
                            message: 'Try searching with different keywords, item names, or categories.',
                            buttonText: 'Reset All Filters',
                            onButtonPressed: () {
                              _searchController.clear();
                              resourceProvider.setSearchQuery('');
                              resourceProvider.setCategory('All');
                              resourceProvider.setResourceType('All Types');
                            },
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ResourceCard(
                                resource: item,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.resourceDetail,
                                    arguments: item,
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
