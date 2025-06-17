import 'dart:io';
import 'package:get/get.dart';
import 'package:two_d_project/firebase/cloudinary_services.dart';

class CloudinaryImageController extends GetxController {
  final CloudinaryImageService _service = CloudinaryImageService();

  RxList<Map<String, dynamic>> imageList = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool uploadLoading = false.obs;
  RxInt currentIndex = 0.obs;
  Rx<File?> selectedFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    _service.getImagesStream().listen((snapshot) {
      imageList.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'url': doc['url'],
          'public_id': doc['public_id'],
        };
      }).toList();
    });
  }

  Future<void> pickImage() async {
    selectedFile.value = await _service.pickImage();
  }

  Future<void> uploadSelectedImage() async {
    if (selectedFile.value == null) return;
    uploadLoading.value = true;
    await _service.uploadImage(selectedFile.value!);
    selectedFile.value = null;
    uploadLoading.value = false;
  }

  Future<void> deleteImage(String docId, String publicId) async {
    isLoading.value = true;
    await _service.deleteImage(docId, publicId);
    isLoading.value = false;
  }
}
