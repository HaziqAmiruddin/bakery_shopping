// presentation/utils/cloudinary_uploader.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryUploader {
  static const _cloudName = 'flc0dq3c'; // from Cloudinary dashboard
  static const _uploadPreset =
      'shopping_app_profile_photo'; // your unsigned preset

  final _picker = ImagePicker();

  Future<String?> pickAndUpload({
    required String uid,
    required ImageSource source,
  }) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 85,
    );

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['public_id'] =
          'user_avatars/$uid' // overwrites previous photo for this user
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed (${response.statusCode}): $responseBody',
      );
    }

    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    return data['secure_url'] as String;
  }
}
