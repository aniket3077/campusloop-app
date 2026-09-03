import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/marketplace/resource_card.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resourceProvider = AppStateProvider.of(context).resourceProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shared Resources'),
      ),
      body: ListenableBuilder(
        listenable: resourceProvider,
        builder: (context, _) {
          // User listings (e.g. sellerId == 'user_101')
          final myListings = resourceProvider.resources
              .where((r) => r.sellerId == 'user_101' || r.sellerName == 'Alex Rivera')
              .toList();

          if (myListings.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.inventory_2_outlined,
              title: 'No Active Listings Yet',
              message: 'Share your textbooks, lab gear, or study notes with fellow verified campus students!',
              buttonText: 'Post First Listing',
              onButtonPressed: () {
                Navigator.pushNamed(context, AppRoutes.createListing);
              },
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: myListings.length,
            itemBuilder: (context, index) {
              final item = myListings[index];
              return ResourceCard(
                resource: item,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.resourceDetail,
                    arguments: item,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
