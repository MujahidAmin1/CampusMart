import 'package:campusmart/core/providers.dart';
import 'package:campusmart/core/services/notification_service.dart';
import 'package:campusmart/features/bottomNavBar/orders/controller/order_contr.dart';
import 'package:campusmart/features/bottomNavBar/listings/repository/listing_repo.dart';
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

  @override
  Widget build(BuildContext context) {
    // Listen to the stream of all orders
    ref.listen(allOrdersProvider, (previous, next) {
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
        final currentUserId = ref.read(firebaseAuthProvider).currentUser?.uid;

        // Check for new order
        if (previousStatus == null) {
          // It's a new order!
          final isSeller = order.sellerId == currentUserId;
          
          if (isSeller) {
            // Fetch product title asynchronously and show notification
            _getProductTitle(order.productId).then((productTitle) {
              NotificationService().showNotification(
                id: order.orderId.hashCode,
                title: 'New Order Received!',
                body: 'You have a new order for $productTitle - ₦${order.amount}',
              );
            });
          }
         
          _previousOrderStatuses[order.orderId] = currentStatus;
        } 
        // Check for status change
        else if (previousStatus != currentStatus) {
          final isSeller = order.sellerId == currentUserId;
          
          // Fetch product title asynchronously and show notification
          _getProductTitle(order.productId).then((productTitle) {
            String title = 'Order Update';
            String body = '$productTitle - Order #${order.orderId.substring(0, 8)} status changed to ${orderStatusToString(currentStatus)}';

            if (isSeller) {
               if (currentStatus == OrderStatus.paid) {
                  title = 'Payment Received';
                  body = 'Buyer has paid for $productTitle';
               }
            } else {
               // Buyer notifications
               if (currentStatus == OrderStatus.shipped) {
                 title = 'Order Shipped!';
                 body = 'Your order for $productTitle is on its way.';
               } else if (currentStatus == OrderStatus.collected) {
                 title = 'Order Delivered';
                 body = 'Your order for $productTitle has been collected.';
               }
            }

            NotificationService().showNotification(
              id: order.orderId.hashCode,
              title: title,
              body: body,
            );
          });
          
          _previousOrderStatuses[order.orderId] = currentStatus;
        }
      }
    });

    return widget.child;
  }
}
