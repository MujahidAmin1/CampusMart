import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/price_format.dart';
import 'package:campusmart/features/bottomNavBar/profile/controller/profie_contr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MyListedItemsScreen extends ConsumerWidget {
  const MyListedItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myListings = ref.watch(myListingsProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff3A2770)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Listings',
          style: TextStyle(
            color: Color(0xff3A2770),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: myListings.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.box,
                    size: 80,
                    color: Color(0xff8E6CEF).withOpacity(0.3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No listings yet',
                    style: kTextStyle(
                      size: 18,
                      color: Color(0xff3A2770),
                      isBold: true,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start selling items to see them here',
                    style: kTextStyle(
                      size: 14,
                      color: Color(0xff3A2770).withOpacity(0.6),
                      isBold: false,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: product.imageUrls.isNotEmpty
                            ? Image.network(
                                product.imageUrls.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Iconsax.image,
                                      color: Colors.grey.shade400,
                                      size: 40,
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Icon(
                                  Iconsax.image,
                                  color: Colors.grey.shade400,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                    
                    // Product Details
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: kTextStyle(
                              size: 14,
                              color: Color(0xff3A2770),
                              isBold: true,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            formatNairaPrice(product.price),
                            style: kTextStyle(
                              size: 16,
                              color: Color(0xff8E6CEF),
                              isBold: true,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: product.isAvailable
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.isAvailable ? 'Available' : 'Sold',
                              style: kTextStyle(
                                size: 11,
                                color: product.isAvailable
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                isBold: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  'Failed to load listings',
                  style: kTextStyle(
                    size: 16,
                    color: Color(0xff3A2770),
                    isBold: true,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.refresh(myListingsProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff8E6CEF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xff8E6CEF),
            ),
          );
        },
      ),
    );
  }
}