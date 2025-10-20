import 'package:campus_mart/core/utils/ktextstyle.dart';
import 'package:campus_mart/core/utils/price_format.dart';
import 'package:flutter/material.dart';

class ProductDisplay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'product-image-${img}',
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                img,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.length >= 15 ? title.substring(0, 15) : title,
                    style: kTextStyle(size: 15)),
                Text(formatNairaPrice(price), style: kTextStyle(isBold: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
