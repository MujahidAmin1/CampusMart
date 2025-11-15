import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/price_format.dart';
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
          Stack(
            children: [
              Hero(
                tag: 'product-image-${img}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    img,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Optional: Add favorite button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Color(0xff8E6CEF),
                  ),
                ),
              ),
            ],
          ),
          
          // Details Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.length >= 18 ? '${title.substring(0, 18)}...' : title,
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