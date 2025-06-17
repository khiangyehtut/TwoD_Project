import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/controller/twod_controller.dart';

class DigitLedger extends StatelessWidget {
  DigitLedger({super.key});

  final TwodController twodController = Get.put(TwodController());

  List<List<String>> generateGrid(int start, int end, int columns) {
    List<List<String>> grid = [];
    int totalNumbers = end - start + 1;
    int rows = (totalNumbers / columns).ceil();

    for (int row = 0; row < rows; row++) {
      List<String> rowList = [];
      for (int col = 0; col < columns; col++) {
        int number = start + row + col * rows;
        if (number <= end) {
          rowList.add(number.toString().padLeft(2, '0'));
        } else {
          rowList.add('');
        }
      }
      grid.add(rowList);
    }
    return grid;
  }

  @override
  Widget build(BuildContext context) {
    final grid1 = generateGrid(0, 29, 3);
    final grid2 = generateGrid(30, 59, 3);
    final grid3 = generateGrid(60, 89, 3);
    final grid4 = generateGrid(90, 99, 1); // Single column

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        title: const Text('လည်ဂျာ', style: TextStyle(fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset('images/table.png', width: 50, height: 50),
          ),
        ],
      ),
      body: Obx(() {
        final entries = twodController.digits.entries
            .where((e) => e.value > 0)
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        Widget buildGrid(List<List<String>> gridData) {
          return Column(
            children: gridData.map((row) {
              return Row(
                children: row.map((digit) {
                  if (digit.isEmpty) {
                    return const Expanded(child: SizedBox());
                  }
                  final entry = entries.firstWhereOrNull((e) => e.key == digit);
                  final displayText = entry != null
                      ? '${entry.key} - ${entry.value}'
                      : '$digit  -  0';
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: (twodController.poukTeeNumber.value == digit)
                            ? Colors.yellow
                            : null,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        displayText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: Text('0 ထိပ်'),
                    )),
                    Expanded(
                        child: Center(
                      child: Text('1 ထိပ်'),
                    )),
                    Expanded(
                        child: Center(
                      child: Text('2 ထိပ်'),
                    ))
                  ],
                ),
                buildGrid(grid1),
                const Divider(),
                const Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: Text('3 ထိပ်'),
                    )),
                    Expanded(
                        child: Center(
                      child: Text('4 ထိပ်'),
                    )),
                    Expanded(
                        child: Center(
                      child: Text('5 ထိပ်'),
                    ))
                  ],
                ),
                buildGrid(grid2),
                const Divider(),
                const Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: Text('6 ထိပ်'),
                    )),
                    Expanded(
                        child: Center(
                      child: Text('7 ထိပ်'),
                    )),
                    Expanded(
                        child: Center(
                      child: Text('8 ထိပ်'),
                    ))
                  ],
                ),
                buildGrid(grid3),
                const Divider(),
                const Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: Text('9 ထိပ်'),
                    )),
                    Expanded(child: SizedBox()),
                    Expanded(child: SizedBox())
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1, // One-third width
                      child: buildGrid(grid4),
                    ),
                    const Spacer(flex: 2), // Two-thirds empty
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
