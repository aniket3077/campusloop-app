import 'package:flutter/material.dart';
import '../../models/rating_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';

class RatingScreen extends StatefulWidget {
  final String transactionId;
  final String resourceTitle;
  final String targetUserId;
  final String targetUserName;

  const RatingScreen({
    super.key,
    required this.transactionId,
    required this.resourceTitle,
    required this.targetUserId,
    required this.targetUserName,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 5.0;
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _onSubmitRating() async {
    setState(() => _isSubmitting = true);

    final appState = AppStateProvider.of(context);
    final user = appState.authProvider.user ?? UserModel.mockUser;

    final newRating = RatingModel(
      id: 'rt_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: widget.transactionId,
      resourceTitle: widget.resourceTitle,
      raterId: user.id,
      raterName: user.name,
      ratedUserId: widget.targetUserId,
      rating: _rating,
      feedback: _feedbackController.text.trim().isNotEmpty ? _feedbackController.text.trim() : null,
      createdAt: DateTime.now(),
    );

    final success = await appState.trustProvider.submitRating(newRating);
    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trust rating and feedback recorded! Thank you for supporting campus safety.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Student Experience'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFDEA7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Color(0xFF7D5800), size: 48),
            ),
            const SizedBox(height: 16),

            Text(
              'How was your trade with ${widget.targetUserName}?',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Transaction: ${widget.resourceTitle}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 1 to 5 Star Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1.0;
                return IconButton(
                  icon: Icon(
                    _rating >= starValue ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 38,
                  ),
                  onPressed: () => setState(() => _rating = starValue),
                );
              }),
            ),
            const SizedBox(height: 8),

            Text(
              'Rating: ${_rating.toStringAsFixed(1)} / 5.0',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 24),

            // Written Feedback
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Optional Written Feedback',
                hintText: 'Comment on item condition match, pickup punctuality, or communication...',
              ),
            ),
            const SizedBox(height: 32),

            CustomButton(
              text: 'Submit Student Rating',
              onPressed: _onSubmitRating,
              isLoading: _isSubmitting,
              icon: Icons.check_circle_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
