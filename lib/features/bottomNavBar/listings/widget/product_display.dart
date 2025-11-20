import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/price_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDisplay extends ConsumerWidget {
  final String title;
  final String description;
  final double price;
  final String img;

  const ProductDisplay({
    super.key,
    required this.img,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              img,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          // Title and Price Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.length >= 18
                      ? '${title.substring(0, 18)}...'
                      : title,
                  style: kTextStyle(
                    size: 14,
                    isBold: true,
                    color: Color(0xff3A2770),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  formatNairaPrice(price),
                  style: kTextStyle(
                    size: 16,
                    isBold: true,
                    color: Color(0xff8E6CEF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}