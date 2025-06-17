// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:two_d_project/components/myelevated.dart';
import 'package:two_d_project/constant/constant.dart';

class PoukteeDialog extends StatelessWidget {
  TextEditingController? controller;
  void Function()? onTap;
  PoukteeDialog({this.controller, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: (Constant.phoneWidth(context) > 500) ? 400 : null,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ပေါက်သီးဂဏန်း',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Constant.secColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'ဂဏန်း',
                  ),
                  keyboardType: TextInputType.number,
                  controller: controller,
                ),
              ),
              const SizedBox(height: 20),
              Myelevated(
                borderColor: Colors.transparent,
                label: 'OK',
                onTap: onTap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
