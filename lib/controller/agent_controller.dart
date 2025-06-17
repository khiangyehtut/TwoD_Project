import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/firebase/agent_services.dart';
import 'package:two_d_project/firebase/digits_services.dart';
import 'package:two_d_project/model/agent_model.dart';

class AgentController extends GetxController {
  final AgentService _agentService = AgentService();
  final DigitsService digitsService = Get.put(DigitsService());
  RxList<AgentModel> agents = <AgentModel>[].obs;

  RxBool isLoading = true.obs;
  var selectedValue = ''.obs;
  var listOfAgentName = [].obs;
  var isKeyboardVisible = false.obs;
  var searchTextAgent = ''.obs;
  var noInternet = 'no-internet'.obs;
  var copyText = 'စာကူးထည့်ခြင်း'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
  }

  void updateSelectedValue(String value) {
    selectedValue.value = value;
  }

  void fetchAgents() {
    listOfAgentName.clear();

    _agentService
        .getAgents(searchText: searchTextAgent.value)
        .listen((agentList) {
      for (var agent in agentList) {
        listOfAgentName.add(agent.name);
      }

      agents.assignAll(agentList);
      isLoading.value = false;
    });
  }

  Future<void> addAgent(AgentModel agent, BuildContext context) async {
    Helper.showloading(context);
    String get = await _agentService.addAgent(agent);
    if (get == 'success') {
      Get.back();
      Get.back();
      Get.snackbar(
        "အောင်မြင်သည်",
        "ကိုယ်စလှယ်အသစ်ထည့်ခြင်းအောင်မြင်သည်",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        "တစ်ခုခုမှားယွင်းနေပါသည်",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // **Update an existing agent**
  Future<void> updateAgent(String id, AgentModel agent) async {
    await _agentService.updateAgent(id, agent);
  }

  // **Delete an agent**
  Future<void> deleteAgent(String id, BuildContext context) async {
    Helper.showloading(context);
    String get = await _agentService.deleteAgent(id);
    if (get == 'success') {
      Get.back();
      Get.back();
      Get.snackbar(
        "အောင်မြင်သည်",
        "ကိုယ်စလှယ်ဖျက်ခြင်းအောင်မြင်သည်",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        "တစ်ခုခုမှားယွင်းနေပါသည်",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<Map<String, int>> getDigitByName(
      String ledgerDoc, AgentModel agent, String number, String za) async {
    int total = 0;
    double percent = 0;
    int poukTeeAmount = 0;
    int earnMoney = 0;
    double finalTotal = 0;
    Completer<Map<String, int>> completer = Completer();

    StreamSubscription? subscription;

    subscription = digitsService
        .getDigitsFromLedger(ledgerDoc, groupName: agent.name)
        .listen(
      (data) {
        for (var d in data) {
          total += d.totalSum;
          for (var digit in d.digits) {
            if (digit['key'] == number) {
              poukTeeAmount += digit['value'] as int;
            }
          }
        }
        percent = total * (agent.percent / 100);
        earnMoney = poukTeeAmount * int.parse(za);
        finalTotal = (total - percent) - earnMoney;
        if (!completer.isCompleted) {
          completer.complete({
            'total': total,
            'percent': percent.toInt(),
            'poukTeeAmount': poukTeeAmount,
            'earnMoney': earnMoney,
            'finalTotal': finalTotal.toInt()
          });
        }
        subscription?.cancel(); // 💡 Cancel stream once data is used
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
        subscription?.cancel();
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete({'total': total});
        }
      },
    );

    return completer.future;
  }
}
