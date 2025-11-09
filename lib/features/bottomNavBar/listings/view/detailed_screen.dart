import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetailedScreen extends StatefulWidget {
  final bool looped;
  final Product product;
  const ProductDetailedScreen(
      {super.key, required this.product, required this.looped});

  @override
  State<ProductDetailedScreen> createState() => _ProductDetailedScreenState();
}

class _ProductDetailedScreenState extends State<ProductDetailedScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              widget.product.imageUrls.length <= 1
                  ? ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        widget.product.imageUrls.first,
                        width: double.infinity,
                        height: height * 0.4,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(
                      height: height * 0.4,
                      child: CarouselView(
                        scrollDirection: Axis.horizontal,
                        itemExtent: MediaQuery.of(context).size.width * 0.8,
                        children: widget.product.imageUrls
                            .map(
                              (img) => ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  img,
                                  width: double.infinity,
                                  height: height * 0.4,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.title,
                        style: kTextStyle(size: 28, isBold: true)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        "${widget.product.category[0].toUpperCase()}${widget.product.category.substring(1)}",
                        style: kTextStyle(size: 10),
                      ),
                    ),
                    Text(widget.product.description,
                        style: kTextStyle(size: 20)),
                    widget.looped
                        ? SizedBox()
                        : // item detail,
                        SizedBox(height: 5),
                    Text(
                      '₦${widget.product.price.toStringAsFixed(2)}',
                      style: kTextStyle(isBold: true, size: 22),
                    ),
                    FilledButton(
                      onPressed: () {
                        
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text("Place an Order"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
