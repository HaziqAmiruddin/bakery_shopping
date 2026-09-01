// presentation/utils/profile_photo_uploader.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoUploader {
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

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
    final ref = _storage.ref().child('user_avatars/$uid.jpg');

    try {
      final uploadTask = await ref.putFile(file);

      if (uploadTask.state != TaskState.success) {
        throw Exception('Upload did not complete: ${uploadTask.state}');
      }

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Storage upload failed: ${e.code} — ${e.message}');
      rethrow;
    }
  }
}
