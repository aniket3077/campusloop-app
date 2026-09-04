import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/app_notification_model.dart';
import '../../providers/app_state_provider.dart';

class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final notifProvider = appState.notificationProvider;
    final notifications = notifProvider.notifications;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_rounded, color: Color(0xFF4F46E5), size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                if (notifProvider.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${notifProvider.unreadCount} new',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                if (notifications.isNotEmpty)
                  TextButton(
                    onPressed: () => notifProvider.markAllAsRead(),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4F46E5),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Mark all read', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),

          // Quick Simulation Banner for Testing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app_rounded, color: Color(0xFF4F46E5), size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Test sending seller message OS notification banner:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3730A3)),
                    ),
                  ),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      notifProvider.notifyMessageSentToSeller(
                        context: context,
                        conversationId: 'conv_001',
                        sellerName: 'Campus Seller',
                        itemTitle: 'TI-84 Plus CE Calculator',
                        messageText: 'Hi! Is this available for ₹1,100 campus pickup?',
                        priceOffer: 1100.0,
                      );
                    },
                    child: const Text('Test OS Banner', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Notifications List
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 54, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text('No notifications yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        const Text('Messages and offers from buyers & sellers appear here.', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFF1F5F9)),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return _NotificationTile(
                        notification: item,
                        onTap: () {
                          notifProvider.markAsRead(item.id);
                          Navigator.pop(context);
                          if (item.conversationId != null) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.chatDetail,
                              arguments: item.conversationId,
                            );
                          }
                        },
                      );
                    },
                  ),
          ),

          // Bottom Bar with Clear All
          if (notifications.isNotEmpty)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => notifProvider.clearAll(),
                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFF94A3B8)),
                      label: const Text('Clear All Notifications', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final timeStr = _formatTimestamp(notification.timestamp);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread ? const Color(0xFFF8FAFC) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar / Icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _getBgColor(notification.type),
                  child: Icon(
                    _getIcon(notification.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (isUnread)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.senderName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                  if (notification.itemTitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Re: ${notification.itemTitle}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUnread ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Interactive action button
                  if (notification.conversationId != null)
                    Row(
                      children: [
                        FilledButton.tonal(
                          onPressed: onTap,
                          style: FilledButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            backgroundColor: const Color(0xFFEEF2FF),
                            foregroundColor: const Color(0xFF4F46E5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded, size: 13),
                              SizedBox(width: 5),
                              Text('Open Chat', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icons.chat_rounded;
      case NotificationType.offer:
        return Icons.local_offer_rounded;
      case NotificationType.transaction:
        return Icons.qr_code_2_rounded;
      case NotificationType.system:
        return Icons.campaign_rounded;
    }
  }

  Color _getBgColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return const Color(0xFF4F46E5);
      case NotificationType.offer:
        return const Color(0xFF10B981);
      case NotificationType.transaction:
        return const Color(0xFFF59E0B);
      case NotificationType.system:
        return const Color(0xFF6366F1);
    }
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}';
  }
}
