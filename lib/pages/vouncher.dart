// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/controller/agent_controller.dart';
import 'package:two_d_project/controller/digits_controller.dart';
import 'package:two_d_project/controller/internet_controller.dart';
import 'package:two_d_project/model/digits_model.dart';

class VouncherPage extends StatelessWidget {
  final DigitsController digitsController = Get.find();
  final AgentController agentController;
  final NetworkController internetController = Get.put(NetworkController());

  VouncherPage({required this.agentController, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        title: const Text('စလစ်များ', style: TextStyle(fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset('images/ledger.png', width: 50, height: 50),
          ),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: digitsController.vouncherDigit.length,
                  itemBuilder: (context, index) {
                    DigitsModel digit = digitsController.vouncherDigit[index];

                    return InkWell(
                      onTap: () {
                        // 💡 Total calculated ONCE here
                        digitsController.editTotalSum.value = digit.digits.fold(
                          0,
                          (sum, item) =>
                              sum + int.tryParse(item['value'].toString())!,
                        );

                        agentController.selectedValue.value = digit.group;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
// Add this check to prevent the error

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Obx(() {
                                          final sortedList = agentController
                                              .listOfAgentName
                                              .toList()
                                              .cast<String>()
                                            ..sort();

                                          final selectedValue = agentController
                                              .selectedValue.value;
                                          final isInList = sortedList
                                              .contains(selectedValue);

                                          // Optional: fallback to the first item if selected value is missing
                                          final fallback = sortedList.isNotEmpty
                                              ? sortedList.first
                                              : null;
                                          final safeSelected = isInList
                                              ? selectedValue
                                              : fallback;

                                          // Optional: update selectedValue if it's invalid
                                          if (!isInList && fallback != null) {
                                            Future.microtask(() =>
                                                agentController
                                                    .updateSelectedValue(
                                                        fallback));
                                          }

                                          return DropdownButton<String>(
                                            value: safeSelected,
                                            dropdownColor: Colors.blueAccent,
                                            items: sortedList
                                                .map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text(item),
                                                    ))
                                                .toList(),
                                            onChanged: (newValue) {
                                              if (newValue != null) {
                                                agentController
                                                    .updateSelectedValue(
                                                        newValue);
                                              }
                                            },
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 300,
                                        child: ListView.builder(
                                          itemCount: digit.digits.length,
                                          itemBuilder: (context, subIndex) {
                                            final entry =
                                                digit.digits[subIndex];
                                            final key = entry['key'].toString();
                                            final value =
                                                entry['value'].toString();

                                            return InkWell(
                                              onTap: () {
                                                final keyController =
                                                    TextEditingController(
                                                        text: key);
                                                final valueController =
                                                    TextEditingController(
                                                        text: value);

                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'အမှားပြင်ဆင်ရန်',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .deepPurple,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly,
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                keyController,
                                                            decoration:
                                                                const InputDecoration(
                                                                    labelText:
                                                                        'ဂဏန်း'),
                                                          ),
                                                          TextField(
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly,
                                                            ],
                                                            controller:
                                                                valueController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                const InputDecoration(
                                                                    labelText:
                                                                        'ပမာဏ'),
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            digit.digits
                                                                .removeAt(
                                                                    subIndex);
                                                            digitsController
                                                                    .editTotalSum
                                                                    .value =
                                                                digit.digits
                                                                    .fold(
                                                              0,
                                                              (sum, item) =>
                                                                  sum +
                                                                  int.tryParse(item[
                                                                          'value']
                                                                      .toString())!,
                                                            );
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .red),
                                                          child: const Text(
                                                              'Delete'),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            final newKey =
                                                                keyController
                                                                    .text;
                                                            final newValue =
                                                                int.tryParse(
                                                                        valueController
                                                                            .text) ??
                                                                    0;

                                                            if (newKey.length ==
                                                                    2 &&
                                                                newValue > 0) {
                                                              digit.digits[
                                                                  subIndex] = {
                                                                'key': newKey,
                                                                'value':
                                                                    newValue,
                                                              };

                                                              digitsController
                                                                      .editTotalSum
                                                                      .value =
                                                                  digit.digits
                                                                      .fold(
                                                                0,
                                                                (sum, item) =>
                                                                    sum +
                                                                    int.tryParse(
                                                                        item['value']
                                                                            .toString())!,
                                                              );

                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              Get.snackbar(
                                                                "မှားယွင်းနေသည်",
                                                                "ဂဏန်း နှင့် ပမာဏအားစစ်ဆေးပါ",
                                                                backgroundColor:
                                                                    Colors.red,
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                              );
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Save'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            '${subIndex + 1}')),
                                                    Expanded(
                                                        child: Center(
                                                            child: Text(entry[
                                                                    'key']
                                                                .toString()))),
                                                    Expanded(
                                                        child: Center(
                                                            child: Text(entry[
                                                                    'value']
                                                                .toString()))),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const Divider(),
                                      Obx(() => Text(
                                          'Total: ${digitsController.editTotalSum.value}')),
                                      ListTile(
                                        leading: const Icon(Icons.save),
                                        title: const Text('Save All'),
                                        onTap: () async {
                                          Helper.showloading(context);
                                          await internetController
                                              .checkInternet();
                                          if (internetController
                                              .isConnected.value) {
                                            digitsController.updateDigit(
                                              digit.id,
                                              DigitsModel(
                                                id: digit.id,
                                                group: agentController
                                                    .selectedValue.value,
                                                timeStamps: digit.timeStamps,
                                                totalSum: digitsController
                                                    .editTotalSum.value,
                                                digits: digit.digits,
                                              ),
                                              context,
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            Helper.customAlertDialog(
                                              context: context,
                                              oneButton: true,
                                              image: 'no-internet',
                                              firstText: 'Network Error',
                                              secondText:
                                                  "Check Internet Connection",
                                            );
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Delete'),
                                        onTap: () {
                                          digitsController.deleteDigit(
                                              digit.id, context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Constant.secColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(digit.totalSum.toString()),
                          leading: Text(digit.group),
                          trailing:
                              Text(Helper.formatTime12Hour(digit.timeStamps)),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
