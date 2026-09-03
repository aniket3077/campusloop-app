import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/academic_resource_model.dart';
import '../../models/digital_product_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/digital/digital_access_delivery_widget.dart';
import '../../widgets/listings/make_offer_bottom_sheet.dart';

class DigitalProductDetailScreen extends StatefulWidget {
  final DigitalProductModel product;

  const DigitalProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<DigitalProductDetailScreen> createState() => _DigitalProductDetailScreenState();
}

class _DigitalProductDetailScreenState extends State<DigitalProductDetailScreen> {
  bool _isPurchased = false;
  String? _transactionId;

  void _onBuyAccess() async {
    final appState = AppStateProvider.of(context);
    final txProvider = appState.transactionProvider;

    final txId = 'tx_${DateTime.now().millisecondsSinceEpoch}';
    final newTx = TransactionModel(
      id: txId,
      resourceId: widget.product.id,
      resourceTitle: widget.product.courseName,
      resourcePrice: widget.product.price,
      transactionType: TransactionType.sell,
      buyerId: 'user_101',
      buyerName: 'Alex Rivera',
      sellerId: widget.product.sellerId,
      sellerName: widget.product.sellerName,
      status: TransactionStatus.completed,
      pickupLocation: 'Digital Instant Transfer',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await txProvider.createTransaction(newTx);

    if (mounted) {
      setState(() {
        _isPurchased = true;
        _transactionId = txId;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction confirmed! Digital course code unlocked below.')),
      );
    }
  }

  void _openOffer() {
    final mockResource = AcademicResourceModel(
      id: widget.product.id,
      title: widget.product.courseName,
      description: widget.product.description,
      category: 'Books',
      resourceType: 'SELL',
      price: widget.product.price,
      condition: 'Like New',
      pickupLocation: 'Digital Transfer',
      sellerId: widget.product.sellerId,
      sellerName: widget.product.sellerName,
      sellerRating: widget.product.sellerRating,
      isVerifiedSeller: widget.product.isVerifiedSeller,
      university: widget.product.university,
      imageUrls: [],
      createdAt: DateTime.now(),
    );

    MakeOfferBottomSheet.show(context, mockResource);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.courseName),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Type & Provider Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 36, color: Colors.blue.shade800),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.productType.displayName,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue.shade900),
                              ),
                              Text(
                                'Provider: ${p.providerPlatform}',
                                style: TextStyle(fontSize: 13, color: Colors.blue.shade800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'Proof of Ownership Verified',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(p.price),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    p.courseName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.event_available_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Expiry: ${p.validityExpiry}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Product Details & Description',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.description,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Post-Payment Access Code Card
                  if (_isPurchased && _transactionId != null) ...[
                    DigitalAccessDeliveryWidget(
                      productId: p.id,
                      transactionId: _transactionId!,
                      courseName: p.courseName,
                      providerPlatform: p.providerPlatform,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Seller Profile Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            radius: 20,
                            child: Text(
                              p.sellerName.isNotEmpty ? p.sellerName[0] : 'S',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(p.sellerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                                    Text('${p.sellerRating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                CampusBadge(university: p.university, isCompact: true),
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

          // Action Bar
          if (!_isPurchased)
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, -2)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Chat',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.chatDetail, arguments: 'conv_001');
                        },
                        isOutlined: true,
                        icon: Icons.chat_bubble_outline_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomButton(
                        text: 'Offer',
                        onPressed: _openOffer,
                        isOutlined: true,
                        icon: Icons.handshake_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: 'Buy Access',
                        onPressed: _onBuyAccess,
                        icon: Icons.shopping_bag_rounded,
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
