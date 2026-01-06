import 'package:campusmart/core/providers.dart';
import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/features/bottomNavBar/orders/controller/order_contr.dart';
import 'package:campusmart/features/bottomNavBar/listings/repository/listing_repo.dart';
import 'package:campusmart/models/order.dart';
import 'package:campusmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

// Provider to fetch product by ID
final productByIdProvider = FutureProvider.autoDispose.family<Product?, String>((ref, productId) async {
  final repo = ref.watch(productRepositoryProvider);
  return await repo.fetchProductById(productId);
});

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(allOrdersProvider);
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
      ),
      body: currentUser == null 
          ? Center(child: Text("Please sign in"))
          : orders.isEmpty
              ? Center(
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
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _NotificationTile(
                      order: order,
                      currentUserId: currentUser.uid,
                    );
                  },
                ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final Order order;
  final String currentUserId;

  const _NotificationTile({
    required this.order,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSeller = order.sellerId == currentUserId;
    final statusInfo = _getStatusInfo(order.status, isSeller);
    final productAsync = ref.watch(productByIdProvider(order.productId));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
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
                      child: Text(
                        statusInfo.title,
                        style: kTextStyle(
                          size: 16,
                          isBold: true,
                          color: MyColors.darkBase,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _formatDate(order.orderDate),
                      style: kTextStyle(
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                productAsync.when(
                  data: (product) {
                    final productTitle = product?.title ?? 'Unknown Product';
                    return RichText(
                      text: TextSpan(
                        style: kTextStyle(
                          size: 14,
                          color: MyColors.darkBase.withOpacity(0.7),
                        ),
                        children: [
                          TextSpan(
                            text: productTitle,
                            style: kTextStyle(
                              size: 14,
                              isBold: true,
                              color: MyColors.darkBase,
                            ),
                          ),
                          TextSpan(text: ' - Order '),
                          TextSpan(
                            text: '#${order.orderId.substring(0, 8)}',
                            style: kTextStyle(
                              size: 14,
                              isBold: true,
                              color: MyColors.darkBase,
                            ),
                          ),
                          TextSpan(text: ' is '),
                          TextSpan(
                            text: orderStatusToString(order.status).toUpperCase(),
                            style: kTextStyle(
                              size: 14,
                              isBold: true,
                              color: statusInfo.color,
                            ),
                          ),
                          if (isSeller && order.status == OrderStatus.paid)
                             TextSpan(text: '. Please ship it soon!'),
                        ],
                      ),
                    );
                  },
                  loading: () => Text(
                    'Loading...',
                    style: kTextStyle(
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                  error: (_, __) => RichText(
                    text: TextSpan(
                      style: kTextStyle(
                        size: 14,
                        color: MyColors.darkBase.withOpacity(0.7),
                      ),
                      children: [
                        TextSpan(text: 'Order '),
                        TextSpan(
                          text: '#${order.orderId.substring(0, 8)}',
                          style: kTextStyle(
                            size: 14,
                            isBold: true,
                            color: MyColors.darkBase,
                          ),
                        ),
                        TextSpan(text: ' is '),
                        TextSpan(
                          text: orderStatusToString(order.status).toUpperCase(),
                          style: kTextStyle(
                            size: 14,
                            isBold: true,
                            color: statusInfo.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('E, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }

  _StatusInfo _getStatusInfo(OrderStatus status, bool isSeller) {
    switch (status) {
      case OrderStatus.pending:
        return _StatusInfo(
          title: isSeller ? 'New Pending Order' : 'Order Pending',
          icon: Iconsax.clock,
          color: Colors.orange,
        );
      case OrderStatus.processing:
        return _StatusInfo(
          title: isSeller ? 'Order Processing' : 'Order Processing',
          icon: Iconsax.box,
          color: Colors.blue,
        );
      case OrderStatus.paid:
        return _StatusInfo(
          title: isSeller ? 'New Order Received!' : 'Payment Successful',
          icon: Iconsax.wallet_check,
          color: MyColors.purpleShade,
        );
      case OrderStatus.shipped:
        return _StatusInfo(
          title: isSeller ? 'Order Shipped' : 'Order Shipped',
          icon: Iconsax.truck,
          color: MyColors.purpleShade,
        );
      case OrderStatus.collected:
        return _StatusInfo(
          title: isSeller ? 'Order Collected' : 'Order Collected',
          icon: Iconsax.box_tick,
          color: Colors.green,
        );
      case OrderStatus.cancelled:
        return _StatusInfo(
          title: 'Order Cancelled',
          icon: Iconsax.close_circle,
          color: Colors.red,
        );
      case OrderStatus.completed:
        return _StatusInfo(
          title: isSeller ? 'Payment Released!' : 'Order Completed',
          icon: isSeller ? Iconsax.money_recive : Iconsax.tick_circle,
          color: Colors.green,
        );
    }
  }
}

class _StatusInfo {
  final String title;
  final IconData icon;
  final Color color;

  _StatusInfo({
    required this.title,
    required this.icon,
    required this.color,
  });
}
