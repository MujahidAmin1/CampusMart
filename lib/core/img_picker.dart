import 'dart:developer' show log;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  ImagePicker imagePicker = ImagePicker();
  try {
    final xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    return xFile != null ? File(xFile.path) : null;
  } catch (e) {
    log('Error picking image: $e');
    return null;
  }
}

Future<List<File>?> pickImages(ImageSource camera) async {
  ImagePicker imagePicker = ImagePicker();
  try {
    final xFiles = await imagePicker.pickMultiImage();
    if (xFiles.isEmpty) return null;
    return xFiles.map((e) => File(e.path)).toList();
  } catch (e) {
    log('Error picking images: $e');
    return null;
  }
}