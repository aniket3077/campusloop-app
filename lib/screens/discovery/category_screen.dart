import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/discovery/filter_bottom_sheet.dart';
import '../../widgets/discovery/sort_bottom_sheet.dart';
import '../../widgets/marketplace/resource_card.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStateProvider.of(context).resourceProvider.setCategory(widget.categoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resourceProvider = AppStateProvider.of(context).resourceProvider;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => FilterBottomSheet.show(context, resourceProvider),
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: () => SortBottomSheet.show(context, resourceProvider),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: resourceProvider,
        builder: (context, _) {
          final items = resourceProvider.resources;

          return Column(
            children: [
              // Category Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(widget.categoryName),
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.categoryName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${items.length} campus resources available',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Resources Grid
              Expanded(
                child: resourceProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.inventory_2_outlined,
                            title: 'No Items in ${widget.categoryName}',
                            message: 'Be the first student to share or post a request in this category!',
                            buttonText: 'Post New Item',
                            onButtonPressed: () {
                              Navigator.pushNamed(context, AppRoutes.createListing);
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
                              final resource = items[index];
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
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Books':
        return Icons.menu_book_rounded;
      case 'Calculators':
        return Icons.calculate_rounded;
      case 'Drawing Kits':
        return Icons.draw_rounded;
      case 'Electronics':
        return Icons.developer_board_rounded;
      case 'Lab Components':
        return Icons.science_rounded;
      case 'Project Materials':
        return Icons.inventory_2_rounded;
      case 'Tools':
        return Icons.build_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
