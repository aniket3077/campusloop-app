import 'package:flutter/material.dart';
import '../../models/offer_model.dart';
import '../../providers/app_state_provider.dart';

class OfferDialog extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final double originalPrice;
  final OfferModel? parentOffer; // If countering

  const OfferDialog({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.originalPrice,
    this.parentOffer,
  });

  static void show(
    BuildContext context, {
    required String itemId,
    required String itemTitle,
    required double originalPrice,
    OfferModel? parentOffer,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => OfferDialog(
        itemId: itemId,
        itemTitle: itemTitle,
        originalPrice: originalPrice,
        parentOffer: parentOffer,
      ),
    );
  }

  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  final _priceController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final defaultPrice = widget.parentOffer != null
        ? widget.parentOffer!.offeredPrice
        : (widget.originalPrice > 0 ? widget.originalPrice * 0.85 : 0.0);
    _priceController.text = defaultPrice.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitOffer() async {
    final price = double.tryParse(_priceController.text);
    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price offer')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final offerProvider = AppStateProvider.of(context).offerProvider;
    final chatProvider = AppStateProvider.of(context).chatProvider;

    if (widget.parentOffer != null) {
      // Submit Counter Offer
      final counter = await offerProvider.counterOffer(
        widget.parentOffer!.offerId,
        price,
        _messageController.text.trim().isNotEmpty
            ? _messageController.text.trim()
            : 'Counter offer proposal',
      );

      if (counter != null && mounted) {
        await chatProvider.sendMessage(
          'conv_001',
          'Counter offer proposed: \$${price.toStringAsFixed(2)}',
          priceOffer: price,
        );
      }
    } else {
      // Submit Initial Offer
      final newOffer = OfferModel(
        offerId: 'ofr_${DateTime.now().millisecondsSinceEpoch}',
        itemId: widget.itemId,
        itemTitle: widget.itemTitle,
        buyerId: 'user_101',
        sellerId: 'user_102',
        originalPrice: widget.originalPrice,
        offeredPrice: price,
        message: _messageController.text.trim().isNotEmpty ? _messageController.text.trim() : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await offerProvider.createOffer(newOffer);
      if (created != null && mounted) {
        await chatProvider.sendMessage(
          'conv_001',
          'Offered \$${price.toStringAsFixed(2)} for ${widget.itemTitle}',
          priceOffer: price,
        );
      }
    }

    setState(() => _isSubmitting = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.parentOffer != null
                ? 'Counter offer of \$${price.toStringAsFixed(2)} sent!'
                : 'Bargain offer of \$${price.toStringAsFixed(2)} sent!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCounter = widget.parentOffer != null;

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
                Icon(
                  isCounter ? Icons.swap_horizontal_circle_outlined : Icons.handshake_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isCounter ? 'Propose Counter Offer' : 'Make Bargain Offer',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Listed Price: \$${widget.originalPrice.toStringAsFixed(2)} • ${widget.itemTitle}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              isCounter ? 'Counter Price (\$)' : 'Your Offered Price (\$)',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money_rounded),
                hintText: 'Enter price offer',
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Note / Message',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. Willing to pick up today at Engineering Quad!',
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submitOffer,
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(isCounter ? 'Submit Counter Offer' : 'Send Offer'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
