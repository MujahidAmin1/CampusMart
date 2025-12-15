import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/core/utils/price_format.dart';
import 'package:campusmart/features/bottomNavBar/listings/view/edit_product_screen.dart';
import 'package:campusmart/features/bottomNavBar/profile/controller/profie_contr.dart';
import 'package:campusmart/features/bottomNavBar/profile/repository/profile_repo.dart';
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
                    // Product Image with action buttons overlay
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Container(
                            height: 140,
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
                        
                        // Action buttons overlay
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            spacing: 6,
                            children: [
                              // Edit button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProductScreen(product: product),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: MyColors.warmGold,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Iconsax.edit_2,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              
                              // Delete button
                              GestureDetector(
                                onTap: () async {
                                  // Show confirmation dialog
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Iconsax.warning_2,
                                            color: Colors.red.shade400,
                                            size: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete Product',
                                            style: kTextStyle(
                                              size: 18,
                                              color: Color(0xff3A2770),
                                              isBold: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        'Are you sure you want to delete "${product.title}"? This action cannot be undone.',
                                        style: kTextStyle(
                                          size: 14,
                                          color: Color(0xff3A2770).withOpacity(0.8),
                                          isBold: false,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Color(0xff3A2770).withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red.shade500,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldDelete == true) {
                                    try {
                                      await ref.read(profileProvider).deleteProduct(product.productId);
                                      
                                      // Refresh the listings
                                      ref.invalidate(myListingsProvider);
                                      
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Product deleted successfully'),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error deleting product: $e'),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade500,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Iconsax.trash,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Product Details
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                              ],
                            ),
                            
                            // Category badge
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xff8E6CEF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product.category.toUpperCase(),
                                style: kTextStyle(
                                  size: 10,
                                  color: Color(0xff8E6CEF),
                                  isBold: true,
                                ),
                              ),
                            ),
                          ],
                        ),
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