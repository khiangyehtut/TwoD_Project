import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Helper {
  static void showloading(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white54,
              backgroundColor: Colors.deepPurple,
            ),
          );
        });
  }

  static void customAlertDialog(
      {required BuildContext context,
      required bool oneButton,
      required String image,
      required String firstText,
      required String secondText,
      void Function()? onTap}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50)),
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        child: const Text(
                          'x',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'images/$image.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    firstText,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    secondText,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (oneButton)
                      ? InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            alignment: Alignment.center,
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple),
                            child: const Text(
                              'Okay',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.deepPurple,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onTap,
                              child: Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.deepPurple),
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
        });
  }

  static Widget showloadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white54,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  static String formatTime12Hour(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute:$second $period";
  }

  static Widget shimmerTwoD(
      {double height = 0,
      EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin,
      BorderRadiusGeometry? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: padding,
        margin: margin,
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
