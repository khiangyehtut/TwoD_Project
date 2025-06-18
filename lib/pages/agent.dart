import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:two_d_project/components/custom_listtile.dart';
import 'package:two_d_project/components/custom_textfield.dart';
import 'package:two_d_project/components/header_container.dart';
import 'package:two_d_project/components/my_dialog.dart';
import 'package:two_d_project/components/myelevated.dart';
import 'package:two_d_project/constant/constant.dart';
import 'package:two_d_project/controller/agent_controller.dart';
import 'package:two_d_project/model/agent_model.dart';

// ignore: must_be_immutable
class AgentPage extends StatelessWidget {
  AgentPage({super.key});
  AgentController agentController = Get.put(AgentController());
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController percent = TextEditingController();
  // CreateUserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'ကိုယ်စလှယ်များ',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'images/agent.png',
                width: 50,
                height: 50,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CupertinoSearchTextField(
                onChanged: (value) {
                  agentController.searchTextAgent.value = value;
                  agentController.fetchAgents();
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: Obx(() {
                  return (agentController.isLoading.value)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: agentController.agents.length,
                          itemBuilder: (context, index) {
                            AgentModel agent = agentController.agents[index];
                            return InkWell(
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MyDialog(
                                        title: agent.name,
                                        headTitle: 'ကိုယ်စလှယ်ဖျက်ခြင်း',
                                        subTitle: 'ကိုယ်စလှယ်အားအပြီးဖျက်မည်',
                                        onTap: () async {
                                          await agentController.deleteAgent(
                                              agent.id ?? '', context);
                                        },
                                      );
                                    });
                              },
                              child: CustomListtile(
                                name: agent.name,
                                address: agent.address,
                                percent: agent.percent,
                              ),
                            );
                          });
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Constant.secColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HeaderContainer(
                            title: 'ကိုယ်စလှယ်အသစ်ထည့်ခြင်း',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextfield(
                            controller: name,
                            label: 'အမည်',
                            hintText: 'ကိုယ်စလှယ်အမည်ထည့်ပါ',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextfield(
                            controller: address,
                            label: 'နေရပ်',
                            hintText: 'နေရပ်လိပ်စာထည့်ပါ',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextfield(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: percent,
                            label: 'ကော်',
                            hintText: 'ကော်ပမာဏထည့်ပါ',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Myelevated(
                            borderColor: Colors.transparent,
                            label: 'OK',
                            onTap: () {
                              if (name.text.isNotEmpty &&
                                  percent.text.isNotEmpty) {
                                final exists = agentController.agents
                                    .any((d) => d.name == name.text);

                                if (exists) {
                                  Get.snackbar(
                                    "အမည်တူရှိခြင်း",
                                    "အခြားအမည်ပြောင်းပါ",
                                    backgroundColor: Colors.red.shade500,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } else {
                                  agentController.addAgent(
                                    AgentModel(
                                      name: name.text,
                                      address: address.text,
                                      percent: int.parse(percent.text),
                                    ),
                                    context,
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  "ပြန်လည်စစ်ဆေးပါ",
                                  "တစ်ခုခုမှားယွင်းနေပါသည်",
                                  backgroundColor: Colors.red.shade500,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
