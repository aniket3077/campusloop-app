import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/resource_type_chip.dart';
import '../pickup/select_pickup_location_screen.dart';
import 'transaction_detail_screen.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppStateProvider.of(context).transactionProvider;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Campus Transactions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Transactions'),
              Tab(text: 'Completed & History'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _buildTransactionList(context, provider.activeTransactions, isActive: true),
                _buildTransactionList(context, provider.completedTransactions, isActive: false),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, List<TransactionModel> txs, {required bool isActive}) {
    if (txs.isEmpty) {
      return EmptyStateWidget(
        icon: isActive ? Icons.loop_rounded : Icons.history_rounded,
        title: isActive ? 'No Active Transactions' : 'No Completed History Yet',
        message: isActive
            ? 'When you agree on a textbook or item transfer, active status will appear here.'
            : 'Completed campus trades and returned borrows will be archived here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: txs.length,
      itemBuilder: (context, index) {
        final tx = txs[index];
        final theme = Theme.of(context);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ResourceTypeChip(resourceType: tx.transactionType.name.toUpperCase()),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tx.status.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Text(
                  tx.resourceTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Seller/Owner: ${tx.sellerName}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      Formatters.formatCurrency(tx.resourcePrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Pickup: ${tx.pickupLocation}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransactionDetailScreen(transaction: tx),
                          ),
                        );
                      },
                      child: const Text('View Timeline'),
                    ),
                    const SizedBox(width: 8),
                    if (isActive)
                      FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectPickupLocationScreen(transaction: tx),
                            ),
                          );
                        },
                        child: const Text('Manage Pickup'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
