import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/controller/digits_controller.dart';
import 'package:two_d_project/controller/ledger_controller.dart';
import 'package:two_d_project/controller/twod_controller.dart';
import 'package:two_d_project/model/ledger_model.dart';

// ignore: must_be_immutable
class LedgerDialog extends StatelessWidget {
  DigitsController digitsController;
  LedgerController ledgerController;
  LedgerDialog(
      {required this.ledgerController,
      required this.digitsController,
      super.key});
  TwodController twodController = Get.put(TwodController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: (Constant.phoneWidth(context) > 500) ? 300 : 200,
        height: 600,
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            title: const Text(
              'လည်ဂျာရွေးပါ',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('images/archive.png'),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  onChanged: (value) {
                    ledgerController.searchTextForLedger.value = value;
                    ledgerController.fetchLedgers();
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Obx(() {
                  return Expanded(
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
                                    digitsController.selectedLedger.value =
                                        ledgerBook;
                                    digitsController.getSelectedLedger();
                                    twodController.selectedLedger.value =
                                        ledgerBook;
                                    twodController.getSelectedLedger();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(1, 2),
                                            color: Colors.black26,
                                            blurRadius: 2)
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color.fromARGB(
                                          255, 230, 221, 248),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ledgerBook.ledger,
                                            style: const TextStyle(
                                                color: Colors.deepPurple,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                      offset: Offset(1, 2),
                                                      color: Colors.black54,
                                                      blurRadius: 2)
                                                ],
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              ledgerBook.poukTeeNo,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
