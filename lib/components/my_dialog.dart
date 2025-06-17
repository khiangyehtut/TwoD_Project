import 'package:flutter/material.dart';
import 'package:two_d_project/components/header_container.dart';

// ignore: must_be_immutable
class MyDialog extends StatelessWidget {
  String? headTitle;
  String? title;
  String? subTitle;
  void Function()? onTap;
  MyDialog({
    super.key,
    this.title,
    this.headTitle,
    this.subTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderContainer(
              color: Colors.red,
              title: headTitle ?? 'ကိုယ်စလှယ်အားဖျက်ခြင်း',
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title ?? '',
              style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Text(
                subTitle ?? 'ဖျက်မည်လား',
                style: const TextStyle(color: Colors.black45, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.deepPurple,
                        )),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
