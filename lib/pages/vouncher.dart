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
          title: const Text('စလစ်များ',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('images/ledger.png', width: 36, height: 36),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(
                children: [
                  Obx(() {
                    final List<String> items = [
                      'All',
                      ...List<String>.from(agentController.filterAgents)
                        ..sort(),
                    ];

                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select agent',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      value: agentController.selectedFilter.value.isEmpty
                          ? 'All'
                          : agentController.selectedFilter.value,
                      items: items
                          .map((name) =>
                              DropdownMenuItem(value: name, child: Text(name)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          agentController
                              .updateFilterValue(val == 'All' ? '' : val);
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      final filter = agentController.selectedFilter.value;
                      final allVouchers = digitsController.vouncherDigit;
                      final vouchers = filter.isEmpty
                          ? allVouchers
                          : allVouchers
                              .where((v) => v.group == filter)
                              .toList();

                      if (vouchers.isEmpty) {
                        return const Center(
                            child: Text('No vouchers available.'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                            bottom: 60), // Extra space for bottom bar
                        itemCount: vouchers.length,
                        itemBuilder: (_, i) =>
                            _voucherItem(context, vouchers[i]),
                      );
                    }),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.deepPurple,
                    child: Obx(() {
                      final filter = agentController.selectedFilter.value;
                      final allVouchers = digitsController.vouncherDigit;
                      final vouchers = filter.isEmpty
                          ? allVouchers
                          : allVouchers
                              .where((v) => v.group == filter)
                              .toList();

                      final totalAmount = vouchers.fold<int>(
                          0, (sum, item) => sum + item.totalSum);

                      return Text(
                        'စုစုပေါင်း : $totalAmount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _voucherItem(BuildContext ctx, DigitsModel digit) {
    return InkWell(
      onTap: () => _openEditSheet(ctx, digit),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Constant.secColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text('${digit.totalSum}'),
          leading: Text(digit.group),
          trailing: Text(Helper.formatTime12Hour(digit.timeStamps)),
        ),
      ),
    );
  }

  void _openEditSheet(BuildContext context, DigitsModel digit) {
    digitsController.editTotalSum.value = digit.digits.fold(
      0,
      (sum, item) => sum + int.tryParse(item['value'].toString())!,
    );

    final sortedAgents = [
      '',
      ...agentController.listOfAgentName.cast<String>()..sort()
    ];
    String currentAgent = digit.group.trim();

    if (currentAgent.isEmpty || !sortedAgents.contains(currentAgent)) {
      currentAgent = '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context)
                  .viewInsets
                  .add(const EdgeInsets.all(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      value: currentAgent,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Agent',
                      ),
                      items: sortedAgents
                          .map(
                              (a) => DropdownMenuItem(value: a, child: Text(a)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            currentAgent = val;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: digit.digits.length,
                      itemBuilder: (_, i) {
                        final entry = digit.digits[i];
                        final key = entry['key'].toString();
                        final val = entry['value'].toString();

                        return InkWell(
                          onTap: () {
                            final keyCtrl = TextEditingController(text: key);
                            final valCtrl = TextEditingController(text: val);

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('အမှားပြင်ဆင်ရန်'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: keyCtrl,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                          labelText: 'ဂဏန်း'),
                                    ),
                                    TextField(
                                      controller: valCtrl,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                          labelText: 'ပမာဏ'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      digit.digits.removeAt(i);
                                      digitsController.editTotalSum.value =
                                          digit.digits.fold(
                                        0,
                                        (sum, item) =>
                                            sum +
                                            int.tryParse(
                                                item['value'].toString())!,
                                      );
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.red),
                                    child: const Text('Delete'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final newKey = keyCtrl.text;
                                      final newVal =
                                          int.tryParse(valCtrl.text) ?? 0;
                                      if (newKey.length == 2 && newVal > 0) {
                                        digit.digits[i] = {
                                          'key': newKey,
                                          'value': newVal
                                        };
                                        digitsController.editTotalSum.value =
                                            digit.digits.fold(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              int.tryParse(
                                                  item['value'].toString())!,
                                        );
                                        setState(() {});
                                        Navigator.pop(context);
                                      } else {
                                        Get.snackbar(
                                          'မှားယွင်းနေသည်',
                                          'ဂဏန်း နှင့် ပမာဏအားစစ်ဆေးပါ',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text('${i + 1}')),
                                Expanded(child: Center(child: Text(key))),
                                Expanded(child: Center(child: Text(val))),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Obx(() =>
                      Text('Total: ${digitsController.editTotalSum.value}')),
                  ListTile(
                    leading: const Icon(Icons.save),
                    title: const Text('Save All'),
                    onTap: () async {
                      Helper.showloading(context);
                      await internetController.checkInternet();
                      if (internetController.isConnected.value) {
                        digitsController.updateDigit(
                          digit.id,
                          DigitsModel(
                            id: digit.id,
                            group: currentAgent,
                            timeStamps: digit.timeStamps,
                            totalSum: digitsController.editTotalSum.value,
                            digits: digit.digits,
                          ),
                          context,
                        );
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Helper.customAlertDialog(
                          context: context,
                          oneButton: true,
                          image: 'no-internet',
                          firstText: 'Network Error',
                          secondText: 'Check Internet Connection',
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      digitsController.deleteDigit(digit.id, context);
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
  }
}
