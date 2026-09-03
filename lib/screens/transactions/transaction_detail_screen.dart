import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/campus_badge.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/transactions/rating_dialog.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TransactionModel _currentTx;

  @override
  void initState() {
    super.initState();
    _currentTx = widget.transaction;
  }

  void _advanceState(TransactionStatus nextStatus) async {
    final provider = AppStateProvider.of(context).transactionProvider;
    final success = await provider.updateStatus(_currentTx.id, nextStatus);
    if (success && mounted) {
      setState(() {
        _currentTx = _currentTx.copyWith(status: nextStatus);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction updated: ${nextStatus.displayName}')),
      );
    }
  }

  void _openRating() {
    RatingDialog.show(
      context,
      otherStudentName: _currentTx.sellerName,
      onSubmit: (rating, review) async {
        final provider = AppStateProvider.of(context).transactionProvider;
        final success = await provider.submitRating(_currentTx.id, rating, review);
        if (success && mounted) {
          setState(() {
            _currentTx = _currentTx.copyWith(
              status: TransactionStatus.rated,
              rating: rating,
              review: review,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rating and trust feedback recorded!')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tx = _currentTx;

    return Scaffold(
      appBar: AppBar(
        title: Text('${tx.transactionType.name.toUpperCase()} Transaction'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resource Header Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.loop_rounded, color: theme.colorScheme.primary, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.resourceTitle,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${tx.transactionType.name.toUpperCase()} • ${Formatters.formatCurrency(tx.resourcePrice)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campus Pickup Location Card
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
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(tx.pickupLocation, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Other Student Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            radius: 20,
                            child: Text(
                              tx.sellerName.isNotEmpty ? tx.sellerName[0] : 'S',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.sellerName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const CampusBadge(university: 'Stanford', isCompact: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Explicit Transaction Step Timeline
                  Text(
                    'Transaction Timeline Progress',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _buildTimelineSteps(tx),

                  if (tx.status == TransactionStatus.rated && tx.rating != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 8),
                          Text(
                            'Your Rating: ${tx.rating} ★',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tx.review ?? 'Great student exchange!',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Button based on current explicit transaction state
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _buildStateActionButton(tx),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSteps(TransactionModel tx) {
    final steps = _getStepsForType(tx.transactionType);
    final currentStepIndex = _getCurrentStepIndex(tx.status, tx.transactionType);

    return Column(
      children: List.generate(steps.length, (index) {
        final stepName = steps[index];
        final isPassed = index <= currentStepIndex;
        final isCurrent = index == currentStepIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: isPassed
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    isPassed ? Icons.check : Icons.circle,
                    size: 14,
                    color: isPassed ? Colors.white : Colors.grey,
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 28,
                    color: isPassed
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  stepName,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isPassed
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  List<String> _getStepsForType(TransactionType type) {
    switch (type) {
      case TransactionType.sell:
        return ['1. Request & Terms Agreed', '2. Scheduled for Pickup', '3. Item Picked Up', '4. Completed & Rated'];
      case TransactionType.borrow:
        return ['1. Request & Owner Approved', '2. Pickup & Borrow Start', '3. Currently Borrowed', '4. Returned & Rated'];
      case TransactionType.exchange:
        return ['1. Item Offered & Accepted', '2. Terms Confirmed', '3. On-Campus Exchange', '4. Completed & Rated'];
      case TransactionType.donate:
        return ['1. Donation Requested', '2. Owner Approved', '3. On-Campus Pickup', '4. Completed & Rated'];
    }
  }

  int _getCurrentStepIndex(TransactionStatus status, TransactionType type) {
    switch (status) {
      case TransactionStatus.requested:
      case TransactionStatus.negotiating:
        return 0;
      case TransactionStatus.agreed:
      case TransactionStatus.approved:
        return 0;
      case TransactionStatus.scheduledForPickup:
        return 1;
      case TransactionStatus.pickedUp:
      case TransactionStatus.borrowed:
        return 2;
      case TransactionStatus.returned:
      case TransactionStatus.completed:
        return 3;
      case TransactionStatus.rated:
        return 3;
      case TransactionStatus.cancelled:
        return 0;
    }
  }

  Widget _buildStateActionButton(TransactionModel tx) {
    switch (tx.status) {
      case TransactionStatus.requested:
      case TransactionStatus.negotiating:
        return CustomButton(
          text: 'Agree to Terms & Confirm Pickup Spot',
          onPressed: () => _advanceState(TransactionStatus.scheduledForPickup),
          icon: Icons.check_circle_outline,
        );
      case TransactionStatus.agreed:
      case TransactionStatus.approved:
        return CustomButton(
          text: 'Schedule On-Campus Pickup',
          onPressed: () => _advanceState(TransactionStatus.scheduledForPickup),
          icon: Icons.event_available,
        );
      case TransactionStatus.scheduledForPickup:
        return CustomButton(
          text: tx.transactionType == TransactionType.borrow
              ? 'Confirm Pickup & Start Borrowing'
              : 'Confirm On-Campus Pickup Complete',
          onPressed: () => _advanceState(
            tx.transactionType == TransactionType.borrow
                ? TransactionStatus.borrowed
                : TransactionStatus.completed,
          ),
          icon: Icons.task_alt,
        );
      case TransactionStatus.pickedUp:
        return CustomButton(
          text: 'Confirm On-Campus Pickup Complete',
          onPressed: () => _advanceState(TransactionStatus.completed),
          icon: Icons.task_alt,
        );
      case TransactionStatus.borrowed:
        return CustomButton(
          text: 'Confirm Item Returned to Owner',
          onPressed: () => _advanceState(TransactionStatus.completed),
          icon: Icons.assignment_return_rounded,
        );
      case TransactionStatus.completed:
      case TransactionStatus.returned:
        return CustomButton(
          text: 'Rate Student & Complete Feedback',
          onPressed: _openRating,
          icon: Icons.star_rounded,
        );
      case TransactionStatus.rated:
        return OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          label: const Text('Transaction Completed & Rated'),
        );
      case TransactionStatus.cancelled:
        return const Text('Transaction Cancelled', textAlign: TextAlign.center);
    }
  }
}
