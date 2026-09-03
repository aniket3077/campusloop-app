import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/digital_product_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/empty_state_widget.dart';
import 'digital_product_detail_screen.dart';

class DigitalMarketplaceScreen extends StatefulWidget {
  const DigitalMarketplaceScreen({super.key});

  @override
  State<DigitalMarketplaceScreen> createState() => _DigitalMarketplaceScreenState();
}

class _DigitalMarketplaceScreenState extends State<DigitalMarketplaceScreen> {
  final _searchController = TextEditingController();
  String _selectedProvider = 'All Providers';

  final providers = [
    'All Providers',
    'Pearson MyLab',
    'McGraw-Hill Connect',
    'WileyPLUS',
    'Canvas / Campus Store',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final digitalProvider = AppStateProvider.of(context).digitalProductProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Course-Access Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_rounded),
            tooltip: 'List Digital Product',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createDigitalListing);
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: digitalProvider,
        builder: (context, _) {
          final products = digitalProvider.products;

          return Column(
            children: [
              // Security & Legitimate Policy Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: Colors.blue.shade800, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verified Publisher Access Codes, Vouchers & Notes. Strictly 0 account passwords or credentials.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => digitalProvider.loadProducts(
                    searchQuery: val.trim(),
                    provider: _selectedProvider == 'All Providers' ? null : _selectedProvider,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search course code, access code, or platform...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),

              // Provider Filter Chips
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final prov = providers[index];
                    final isSelected = prov == _selectedProvider;

                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ChoiceChip(
                        label: Text(prov),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedProvider = prov);
                          digitalProvider.loadProducts(
                            searchQuery: _searchController.text.trim(),
                            provider: prov == 'All Providers' ? null : prov,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Digital Products List
              Expanded(
                child: digitalProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : products.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.key_off_rounded,
                            title: 'No Digital Access Products Found',
                            message: 'Be the first student to post a legitimate publisher access code or course material!',
                            buttonText: 'List Digital Product',
                            onButtonPressed: () {
                              Navigator.pushNamed(context, AppRoutes.createDigitalListing);
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final p = products[index];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DigitalProductDetailScreen(product: p),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            _getProductTypeIcon(p.productType),
                                            color: Colors.blue.shade900,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: theme.colorScheme.primaryContainer,
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      p.productType.displayName,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: theme.colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    Formatters.formatCurrency(p.price),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: theme.colorScheme.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),

                                              Text(
                                                p.courseName,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              ),
                                              const SizedBox(height: 4),

                                              Text(
                                                'Provider: ${p.providerPlatform} • ${p.validityExpiry}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: theme.colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  text: 'List Legitimate Digital Course Product',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createDigitalListing);
                  },
                  icon: Icons.add_card_rounded,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getProductTypeIcon(DigitalProductType type) {
    switch (type) {
      case DigitalProductType.accessCode:
        return Icons.key_rounded;
      case DigitalProductType.courseLicense:
        return Icons.card_membership_rounded;
      case DigitalProductType.voucher:
        return Icons.confirmation_number_rounded;
      case DigitalProductType.digitalCourseMaterial:
        return Icons.file_present_rounded;
      case DigitalProductType.transferableEnrollment:
        return Icons.verified_user_rounded;
      case DigitalProductType.studyNotes:
        return Icons.menu_book_rounded;
    }
  }
}
