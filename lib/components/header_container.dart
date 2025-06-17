import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HeaderContainer extends StatelessWidget {
  Color? color;
  String? title;
  HeaderContainer({this.title, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
            color: color ?? Colors.deepPurple,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          title ?? 'ကိုယ်စလှယ်အသစ်ထည့်ခြင်း',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ));
  }
}
