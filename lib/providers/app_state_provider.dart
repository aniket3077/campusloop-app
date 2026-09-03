import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'resource_provider.dart';
import 'chat_provider.dart';
import 'theme_provider.dart';

class AppStateProvider extends InheritedWidget {
  final AuthProvider authProvider;
  final ResourceProvider resourceProvider;
  final ChatProvider chatProvider;
  final ThemeProvider themeProvider;

  const AppStateProvider({
    super.key,
    required this.authProvider,
    required this.resourceProvider,
    required this.chatProvider,
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
        themeProvider != oldWidget.themeProvider;
  }
}
