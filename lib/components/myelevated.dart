import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Myelevated extends StatelessWidget {
  String? label;

  double? letterSpacing;
  void Function()? onTap;
  Color? btnColor;
  Color? labelColor;
  Color? borderColor;
  Myelevated(
      {this.label,
      this.labelColor,
      this.borderColor,
      this.letterSpacing,
      this.onTap,
      this.btnColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: borderColor ?? Colors.red),
              color: btnColor ?? Colors.deepPurple,
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            label ?? 'Login',
            style: TextStyle(
                color: labelColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: letterSpacing ?? 10),
          )),
    );
  }
}
