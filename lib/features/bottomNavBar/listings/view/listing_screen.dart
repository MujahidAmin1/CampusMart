import 'package:campus_mart/core/utils/extensions.dart';
import 'package:campus_mart/core/utils/ktextstyle.dart';
import 'package:campus_mart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:campus_mart/features/bottomNavBar/listings/view/create_prod_screen.dart';
import 'package:campus_mart/features/bottomNavBar/listings/view/detailed_screen.dart';
import 'package:campus_mart/features/bottomNavBar/listings/widget/category_chips.dart';
import 'package:campus_mart/features/bottomNavBar/listings/widget/product_display.dart';
import 'package:campus_mart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ListingsScreen extends ConsumerWidget {
  const ListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(categoryFilterProvider);
    final filteredProductsAsync = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('CampusMart')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.search_favorite),
                hintText: "search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text("Categories", style: kTextStyle(size: 20, isBold: true)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var value in Category.values) ...[
                    CategoryChips(
                      selectedColor: Color(0xff8E6CEF),
                      label: "${value.name[0].toUpperCase()}${value.name.substring(1)}",
                      isSelected: selectedCategory == value,
                      onTap: () {
                        // Update the provider state instead of setState
                        ref.read(categoryFilterProvider.notifier).state = value;
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: filteredProductsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return Center(child: Text('No Products available'));
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      mainAxisExtent: 220,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final currentProduct = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailedScreen(
                                product: currentProduct,
                                looped: false,
                              ),
                            ),
                          );
                        },
                        child: ProductDisplay(
                          img: currentProduct.imageUrls.first,
                          title: currentProduct.title,
                          description: currentProduct.description,
                          price: currentProduct.price,
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: SpinKitSpinningLines(color: Colors.black),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    error.toString(),
                    style: kTextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff8E6CEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => context.push(CreateProdScreen()),
        child: Icon(Iconsax.additem),
      ),
    );
  }
}