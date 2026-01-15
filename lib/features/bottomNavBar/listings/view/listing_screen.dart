import 'package:campusmart/core/utils/extensions.dart';
import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:campusmart/features/bottomNavBar/listings/view/create_prod_screen.dart';
import 'package:campusmart/features/bottomNavBar/listings/view/detailed_screen.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/category_chips.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/filter_modal.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/product_display.dart';
import 'package:campusmart/features/search/search_screen.dart';
import 'package:campusmart/models/product.dart';
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff8E6CEF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.shopping_bag, color: Colors.white, size: 20),
            ),
            SizedBox(width: 10),
            Text(
              'BUK CampusMart',
              style: TextStyle(
                color: Color(0xff3A2770),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // Search Bar
            GestureDetector(
              onTap: () {
                context.push(SearchScreen());
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Iconsax.search_favorite,
                      color: Color(0xff8E6CEF),
                    ),
                    hintText: "Search products...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Color(0xff8E6CEF), width: 2),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            
            // Categories Header
            Text(
              "Categories",
              style: kTextStyle(size: 18, isBold: true, color: Color(0xff3A2770)),
            ),
            SizedBox(height: 12),
            
            // Categories Row with Filter Button
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 8,
                      children: [
                        for (var value in Category.values)
                          CategoryChips(
                            selectedColor: Color(0xff8E6CEF),
                            label: "${value.name[0].toUpperCase()}${value.name.substring(1)}",
                            isSelected: selectedCategory == value,
                            onTap: () {
                              ref.read(categoryFilterProvider.notifier).state = value;
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Filter button with active indicator
                Builder(
                  builder: (context) {
                    final priceRange = ref.watch(priceRangeFilterProvider);
                    final isFilterActive = priceRange.start > 0 || priceRange.end < 500000;
                    
                    return Container(
                      decoration: BoxDecoration(
                        color: isFilterActive ? Color(0xff8E6CEF).withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isFilterActive ? Color(0xff8E6CEF) : Colors.grey.shade200,
                        ),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return const FilterModal();
                                },
                              );
                            },
                            icon: Icon(Iconsax.filter, color: Color(0xff8E6CEF)),
                          ),
                          if (isFilterActive)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Color(0xff8E6CEF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Products Grid
            Expanded(
              child: filteredProductsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => ref.refresh(allProductsProvider.future),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.shop,
                                  size: 80,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Products Available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff3A2770).withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(allProductsProvider);
                    },
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 240,
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
                            img: currentProduct.imageUrls.isNotEmpty
                                ? currentProduct.imageUrls[0]
                                : '',
                            title: currentProduct.title,
                            description: currentProduct.description,
                            price: currentProduct.price,
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xff8E6CEF),
                          shape: BoxShape.circle,
                        ),
                        child: SpinKitSpinningLines(
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading products...',
                        style: TextStyle(
                          color: Color(0xff3A2770).withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                error: (error, stack) => RefreshIndicator(
                  onRefresh: () => ref.refresh(allProductsProvider.future),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red.shade300,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load products',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff3A2770),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pull to try again',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Color(0xff8E6CEF),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xff8E6CEF).withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => context.push(CreateProdScreen()),
          child: Icon(Iconsax.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}