import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_d_project/components/custom_textfield.dart';
import 'package:two_d_project/components/header_container.dart';
import 'package:two_d_project/components/myelevated.dart';
import 'package:two_d_project/constant/constant.dart';

// ignore: must_be_immutable
class LedgerForm extends StatelessWidget {
  void Function()? okTap;
  TextEditingController? controller1;
  TextEditingController? controller2;
  TextEditingController? controller3;
  LedgerForm(
      {super.key,
      this.controller1,
      this.controller2,
      this.controller3,
      this.okTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          width: (Constant.phoneWidth(context) > 500) ? 400 : null,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeaderContainer(
                color: Colors.deepPurple,
                title: 'စရင်းဖွင့်ခြင်း',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfield(
                labelColor: const Color(0xff434e64),
                frameColor: const Color(0xff434e64),
                controller: controller1,
                label: 'Ledger အမည်',
                hintText: 'Ledger အမည်ထည့်ပါ',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfield(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                labelColor: const Color(0xff434e64),
                frameColor: const Color(0xff434e64),
                controller: controller2,
                label: 'Break',
                hintText: 'Break ပမာဏထည့်ပါ',
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfield(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                labelColor: const Color(0xff434e64),
                frameColor: const Color(0xff434e64),
                controller: controller3,
                label: 'Za',
                hintText: 'ဇ ပမာဏထည့်ပါ',
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Myelevated(
                      borderColor: Colors.deepPurple,
                      labelColor: Colors.deepPurple,
                      onTap: () => Navigator.pop(context),
                      letterSpacing: 0,
                      btnColor: Colors.transparent,
                      label: 'Cancel',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Myelevated(
                        btnColor: Colors.deepPurple,
                        borderColor: Colors.deepPurple,
                        label: 'Confirm',
                        letterSpacing: 0,
                        onTap: okTap),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
