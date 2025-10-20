import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  int selectedIndex = 0;
  final auth = ref.read
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  int quantity = 1;

  final List<File>? _selectedImages = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickImages(ImageSource source) async {
    final List<XFile> selectedImages = await picker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      final remainingSlots = 4 - _selectedImages!.length;

      final limitedNewImages = selectedImages.take(remainingSlots).toList();
      final newFiles =
          limitedNewImages.map((xfile) => File(xfile.path)).toList();

      setState(() {
        _selectedImages.addAll(newFiles);
      });
    }
  }

  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildIconButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  Navigator.pop(context);
                  pickImages(ImageSource.camera);
                },
              ),
              buildIconButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Navigator.pop(context);
                  pickImages(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      ...Category.values.map(
                        (value) => CategoryChips(
                          selectedColor: Color(0xff8E6CEF),
                          label:
                              "${value.name[0].toUpperCase()}${value.name.substring(1)}",
                          isSelected: selectedIndex == value.index,
                          onTap: () {
                            setState(
                              () {
                                selectedIndex = value.index;
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                _selectedImages!.isEmpty
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
                              ..._selectedImages.asMap().entries.map((entry) {
                                var img = entry.value;
                                int index = entry.key;
                                return Stack(
                                  children: [
                                    Image.file(
                                      img,
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
                                          _selectedImages.removeAt(index);
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
                QuantitySelector(
                  quantity: 1,
                  onChanged: (qty) {
                  quantity = qty;
                }),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (_selectedImages.isEmpty) {
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
                        quantity: quantity,
                        productId: uid,
                        ownerId: auth.currentUser!.uid,
                        title: titleController.text,
                        description: descriptionController.text,
                        price: double.parse(priceController.text),
                        category: Category.values[selectedIndex].name,
                        isAvailable: true,
                        datePosted: DateTime.now(),
                        imageUrls: [],
                      );
                      database.createProduct(
                          product: product, imageFiles: _selectedImages);

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
