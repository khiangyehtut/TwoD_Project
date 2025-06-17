// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/components/myelevated.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/controller/auth_services_controller.dart';

class LoginPage extends StatelessWidget {
  AuthService auth = Get.put(AuthService());
  LoginPage({super.key});
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.secColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/2d.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'MM2D',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          letterSpacing: 10,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: email,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: password,
                        obscureText: !auth.isVisibility.value,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                auth.isVisibility.value =
                                    !auth.isVisibility.value;
                              },
                              child: (!auth.isVisibility.value)
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            hintText: 'Password',
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Myelevated(
                    borderColor: Colors.transparent,
                    label: 'Login',
                    onTap: () {
                      auth.login(email.text, password.text, context);
                    },
                  )
                ],
              ),
              // InkWell(
              //   onTap: () => Get.to(() => SignupPage()),
              //   child: Container(
              //     padding: const EdgeInsets.all(10),
              //     alignment: Alignment.centerRight,
              //     child: const Text(
              //       'အကောင့်အသစ်ဖွင့်မည်',
              //       style: TextStyle(color: Colors.black45),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
