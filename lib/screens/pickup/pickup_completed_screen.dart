import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/transactions/rating_dialog.dart';

class PickupCompletedScreen extends StatelessWidget {
  final TransactionModel transaction;

  const PickupCompletedScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBorrow = transaction.transactionType == TransactionType.borrow;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                isBorrow ? 'Borrow Active & Item Collected!' : 'On-Campus Transfer Completed!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Verification QR confirmed at ${transaction.pickupLocation}.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Resource:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Expanded(
                            child: Text(
                              transaction.resourceTitle,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pickup Spot:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(transaction.pickupLocation, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Transaction Mode:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            transaction.transactionType.name.toUpperCase(),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                      if (isBorrow && transaction.expectedReturnDate != null) ...[
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Expected Return Date:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber)),
                            Text(
                              Formatters.formatRelativeTime(transaction.expectedReturnDate!),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber.shade900),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Rate Student Experience',
                onPressed: () {
                  RatingDialog.show(
                    context,
                    otherStudentName: transaction.sellerName,
                    onSubmit: (rating, review) async {
                      final provider = AppStateProvider.of(context).transactionProvider;
                      await provider.submitRating(transaction.id, rating, review);
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
                      }
                    },
                  );
                },
                icon: Icons.star_rounded,
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
                },
                child: const Text('Back to Campus Marketplace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
