import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/components/agent_container.dart';
import 'package:two_d_project/controller/agent_controller.dart';
import 'package:two_d_project/model/agent_model.dart';
import 'package:two_d_project/model/ledger_model.dart';

class AgentLedgerPage extends StatelessWidget {
  final AgentController agentController = Get.put(AgentController());
  final LedgerModel selected;

  AgentLedgerPage({required this.selected, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'စရင်းရှင်းတမ်း',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'images/folders.png',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return Column(
            children: [
              CupertinoSearchTextField(
                onChanged: (value) {
                  agentController.searchTextAgent.value = value;
                  agentController.fetchAgents();
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: (agentController.isLoading.value)
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: agentController.agents.length,
                          itemBuilder: (context, index) {
                            AgentModel agent = agentController.agents[index];
                            return FutureBuilder<Map<String, int>>(
                              future: agentController.getDigitByName(
                                selected.id.toString(),
                                agent,
                                selected.poukTeeNo,
                                selected.za.toString(),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(); // Hide loading tile
                                } else if (snapshot.hasError ||
                                    !snapshot.hasData) {
                                  return const SizedBox(); // Hide error/no-data agent
                                } else {
                                  final total = snapshot.data!['total'] ?? 0;
                                  if (total == 0) {
                                    return const SizedBox(); // Skip agents with 0 total
                                  }

                                  return AgentContainer(
                                    poukTeeNo: selected.poukTeeNo,
                                    date: selected.ledger,
                                    name: agent.name,
                                    total: total.toString(),
                                    percent:
                                        snapshot.data!['percent'].toString(),
                                    poukTeeAmount: snapshot
                                        .data!['poukTeeAmount']
                                        .toString(),
                                    earnMoney:
                                        snapshot.data!['earnMoney'].toString(),
                                    finalTotal: snapshot.data?['finalTotal']
                                            .toString() ??
                                        '0',
                                  );
                                }
                              },
                            );
                          })),
            ],
          );
        }),
      ),
    );
  }
}
