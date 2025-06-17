import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/exit.dart';
import 'package:two_d_project/controller/noti_controller.dart';

class NotiTextPage extends StatelessWidget {
  final NotiTextController controller = Get.put(NotiTextController());
  final TextEditingController descriptionController = TextEditingController();

  NotiTextPage({super.key});

  void clearField() => descriptionController.clear();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await showExitConfirmationDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                final reversedList = controller.notiTexts.reversed.toList();
                return ListView.builder(
                  itemCount: reversedList.length,
                  itemBuilder: (context, index) {
                    final item = reversedList[index];
                    return ListTile(
                      title: Text(item['description'] ?? 'No Description'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => controller.deleteNotiText(item['id']),
                      ),
                      onTap: () {
                        descriptionController.text = item['description'] ?? '';
                        Get.defaultDialog(
                          title: 'Edit Message',
                          content: TextField(
                            controller: descriptionController,
                            decoration:
                                InputDecoration(labelText: 'New Description'),
                          ),
                          textConfirm: 'Update',
                          textCancel: 'Cancel',
                          onConfirm: () {
                            controller.updateNotiText(item['id'], {
                              'description': descriptionController.text,
                            });
                            clearField();
                            Get.back();
                          },
                          onCancel: () {
                            clearField();
                            Get.back();
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (descriptionController.text.isNotEmpty) {
                        controller.addNotiText({
                          'description': descriptionController.text,
                        });
                        clearField();
                      }
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
