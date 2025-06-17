import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/controller/bottom_navi.dart';
import 'package:two_d_project/controller/admin_controller.dart';
import 'package:two_d_project/pages/home.dart';
import 'package:two_d_project/pages/image_upload.dart';
import 'package:two_d_project/pages/noti_page.dart';

class MainPage extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());
  final AdminController adminController = Get.put(AdminController());

  final List<Widget> pages = [
    HomePage(),
    ImagePage(),
    NotiTextPage(),
  ];

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: pages[navController.currentIndex.value],
          bottomNavigationBar: adminController.admin.value
              ? BottomNavigationBar(
                  currentIndex: navController.currentIndex.value,
                  onTap: navController.changeTabIndex,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.grey),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.image, color: Colors.grey),
                      label: 'Image',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications, color: Colors.grey),
                      label: 'Noti Text',
                    ),
                  ],
                )
              : null,
        ));
  }
}
