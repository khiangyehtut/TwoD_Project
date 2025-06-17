import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppbar extends StatelessWidget {
  Widget? leftIcon;
  String? label;
  List<Widget>? action;
  CustomAppbar({this.leftIcon, this.label, this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 100,
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child:
                  Container(alignment: Alignment.centerLeft, child: leftIcon),
            ),
            Expanded(
              flex: 2,
              child: Text(
                label ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  children: action ?? [],
                ))
          ],
        ),
      ),
    );
  }
}
