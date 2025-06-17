import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:two_d_project/firebase/admin_services.dart';

class AdminController extends GetxController {
  final AdminServices _service = AdminServices();

  RxString name = '.......'.obs;
  RxBool admin = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdminInfo();
  }

  void fetchAdminInfo() {
    isLoading.value = true;
    _service.getAdminInfo().listen(
      (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        isLoading.value = false;
        if (snapshot.exists) {
          final data = snapshot.data();
          name.value = data?['name'] ?? '......';
          admin.value = data?['admin'] ?? false;
        } else {
          name.value = '......';
          admin.value = false;
          print("No admin document found");
        }
      },
      onError: (e) {
        isLoading.value = false;
        print("Error fetching admin info: $e");
      },
    );
  }
}
