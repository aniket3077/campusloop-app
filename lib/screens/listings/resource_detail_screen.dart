import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/academic_resource_model.dart';
import '../../models/report_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/resource_type_chip.dart';
import '../../widgets/listings/make_offer_bottom_sheet.dart';
import '../requests/request_screen.dart';
import '../trust/report_screen.dart';

class ResourceDetailScreen extends StatefulWidget {
  final AcademicResourceModel resource;

  const ResourceDetailScreen({
    super.key,
    required this.resource,
  });

  @override
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final res = widget.resource;
    final images = res.imageUrls.isNotEmpty
        ? res.imageUrls
        : ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c'];

    return Scaffold(
      appBar: AppBar(
        title: Text(res.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item saved to your bookmarks!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share link copied to clipboard!')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'report') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportScreen(
                      type: ReportType.listing,
                      targetId: res.id,
                      targetTitle: res.title,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text('Report Listing'),
                  ],
                ),
              ),
            ],
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
                  // 1. Large Image Gallery PageView Carousel
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getCategoryIcon(res.category),
                                      size: 72,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Photo ${index + 1} of ${images.length}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Image Index Indicator Dots
                        if (images.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (idx) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == idx
                                        ? theme.colorScheme.primary
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Availability Tag Badge
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: res.isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  res.isAvailable ? Icons.check_circle : Icons.cancel,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  res.isAvailable ? 'Available Now' : 'Currently Unavailable',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Transaction Type & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ResourceTypeChip(resourceType: res.resourceType),
                      Text(
                        Formatters.formatCurrency(res.price),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. Item Name
                  Text(
                    res.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4. Category, Condition & Course Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (res.courseCode != null && res.courseCode!.isNotEmpty)
                        Chip(
                          backgroundColor: const Color(0xFFEEF2FF),
                          side: const BorderSide(color: Color(0xFFC7D2FE)),
                          label: Text(
                            'Course: ${res.courseCode}',
                            style: const TextStyle(
                              color: Color(0xFF4338CA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          avatar: const Icon(
                            Icons.school_rounded,
                            size: 16,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      Chip(
                        label: Text(res.category),
                        avatar: const Icon(Icons.category_rounded, size: 16),
                      ),
                      Chip(
                        label: Text('Condition: ${res.condition}'),
                        avatar: const Icon(Icons.verified_outlined, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 5. Description
                  Text(
                    'Item Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    res.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6. Campus Pickup Location
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Campus Pickup Spot',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  res.pickupLocation,
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

                  // 7. Seller / Owner Card with Verification & Rating
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            radius: 22,
                            child: Text(
                              res.sellerName.isNotEmpty ? res.sellerName[0] : 'S',
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
                                      res.sellerName,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Color(0xFFF59E0B),
                                    ),
                                    Text(
                                      '${res.sellerRating}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                CampusBadge(
                                  university: res.university,
                                  isVerified: res.isVerifiedSeller,
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

          // Action Bar Area
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
              child: res.isAvailable
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Chat with Owner',
                                onPressed: () {
                                  final appState = AppStateProvider.of(context);
                                  final currentUser = appState.authProvider.user;
                                  final conversation = appState.chatProvider.getOrCreateConversationForResource(
                                    resource: res,
                                    currentUser: currentUser,
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.chatDetail,
                                    arguments: conversation.id,
                                  );
                                },
                                isOutlined: true,
                                icon: Icons.chat_bubble_outline_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: _getActionText(res.resourceType),
                                onPressed: () {
                                  if (res.resourceType.toUpperCase() == 'DONATE') {
                                    final appState = AppStateProvider.of(context);
                                    final currentUser = appState.authProvider.user;
                                    final conversation = appState.chatProvider.getOrCreateConversationForResource(
                                      resource: res,
                                      currentUser: currentUser,
                                    );
                                    appState.chatProvider.sendMessage(
                                      conversation.id,
                                      'Hi ${res.sellerName}! I would love to claim your donated item: "${res.title}". When can we meet at ${res.pickupLocation}?',
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.chatDetail,
                                      arguments: conversation.id,
                                    );
                                  } else {
                                    MakeOfferBottomSheet.show(context, res);
                                  }
                                },
                                icon: _getActionIcon(res.resourceType),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber.shade800,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.add_alert_outlined),
                        label: const Text(
                          'Request This Item (Currently Unavailable)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RequestScreen(resource: res),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
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

  String _getActionText(String type) {
    switch (type.toUpperCase()) {
      case 'DONATE':
        return 'Claim Free Item';
      case 'BORROW':
        return 'Request to Borrow';
      case 'EXCHANGE':
        return 'Propose Exchange';
      case 'BUY':
        return 'Offer to Supply';
      default:
        return 'Make Offer';
    }
  }

  IconData _getActionIcon(String type) {
    switch (type.toUpperCase()) {
      case 'DONATE':
        return Icons.favorite_rounded;
      case 'BORROW':
        return Icons.handshake_rounded;
      case 'EXCHANGE':
        return Icons.published_with_changes_rounded;
      default:
        return Icons.handshake_outlined;
    }
  }
}
