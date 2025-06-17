// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/components/custom_list_contain.dart';
import 'package:two_d_project/components/header_container.dart';
import 'package:two_d_project/components/ledger_container.dart';
import 'package:two_d_project/components/ledger_form.dart';
import 'package:two_d_project/components/pouktee_dialog.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/controller/digits_controller.dart';
import 'package:two_d_project/controller/internet_controller.dart';
import 'package:two_d_project/controller/ledger_controller.dart';
import 'package:two_d_project/controller/twod_controller.dart';
import 'package:two_d_project/model/ledger_model.dart';

// ignore: must_be_immutable
class LedgerPage extends StatelessWidget {
  LedgerPage({super.key});

  TextEditingController ledger = TextEditingController();
  TextEditingController limitBreak = TextEditingController();
  TextEditingController za = TextEditingController();
  TextEditingController poukTee = TextEditingController();
  LedgerController ledgerController = Get.put(LedgerController());
  DigitsController digitsController = Get.find();
  TwodController twodController = Get.put(TwodController());
  NetworkController internetController = Get.put(NetworkController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'လည်ဂျာများ',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'images/archive.png',
              width: 50,
              height: 50,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return Column(
            children: [
              CupertinoSearchTextField(
                onChanged: (value) {
                  ledgerController.searchTextForLedger.value = value;
                  ledgerController.fetchLedgers();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: (ledgerController.isLoading.value)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: ledgerController.ledgers.length,
                          itemBuilder: (context, index) {
                            LedgerModel ledgerBook =
                                ledgerController.ledgers[index];
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          width: (Constant.phoneWidth(context) >
                                                  500)
                                              ? 400
                                              : null,
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              HeaderContainer(
                                                color: Colors.deepPurple,
                                                title: ledgerBook.ledger,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  digitsController
                                                      .selectedLedger
                                                      .value = ledgerBook;

                                                  twodController
                                                      .putLedger(ledgerBook);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: CustomListContain(
                                                  color: Constant.secColor,
                                                  label: 'လည်ဂျာရွေးမည်',
                                                  secLabel: '',
                                                  icon: const Icon(
                                                      Icons.select_all),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return PoukteeDialog(
                                                          controller: poukTee,
                                                          onTap: () async {
                                                            if (poukTee.text
                                                                        .length ==
                                                                    2 ||
                                                                poukTee.text
                                                                    .isEmpty) {
                                                              internetController
                                                                  .checkInternet();
                                                              if (internetController
                                                                  .isConnected
                                                                  .value) {
                                                                final getBack =
                                                                    await ledgerController
                                                                        .updateLedger(
                                                                  poukTee: true,
                                                                  ledgerBook
                                                                      .id!,
                                                                  LedgerModel(
                                                                    ledger: ledgerBook
                                                                        .ledger,
                                                                    limitBreak:
                                                                        ledgerBook
                                                                            .limitBreak,
                                                                    za: ledgerBook
                                                                        .za,
                                                                    poukTeeNo:
                                                                        poukTee
                                                                            .text,
                                                                    timeStamps:
                                                                        ledgerBook
                                                                            .timeStamps,
                                                                  ),
                                                                  context,
                                                                );
                                                                if (getBack ==
                                                                    'success') {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  poukTee
                                                                      .clear();
                                                                }
                                                              } else {
                                                                Helper
                                                                    .customAlertDialog(
                                                                  context:
                                                                      context,
                                                                  oneButton:
                                                                      true,
                                                                  image:
                                                                      'no-internet',
                                                                  firstText:
                                                                      'Network Error',
                                                                  secondText:
                                                                      "Check Internet Connection",
                                                                );
                                                              }
                                                            }
                                                          },
                                                        );
                                                      });
                                                },
                                                child: CustomListContain(
                                                  color: Constant.secColor,
                                                  label: 'ပေါက်သီးထည့်မည်',
                                                  secLabel: '',
                                                  icon: Image.asset(
                                                    'images/2d.png',
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  ledger.text =
                                                      ledgerBook.ledger;
                                                  limitBreak.text = ledgerBook
                                                      .limitBreak
                                                      .toString();
                                                  za.text =
                                                      ledgerBook.za.toString();
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return LedgerForm(
                                                          controller1: ledger,
                                                          controller2:
                                                              limitBreak,
                                                          controller3: za,
                                                          okTap: () async {
                                                            await ledgerController
                                                                .updateLedger(
                                                                    ledgerBook
                                                                        .id
                                                                        .toString(),
                                                                    LedgerModel(
                                                                        ledger: ledger
                                                                            .text,
                                                                        limitBreak:
                                                                            int.parse(limitBreak
                                                                                .text),
                                                                        za: int.parse(za
                                                                            .text),
                                                                        poukTeeNo:
                                                                            ledgerBook
                                                                                .poukTeeNo,
                                                                        timeStamps:
                                                                            ledgerBook.timeStamps),
                                                                    context)
                                                                .then((value) {
                                                              if (value ==
                                                                  'success') {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            });
                                                          },
                                                        );
                                                      });
                                                },
                                                child: CustomListContain(
                                                  color: Constant.secColor,
                                                  label: 'လည်ဂျာပြင်ဆင်မည်',
                                                  secLabel: '',
                                                  icon: const Icon(Icons.edit),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  ledgerController.deleteLedger(
                                                      ledgerBook.id.toString(),
                                                      context);
                                                },
                                                child: CustomListContain(
                                                  color: Constant.secColor,
                                                  label: 'လည်ဂျာဖျက်မည်',
                                                  secLabel: '',
                                                  icon:
                                                      const Icon(Icons.delete),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: LedgerContainer(
                                labelStyle: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Boldon',
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                                boxColor: Colors.yellow,
                                textColor: Colors.black54,
                                boxTextColor: Colors.black87,
                                containColor: Constant.secColor,
                                ledgerDate: ledgerBook.ledger,
                                poukTeeNo: ledgerBook.poukTeeNo,
                                breakAmount: ledgerBook.limitBreak.toString(),
                                za: ledgerBook.za.toString(),
                              ),
                            );
                          }))
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return LedgerForm(
                  controller1: ledger,
                  controller2: limitBreak,
                  controller3: za,
                  okTap: () {
                    if (za.text.isNotEmpty &&
                        limitBreak.text.isNotEmpty &&
                        ledger.text.isNotEmpty) {
                      ledgerController.addLedger(
                          DateTime.now().toString(),
                          LedgerModel(
                              ledger: ledger.text,
                              limitBreak: int.parse(limitBreak.text),
                              za: int.parse(za.text),
                              poukTeeNo: '',
                              timeStamps: DateTime.now()),
                          context);
                    } else {
                      Get.snackbar(
                        "စစ်ဆေးပါ",
                        "ထည့်သွင်းခြင်းများစစ်ဆေးပါ",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                );
              });
        },
        child: const Icon(
          Icons.add,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
