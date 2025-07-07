// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/components/choose_container.dart';
import 'package:two_d_project/components/ledger_container.dart';
import 'package:two_d_project/components/pouktee_dialog.dart';
import 'package:two_d_project/constant/exit.dart';
import 'package:two_d_project/controller/admin_controller.dart';
import 'package:two_d_project/controller/agent_controller.dart';
import 'package:two_d_project/controller/digits_controller.dart';
import 'package:two_d_project/controller/ledger_controller.dart';
import 'package:two_d_project/controller/twod_controller.dart';
import 'package:two_d_project/model/ledger_model.dart';
import 'package:two_d_project/pages/agent.dart';
import 'package:two_d_project/pages/agent_ledger.dart';
import 'package:two_d_project/pages/digit_ledger.dart';
import 'package:two_d_project/pages/ledger.dart';
import 'package:two_d_project/pages/ledger_dialog.dart';
import 'package:two_d_project/pages/two_d.dart';
import 'package:two_d_project/pages/vouncher.dart';
import 'package:two_d_project/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  final DigitsController digitsController = Get.put(DigitsController());
  final LedgerController ledgerController = Get.put(LedgerController());
  final TwodController twodController = Get.put(TwodController());
  final AgentController agentController = Get.put(AgentController());
  final AdminController adminController = Get.put(AdminController());
  final TextEditingController poukTee = TextEditingController();
  // final CreateUserController user = Get.put(CreateUserController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => await showExitConfirmationDialog(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
          title: const Text('M M 2 D', style: TextStyle(color: Colors.white)),
        ),
        drawer: CustomDrawer(),
        body: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                LedgerContainer(
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Boldon',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  boxColor: Colors.yellow,
                  breakAmount: digitsController.selectedLedger.value?.limitBreak
                      .toString(),
                  za: digitsController.selectedLedger.value?.za.toString(),
                  ledgerDate: digitsController.selectedLedger.value?.ledger,
                  poukTeeNo: digitsController.selectedLedger.value?.poukTeeNo,
                  onTap: () {
                    if (digitsController.selectedLedger.value != null) {
                      poukTee.clear();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PoukteeDialog(
                            controller: poukTee,
                            onTap: () async {
                              if (poukTee.text.length == 2 ||
                                  poukTee.text.isEmpty) {
                                final selectedLedger =
                                    digitsController.selectedLedger.value!;
                                final result =
                                    await ledgerController.updateLedger(
                                  selectedLedger.id!,
                                  LedgerModel(
                                    ledger: selectedLedger.ledger,
                                    limitBreak: selectedLedger.limitBreak,
                                    za: selectedLedger.za,
                                    poukTeeNo: poukTee.text,
                                    timeStamps: selectedLedger.timeStamps,
                                  ),
                                  context,
                                  poukTee: true,
                                );
                                if (result == 'success') {
                                  digitsController.getSelectedLedger();
                                  twodController.getSelectedLedger();
                                  Navigator.pop(context);
                                  poukTee.clear();
                                }
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                ChooseContainer(
                  image: '2d',
                  title: 'စရင်းတင်ရန်',
                  onTap: () {
                    ledgerController.fetchLedgers();
                    agentController.searchTextAgent.value = '';

                    if (digitsController.selectedLedger.value != null) {
                      twodController.fetchDigitsFromFirebase();
                      agentController.fetchAgents();
                      digitsController.copy.value = '';
                      Get.to(() => TwoDPage(
                          ledger: digitsController.selectedLedger.value!));
                    } else {
                      _openLedgerDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 10),
                ChooseContainer(
                  image: 'folders',
                  title: 'စရင်းရှင်းတမ်း',
                  onTap: () {
                    agentController.searchTextAgent.value = '';
                    ledgerController.fetchLedgers();
                    agentController.fetchAgents();
                    if (digitsController.selectedLedger.value != null) {
                      Get.to(() => AgentLedgerPage(
                          selected: digitsController.selectedLedger.value!));
                    } else {
                      _openLedgerDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 10),
                ChooseContainer(
                  image: 'table',
                  title: 'လည်ဂျာ',
                  onTap: () {
                    ledgerController.fetchLedgers();
                    agentController.fetchAgents();
                    if (digitsController.selectedLedger.value != null) {
                      agentController.fetchAgents();
                      twodController.fetchDigitsFromFirebase();
                      twodController.getSelectedLedger();
                      Get.to(() => DigitLedger());
                    } else {
                      _openLedgerDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 10),
                ChooseContainer(
                  image: 'ledger',
                  title: 'စလစ်များ',
                  onTap: () {
                    agentController.searchTextAgent.value = '';
                    if (digitsController.selectedLedger.value != null) {
                      agentController.fetchAgents();
                      digitsController.listenToGroups();
                      twodController.fetchDigitsFromFirebase();

                      Get.to(
                          () => VouncherPage(agentController: agentController));
                    } else {
                      _openLedgerDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 10),
                ChooseContainer(
                  image: 'agent',
                  title: 'ကိုယ်စလှယ်များ',
                  onTap: () {
                    agentController.searchTextAgent.value = '';
                    agentController.fetchAgents();
                    Get.to(() => AgentPage());
                  },
                ),
                const SizedBox(height: 10),
                ChooseContainer(
                  image: 'archive',
                  title: 'လည်ဂျာများ',
                  onTap: () {
                    ledgerController.searchTextForLedger.value = '';
                    ledgerController.fetchLedgers();
                    Get.to(() => LedgerPage());
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _openLedgerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => LedgerDialog(
        digitsController: digitsController,
        ledgerController: ledgerController,
      ),
    );
  }
}
