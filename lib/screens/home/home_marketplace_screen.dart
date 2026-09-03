import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/marketplace/campus_deals_banner.dart';
import '../../widgets/marketplace/category_grid_selector.dart';
import '../../widgets/marketplace/course_filter_bar.dart';
import '../../widgets/marketplace/horizontal_resource_section.dart';
import '../../widgets/marketplace/quick_action_bar.dart';
import '../../widgets/marketplace/welcome_hero_card.dart';

class HomeMarketplaceScreen extends StatelessWidget {
  const HomeMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final resourceProvider = appState.resourceProvider;
    final authProvider = appState.authProvider;
    final user = authProvider.user ?? UserModel.mockUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFE),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 10,
        title: Row(
          children: [
            // Hamburger Menu Button
            IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Color(0xFF0F172A),
                size: 26,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu clicked')),
                );
              },
            ),
            const SizedBox(width: 2),

            // Creative Official Logo Badge
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Logo & Tagline Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "Campus" Navy + "Loop" Indigo-Purple
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'Campus',
                          style: TextStyle(color: Color(0xFF0F172A)),
                        ),
                        TextSpan(
                          text: 'Loop',
                          style: TextStyle(color: Color(0xFF4F46E5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                  // Subtitle: "Reuse more. Spend less. Build a circular campus."
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: 'Reuse more. Spend less. Build a '),
                        TextSpan(
                          text: 'circular campus.',
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Notification Bell with Badge "3"
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF0F172A),
                  size: 26,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You have 3 new notifications.')),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          // User Avatar with Verified Green Checkmark
          Padding(
            padding: const EdgeInsets.only(right: 14.0, left: 4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.collegeVerification);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: resourceProvider,
        builder: (context, _) {
          final allResources = resourceProvider.resources;

          // Recommended Items
          final recommendedItems = allResources
              .where((r) => r.isRecommended)
              .toList();

          // Recent Listings Near You
          final nearbyResources = allResources
              .where((r) => r.isNearby || r.distanceMeters != null)
              .toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),

                // 1. Search Bar (Pill with filter sliders)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF4F46E5),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => resourceProvider.setSearchQuery(val),
                            decoration: const InputDecoration(
                              hintText: 'Search books, tools, electronics, kits...',
                              hintStyle: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF4F46E5),
                            size: 22,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.mainShell);
                          },
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // 2. Welcome Back Hero Banner Card (With official creative logo integration)
                WelcomeHeroCard(
                  userName: user.name,
                  isVerified: user.isVerifiedStudent,
                ),

                const SizedBox(height: 8),

                // 3. Explore by Category (2x4 Grid)
                CategoryGridSelector(
                  selectedCategory: resourceProvider.selectedCategory,
                  onCategorySelected: (cat) => resourceProvider.setCategory(cat),
                ),

                const SizedBox(height: 12),

                // 4. Quick Actions (6 Cards)
                QuickActionBar(
                  selectedType: resourceProvider.selectedType,
                  onTypeSelected: (type) => resourceProvider.setResourceType(type),
                ),

                const SizedBox(height: 12),

                // 5. Course Option (Browse by Academic Course)
                CourseFilterBar(
                  selectedCourse: resourceProvider.selectedCourse,
                  onCourseSelected: (course) => resourceProvider.setCourse(course),
                ),

                const SizedBox(height: 10),

                // 5. Great Deals Near You Promotional Banner (With high-res campus students illustration asset)
                CampusDealsBanner(
                  onExplore: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exploring great campus deals!')),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // 6. Recommended for You Section
                HorizontalResourceSection(
                  title: 'Recommended for You',
                  items: recommendedItems.isNotEmpty
                      ? recommendedItems
                      : allResources.take(4).toList(),
                  isCompact: false,
                  onSeeAll: () {
                    Navigator.pushNamed(context, AppRoutes.category, arguments: 'All');
                  },
                ),

                const SizedBox(height: 8),

                // 7. Recent Listings Near You Section
                HorizontalResourceSection(
                  title: 'Recent Listings Near You',
                  items: nearbyResources.isNotEmpty
                      ? nearbyResources
                      : allResources.skip(4).toList(),
                  isCompact: true,
                  onSeeAll: () {
                    Navigator.pushNamed(context, AppRoutes.category, arguments: 'All');
                  },
                ),

                const SizedBox(height: 12),

                // 8. Creative Circular Campus Movement Banner Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0F172A),
                          Color(0xFF1E293B),
                          Color(0xFF064E3B),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Official Logo Graphic with glow
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Text & Action
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Circular Campus Movement',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reuse more, spend less. Every book & kit circulated prevents campus waste.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.impactDashboard);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'View Campus Impact',
                                      style: TextStyle(
                                        color: Color(0xFF34D399),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
                                      color: Color(0xFF34D399),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom padding to ensure content is not hidden behind the floating bottom bar
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}
