import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextfield extends StatelessWidget {
  String? label;
  String? hintText;
  Widget? suffix;
  String? initialValue;
  TextInputType? keyboardType;
  Color? frameColor;
  Color? labelColor;
  List<TextInputFormatter>? inputFormatters;

  void Function(String)? onChanged;
  TextEditingController? controller;
  CustomTextfield(
      {this.label,
      this.labelColor,
      this.inputFormatters,
      this.frameColor,
      this.initialValue,
      this.onChanged,
      this.hintText,
      this.suffix,
      this.keyboardType,
      this.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        suffix: suffix,
        label: (label != null)
            ? Text(
                label!,
                style: TextStyle(color: labelColor ?? Colors.deepPurple),
              )
            : null,
        hintText: hintText,
        contentPadding: const EdgeInsets.all(10), // Adjust padding if needed
        border: const OutlineInputBorder(), // Default border

        /// ✅ Border when `TextField` is **not focused**
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey, // Set active border color
            width: 1.5,
          ),
        ),

        /// ✅ Border when `TextField` is **focused**
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: frameColor ?? Colors.deepPurple, // Set focus border color
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
