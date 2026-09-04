import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/firebase/firebase_manager.dart';
import 'core/firebase/firestore_seeder.dart';
import 'core/navigation/app_router.dart';
import 'core/navigation/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/analytics_provider.dart';
import 'providers/app_state_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/digital_product_provider.dart';
import 'providers/offer_provider.dart';
import 'providers/resource_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/trust_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and Google Cloud Firestore
  try {
    await FirebaseManager.initialize().timeout(const Duration(seconds: 4));
  } catch (e) {
    debugPrint('[main] Firebase initialization notice: $e');
  }

  // 1. Launch UI immediately so the user never sees a black screen
  runApp(const CampusLoopApp());

  // 2. Seed sample database collections in background without blocking app startup
  FirestoreSeeder.seedIfEmpty().catchError((e) {
    debugPrint('[FirestoreSeeder] Background seeding notice: $e');
  });
}

class CampusLoopApp extends StatefulWidget {
  const CampusLoopApp({super.key});

  @override
  State<CampusLoopApp> createState() => _CampusLoopAppState();
}

class _CampusLoopAppState extends State<CampusLoopApp> {
  late final AuthProvider _authProvider;
  late final ResourceProvider _resourceProvider;
  late final ChatProvider _chatProvider;
  late final TransactionProvider _transactionProvider;
  late final OfferProvider _offerProvider;
  late final DigitalProductProvider _digitalProductProvider;
  late final TrustProvider _trustProvider;
  late final AnalyticsProvider _analyticsProvider;
  late final ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _resourceProvider = ResourceProvider();
    _chatProvider = ChatProvider();
    _transactionProvider = TransactionProvider();
    _offerProvider = OfferProvider();
    _digitalProductProvider = DigitalProductProvider();
    _trustProvider = TrustProvider();
    _analyticsProvider = AnalyticsProvider();
    _themeProvider = ThemeProvider();
  }

  @override
  void dispose() {
    _authProvider.dispose();
    _resourceProvider.dispose();
    _chatProvider.dispose();
    _transactionProvider.dispose();
    _offerProvider.dispose();
    _digitalProductProvider.dispose();
    _trustProvider.dispose();
    _analyticsProvider.dispose();
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      authProvider: _authProvider,
      resourceProvider: _resourceProvider,
      chatProvider: _chatProvider,
      transactionProvider: _transactionProvider,
      offerProvider: _offerProvider,
      digitalProductProvider: _digitalProductProvider,
      trustProvider: _trustProvider,
      analyticsProvider: _analyticsProvider,
      themeProvider: _themeProvider,
      child: ListenableBuilder(
        listenable: _themeProvider,
        builder: (context, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeProvider.themeMode,
            initialRoute: AppRoutes.mainShell,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
