import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_routes.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/marketplace/resource_card.dart';

class ExploreSearchScreen extends StatefulWidget {
  const ExploreSearchScreen({super.key});

  @override
  State<ExploreSearchScreen> createState() => _ExploreSearchScreenState();
}

class _ExploreSearchScreenState extends State<ExploreSearchScreen> {
  final _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 100);
  String _selectedCondition = 'All';

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
        title: const Text('Explore & Filter Resources'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => resourceProvider.setSearchQuery(val),
                  decoration: const InputDecoration(
                    hintText: 'Search by course code, title, or item...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Max Price: \$${_priceRange.end.round()}',
                      style: theme.textTheme.labelLarge,
                    ),
                    Expanded(
                      child: RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 200,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${_priceRange.start.round()}',
                          '\$${_priceRange.end.round()}',
                        ),
                        onChanged: (values) {
                          setState(() => _priceRange = values);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListenableBuilder(
              listenable: resourceProvider,
              builder: (context, _) {
                final filtered = resourceProvider.resources.where((r) {
                  return r.price >= _priceRange.start && r.price <= _priceRange.end;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No matching items in price range.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
