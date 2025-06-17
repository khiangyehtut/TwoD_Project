import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/controller/agent_controller.dart';
import 'package:two_d_project/controller/digits_controller.dart';
import 'package:two_d_project/controller/external_keyboard_con.dart';
import 'package:two_d_project/controller/internet_controller.dart';
import 'package:two_d_project/controller/twod_controller.dart';
import 'package:two_d_project/model/ledger_model.dart';
import 'package:two_d_project/pages/digit_ledger.dart';
import 'package:two_d_project/pages/vouncher.dart';
import 'package:two_d_project/widgets/copy_dialog.dart';
import 'package:two_d_project/widgets/mykeyboard.dart';

// ignore: must_be_immutable
class TwoDPage extends StatelessWidget {
  final LedgerModel ledger;
  final TwodController twodController = Get.put(TwodController());
  final AgentController agentController = Get.put(AgentController());
  DigitsController digitsController = Get.find();
  NetworkController internetController = Get.put(NetworkController());
  ExternalKeyboardController keyboardController =
      Get.put(ExternalKeyboardController());

  TwoDPage({super.key, required this.ledger});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        title: Text(
          ledger.ledger,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(5),
              child: Obx(() {
                final sortedList =
                    agentController.listOfAgentName.toSet().toList()..sort();
                final selectedValue = agentController.selectedValue.value;
                final isValidSelection = sortedList.contains(selectedValue);

                return DropdownButton<String>(
                  dropdownColor: Colors.blueAccent,
                  style: const TextStyle(color: Colors.white),
                  value: isValidSelection ? selectedValue : null,
                  items: sortedList
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      agentController.updateSelectedValue(newValue);
                    }
                  },
                );
              })),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () {
                digitsController.listenToGroups();
                twodController.getSelectedLedger();
                Get.to(() => DigitLedger());
              },
              child: Column(
                children: [
                  Image.asset(
                    'images/table.png',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  const Text(
                    'လည်ဂျာ',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () {
                agentController.isKeyboardVisible.value = false;
                agentController.fetchAgents();
                digitsController.listenToGroups();
                Get.to(() => VouncherPage(
                      agentController: agentController,
                    ));
              },
              child: Column(
                children: [
                  Image.asset(
                    'images/ledger.png',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  const Text(
                    'စလစ်များ',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.lightBlue.shade100,
                          child: Obx(() {
                            final entries = twodController.preDigits;
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Center(child: Text('No')),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(child: Text('2D')),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(child: Text('ပမာဏ')),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    controller: twodController.scrollController,
                                    itemCount: entries.length,
                                    itemBuilder: (context, index) {
                                      final entry = entries[index];
                                      return InkWell(
                                        onLongPress: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'ဖျက်မည်',
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                  content: Text(
                                                      '${entry.key} - ${entry.value}'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Get.back(),
                                                        child: const Text(
                                                            'Cancel')),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          twodController
                                                              .preDigits
                                                              .removeAt(index);
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ))
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.lightBlue)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text('${index + 1}'),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                    child: Text(entry.key)),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: Text(
                                                      entry.value.toString()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Total: ${twodController.totalAmount}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                (agentController.isKeyboardVisible.value)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () => twodController
                                                  .preDigits
                                                  .clear(),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 60,
                                                  height: 30,
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: const Text(
                                                    'Clear',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))),
                                          InkWell(
                                            onTap: () {
                                              agentController.isKeyboardVisible
                                                  .value = false;
                                              TextEditingController
                                                  textController =
                                                  TextEditingController();

                                              Get.dialog(CopyDialog(
                                                  twodController:
                                                      twodController,
                                                  controller: textController));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              height: 30,
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 125, 215, 128),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Icon(
                                                  Icons.post_add_outlined),
                                            ),
                                          ),
                                          (keyboardController
                                                  .keyboardIsConnected.value)
                                              ? InkWell(
                                                  onTap: () {
                                                    keyboardController
                                                        .keyboardIsConnected
                                                        .value = false;
                                                  },
                                                  child: const Icon(
                                                      Icons.arrow_upward))
                                              : const SizedBox(),
                                          InkWell(
                                              onTap: () {
                                                agentController
                                                        .isKeyboardVisible
                                                        .value =
                                                    !agentController
                                                        .isKeyboardVisible
                                                        .value;
                                              },
                                              child: const Icon(Icons.keyboard))
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: const Color.fromARGB(255, 245, 227, 173),
                          child: Obx(() {
                            final entries = twodController.digits.entries
                                .where((e) => e.value > 0)
                                .toList()
                              ..sort((a, b) => b.value.compareTo(a.value));

                            final totalOver =
                                twodController.getOverTotal(ledger.limitBreak);
                            final totalValue =
                                twodController.totalValue - totalOver;
                            digitsController.copy.value = '';

                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: Center(child: Text('2D')),
                                      ),
                                      const Expanded(
                                        flex: 3,
                                        child: Center(child: Text('ပမာဏ')),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('ကျွံ'),
                                            InkWell(
                                              onTap: () async {
                                                if (digitsController
                                                    .copy.isNotEmpty) {
                                                  await FlutterClipboard.copy(
                                                      digitsController
                                                          .copy.value);
                                                  Fluttertoast.showToast(
                                                    msg: "Copy",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black45,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg: "ကျွံသီးမရှိပါ",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black45,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                              },
                                              child: const Icon(
                                                Icons.copy,
                                                size: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                (entries.isEmpty)
                                    ? const Expanded(
                                        child: Center(
                                            child: Text('တင်ဂဏန်းမရှိသေးပါ')))
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: entries.length,
                                          itemBuilder: (context, index) {
                                            final digit = entries[index].key;
                                            final value = entries[index].value;
                                            final overValue = value >
                                                    ledger.limitBreak
                                                ? (value - ledger.limitBreak)
                                                : 0;

                                            if (overValue > 0) {
                                              digitsController.copy.value +=
                                                  '$digit-$overValue \n';
                                            }
                                            return Container(
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.amber),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                        child: Text(digit)),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: Text(
                                                          '${value - overValue}'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: Text(
                                                        overValue > 0
                                                            ? overValue
                                                                .toString()
                                                            : '',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .red.shade800,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Expanded(flex: 1, child: SizedBox()),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          '$totalValue',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          '$totalOver',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: child,
                      );
                    },
                    child: agentController.isKeyboardVisible.value
                        ? MyKeyboard(
                            agentController: agentController,
                          )
                        : const SizedBox.shrink(),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return agentController.isKeyboardVisible.value
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        agentController.isKeyboardVisible.value = true;
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(2, 3),
                                  blurRadius: 2)
                            ]),
                        child: const Icon(
                          Icons.keyboard,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    (Constant.phoneWidth(context) > 500)
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  TextEditingController textController =
                                      TextEditingController();

                                  Get.dialog(CopyDialog(
                                      twodController: twodController,
                                      controller: textController));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 125, 215, 128),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(2, 3),
                                            blurRadius: 2)
                                      ]),
                                  child: const Icon(Icons.post_add_outlined),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (twodController.preDigits.isNotEmpty) {
                                    twodController.isUploading.value = true;
                                    await internetController.checkInternet();
                                    if (internetController.isConnected.value) {
                                      twodController.submitToFirebase(
                                          agentController.selectedValue.value);
                                    } else {
                                      twodController.isUploading.value = false;
                                      Helper.customAlertDialog(
                                        // ignore: use_build_context_synchronously
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
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(2, 3),
                                            blurRadius: 2)
                                      ]),
                                  child: (twodController.isUploading.value)
                                      ? const Center(
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : const Icon(
                                          Icons.upload,
                                          color: Colors.white,
                                        ),
                                ),
                              )
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
              );
      }),
    );
  }
}
