import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/models/order.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final bool isCompact;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: isCompact ? 14 : 16,
            color: _getStatusColor(),
          ),
          SizedBox(width: isCompact ? 4 : 6),
          Text(
            _getStatusText(),
            style: TextStyle(
              color: _getStatusColor(),
              fontSize: isCompact ? 11 : 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.paid:
        return Colors.green;
      case OrderStatus.shipped:
        return MyColors.purpleShade;
      case OrderStatus.collected:
        return MyColors.coldGold;
      case OrderStatus.completed:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case OrderStatus.pending:
        return Iconsax.clock;
      case OrderStatus.processing:
        return Iconsax.refresh;
      case OrderStatus.paid:
        return Iconsax.tick_circle;
      case OrderStatus.shipped:
        return Iconsax.truck_fast;
      case OrderStatus.collected:
        return Iconsax.box_tick;
      case OrderStatus.completed:
        return Iconsax.verify;
      case OrderStatus.cancelled:
        return Iconsax.close_circle;
    }
  }

  String _getStatusText() {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.collected:
        return 'Collected';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
