import 'package:flutter/material.dart';
import 'package:two_d_project/constant/constant.dart';

// ignore: must_be_immutable
class ChooseContainer extends StatelessWidget {
  String image;
  String title;
  void Function()? onTap;
  ChooseContainer(
      {required this.image, required this.title, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: Constant.secColor, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/$image.png',
              width: 50,
              height: 50,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
