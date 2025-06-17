// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:two_d_project/components/myelevated.dart';
// import 'package:two_d_project/constant/constant.dart';
// import 'package:two_d_project/controller/create_user.dart';

// class SignupPage extends StatelessWidget {
//   SignupPage({super.key});

//   // final CreateUserController authController = Get.put(CreateUserController());

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Constant.secColor,
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: size.height,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(30),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'အကောင့်အသစ်ဖွင့်ခြင်း',
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   TextField(
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'အမည်',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   TextField(
//                     controller: emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   TextField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   TextField(
//                     controller: confirmPasswordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Confirm Password',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Myelevated(
//                     letterSpacing: 0,
//                     label: 'Sign up with Email',
//                     borderColor: Colors.transparent,
//                     onTap: () {
//                       authController.emailSignup(
//                         nameController.text,
//                         emailController.text,
//                         passwordController.text,
//                         confirmPasswordController.text,
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: authController.googleSignup,
//                         child: Image.asset(
//                           'images/sinup/google.png',
//                           width: 50,
//                           height: 50,
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       GestureDetector(
//                         onTap: authController.facebookSignup,
//                         child: Image.asset(
//                           'images/sinup/facebook.png',
//                           width: 50,
//                           height: 50,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton(
//                     onPressed: () => Get.back(),
//                     child: const Text("Already have an account? Login"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
