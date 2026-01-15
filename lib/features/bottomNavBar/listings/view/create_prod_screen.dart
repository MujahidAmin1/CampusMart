import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:campusmart/core/utils/extensions.dart';
import 'package:campusmart/features/auth/repository/auth_repository.dart';
import 'package:campusmart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:campusmart/features/bottomNavBar/listings/repository/listing_repo.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/category_chips.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/img_source_sheet.dart';
import 'package:campusmart/features/bottomNavBar/orders/controller/order_contr.dart';
import 'package:campusmart/models/product.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateProdScreen extends ConsumerStatefulWidget {
  const CreateProdScreen({super.key});

  @override
  ConsumerState<CreateProdScreen> createState() => _CreateProdScreenState();
}

class _CreateProdScreenState extends ConsumerState<CreateProdScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<File?> selectedImages = [];
  
  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(categoryFilterProvider);
    final listingsRepo = ref.watch(productRepositoryProvider);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Create Product",
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
      body: Padding(
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
                                    ref
                                        .read(categoryFilterProvider.notifier)
                                        .state = value;
                                  },
                                ),
                              )
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Image Upload Section
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
                        ],
                      ),
                      SizedBox(height: 16),
                      selectedImages.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                showImageSourceActionSheet(context, (images) {
                                  setState(() {
                                    selectedImages.addAll(images);
                                  });
                                });
                              },
                              child: Container(
                                width: width,
                                height: height * 0.2,
                                decoration: BoxDecoration(
                                  color: Color(0xff8E6CEF).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xff8E6CEF).withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Color(0xff8E6CEF).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Iconsax.document_upload,
                                        color: Color(0xff8E6CEF),
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Tap to upload images",
                                      style: TextStyle(
                                        color: Color(0xff3A2770).withOpacity(0.6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 10,
                                children: [
                                  ...selectedImages.asMap().entries.map((entry) {
                                    var img = entry.value;
                                    int index = entry.key;
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.file(
                                            img!,
                                            width: width * 0.7,
                                            height: 250,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            filterQuality: FilterQuality.high,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => setState(() {
                                              selectedImages.removeAt(index);
                                            }),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade500,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                                ],
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

                // Create Button
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
                    onPressed: () async {
                      if (selectedImages.isEmpty) {
                        Flushbar(
                          flushbarPosition: FlushbarPosition.TOP,
                          title: 'Product created',
                          icon: Icon(Icons.info_outline),
                        );
                        return;
                      }

                      if (titleController.text.isEmpty ||
                          priceController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Fill in required fields")),
                        );
                        return;
                      }
                      var uid = Uuid().v4();
                      final product = Product(
                        productId: uid,
                        ownerId: ref.read(authRepoProvider).firebaseAuth.currentUser!.uid,
                        title: titleController.text,
                        description: descriptionController.text,
                        price: double.parse(priceController.text),
                        category: Category.values[selectedCategory.index].name,
                        isAvailable: true,
                        datePosted: DateTime.now(),
                        imageUrls: selectedImages.map((e) => e!.path).toList(),
                      );
                      await listingsRepo.createProduct(product);
                      
                      Flushbar(
                        flushbarPosition: FlushbarPosition.TOP,
                        title: 'Product created',
                        icon: Icon(Icons.info_outline),
                      );
                      ref.invalidate(ordersProvider);
                      context.pop();
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
                        Icon(Iconsax.add_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Create Product',
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
    );
  }
}