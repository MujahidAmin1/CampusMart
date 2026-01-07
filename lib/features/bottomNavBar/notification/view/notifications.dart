import 'package:campusmart/core/providers.dart';
import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/features/bottomNavBar/notification/controller/notification_contr.dart';
import 'package:campusmart/models/app_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final currentUser = ref.watch(firebaseAuthProvider).currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: kTextStyle(
            size: 20,
            isBold: true,
            color: MyColors.darkBase,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // Mark all as read button
          notificationsAsync.when(
            data: (notifications) {
              final hasUnread = notifications.any((n) => !n.isRead);
              if (hasUnread) {
                return IconButton(
                  onPressed: () {
                    ref.read(notificationControllerProvider.notifier).markAllAsRead();
                  },
                  icon: Icon(
                    Iconsax.tick_circle,
                    color: MyColors.purpleShade,
                  ),
                  tooltip: 'Mark all as read',
                );
              }
              return SizedBox.shrink();
            },
            loading: () => SizedBox.shrink(),
            error: (_, __) => SizedBox.shrink(),
          ),
        ],
      ),
      body: currentUser == null 
          ? Center(child: Text("Please sign in"))
          : notificationsAsync.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.notification,
                          size: 64,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No notifications yet',
                          style: kTextStyle(
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationTile(notification: notification);
                  },
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: MyColors.purpleShade,
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Error loading notifications',
                  style: kTextStyle(size: 16, color: Colors.grey),
                ),
              ),
            ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusInfo = _getStatusInfo(notification.type);

    return GestureDetector(
      onTap: () {
        // Mark as read when tapped
        if (!notification.isRead) {
          ref.read(notificationControllerProvider.notifier).markAsRead(notification.id);
        }
        // TODO: Navigate to order details if relatedId is available
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : MyColors.purpleShade.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: notification.isRead 
                ? Colors.grey.withOpacity(0.1)
                : MyColors.purpleShade.withOpacity(0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusInfo.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusInfo.icon,
                color: statusInfo.color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: MyColors.purpleShade,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Expanded(
                              child: Text(
                                notification.title,
                                style: kTextStyle(
                                  size: 16,
                                  isBold: true,
                                  color: MyColors.darkBase,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        _formatDate(notification.createdAt),
                        style: kTextStyle(
                          size: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: kTextStyle(
                      size: 14,
                      color: MyColors.darkBase.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return DateFormat('E, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }

  _StatusInfo _getStatusInfo(NotificationType? type) {
    switch (type) {
      case NotificationType.orderNew:
        return _StatusInfo(
          icon: Iconsax.shopping_bag,
          color: MyColors.purpleShade,
        );
      case NotificationType.orderPaid:
        return _StatusInfo(
          icon: Iconsax.wallet_check,
          color: MyColors.purpleShade,
        );
      case NotificationType.orderShipped:
        return _StatusInfo(
          icon: Iconsax.truck,
          color: MyColors.purpleShade,
        );
      case NotificationType.orderCollected:
        return _StatusInfo(
          icon: Iconsax.box_tick,
          color: Colors.green,
        );
      case NotificationType.orderCompleted:
        return _StatusInfo(
          icon: Iconsax.tick_circle,
          color: Colors.green,
        );
      case NotificationType.paymentReleased:
        return _StatusInfo(
          icon: Iconsax.money_recive,
          color: Colors.green,
        );
      case NotificationType.general:
      case null:
        return _StatusInfo(
          icon: Iconsax.notification,
          color: Colors.grey,
        );
    }
  }
}

class _StatusInfo {
  final IconData icon;
  final Color color;

  _StatusInfo({
    required this.icon,
    required this.color,
  });
}
