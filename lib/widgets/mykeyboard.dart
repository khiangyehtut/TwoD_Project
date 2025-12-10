// ignore_for_file: must_be_immutable, use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/controller/agent_controller.dart';
import 'package:two_d_project/controller/external_keyboard_con.dart';
import 'package:two_d_project/controller/internet_controller.dart';
import 'package:two_d_project/controller/ledger_controller.dart';
import 'package:two_d_project/controller/twod_controller.dart';

class MyKeyboard extends StatelessWidget {
  AgentController agentController;
  NetworkController internetController = Get.find();
  MyKeyboard({super.key, required this.agentController});

  final TwodController twodController = Get.find();
  final LedgerController ledgerController = Get.put(LedgerController());
  final ExternalKeyboardController keyboardController = Get.find();
  final List<String> topSpecial = [
    'အပူး',
    'အပါ',
    'ထိပ်',
    'နောက်',
    'ပါဝါ',
    'နက္ခတ်',
    'မပူး',
    'စုံပူး',
    'စုံစုံ',
    'မမ',
    'စုံမ',
    'မစုံ'
  ];
  final List<String> number = [
    'ဘရိတ်',
    '7',
    '8',
    '9',
    '<',
    'ညီကို',
    '4',
    '5',
    '6',
    'R',
    'ခွေ',
    '1',
    '2',
    '3',
    '/',
    'ခွေပူး',
    '0',
    '00',
    '000',
    'Enter',
  ];

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode()..requestFocus(),
      onKey: keyboardController.handleRawKey,
      child: Container(
        alignment:
            (Constant.phoneWidth(context) > 500) ? Alignment.center : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: (Constant.phoneWidth(context) > 500) ? 400 : double.infinity,
          child: Obx(() {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => twodController
                                  .isFirstInputActive.value = true,
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: twodController.firstInput.value
                                        .toUpperCase()),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.deepPurple,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: twodController
                                              .isFirstInputActive.value
                                          ? Colors.deepPurple
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => twodController
                                  .isFirstInputActive.value = false,
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: twodController.secondInput.value),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.deepPurple,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: !twodController
                                              .isFirstInputActive.value
                                          ? Colors.deepPurple
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Obx(() {
                        final selected = agentController.selectedValue.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              if (twodController.isUploading.value ==
                                  false) if (twodController.preDigits.isNotEmpty) {
                                twodController.isUploading.value = true;
                                await internetController.checkInternet();
                                if (internetController.isConnected.value) {
                                  twodController.submitToFirebase(selected);
                                } else {
                                  twodController.isUploading.value = false;
                                  Helper.customAlertDialog(
                                    context: context,
                                    oneButton: true,
                                    image: 'no-internet',
                                    firstText: 'Network Error',
                                    secondText: "Check Internet Connection",
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: (twodController.isUploading.value)
                                  ? const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white54,
                                      ),
                                    )
                                  : const Text(
                                      'တင်မည်',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                (keyboardController.keyboardIsConnected.value)
                    ? const SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topSpecial.length,
                              itemBuilder: (context, index) {
                                final keyText = topSpecial[index];
                                final bgColor = Constant.secColor;

                                return InkWell(
                                  onTap: () => twodController.addInput(keyText),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 5 -
                                            10, // ~5 items on screen
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      keyText,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: number.length,
                            itemBuilder: (context, index) {
                              final keyText = number[index];
                              final isSpecial = keyText == 'Enter';
                              final bgColor = (keyText == 'Enter')
                                  ? Colors.red
                                  : Constant.secColor;

                              return InkWell(
                                onTap: () {
                                  twodController.addInput(keyText);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    keyText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSpecial
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
