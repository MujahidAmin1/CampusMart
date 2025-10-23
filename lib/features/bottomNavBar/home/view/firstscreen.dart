import 'package:campus_mart/core/utils/ktextstyle.dart';
import 'package:campus_mart/features/bottomNavBar/listings/widget/category_chips.dart';
import 'package:campus_mart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
class Firstscreen extends StatefulWidget {
  const Firstscreen({super.key});

  @override
  State<Firstscreen> createState() => _FirstscreenState();
}

class _FirstscreenState extends State<Firstscreen> {
  Category selectedCategory = Category.all;
  int _selectedIndex = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopify')),
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
                      label:
                          "${value.name[0].toUpperCase()}${value.name.substring(1)}",
                      isSelected: _selectedIndex == value.index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = value.index;
                          selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: databaseService.getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitSpinningLines(color: Colors.black),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error!.toString(),
                        style: kTextStyle(color: Colors.white),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Products available'));
                  }

                  List<Product> products = snapshot.data!;
                  List<Product> filteredProducts;

                  if (selectedCategory == Category.all) {
                    filteredProducts = products;
                  } else {
                    filteredProducts = products
                        .where((p) =>
                            p.category.toLowerCase() ==
                            selectedCategory.name.toLowerCase())
                        .toList();
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      mainAxisExtent: 220,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final currentProduct = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProductDetailedScreen(
                              product: currentProduct,
                              looped: false,
                            );
                          }));
                        },
                        child: ProductDisplay(
                            img: currentProduct.imageUrls.first,
                            title: currentProduct.title,
                            description: currentProduct.description,
                            price: currentProduct.price),
                      );
                    },
                  );
                },
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
        onPressed: () => context.push(CreateProduct()),
        child: Icon(Iconsax.additem),
      ),
    );
  }
}
