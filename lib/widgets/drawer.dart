import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/controller/admin_controller.dart';
import 'package:two_d_project/controller/auth_services_controller.dart';
import 'package:two_d_project/controller/image_controller.dart';
import 'package:two_d_project/controller/noti_controller.dart';
import 'package:two_d_project/pages/auth.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  AuthService authService = Get.put(AuthService());
  NotiTextController notiController = Get.put(NotiTextController());

  AdminController adminController = Get.find();

  final CloudinaryImageController imageController =
      Get.put(CloudinaryImageController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Constant.secColor,
      child: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Image.asset('images/2d.png', width: 80, height: 80),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'MM2D',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    letterSpacing: 10,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Admin',
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
                trailing: Text(adminController.name.value,
                    style: const TextStyle(fontSize: 14)),
              ),
              ListTile(
                title: const Text('Email',
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
                trailing: Text(
                  authService.currentEmail?.value ??
                      authService.loadingText.value,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              ListTile(
                title: const Text('Logout',
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
                trailing: InkWell(
                  onTap: () {
                    Helper.customAlertDialog(
                      onTap: () {
                        authService.logout();
                        Get.offAll(const AuthPage());
                      },
                      context: context,
                      oneButton: false,
                      image: 'logout',
                      firstText: 'Logout',
                      secondText: 'Are you sure ',
                    );
                  },
                  child: const Icon(Icons.logout),
                ),
              ),
              const Divider(),
              carouselImage(),
              carouselDot(),
              marqueeNotiText(),
              const SizedBox(height: 10),
              const Center(
                child: Text('Developed By AK',
                    style: TextStyle(color: Colors.black45)),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget marqueeNotiText() {
    return SizedBox(
      height: 30,
      child: Obx(() {
        if (notiController.notiTexts.isEmpty) {
          return const Center(child: Text('No messages yet'));
        }
        final latest = notiController.notiTexts.last;
        return Marquee(
          text: latest['description'] ?? '',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          blankSpace: 50.0,
          velocity: 40.0,
        );
      }),
    );
  }

  Widget carouselImage() {
    return CarouselSlider(
      items: imageController.imageList.map((img) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  img['url'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image));
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        onPageChanged: (index, reason) =>
            imageController.currentIndex.value = index,
      ),
    );
  }

  Widget carouselDot() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(imageController.imageList.length, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: imageController.currentIndex.value == index
                  ? Colors.redAccent
                  : Colors.grey,
            ),
          );
        }),
      );
    });
  }
}
