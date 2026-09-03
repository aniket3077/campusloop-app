import 'package:flutter/material.dart';
import '../../models/academic_resource_model.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/student_verification_screen.dart';
import '../../screens/chat/chat_detail_screen.dart';
import '../../screens/listings/create_listing_screen.dart';
import '../../screens/listings/resource_detail_screen.dart';
import '../../screens/splash/splash_screen.dart';
import 'app_routes.dart';
import 'main_navigation_shell.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.studentVerification:
        return MaterialPageRoute(builder: (_) => const StudentVerificationScreen());

      case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => const MainNavigationShell());

      case AppRoutes.createListing:
        return MaterialPageRoute(builder: (_) => const CreateListingScreen());

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
