import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryImageService {
  final String cloudName = 'dp7w7hawr';
  final String uploadPreset = 'twodproject';
  final String apiKey = '484558557864683';
  final String apiSecret = 'OZCn-o5mKKS7LGtuS86-0WBu98w';

  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<File?> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }

  Future<void> uploadImage(File file) async {
    final uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final resString = await response.stream.bytesToString();
        final data = jsonDecode(resString);
        await firestore.collection('public').add({
          'url': data['secure_url'],
          'public_id': data['public_id'],
          'uploadedAt': FieldValue.serverTimestamp(),
        });
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload error: $e');
    }
  }

  Future<void> deleteImage(String docId, String publicId) async {
    try {
      // Delete from Cloudinary
      final timestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      final signature = sha1
          .convert(
              utf8.encode('public_id=$publicId&timestamp=$timestamp$apiSecret'))
          .toString();

      final response = await http.post(
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy'),
        body: {
          'public_id': publicId,
          'api_key': apiKey,
          'timestamp': timestamp,
          'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['result'] == 'ok') {
          // Then delete from Firestore
          await firestore.collection('public').doc(docId).delete();
        } else {
          print('Cloudinary deletion failed: ${result['result']}');
        }
      } else {
        print('Cloudinary deletion HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete error: $e');
    }
  }

  Stream<QuerySnapshot> getImagesStream() {
    return firestore
        .collection('public')
        .orderBy('uploadedAt', descending: true)
        .snapshots();
  }
}
