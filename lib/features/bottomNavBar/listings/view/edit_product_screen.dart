import 'package:another_flushbar/flushbar.dart';
import 'package:campusmart/core/utils/extensions.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/category_chips.dart';
import 'package:campusmart/features/bottomNavBar/profile/controller/profie_contr.dart';
import 'package:campusmart/features/bottomNavBar/profile/repository/profile_repo.dart';
import 'package:campusmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final Product product;
  
  const EditProductScreen({super.key, required this.product});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late Category selectedCategory;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    descriptionController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(text: widget.product.price.toString());
    
    // Set the selected category
    selectedCategory = Category.values.firstWhere(
      (cat) => cat.name == widget.product.category,
      orElse: () => Category.all,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Edit Product",
          style: TextStyle(
            color: Color(0xff3A2770),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xff3A2770)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(height: 20),
                Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Section
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff8E6CEF).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xff8E6CEF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Iconsax.category,
                                  color: Color(0xff8E6CEF),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Select Category",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3A2770),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              ...Category.values.skip(1).map(
                                    (value) => CategoryChips(
                                      selectedColor: Color(0xff8E6CEF),
                                      label:
                                          "${value.name[0].toUpperCase()}${value.name.substring(1)}",
                                      isSelected: selectedCategory == value,
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      },
                                    ),
                                  )
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Product Images Section (Read-only)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff8E6CEF).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xff6CEFBD).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Iconsax.gallery,
                                  color: Color(0xff6CEFBD),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Product Images",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3A2770),
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "View Only",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          
                          // Display existing images (read-only)
                          if (widget.product.imageUrls.isEmpty)
                            Container(
                              width: width,
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.image,
                                      color: Colors.grey.shade400,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "No images",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 10,
                                children: widget.product.imageUrls.map((imageUrl) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      width: width * 0.7,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: width * 0.7,
                                          height: 200,
                                          color: Colors.grey.shade300,
                                          child: Icon(
                                            Iconsax.image,
                                            color: Colors.grey.shade600,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Product Details Section
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff8E6CEF).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xffEFC66C).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Iconsax.edit,
                                  color: Color(0xffEFC66C),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Product Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3A2770),
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            controller: titleController,
                            cursorColor: Color(0xff8E6CEF),
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              labelText: "Title",
                              labelStyle: TextStyle(color: Color(0xff3A2770).withOpacity(0.6)),
                              prefixIcon: Icon(Iconsax.tag, color: Color(0xff8E6CEF), size: 20),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              focusColor: Color(0xff8E6CEF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Color(0xff8E6CEF), width: 2),
                              ),
                            ),
                          ),
                          TextField(
                            controller: descriptionController,
                            cursorColor: Color(0xff8E6CEF),
                            maxLines: 4,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              labelText: "Product Description",
                              labelStyle: TextStyle(color: Color(0xff3A2770).withOpacity(0.6)),
                              alignLabelWithHint: true,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(bottom: 60),
                                child: Icon(Iconsax.document_text, color: Color(0xff8E6CEF), size: 20),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              focusColor: Color(0xff8E6CEF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Color(0xff8E6CEF), width: 2),
                              ),
                            ),
                          ),
                          TextField(
                            controller: priceController,
                            cursorColor: Color(0xff8E6CEF),
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              labelText: "Price",
                              labelStyle: TextStyle(color: Color(0xff3A2770).withOpacity(0.6)),
                              prefixIcon: Icon(Iconsax.dollar_circle, color: Color(0xffEFC66C), size: 20),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              focusColor: Color(0xff8E6CEF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Color(0xff8E6CEF), width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Update Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff8E6CEF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff8E6CEF).withOpacity(0.4),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          if (titleController.text.isEmpty ||
                              priceController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Fill in required fields")),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final updatedProduct = widget.product.copyWith(
                              title: titleController.text,
                              description: descriptionController.text,
                              price: double.parse(priceController.text),
                              category: selectedCategory.name,
                            );

                            await ref.read(profileProvider).updateProduct(updatedProduct);

                            if (mounted) {
                              // Defer Flushbar and navigation to avoid !_debugLocked error
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  Flushbar(
                                    flushbarPosition: FlushbarPosition.TOP,
                                    title: 'Product updated successfully',
                                    message: 'Your changes have been saved',
                                    icon: Icon(Icons.check_circle_outline, color: Colors.white),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 3),
                                  ).show(context);

                                  // Refresh the listings
                                  ref.invalidate(myListedProductsProvider);
                                }
                              });
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error updating product: $e")),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.tick_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Update Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
          
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xff8E6CEF),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Updating product...',
                        style: TextStyle(
                          color: Color(0xff3A2770),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
