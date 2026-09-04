import 'package:flutter/material.dart';
import '../core/navigation/app_router.dart';
import '../core/navigation/app_routes.dart';
import '../models/app_notification_model.dart';
import '../services/in_app_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final List<AppNotificationModel> _notifications = [];

  List<AppNotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Dispatch an interactive OS-style notification and store in history
  void showAndAddNotification({
    BuildContext? context,
    required AppNotificationModel notification,
    VoidCallback? onTap,
  }) {
    _notifications.insert(0, notification);
    notifyListeners();

    final targetContext = context ?? AppRouter.navigatorKey.currentContext;
    if (targetContext != null) {
      InAppNotificationService.show(
        context: targetContext,
        notification: notification,
        onTap: () {
          markAsRead(notification.id);
          if (onTap != null) {
            onTap();
          } else if (notification.conversationId != null) {
            Navigator.of(targetContext).pushNamed(
              AppRoutes.chatDetail,
              arguments: notification.conversationId,
            );
          }
        },
      );
    }
  }

  /// Dispatch notification when a message or offer is sent to seller
  void notifyMessageSentToSeller({
    BuildContext? context,
    required String conversationId,
    required String sellerName,
    required String messageText,
    String? itemTitle,
    String? itemId,
    double? priceOffer,
  }) {
    final notif = AppNotificationModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: priceOffer != null ? 'New Price Offer' : 'Message to Seller Sent',
      message: messageText,
      conversationId: conversationId,
      itemId: itemId,
      itemTitle: itemTitle,
      senderName: sellerName,
      priceOffer: priceOffer,
      type: priceOffer != null ? NotificationType.offer : NotificationType.message,
      timestamp: DateTime.now(),
      isRead: false,
    );

    showAndAddNotification(
      context: context,
      notification: notif,
      onTap: () {
        final ctx = context ?? AppRouter.navigatorKey.currentContext;
        if (ctx != null) {
          Navigator.of(ctx).pushNamed(
            AppRoutes.chatDetail,
            arguments: conversationId,
          );
        }
      },
    );
  }

  /// Mark single notification as read
  void markAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1 && !_notifications[idx].isRead) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      notifyListeners();
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
