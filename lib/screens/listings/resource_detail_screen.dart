import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/academic_resource_model.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/resource_type_chip.dart';

class ResourceDetailScreen extends StatelessWidget {
  final AcademicResourceModel resource;

  const ResourceDetailScreen({
    super.key,
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(resource.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header image area
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price & Resource Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ResourceTypeChip(resourceType: resource.resourceType),
                      Text(
                        Formatters.formatCurrency(resource.price),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    resource.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category & Condition
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(resource.category),
                        avatar: const Icon(Icons.category, size: 16),
                      ),
                      Chip(
                        label: Text('Condition: ${resource.condition}'),
                        avatar: const Icon(Icons.verified_outlined, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Item Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    resource.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campus Pickup Location
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Campus Pickup Location',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  resource.pickupLocation,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Seller Profile Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            radius: 22,
                            child: Text(
                              resource.sellerName.isNotEmpty
                                  ? resource.sellerName[0]
                                  : 'S',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      resource.sellerName,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFF59E0B),
                                    ),
                                    Text(
                                      '${resource.sellerRating}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                CampusBadge(
                                  university: resource.university,
                                  isCompact: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Chat & Bargain',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatDetail,
                          arguments: 'conv_001',
                        );
                      },
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
