import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:campusmart/core/utils/extensions.dart';
import 'package:campusmart/features/auth/repository/auth_repository.dart';
import 'package:campusmart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:campusmart/features/bottomNavBar/listings/repository/listing_repo.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/category_chips.dart';
import 'package:campusmart/features/bottomNavBar/listings/widget/img_source_sheet.dart';
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
  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(categoryFilterProvider);
    final listingsProvider = ref.watch(productListProvider);
    final List<File?> selectedImages = [];
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            Column(
              spacing: 15,
              children: [
                DottedBorder(
                  padding: EdgeInsets.all(12),
                  color: Colors.grey, // border color
                  strokeWidth: 1.5,
                  dashPattern: [6, 3], // [dash length, space length]
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  child: Wrap(
                    runSpacing: 9,
                    spacing: 8,
                    children: [
                      ...Category.values.skip(0).map(
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
                ),
                selectedImages.isEmpty
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            showImageSourceActionSheet(context);
                          },
                          child: DottedBorder(
                            color: Colors.grey, // border color
                            strokeWidth: 1.5,
                            dashPattern: [6, 3], // [dash length, space length]
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            child: Container(
                                width: width,
                                height: height * 0.2,
                                alignment: Alignment.center,
                                child: Center(
                                  child: Icon(
                                    Iconsax.document_upload,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                )),
                          ),
                        ),
                      )
                    : Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 6,
                            children: [
                              ...selectedImages.asMap().entries.map((entry) {
                                var img = entry.value;
                                int index = entry.key;
                                return Stack(
                                  children: [
                                    Image.file(
                                      img!,
                                      width: width,
                                      height: 300,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      filterQuality: FilterQuality.high,
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
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
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
                      ),
                TextField(
                  controller: titleController,
                  cursorColor: Color(0xff8E6CEF),
                  decoration: InputDecoration(
                    labelText: "Title",
                    focusColor: Color(0xff8E6CEF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff8E6CEF), width: 2),
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  cursorColor: Color(0xff8E6CEF),
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Product Description",
                    alignLabelWithHint: true,
                    focusColor: Color(0xff8E6CEF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff8E6CEF), width: 2),
                    ),
                  ),
                ),
                TextField(
                  controller: priceController,
                  cursorColor: Color(0xff8E6CEF),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    focusColor: Color(0xff8E6CEF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff8E6CEF), width: 2),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
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
                        imageUrls: [],
                      );
                      listingsProvider.createProduct(product);
                      Flushbar(
                        flushbarPosition: FlushbarPosition.TOP,
                        title: 'Product created',
                        icon: Icon(Icons.info_outline),
                      );

                      context.pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Color(0xff8E6CEF),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Create Product',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
