import 'package:campusmart/core/providers.dart';
import 'package:campusmart/features/bottomNavBar/notification/repository/notification_repo.dart';
import 'package:campusmart/features/bottomNavBar/orders/controller/order_contr.dart';
import 'package:campusmart/features/bottomNavBar/listings/repository/listing_repo.dart';
import 'package:campusmart/models/app_notification.dart';
import 'package:campusmart/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationListenerWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const NotificationListenerWrapper({super.key, required this.child});

  @override
  ConsumerState<NotificationListenerWrapper> createState() =>
      _NotificationListenerWrapperState();
}

class _NotificationListenerWrapperState
    extends ConsumerState<NotificationListenerWrapper> {
  Map<String, OrderStatus> _previousOrderStatuses = {};
  bool _isFirstLoad = true;

  Future<String> _getProductTitle(String productId) async {
    try {
      final product = await ref.read(productRepositoryProvider).fetchProductById(productId);
      return product?.title ?? 'Unknown Product';
    } catch (e) {
      return 'Unknown Product';
    }
  }

  /// Creates an in-app notification in Firestore for the specified user
  Future<void> _createNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    required String orderId,
  }) async {
    await ref.read(notificationRepositoryProvider).createNotification(
      userId: userId,
      title: title,
      body: body,
      type: type,
      relatedId: orderId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    
    // Listen to the stream of all orders
    ref.listen(allOrdersProvider, (previous, next) {
      if (currentUserId == null) return;
      
      if (_isFirstLoad) {
        // On first load, just populate the map, don't notify
        if (next.isNotEmpty) {
          _previousOrderStatuses = {
            for (var order in next) order.orderId: order.status
          };
          _isFirstLoad = false;
        }
        return;
      }

      for (var order in next) {
        final previousStatus = _previousOrderStatuses[order.orderId];
        final currentStatus = order.status;
        
        // Determine current user's role in this order
        final isBuyer = order.buyerId == currentUserId;
        final isSeller = order.sellerId == currentUserId;
        
        if (!isBuyer && !isSeller) {
          // This order doesn't involve the current user, skip
          continue;
        }

        // Check for new order (buyer places order)
        if (previousStatus == null) {
          // Only buyer creates notifications for new orders
          if (isBuyer) {
            _getProductTitle(order.productId).then((productTitle) {
              // Send "new order" notification to seller
              _createNotification(
                userId: order.sellerId,
                title: 'New Order Received!',
                body: 'You have a new order for $productTitle - ₦${order.amount}\norderId: ${order.orderId.substring(0, 6)}...',
                type: NotificationType.orderNew,
                orderId: order.orderId,
              );
              
              // If order is created with paid status, also send paid notifications
              if (currentStatus == OrderStatus.paid) {
                // Buyer gets payment confirmation
                _createNotification(
                  userId: order.buyerId,
                  title: 'Payment Successful',
                  body: 'You have successfully paid for $productTitle',
                  type: NotificationType.orderPaid,
                  orderId: order.orderId,
                );
                // Seller gets payment received notification
                _createNotification(
                  userId: order.sellerId,
                  title: 'Payment Received',
                  body: 'Buyer has paid for $productTitle - ₦${order.amount}',
                  type: NotificationType.orderPaid,
                  orderId: order.orderId,
                );
              }
            });
          }
         
          _previousOrderStatuses[order.orderId] = currentStatus;
        } 
        // Check for status change
        else if (previousStatus != currentStatus) {
          _getProductTitle(order.productId).then((productTitle) {
            
            if (currentStatus == OrderStatus.paid) {
              // Buyer triggers payment, so ONLY BUYER creates notifications for both parties
              if (isBuyer) {
                // Buyer gets payment confirmation
                _createNotification(
                  userId: order.buyerId,
                  title: 'Payment Successful',
                  body: 'You have successfully paid for $productTitle',
                  type: NotificationType.orderPaid,
                  orderId: order.orderId,
                );
                // Seller gets payment received notification
                _createNotification(
                  userId: order.sellerId,
                  title: 'Payment Received',
                  body: 'Buyer has paid for $productTitle - ₦${order.amount}',
                  type: NotificationType.orderPaid,
                  orderId: order.orderId,
                );
              }
              // Note: Seller does NOT create notifications for 'paid' status
              // to avoid duplicates
            }
            // For admin-triggered status changes (shipped, collected, completed),
            // notifications should be created from the admin panel when the status
            // is changed, NOT from user apps. This prevents duplicate notifications
            // from both buyer and seller apps seeing the same change.
            //
            // The following status changes are handled by admin actions:
            // - shipped: Admin drops off item at pickup station
            // - collected: Admin confirms buyer collected item  
            // - completed: Admin releases payment to seller
          });
          
          _previousOrderStatuses[order.orderId] = currentStatus;
        }
      }
    });

    return widget.child;
  }
}
