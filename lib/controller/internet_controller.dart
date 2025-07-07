// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkController extends GetxController {
  var isConnected = true.obs;

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((_) => checkInternet());
    checkInternet(); // initial check
  }

  Future<void> checkInternet() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        isConnected.value = false;
        return;
      }

      final result = await http
          .get(Uri.parse('https://clients3.google.com/generate_204'))
          .timeout(const Duration(seconds: 5));

      isConnected.value = result.statusCode == 204;
    } catch (_) {
      isConnected.value = false;
    }
  }
}
