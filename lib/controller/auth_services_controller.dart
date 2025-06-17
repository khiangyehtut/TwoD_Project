// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/controller/admin_controller.dart';
import 'package:two_d_project/firebase/ledger_services.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AdminController adminController = Get.put(AdminController());
  Rx<String?>? currentEmail = ''.obs;
  var loadingText = 'loading...'.obs;
  late LedgerService ledgerService = Get.put(LedgerService());
  var isVisibility = false.obs;

  // **Login with Email & Password**

  Future<void> login(
      String email, String password, BuildContext context) async {
    Helper.showloading(context);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      adminController.fetchAdminInfo();
      currentEmail?.value = _auth.currentUser?.email;
      Get.back(); // close loading
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // close loading
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'အကောင့်မတွေ့ပါ။ Email မှန်ကြောင်းစစ်ပါ။';
          break;
        case 'wrong-password':
          errorMessage = 'Password မှားယွင်းနေသည်။';
          break;
        case 'invalid-email':
          errorMessage = 'Email ဖော်ပြချက်မှားနေသည်။';
          break;
        case 'network-request-failed':
          errorMessage = 'Internet မရှိပါ။';
          break;
        case 'too-many-requests':
          errorMessage = 'သင်ပြုလုပ်မှုများလွန်းပါသည်။ ခဏစောင့်ပါ။';
          break;
        default:
          errorMessage =
              'အကောင့်ဝင်ရန်မအောင်မြင်ပါ။ Email or Password စစ်ဆေးပါ';
      }

      Get.snackbar(
        "Login Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Navigator.pop(context); // close loading
      Get.snackbar(
        "Error",
        "အမှားအယွင်းဖြစ်ပွားသည်။",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // **Logout**
  Future<void> logout() async {
    try {
      await _auth.signOut();

      Get.snackbar("Success", "Logged out successfully!");
    } catch (e) {
      print('something wrong $e');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (_auth.currentUser?.email != null) {
      currentEmail?.value = _auth.currentUser!.email;
    }
  }
}
