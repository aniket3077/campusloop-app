import 'package:flutter/material.dart';
import '../../models/academic_resource_model.dart';
import '../../models/report_model.dart';
import '../../screens/auth/college_verification_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/verification_pending_screen.dart';
import '../../screens/auth/verification_success_screen.dart';
import '../../screens/chat/chat_detail_screen.dart';
import '../../screens/chat/chat_list_screen.dart';
import '../../screens/digital/create_digital_listing_screen.dart';
import '../../screens/digital/digital_marketplace_screen.dart';
import '../../screens/discovery/category_screen.dart';
import '../../screens/impact/impact_dashboard_screen.dart';
import '../../screens/listings/create_listing_screen.dart';
import '../../screens/listings/my_listings_screen.dart';
import '../../screens/listings/resource_detail_screen.dart';
import '../../screens/pickup/admin_pickup_locations_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/transactions/transaction_history_screen.dart';
import '../../screens/trust/rating_screen.dart';
import '../../screens/trust/report_screen.dart';
import 'app_routes.dart';
import 'main_navigation_shell.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const MainNavigationShell());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.collegeVerification:
        return MaterialPageRoute(builder: (_) => const CollegeVerificationScreen());

      case AppRoutes.verificationPending:
        return MaterialPageRoute(builder: (_) => const VerificationPendingScreen());

      case AppRoutes.verificationSuccess:
        return MaterialPageRoute(builder: (_) => const VerificationSuccessScreen());

      case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => const MainNavigationShell());

      case AppRoutes.createListing:
        return MaterialPageRoute(builder: (_) => const CreateListingScreen());

      case AppRoutes.myListings:
        return MaterialPageRoute(builder: (_) => const MyListingsScreen());

      case AppRoutes.chatList:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());

      case AppRoutes.transactions:
        return MaterialPageRoute(builder: (_) => const TransactionHistoryScreen());

      case AppRoutes.adminPickupLocations:
        return MaterialPageRoute(builder: (_) => const AdminPickupLocationsScreen());

      case AppRoutes.digitalMarketplace:
        return MaterialPageRoute(builder: (_) => const DigitalMarketplaceScreen());

      case AppRoutes.createDigitalListing:
        return MaterialPageRoute(builder: (_) => const CreateDigitalListingScreen());

      case AppRoutes.impactDashboard:
        return MaterialPageRoute(builder: (_) => const ImpactDashboardScreen());

      case AppRoutes.rating:
        return MaterialPageRoute(
          builder: (_) => const RatingScreen(
            transactionId: 'tx_001',
            resourceTitle: 'Linear Algebra & Its Applications',
            targetUserId: 'user_102',
            targetUserName: 'Marcus Chen',
          ),
        );

      case AppRoutes.report:
        return MaterialPageRoute(
          builder: (_) => const ReportScreen(
            type: ReportType.user,
            targetId: 'user_102',
            targetTitle: 'Marcus Chen',
          ),
        );

      case AppRoutes.category:
        final categoryName = (settings.arguments as String?) ?? 'Books';
        return MaterialPageRoute(
          builder: (_) => CategoryScreen(categoryName: categoryName),
        );

      case AppRoutes.resourceDetail:
        final resource = settings.arguments as AcademicResourceModel?;
        if (resource != null) {
          return MaterialPageRoute(
            builder: (_) => ResourceDetailScreen(resource: resource),
          );
        }
        return _errorRoute();

      case AppRoutes.chatDetail:
        final conversationId = (settings.arguments as String?) ?? 'conv_001';
        return MaterialPageRoute(
          builder: (_) => ChatDetailScreen(conversationId: conversationId),
        );

      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Route not found'),
        ),
      ),
    );
  }
}
