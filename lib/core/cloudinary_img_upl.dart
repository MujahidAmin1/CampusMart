import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class CloudinaryService {
  final String cloudName;
  final String apiKey;
  final String apiSecret;

  CloudinaryService({
    required this.cloudName,
    required this.apiKey,
    required this.apiSecret,
  });

  /// Upload single image - replaces your Appwrite uploadImage function
  Future<String> uploadImage(File file) async {
    try {
      log('Starting upload...');
      
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      // Generate signature
      final signature = _generateSignature({
        'timestamp': timestamp.toString(),
        'folder': 'products',
      });

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      var request = http.MultipartRequest('POST', uri);

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      // Add signed parameters
      request.fields['api_key'] = apiKey;
      request.fields['timestamp'] = timestamp.toString();
      request.fields['signature'] = signature;
      request.fields['folder'] = 'products';

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        log('Upload complete: ${jsonResponse['secure_url']}');
        return jsonResponse['secure_url'];
      } else {
        log('Upload failed: ${jsonResponse['error']['message']}');
        throw Exception('Upload failed: ${jsonResponse['error']['message']}');
      }
    } catch (e) {
      log('Upload error: $e');
      throw Exception("Error uploading image");
    }
  }

  /// Generate signature for Cloudinary API
  String _generateSignature(Map<String, String> params) {
    var sortedKeys = params.keys.toList()..sort();
    var stringToSign = sortedKeys
        .map((key) => '$key=${params[key]}')
        .join('&');
    stringToSign += apiSecret;
    
    var bytes = utf8.encode(stringToSign);
    var digest = sha1.convert(bytes);
    return digest.toString();
  }

  /// Generate image URL from public ID - replaces your genImageUrl function
  String genImageUrl(String publicId) {
    return 'https://res.cloudinary.com/$cloudName/image/upload/$publicId';
  }

  /// Get optimized/transformed image URL
  String getTransformedUrl(
    String publicId, {
    int? width,
    int? height,
    String crop = 'fill',
  }) {
    var transformations = <String>[];
    
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('c_$crop');
    transformations.add('q_auto');
    transformations.add('f_auto');
    
    var transformString = transformations.join(',');
    
    return 'https://res.cloudinary.com/$cloudName/image/upload/$transformString/$publicId';
  }
}