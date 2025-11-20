import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/core/utils/price_format.dart';
import 'package:campusmart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OwnerProfileListsScreen extends ConsumerWidget {
  final String ownerId;
  
  const OwnerProfileListsScreen({
    super.key,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerData = ref.watch(productOwnerProvider(ownerId));
    final ownerProducts = ref.watch(ownerProductsProvider(ownerId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyColors.darkBase),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Seller Profile',
          style: kTextStyle(
            size: 20,
            color: MyColors.darkBase,
            isBold: true,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Seller Info Header
          if (ownerData.hasValue && ownerData.value != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: MyColors.purpleShade.withOpacity(0.1),
                    child: Text(
                      ownerData.value!.username[0].toUpperCase(),
                      style: kTextStyle(
                        size: 32,
                        color: MyColors.purpleShade,
                        isBold: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    ownerData.value!.username,
                    style: kTextStyle(
                      size: 20,
                      color: MyColors.darkBase,
                      isBold: true,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    ownerData.value!.email,
                    style: kTextStyle(
                      size: 14,
                      color: MyColors.darkBase.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

          // Products Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Iconsax.box, size: 18, color: MyColors.purpleShade),
                SizedBox(width: 8),
                Text(
                  'Listed Items',
                  style: kTextStyle(
                    size: 16,
                    color: MyColors.darkBase,
                    isBold: true,
                  ),
                ),
              ],
            ),
          ),

          // Products Grid
          Expanded(
            child: ownerProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.box,
                          size: 60,
                          color: MyColors.purpleShade.withOpacity(0.3),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No items listed',
                          style: kTextStyle(
                            size: 16,
                            color: MyColors.darkBase.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
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
                                    color: MyColors.darkBase,
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
                                    color: MyColors.purpleShade,
                                    isBold: true,
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
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: MyColors.purpleShade,
                ),
              ),
              error: (_, __) => Center(
                child: Text(
                  'Failed to load products',
                  style: kTextStyle(
                    size: 14,
                    color: MyColors.darkBase.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
