import 'package:flutter/material.dart';
import 'analytics_provider.dart';
import 'auth_provider.dart';
import 'chat_provider.dart';
import 'digital_product_provider.dart';
import 'offer_provider.dart';
import 'resource_provider.dart';
import 'theme_provider.dart';
import 'transaction_provider.dart';
import 'trust_provider.dart';

class AppStateProvider extends InheritedWidget {
  final AuthProvider authProvider;
  final ResourceProvider resourceProvider;
  final ChatProvider chatProvider;
  final TransactionProvider transactionProvider;
  final OfferProvider offerProvider;
  final DigitalProductProvider digitalProductProvider;
  final TrustProvider trustProvider;
  final AnalyticsProvider analyticsProvider;
  final ThemeProvider themeProvider;

  const AppStateProvider({
    super.key,
    required this.authProvider,
    required this.resourceProvider,
    required this.chatProvider,
    required this.transactionProvider,
    required this.offerProvider,
    required this.digitalProductProvider,
    required this.trustProvider,
    required this.analyticsProvider,
    required this.themeProvider,
    required super.child,
  });

  static AppStateProvider of(BuildContext context) {
    final AppStateProvider? result =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(result != null, 'No AppStateProvider found in context');
    return result!;
  }

  static AppStateProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    return authProvider != oldWidget.authProvider ||
        resourceProvider != oldWidget.resourceProvider ||
        chatProvider != oldWidget.chatProvider ||
        transactionProvider != oldWidget.transactionProvider ||
        offerProvider != oldWidget.offerProvider ||
        digitalProductProvider != oldWidget.digitalProductProvider ||
        trustProvider != oldWidget.trustProvider ||
        analyticsProvider != oldWidget.analyticsProvider ||
        themeProvider != oldWidget.themeProvider;
  }
}
