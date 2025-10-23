import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';

String genImageUrl(String imageId, String bucketId) {
  return "https://cloud.appwrite.io/v1/storage/buckets/$bucketId/files/$imageId/view?project=68f8a26b001714973226";
}
Future<String> uploadImage(
  Storage storage,
  File file,
  String bucketId,
) async {
  try {
    log('starting');
    final imageUrl = await storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(
          path: file.path, filename: file.path.split('/').last),
    );
    log('done');
    return genImageUrl(imageUrl.$id, bucketId);
  } on AppwriteException catch (e) {
    log(e.toString());
    throw Exception("Error uploading image");
  }
}