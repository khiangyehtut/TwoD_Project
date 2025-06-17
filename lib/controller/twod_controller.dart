import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/controller/digits_controller.dart';
import 'package:two_d_project/firebase/ledger_services.dart';
import 'package:two_d_project/model/digits_model.dart';
import 'package:two_d_project/model/ledger_model.dart';
import 'package:two_d_project/model/pridigit_model.dart';

class TwodController extends GetxController {
  var digits = <String, int>{}.obs;
  RxBool isKeyboardOn = false.obs;
  RxString firstInput = ''.obs;
  RxString secondInput = ''.obs;
  var isUploading = false.obs;
  RxBool isFirstInputActive = true.obs;
  var preDigits = <PreDigit>[].obs;
  final scrollController = ScrollController();
  final player = AudioPlayer();
  final digitsController = Get.put(DigitsController());
  final LedgerService ledgerService = Get.put(LedgerService());
  Rxn<LedgerModel> selectedLedger = Rxn<LedgerModel>();
  RxString poukTeeNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    generateDigits();
  }

  void putLedger(LedgerModel ledger) {
    selectedLedger.value = ledger;
  }

  void getSelectedLedger() {
    if (selectedLedger.value != null) {
      ledgerService
          .getLedgerById(selectedLedger.value!.id.toString())
          .listen((ledger) {
        poukTeeNumber.value = ledger?.poukTeeNo ?? '';
      });
    }
  }

  void generateDigits() {
    final Map<String, int> map = {
      for (var item in List.generate(100, (i) => i))
        item.toString().padLeft(2, '0'): 0
    };
    digits.value = map;
  }

  void addInput(String input) async {
    await player.play(AssetSource(
        input == 'Enter' ? 'sounds/mouse.mp3' : 'sounds/press.mp3'));

    if (input == 'Enter') {
      if (firstInput.value.isEmpty && secondInput.value.isEmpty) {
        isFirstInputActive.value = true;
      } else if (firstInput.value.isNotEmpty && secondInput.value.isNotEmpty) {
        callSubmitFunction();
      } else {
        isFirstInputActive.value = false;
      }
    } else if (input == '<') {
      removeLastChar();
    } else {
      if (isFirstInputActive.value) {
        // ✅ Clear secondInput when typing into firstInput
        if (secondInput.value.isNotEmpty) {
          secondInput.value = '';
        }
        firstInput.value += input;
      } else {
        // ✅ Auto-refocus to firstInput if it's empty
        if (firstInput.value.isEmpty) {
          isFirstInputActive.value = true;
          firstInput.value += input;
          return;
        }

        // ✅ Only accept valid input for secondInput
        final isDigit = RegExp(r'^\d+$').hasMatch(input);
        final isSlash = input == '/' && firstInput.value.length == 2;

        if (isDigit || isSlash) {
          secondInput.value += input;
        }
      }
    }
  }

  void removeLastChar() {
    if (!isFirstInputActive.value && secondInput.value.isNotEmpty) {
      secondInput.value =
          secondInput.value.substring(0, secondInput.value.length - 1);
    } else if (!isFirstInputActive.value && secondInput.value.isEmpty) {
      isFirstInputActive.value = true;
      if (firstInput.value.isNotEmpty) {
        firstInput.value =
            firstInput.value.substring(0, firstInput.value.length - 1);
      }
    } else if (isFirstInputActive.value && firstInput.value.isNotEmpty) {
      firstInput.value =
          firstInput.value.substring(0, firstInput.value.length - 1);
    }
  }

  void callSubmitFunction() async {
    final input = firstInput.value;
    final valueStr = secondInput.value;

    if (input.isNotEmpty && valueStr.isNotEmpty) {
      final isTwoDigit = RegExp(r'^\d{2}$').hasMatch(input);
      final isReversible =
          input.length == 3 && input.endsWith('R') || input.endsWith('r');
      final isSlashReversible = input.length == 3 && input.endsWith('/');

      void addPreDigit(String key, int val) {
        preDigits.add(PreDigit(key: key, value: val));
      }

      if (input == 'အပူး' || input == 'P') {
        final list = [
          '00',
          '11',
          '22',
          '33',
          '44',
          '55',
          '66',
          '77',
          '88',
          '99'
        ];
        final value = int.tryParse(valueStr);
        if (value != null) {
          for (var digit in list) {
            addPreDigit(digit, value);
          }
        }
      } else if (input == 'စုံပူး' || input.toUpperCase() == 'SP') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          const targets = [
            '00',
            '22',
            '44',
            '66',
            '88',
          ];
          for (var key in targets) {
            addPreDigit(key, value);
          }
        }
      } else if (input == 'မပူး' || input.toUpperCase() == 'MP') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          const targets = [
            '11',
            '33',
            '55',
            '77',
            '99',
          ];
          for (var key in targets) {
            addPreDigit(key, value);
          }
        }
      } else if (isTwoDigit) {
        if (valueStr.contains('/')) {
          final parts = valueStr.split('/');
          if (parts.length == 2 &&
              RegExp(r'^\d+$').hasMatch(parts[0]) &&
              RegExp(r'^\d+$').hasMatch(parts[1])) {
            final v1 = int.parse(parts[0]);
            final v2 = int.parse(parts[1]);
            final reversed = input.split('').reversed.join();
            addPreDigit(input, v1);
            addPreDigit(reversed, v2);
          }
        } else {
          final value = int.tryParse(valueStr);
          if (value != null) addPreDigit(input, value);
        }
      } else if (isReversible) {
        final base = input.substring(0, 2);
        final reversed = base.split('').reversed.join();
        final value = int.tryParse(valueStr);
        if (value != null) {
          addPreDigit(base, value);
          addPreDigit(reversed, value);
        }
      } else if (isSlashReversible) {
        final base = input.substring(0, 2);
        final reversed = base.split('').reversed.join();
        final value = int.tryParse(valueStr);
        if (value != null) {
          addPreDigit(base, value);
          addPreDigit(reversed, value);
        }
      } else if (RegExp(r'^[0-9]\*(.*)?$').hasMatch(input) ||
          RegExp(r'^[0-9]ထိပ်$').hasMatch(input)) {
        final prefix = input[0];
        final value = int.tryParse(valueStr);
        if (value != null) {
          final list = List.generate(10, (i) => '$prefix$i');
          for (var digit in list) {
            addPreDigit(digit, value);
          }
        }
      } else if (RegExp(r'^\dအပါ$').hasMatch(input) ||
          RegExp(r'^\d[Pp]$').hasMatch(input)) {
        final center = input[0];
        final value = int.tryParse(valueStr);
        if (value != null) {
          for (int i = 0; i < 10; i++) {
            final a = '$center$i'.padLeft(2, '0');
            final b = '$i$center'.padLeft(2, '0');

            if (a == b) {
              addPreDigit(a, value);
            } else {
              addPreDigit(a, value);
              addPreDigit(b, value);
            }
          }
        }
      } else if (input == 'မပူး') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          const keys = ['11', '33', '55', '77', '99'];
          for (final key in keys) {
            addPreDigit(key, value);
          }
        }
      } else if (RegExp(r'^\dနောက်$').hasMatch(input) ||
          RegExp(r'^\*\d$').hasMatch(input)) {
        final digit =
            input.contains('နောက်') ? input[0] : input[1]; // get the digit
        final value = int.tryParse(valueStr);
        if (value != null) {
          final list = List.generate(10, (i) => '$i$digit');
          for (var item in list) {
            addPreDigit(item.padLeft(2, '0'), value);
          }
        }
      } // 1. Handle "ခွေပူး" or PP (check this FIRST)
      else if (input.endsWith('ခွေပူး') ||
          (input.toUpperCase().endsWith('PP') && input.length > 3)) {
        final raw = input.replaceAll(RegExp(r'(ခွေပူး|[Pp]{2})'), '');
        final digitsOnly = raw.replaceAll(RegExp(r'[^\d]'), '');
        final chars = digitsOnly.split('');
        final value = int.tryParse(valueStr);

        if (value != null) {
          final list = <String>{};
          for (int i = 0; i < chars.length; i++) {
            for (int j = 0; j < chars.length; j++) {
              list.add(chars[i] + chars[j]); // includes i==j for ပူး
            }
          }
          for (var item in list) {
            addPreDigit(item, value);
          }
        }
      }

