import 'dart:io';

import 'package:campusmart/core/img_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showImageSourceActionSheet(BuildContext context, Function(List<File>) onImagesSelected) async {
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
              onTap: () async {
                Navigator.pop(context);
                final images = await pickImages(ImageSource.camera);
                if (images != null && images.isNotEmpty) {
                  onImagesSelected(images);
                }
              },
            ),
            buildIconButton(
              icon: Icons.photo_library,
              label: 'Gallery',
              onTap: () async {
                Navigator.pop(context);
                final images = await pickImages(ImageSource.gallery);
                if (images != null && images.isNotEmpty) {
                  onImagesSelected(images);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
  
Widget buildIconButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    ),
  );
}