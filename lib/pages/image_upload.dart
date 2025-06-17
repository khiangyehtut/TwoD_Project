import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/exit.dart';
import 'package:two_d_project/controller/image_controller.dart';

class ImagePage extends StatelessWidget {
  final CloudinaryImageController controller =
      Get.put(CloudinaryImageController());

  ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await showExitConfirmationDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Image Upload ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.imageList.isEmpty) {
                  return const Center(child: Text("No images found."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: controller.imageList.length,
                  itemBuilder: (context, index) {
                    final item = controller.imageList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: Image.network(item['url'],
                            width: 60, height: 60, fit: BoxFit.cover),
                        title: const Text("Uploaded Image"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this image?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              controller.deleteImage(
                                  item['id'], item['public_id']);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Obx(() {
              final file = controller.selectedFile.value;
              if (file != null) {
                return Image.file(file, height: 100, fit: BoxFit.cover);
              }
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No image selected."),
              );
            }),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(50),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Choose Image"),
                  onPressed: controller.pickImage,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload"),
                  onPressed: controller.uploadSelectedImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
