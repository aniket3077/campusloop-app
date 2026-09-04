import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/academic_resource_model.dart';
import '../../providers/app_state_provider.dart';

class MakeOfferBottomSheet extends StatefulWidget {
  final AcademicResourceModel resource;

  const MakeOfferBottomSheet({
    super.key,
    required this.resource,
  });

  static void show(BuildContext context, AcademicResourceModel resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MakeOfferBottomSheet(resource: resource),
    );
  }

  @override
  State<MakeOfferBottomSheet> createState() => _MakeOfferBottomSheetState();
}

class _MakeOfferBottomSheetState extends State<MakeOfferBottomSheet> {
  late final TextEditingController _offerPriceController;
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _offerPriceController = TextEditingController(
      text: widget.resource.price > 0
          ? (widget.resource.price * 0.9).toStringAsFixed(2)
          : '0.00',
    );
  }

  @override
  void dispose() {
    _offerPriceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitOffer() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.pop(context); // Close bottom sheet

    final appState = AppStateProvider.of(context);
    final chatProvider = appState.chatProvider;
    final currentUser = appState.authProvider.user;
    final offerPrice = double.tryParse(_offerPriceController.text);

    // Dynamically get or create conversation with the seller of this resource
    final conversation = chatProvider.getOrCreateConversationForResource(
      resource: widget.resource,
      currentUser: currentUser,
    );

    await chatProvider.sendMessage(
      conversation.id,
      _messageController.text.trim().isEmpty
          ? 'Proposing price offer of ₹${offerPrice?.toStringAsFixed(0)} for ${widget.resource.title}'
          : _messageController.text.trim(),
      priceOffer: offerPrice,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Offer of ₹${offerPrice?.toStringAsFixed(0)} sent to ${widget.resource.sellerName}!'),
          action: SnackBarAction(
            label: 'Open Chat',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.chatDetail, arguments: conversation.id);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.handshake_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Make Bargain Offer',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Listed price: ${Formatters.formatCurrency(widget.resource.price)} • ${widget.resource.sellerName}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Your Proposed Price (₹)',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _offerPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.currency_rupee_rounded),
                hintText: 'Enter offered price in ₹',
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Optional Message to Seller',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. Can pick up at MIT CSN Central Library today at 3 PM!',
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submitOffer,
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Send Offer to Seller'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
