import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:two_d_project/controller/agent_controller.dart';
import 'package:two_d_project/controller/twod_controller.dart';

class ExternalKeyboardController extends GetxController {
  var keyboardIsConnected = false.obs;

  void handleRawKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final twod = Get.find<TwodController>();
      final agent = Get.find<AgentController>();
      final char = event.character;

      // ✅ Set as connected on first key press
      if (!keyboardIsConnected.value) {
        keyboardIsConnected.value = true;
        print('✅ Detected physical keyboard by key press');
      }

      // F4 key = Submit
      if (event.logicalKey == LogicalKeyboardKey.f4) {
        twod.submitToFirebase(agent.selectedValue.value);
        return;
      }

      // Delete/Backspace
      if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
        if (twod.isFirstInputActive.value && twod.firstInput.value.isNotEmpty) {
          twod.firstInput.value = twod.firstInput.value
              .substring(0, twod.firstInput.value.length - 1);
        } else if (!twod.isFirstInputActive.value &&
            twod.secondInput.value.isNotEmpty) {
          twod.secondInput.value = twod.secondInput.value
              .substring(0, twod.secondInput.value.length - 1);
        }
        return;
      }

      // Enter
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        twod.addInput('Enter');
        return;
      }

      // Skip if character is null/empty/space
      if (char == null || char.trim().isEmpty) return;

      // First input
      if (twod.isFirstInputActive.value) {
        if (twod.secondInput.value.isNotEmpty) {
          twod.secondInput.value = '';
        }
        twod.firstInput.value += char.toUpperCase();
      } else {
        if (RegExp(r'^[0-9]$').hasMatch(char) ||
            char == '/' ||
            char.toUpperCase() == 'R') {
          twod.secondInput.value += char.toUpperCase();
        }
      }
    }
  }

  Future<bool> isKeyboardConnected() async {
    const platform = MethodChannel('keyboard.check/channel');
    try {
      final bool isConnected =
          await platform.invokeMethod('isPhysicalKeyboardConnected');
      return isConnected;
    } on PlatformException catch (e) {
      print('⚠️ Platform error: ${e.message}');
      return false;
    }
  }

  void checkKeyboardStatus() async {
    bool connected = await isKeyboardConnected();
    print('🔌 Keyboard Connected: $connected');
    Future.delayed(const Duration(seconds: 3), () {
      print(connected);
    });
  }
}
