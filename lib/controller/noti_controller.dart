import 'package:get/get.dart';
import 'package:two_d_project/firebase/noti_services.dart';

class NotiTextController extends GetxController {
  final NotiTextService _service = NotiTextService();
  var notiTexts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _bindStream();
  }

  void _bindStream() {
    _service.getNotiTextList().listen((data) {
      notiTexts.value = data;
    });
  }

  Future<void> addNotiText(Map<String, dynamic> data) async {
    await _service.addNotiText(data);
  }

  Future<void> updateNotiText(String id, Map<String, dynamic> data) async {
    await _service.updateNotiText(id, data);
  }

  Future<void> deleteNotiText(String id) async {
    await _service.deleteNotiText(id);
  }
}
