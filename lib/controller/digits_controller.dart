import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_d_project/constant/helper.dart';
import 'package:two_d_project/firebase/digits_services.dart';
import 'package:two_d_project/firebase/ledger_services.dart';
import 'package:two_d_project/model/digits_model.dart';
import 'package:two_d_project/model/ledger_model.dart';

class DigitsController extends GetxController {
  final DigitsService _service = DigitsService();
  RxList<DigitsModel> vouncherDigit = <DigitsModel>[].obs;
  RxBool isLoading = false.obs;
  Rxn<LedgerModel> selectedLedger = Rxn<LedgerModel>();
  var openDate = Rxn<DateTime>();
  final player = AudioPlayer();
  final LedgerService ledgerService = Get.put(LedgerService());
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  Rxn<DigitsModel?> editDigitMoel = Rxn<DigitsModel>();
  var entry = {}.obs;
  RxInt editTotalSum = 0.obs;
  RxString selectedAgent = ''.obs;
  RxString copy = ''.obs;

  @override
  void onInit() {
    super.onInit();

    getSelectedLedger();
  }

  void getSelectedLedger() {
    if (selectedLedger.value != null) {
      ledgerService
          .getLedgerById(selectedLedger.value!.id.toString())
          .listen((ledger) {
        selectedLedger.value = ledger;
      });
    }
  }

  void listenToGroups() {
    if (selectedLedger.value != null) {
      isLoading.value = true;

      _service
          .getDigitsFromLedger(
        selectedLedger.value!.id.toString(),
      )
          .listen((data) {
        vouncherDigit.value = data;
        isLoading.value = false;
      });
    }
  }

  Future<void> addDataDigits(DigitsModel data) async {
    copy.value = '';
    if (selectedLedger.value != null) {
      final result =
          await _service.addDigitsToLedger(selectedLedger.value!.id!, data);

      if (result == 'success') {
        await player.play(AssetSource('sounds/success.mp3'));
      } else {}
    }
  }

  Stream<List<DigitsModel>>? getDigitsStream() {
    if (selectedLedger.value != null) {
      return _service.getDigitsFromLedger(selectedLedger.value!.id!);
    } else {
      return null;
    }
  }

  Future<void> updateDigit(
      String documentId, DigitsModel digit, BuildContext context) async {
    String getBack = await _service.updateDigit(
        selectedLedger.value!.id.toString(), documentId, digit);
    if (getBack == 'success') {
      Get.back();
      Get.snackbar(
        "အောင်မြင်သည်",
        "ဘောင်ချာပြင်ဆင်ခြင်းအောင်မြင်သည်",
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

  Future<void> deleteDigit(String id, BuildContext context) async {
    Helper.showloading(context);
    if (selectedLedger.value != null) {
      String getBack =
          await _service.deleteDigit(selectedLedger.value!.id.toString(), id);
      if (getBack == 'success') {
        Get.back();
        Get.snackbar(
          "အောင်မြင်သည်",
          "ဘောင်ချာဖျက်ခြင်းအောင်မြင်သည်",
          backgroundColor: Colors.red,
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
  }
}
