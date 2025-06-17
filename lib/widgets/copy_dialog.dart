import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/components/myelevated.dart';
import 'package:two_d_project/controller/twod_controller.dart';

// ignore: must_be_immutable
class CopyDialog extends StatelessWidget {
  TextEditingController? controller;
  TwodController twodController;
  CopyDialog(
      {required this.twodController, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'စာကူးထည့်ခြင်း',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey[200],
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () async {
                        final text = await FlutterClipboard.paste();
                        controller!.text = text;
                      },
                      child: const Icon(Icons.paste),
                    ),
                    hintText: 'Enter data...',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Myelevated(
                  borderColor: Colors.transparent,
                  label: 'Confirm',
                  onTap: () {
                    twodController.processInput(controller!.text);
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
