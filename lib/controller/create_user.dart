// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:two_d_project/firebase/create_user.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CreateUserController extends GetxController {
//   final CreateUserServices _authService = CreateUserServices();
//   RxBool expired = false.obs;

//   void emailSignup(
//     String name,
//     String email,
//     String password,
//     String confirmPassword,
//   ) async {
//     if (name.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       Get.snackbar("Error", "All fields are required");
//       return;
//     }

//     if (password != confirmPassword) {
//       Get.snackbar("Error", "Passwords do not match");
//       return;
//     }

//     try {
//       await _authService.createUserWithEmail(
//         name: name,
//         email: email,
//         password: password,
//       );

//       Get.snackbar("Success", "Account created");
//     } catch (e) {
//       Get.snackbar("Signup Error", e.toString());
//     }
//   }

//   Future<void> googleSignup() async {
//     try {
//       final userCredential = await _authService.signInWithGoogle();
//       if (userCredential != null) {
//         Get.snackbar("Success", "Signed in with Google");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }

//   Future<void> facebookSignup() async {
//     try {
//       final userCredential = await _authService.signInWithFacebook();
//       if (userCredential != null) {
//         Get.snackbar("Success", "Signed in with Facebook");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }

//   Future<void> checkTrial(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     expired.value = await _authService.isTrialExpired(user.email!);
//     if (expired.value) {
//       Get.dialog(AlertDialog(
//         title: const Text("Trial Expired"),
//         content: const Text("အစမ်းအသုံးပြုချိန်ပြည့်သွားပါသည်"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back();
//               // Navigate to payment screen
//             },
//             child: const Text("Upgrade"),
//           )
//         ],
//       ));
//     }
//   }
// }
