// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/firebase/digits_services.dart';
import 'package:two_d_project/firebase/ledger_services.dart';
import 'package:two_d_project/model/ledger_model.dart';

class LedgerController extends GetxController {
  final LedgerService _service = Get.put(LedgerService());
  final DigitsService digitsService = DigitsService();

  RxList<LedgerModel> ledgers = <LedgerModel>[].obs;
  RxBool isLoading = false.obs;
  RxString searchTextForLedger = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLedgers();

    debounce(searchTextForLedger, (_) => fetchLedgers(),
        time: const Duration(milliseconds: 300));
  }

  void fetchLedgers() {
    isLoading.value = true;
    _service.getAllLedgers(searchText: searchTextForLedger.value).listen(
      (data) async {
        ledgers.value = data;
        isLoading.value = false;
        await deleteOldLedgersIfNeeded();
      },
      onError: (e) {
        isLoading.value = false;
      },
    );
  }

  Future<void> deleteOldLedgersIfNeeded() async {
    if (ledgers.length > 200) {
      final sortedLedgers = List<LedgerModel>.from(ledgers)
        ..sort((a, b) => a.timeStamps.compareTo(b.timeStamps));

      final ledgersToDelete = sortedLedgers.take(10).toList();

      for (final ledger in ledgersToDelete) {
        await deleteLedgerInternal(ledger.id!);
      }

      fetchLedgers();
    }
  }

  Future<void> addLedger(
      String docName, LedgerModel model, BuildContext context) async {
    Helper.showloading(context);
    String result = await _service.addLedger(docName, model);
    Get.back(); // close loading
    if (result == 'success') {
      Get.back(); // close form
      Get.snackbar(
        "အောင်မြင်သည်",
        "လည်ဂျာအသစ်ဖွင့်ခြင်းအောင်မြင်သည်",
        backgroundColor: Colors.green.shade500,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "ပြန်လည်စစ်ဆေးပါ",
        "တစ်ခုခုမှားယွင်းနေပါသည်",
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String> deleteLedger(String docName, BuildContext context) async {
    Helper.showloading(context);
    try {
      await deleteDigitsForLedger(docName);
      final result = await _service.deleteLedger(docName);
      Get.back(); // close loading
      if (result == 'success') {
        Get.back(); // close dialog
        Get.snackbar(
          "ဖျက်ခြင်း",
          "လည်ဂျာဖျက်ခြင်းအောင်မြင်သည်",
          backgroundColor: Colors.green.shade500,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return 'success';
      } else {
        Get.snackbar(
          "ပြန်လည်စစ်ဆေးပါ",
          "တစ်ခုခုမှားယွင်းနေပါသည်",
          backgroundColor: Colors.red.shade500,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return 'error';
      }
    } catch (e) {
      Get.back(); // close loading
      Get.snackbar(
        "အမှား",
        "ဖျက်ခြင်းအတွင်းအမှားတစ်ခုဖြစ်ပွားသည်",
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return 'error';
    }
  }

  Future<void> deleteLedgerInternal(String docName) async {
    await deleteDigitsForLedger(docName);
    await _service.deleteLedger(docName);
  }

  Future<void> deleteDigitsForLedger(String ledgerId) async {
    final digitsRef = digitsService.getDigitsRef(ledgerId);
    final digitsSnapshot = await digitsRef.get();
    for (final doc in digitsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<String> updateLedger(
      String docName, LedgerModel ledger, BuildContext context,
      {bool poukTee = false}) async {
    Helper.showloading(context);
    String result = await _service.updateLedger(docName, ledger);
    Get.back(); // close loading

    if (result == 'success') {
      Get.snackbar(
        poukTee ? "ပေါက်သီး" : "ပြင်ဆင်ခြင်း",
        poukTee
            ? "ပေါက်သီးထည့်ခြင်းအောင်မြင်သည်"
            : "လည်ဂျာပြင်ဆင်ခြင်းအောင်မြင်သည်",
        backgroundColor: Colors.green.shade500,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "ပြန်လည်စစ်ဆေးပါ",
        "တစ်ခုခုမှားယွင်းနေပါသည်",
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    return result;
  }

  void clearAll() {
    ledgers.clear();
  }
}
