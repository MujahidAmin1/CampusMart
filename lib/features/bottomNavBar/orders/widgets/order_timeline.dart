import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/models/order.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class OrderTimeline extends StatelessWidget {
  final Order order;

  const OrderTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final stages = _getOrderStages();
    final currentStageIndex = _getCurrentStageIndex();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.darkBase,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(stages.length, (index) {
            final stage = stages[index];
            final isCompleted = index < currentStageIndex;
            final isCurrent = index == currentStageIndex;
            final isLast = index == stages.length - 1;

            return _buildTimelineItem(
              stage: stage,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required OrderStage stage,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    final color = isCompleted || isCurrent
        ? MyColors.purpleShade
        : Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? MyColors.purpleShade
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Icon(
                stage.icon,
                size: 20,
                color: isCompleted || isCurrent ? Colors.white : Colors.grey,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? MyColors.purpleShade : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                    color: isCompleted || isCurrent
                        ? MyColors.darkBase
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stage.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (isCompleted && stage.timestamp != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a').format(stage.timestamp!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
                if (!isLast) const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<OrderStage> _getOrderStages() {
    return [
      OrderStage(
        title: 'Order Placed',
        description: 'Your order has been placed',
        icon: Iconsax.shopping_cart,
        timestamp: order.orderDate,
      ),
      OrderStage(
        title: 'Payment Confirmed',
        description: 'Payment has been verified',
        icon: Iconsax.tick_circle,
        timestamp: order.status.index >= OrderStatus.paid.index
            ? order.orderDate
            : null,
      ),
      OrderStage(
        title: 'Shipped',
        description: 'Seller has confirmed shipping',
        icon: Iconsax.truck_fast,
        timestamp: order.isShippingConfirmed ? order.orderDate : null,
      ),
      OrderStage(
        title: 'Collected',
        description: 'You have collected the item',
        icon: Iconsax.box_tick,
        timestamp: order.hasCollectedItem ? order.recievedAt : null,
      ),
      OrderStage(
        title: 'Completed',
        description: 'Order has been completed',
        icon: Iconsax.verify,
        timestamp: order.status == OrderStatus.completed
            ? order.recievedAt
            : null,
      ),
    ];
  }

  int _getCurrentStageIndex() {
    if (order.status == OrderStatus.completed) return 4;
    if (order.hasCollectedItem) return 3;
    if (order.isShippingConfirmed) return 2;
    if (order.status == OrderStatus.paid) return 1;
    return 0;
  }
}

class OrderStage {
  final String title;
  final String description;
  final IconData icon;
  final DateTime? timestamp;

  OrderStage({
    required this.title,
    required this.description,
    required this.icon,
    this.timestamp,
  });
}