// 2. Handle "ခွေ" or P (but not PP)
      else if ((input.endsWith('ခွေ')) ||
          ((input.toUpperCase().endsWith('P') &&
              !input.toUpperCase().endsWith('PP') &&
              input.length > 3))) {
        final raw = input.replaceAll(RegExp(r'(ခွေ|[Pp])'), '');
        final digitsOnly = raw.replaceAll(RegExp(r'[^\d]'), '');
        final chars = digitsOnly.split('');
        final value = int.tryParse(valueStr);

        if (value != null) {
          final list = <String>{};
          for (int i = 0; i < chars.length; i++) {
            for (int j = 0; j < chars.length; j++) {
              if (i != j) list.add(chars[i] + chars[j]);
            }
          }
          for (var item in list) {
            addPreDigit(item, value);
          }
        }
      } else if (input == 'နက္ခတ်' || input.toUpperCase() == 'K') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          const targets = [
            '07',
            '18',
            '24',
            '35',
            '42',
            '53',
            '69',
            '70',
            '81',
            '96'
          ];
          for (var key in targets) {
            addPreDigit(key, value);
          }
        }
      } else if (input == 'ညီကို' || input.toUpperCase() == 'NK') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          final list = <String>{};
          for (int i = 0; i < 10; i++) {
            if (i > 0) {
              list.add('$i${i - 1}');
              list.add('${i - 1}$i');
            }
            if (i < 9) {
              list.add('$i${i + 1}');
              list.add('${i + 1}$i');
            }
          }
          list.add('90');
          list.add('09');

          for (var item in list) {
            addPreDigit(item, value);
          }
        }
      } else if (RegExp(r'^\dဘရိတ်$').hasMatch(input) ||
          RegExp(r'^\d[Bb]$').hasMatch(input)) {
        final breakDigit = input[0]; // First digit
        final value = int.tryParse(valueStr);

        if (value != null) {
          final digitsList = generateBreak(breakDigit);
          for (var digit in digitsList) {
            addPreDigit(digit, value);
          }
        }
      } else if (input == 'စုံပူး') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          const targets = ['00', '22', '44', '66', '88'];
          for (final key in targets) {
            addPreDigit(key, value);
          }
          // ✅ 5
        }
      } else if (input == 'စုံစုံ') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          for (int i = 0; i < 10; i += 2) {
            for (int j = 0; j < 10; j += 2) {
              final key = '$i$j'.padLeft(2, '0');
              addPreDigit(key, value);
            }
          }
          // ✅ 25 total even-even combinations
        }
      } else if (input == 'မမ') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          for (int i = 1; i < 10; i += 2) {
            for (int j = 1; j < 10; j += 2) {
              final key = '$i$j';
              addPreDigit(key.padLeft(2, '0'), value);
            }
          }
          // ✅ 25 total odd-odd combinations
        }
      } else if (input == 'စုံမ') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          for (int i = 0; i < 10; i += 2) {
            for (int j = 1; j < 10; j += 2) {
              final key = '$i$j';
              addPreDigit(key.padLeft(2, '0'), value);
            }
          }
          // ✅ 25 total even-odd combinations
        }
      } else if (input == 'မစုံ') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          for (int i = 1; i < 10; i += 2) {
            for (int j = 0; j < 10; j += 2) {
              final key = '$i$j';
              addPreDigit(key.padLeft(2, '0'), value);
            }
          }
          // ✅ 25 total odd-even combinations
        }
      } else if (input == 'ပါဝါ' || input.toUpperCase() == 'W') {
        final value = int.tryParse(valueStr);
        if (value != null) {
          const powerList = [
            '05',
            '16',
            '27',
            '38',
            '49',
            '50',
            '61',
            '72',
            '83',
            '94'
          ];
          for (var digit in powerList) {
            addPreDigit(digit, value);
          }
        }
      } else {
        isFirstInputActive.value = true;
        firstInput.value = '';
        return;
      }

      firstInput.value = '';
      secondInput.value = '';
      isFirstInputActive.value = true;

      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
  }

  void normalPut() {
    final key = firstInput.value;
    final value = int.parse(secondInput.value);

    preDigits.add(PreDigit(key: key, value: value));

    firstInput.value = '';
    secondInput.value = '';
    isFirstInputActive.value = true;
  }

  int get totalAmount => preDigits.fold(0, (sum, item) => sum + item.value);

  void submitToFirebase(String groupLabel) async {
    isUploading.value = true;
    final total = totalAmount;
    final digitsList =
        preDigits.map((e) => {'key': e.key, 'value': e.value}).toList();

    final model = DigitsModel(
      id: '', // Firestore will assign
      group: groupLabel,
      timeStamps: DateTime.now(),
      totalSum: total,
      digits: digitsList,
    );
    // await preController.saveToDb();
    try {
      await digitsController.addDataDigits(model);
      fetchDigitsFromFirebase();
      digitsController.listenToGroups();

      isUploading.value = false;
    } catch (e) {
      isUploading.value = false;
    }

    // Reset after submit
    preDigits.clear();
    firstInput.value = '';
    secondInput.value = '';
    isFirstInputActive.value = true;
  }

  void fetchDigitsFromFirebase() {
    digitsController.getDigitsStream()?.listen((digitModels) {
      final Map<String, int> combined = {};

      // 🔁 Combine all digit entries across all documents
      for (var model in digitModels) {
        for (var item in model.digits) {
          final key = item['key'];
          final value = item['value'];
          if (key is String && value is int) {
            combined[key] = (combined[key] ?? 0) + value;
          }
        }
      }

      // 🧼 Clear old data before updating
      digits.updateAll((key, value) => 0);

      // ✅ Now set final combined values
      digits.addAll(combined);
    });
  }

  int get totalValue {
    return digits.values.where((v) => v > 0).fold(0, (sum, v) => sum + v);
  }

  int getOverTotal(int limitBreak) {
    return digits.values
        .where((v) => v > limitBreak)
        .fold(0, (sum, v) => sum + (v - limitBreak));
  }

  List<String> generateBreak(String data) {
    switch (data) {
      case '0':
        return ['00', '19', '28', '37', '46', '55', '64', '73', '82', '91'];
      case '1':
        return ['01', '10', '29', '38', '47', '56', '65', '74', '83', '92'];
      case '2':
        return ['02', '11', '20', '39', '48', '57', '66', '75', '84', '93'];
      case '3':
        return ['03', '12', '21', '30', '49', '58', '67', '76', '85', '94'];
      case '4':
        return ['04', '13', '22', '31', '40', '59', '68', '77', '86', '95'];
      case '5':
        return ['05', '14', '23', '32', '41', '50', '69', '78', '87', '96'];
      case '6':
        return ['06', '15', '24', '33', '42', '51', '60', '79', '88', '97'];
      case '7':
        return ['07', '16', '25', '34', '43', '52', '61', '70', '89', '98'];
      case '8':
        return ['08', '17', '26', '35', '44', '53', '62', '71', '80', '99'];
      case '9':
        return ['09', '18', '27', '36', '45', '54', '63', '72', '81', '90'];
      default:
        return [];
    }
  }

  void processInput(String input) {
    final lines = input.split('\n');
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      //

      if (RegExp(r'ပါ?ဝါ').hasMatch(line)) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        const targets = [
          '05',
          '16',
          '27',
          '38',
          '49',
          '50',
          '61',
          '72',
          '83',
          '94'
        ];
        for (var key in targets) {
          preDigits.add(PreDigit(key: key, value: value));
        }
        continue;
      }
      if (RegExp(r'^(\d+)[,.\s-](\d+)[Rr= -](\d+)$').hasMatch(line)) {
        final match =
            RegExp(r'^(\d+)[,.\s-](\d+)[Rr= -](\d+)$').firstMatch(line);
        if (match != null) {
          final first = match.group(1)!;
          final second = match.group(2)!;
          final rValue = int.tryParse(match.group(3)!) ?? 0;

          if (second.length > 2) {
            // Treat second as value for first digit
            final customValue = int.tryParse(second) ?? rValue;
            preDigits
                .add(PreDigit(key: first.padLeft(2, '0'), value: customValue));
            preDigits.add(PreDigit(
                key: first.split('').reversed.join().padLeft(2, '0'),
                value: rValue));
          } else {
            final keys = [
              first,
              first.split('').reversed.join(),
              second,
              second.split('').reversed.join()
            ];
            for (var key in keys.toSet()) {
              preDigits.add(PreDigit(key: key.padLeft(2, '0'), value: rValue));
            }
          }

          continue;
        }
      }
      // ✅ "နက္ခတ်" pattern: fixed predefined keys
      if (RegExp(r'န[တ်က်]?[ခက]တ်').hasMatch(line)) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        const targets = [
          '07',
          '18',
          '24',
          '35',
          '42',
          '53',
          '69',
          '70',
          '81',
          '96'
        ];
        for (var key in targets) {
          preDigits.add(PreDigit(key: key, value: value));
        }
        continue;
      }
      if (line.contains('မပူး')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        const targets = ['11', '33', '55', '77', '99'];
        for (var key in targets) {
          preDigits.add(PreDigit(key: key, value: value));
        }
        continue;
      }

      if (line.contains('စုံပူး')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        const targets = ['00', '22', '44', '66', '88'];
        for (var key in targets) {
          preDigits.add(PreDigit(key: key, value: value));
        }
        continue;
      }
      if (line.contains('စုံစုံ')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

        for (int i = 0; i < 10; i += 2) {
          for (int j = 0; j < 10; j += 2) {
            final key = '$i$j'.padLeft(2, '0');
            preDigits.add(PreDigit(key: key, value: value));
          }
        }
        continue;
      }
      if (line.contains('မမ')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

        for (int i = 1; i < 10; i += 2) {
          for (int j = 1; j < 10; j += 2) {
            final key = '$i$j'.padLeft(2, '0');
            preDigits.add(PreDigit(key: key, value: value));
          }
        }
        continue;
      } else if (line.contains('စုံမ')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

        for (int i = 0; i < 10; i += 2) {
          for (int j = 1; j < 10; j += 2) {
            final key = '$i$j'.padLeft(2, '0');
            preDigits.add(PreDigit(key: key, value: value));
          }
        }
        continue;
      } else if (line.contains('မစုံ')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

        for (int i = 1; i < 10; i += 2) {
          for (int j = 0; j < 10; j += 2) {
            final key = '$i$j'.padLeft(2, '0');
            preDigits.add(PreDigit(key: key, value: value));
          }
        }
        continue;
      }
      // ✅ Group Reversibles (e.g., 25,35 R 10000 or 25 35 r 10000)
      if (line.contains(RegExp(r'[Rr@/0-9]*[Rr@/][0-9]*'))) {
        final parts = line.split(RegExp(r'\s*[Rr@/]\s*'));
        if (parts.length == 2) {
          final digitGroup = parts[0].trim();
          final amount = int.tryParse(parts[1].trim()) ?? 0;

          // Split by commas, periods, spaces, equals, dashes
          final digits = digitGroup.split(RegExp(r'[,.\s=\-]+'));

          for (var raw in digits) {
            final d = raw.trim();
            if (RegExp(r'^\d{2}$').hasMatch(d)) {
              final reversed = d.split('').reversed.join();
              preDigits.add(PreDigit(key: d, value: amount));
              preDigits.add(PreDigit(key: reversed, value: amount));
            }
          }
          continue;
        }
      }

      // ✅ Patterns: 2P, 2အပါ, 2ပါ, 2ပတ်, 2အပတ်
      if (RegExp(r'^\d(အပါ|ပါ|P|ပတ်|အပတ်)[ =\-\.,]?\d+$').hasMatch(line)) {
        final match = RegExp(r'^(\d)(?:အပါ|ပါ|P|ပတ်|အပတ်)[ =\-\.,]?(\d+)$')
            .firstMatch(line);
        if (match != null) {
          final digit = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;

          for (int i = 0; i < 10; i++) {
            final a = '$digit$i'.padLeft(2, '0');
            final b = '$i$digit'.padLeft(2, '0');

            if (a == b) {
              preDigits.add(PreDigit(key: a, value: value));
            } else {
              preDigits.add(PreDigit(key: a, value: value));
              preDigits.add(PreDigit(key: b, value: value));
            }
          }
          continue;
        }
      }
      // 1,2,3 အပါ
      if (RegExp(r'^([\d,.\-= ]+)(အပါ|ပါ|P|ပတ်|အပတ်)[ =\-.,]?\d+$')
          .hasMatch(line)) {
        final match =
            RegExp(r'^([\d,.\-= ]+)(?:အပါ|ပါ|P|ပတ်|အပတ်)[ =\-.,]?(\d+)$')
                .firstMatch(line);
        if (match != null) {
          final rawDigits = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;

          final digits = rawDigits
              .split(RegExp(r"[,\.\-= ]+"))
              .where((e) => e.isNotEmpty)
              .toList();

          for (var digit in digits) {
            for (int i = 0; i < 10; i++) {
              final a = '$digit$i'.padLeft(2, '0');
              final b = '$i$digit'.padLeft(2, '0');

              if (a == b) {
                preDigits.add(PreDigit(key: a, value: value));
              } else {
                preDigits.add(PreDigit(key: a, value: value));
                preDigits.add(PreDigit(key: b, value: value));
              }
            }
          }
        }
      }
      // 1 ထိပ် နောက်
      final regex =
          RegExp(r'(\d)\s*ထိပ်[ =\-\.,]?(\d+)|(\d)\s*နောက်[ =\-\.,]?(\d+)');
      final matches = regex.allMatches(line);

      for (final match in matches) {
        if (match.group(1) != null && match.group(2) != null) {
          // Handle "ထိပ်"
          final digit = match.group(1)!;
          final value = int.parse(match.group(2)!);
          for (var i = 0; i < 10; i++) {
            preDigits.add(PreDigit(key: '$digit$i', value: value));
          }
        }
        if (match.group(3) != null && match.group(4) != null) {
          // Handle "နောက်"
          final digit = match.group(3)!;
          final value = int.parse(match.group(4)!);
          for (var i = 0; i < 10; i++) {
            preDigits.add(PreDigit(key: '$i$digit', value: value));
          }
        }
      }

      // ✅ "ထိပ်" pattern: 5ထိပ် or 5 ထိပ် = 50-59
      if (RegExp(r'^\d\s?ထိပ်[ =\-\.,]?\d+$').hasMatch(line)) {
        final match = RegExp(r'^(\d)\s?ထိပ်[ =\-\.,]?(\d+)$').firstMatch(line);
        if (match != null) {
          final digit = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;
          final list = List.generate(10, (i) => '$digit$i');
          for (var d in list) {
            preDigits.add(PreDigit(key: d, value: value));
          }
          continue;
        }
      }
      // 1,2,3 ထိပ်
      if (RegExp(r'^([\d,.\-= ]+)\s?ထိပ်[ =\-.,]?\d+$').hasMatch(line)) {
        final match =
            RegExp(r'^([\d,.\-= ]+)\s?ထိပ်[ =\-.,]?(\d+)$').firstMatch(line);
        if (match != null) {
          final rawDigits = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;

          final digits = rawDigits
              .split(RegExp(r"[,\.\-= ]+"))
              .where((e) => e.isNotEmpty)
              .toList();

          for (var digit in digits) {
            final list = List.generate(10, (i) => '$digit$i');
            for (var d in list) {
              preDigits.add(PreDigit(key: d, value: value));
            }
          }
        }
      }

      // ✅ "နောက်" pattern: 5နောက် or 5 နောက် = 05,15,...95
      if (RegExp(r'^\d\s?နောက်[ =\-\.,]?\d+$').hasMatch(line)) {
        final match = RegExp(r'^(\d)\s?နောက်[ =\-\.,]?(\d+)$').firstMatch(line);
        if (match != null) {
          final digit = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;
          final list = List.generate(10, (i) => '$i$digit');
          for (var d in list) {
            preDigits.add(PreDigit(key: d, value: value));
          }
          continue;
        }
      }

      // ✅ "ညီကို" pattern
      if (line.contains('ညီကို')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        final list = <String>{};
        for (int i = 0; i < 10; i++) {
          if (i > 0) {
            list.add('$i${i - 1}');
            list.add('${i - 1}$i');
          }
          if (i < 9) {
            list.add('$i${i + 1}');
            list.add('${i + 1}$i');
          }
        }
        list.add('90');
        list.add('09');
        for (var d in list) {
          preDigits.add(PreDigit(key: d, value: value));
        }
        continue;
      }
      if (line.contains('ပါဝါ')) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        const targets = [
          '05',
          '16',
          '27',
          '38',
          '49',
          '50',
          '61',
          '72',
          '83',
          '94'
        ];
        for (var key in targets) {
          preDigits.add(PreDigit(key: key, value: value));
        }
        continue;
      }

      // ✅ "အပူး" or "အပူ" pattern: all double numbers
      if (RegExp(r'(အ)?ပ[ူးုး]|p', caseSensitive: false).hasMatch(line)) {
        final value = int.tryParse(line.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
        final list = [
          '00',
          '11',
          '22',
          '33',
          '44',
          '55',
          '66',
          '77',
          '88',
          '99'
        ];
        for (var digit in list) {
          preDigits.add(PreDigit(key: digit, value: value));
        }
        continue;
      }

      // ✅ "ဘရိတ်", "ဘရိတ", "B", "Bk", "BK" pattern: e.g. 2ဘရိတ် = [break list]
      if (RegExp(r'^\d(ဘရိတ်|ဘရိတ|B|BK)[ =\-\.,]?\d+$', caseSensitive: false)
          .hasMatch(line)) {
        final match = RegExp(r'^(\d)(?:ဘရိတ်|ဘရိတ|B|BK)[ =\-\.,]?(\d+)$',
                caseSensitive: false)
            .firstMatch(line);
        if (match != null) {
          final digit = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;
          final digitsList = generateBreak(digit);
          for (var d in digitsList) {
            preDigits.add(PreDigit(key: d, value: value));
          }
          continue;
        }
      }

      // ✅ "ခွေ" pattern: includes only non-repeating combinations (e.g. 12, 21, 13, 31, etc.)
      if (RegExp(r'^(\d{2,})ခွေ[ =\-\.,]?\d+$').hasMatch(line)) {
        final match = RegExp(r'^(\d{2,})ခွေ[ =\-\.,]?(\d+)$').firstMatch(line);
        if (match != null) {
          final raw = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;

          final chars = raw.split('');
          final seen = <String>{};

          for (int i = 0; i < chars.length; i++) {
            for (int j = 0; j < chars.length; j++) {
              if (i != j) {
                final combo = chars[i] + chars[j];
                if (seen.add(combo)) {
                  preDigits.add(PreDigit(key: combo, value: value));
                }
              }
            }
          }
          continue;
        }
      }

      // ✅ "ခွေပူး" pattern: includes ALL combinations (e.g. 11, 12, 21, 22, etc.)
      if (RegExp(r'^(\d{2,})ခွေပူး[ =\-\.,]?\d+$').hasMatch(line)) {
        final match =
            RegExp(r'^(\d{2,})ခွေပူး[ =\-\.,]?(\d+)$').firstMatch(line);
        if (match != null) {
          final raw = match.group(1)!;
          final value = int.tryParse(match.group(2)!) ?? 0;

          final chars = raw.split('');
          for (int i = 0; i < chars.length; i++) {
            for (int j = 0; j < chars.length; j++) {
              final combo = chars[i] + chars[j];
              preDigits.add(PreDigit(key: combo, value: value));
            }
          }
          continue;
        }
      }

      // ✅ Normal single entry: 25 = 5000
      if (line.contains(RegExp(r'[=,\-\s\.\/]'))) {
        final parts = line.split(RegExp(r'[=,\-\s\.\/]+'));
        if (parts.length >= 2) {
          final value = int.tryParse(parts.last.trim()) ?? 0;

          for (int i = 0; i < parts.length - 1; i++) {
            final digit = parts[i].trim();
            if (digit.length == 2 && RegExp(r'^\d{2}$').hasMatch(digit)) {
              preDigits.add(PreDigit(key: digit, value: value));
            }
          }
        }
      }
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
}
