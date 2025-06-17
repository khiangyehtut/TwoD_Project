import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LedgerContainer extends StatelessWidget {
  String? ledgerDate;
  String? poukTeeNo;
  String? breakAmount;
  String? za;
  Color? boxColor;
  Color? containColor;
  Color? textColor;
  TextStyle? labelStyle;
  Color? boxTextColor;
  void Function()? onTap;
  LedgerContainer(
      {this.ledgerDate,
      this.labelStyle,
      this.poukTeeNo,
      this.boxTextColor,
      this.boxColor,
      this.textColor,
      this.breakAmount,
      this.za,
      this.containColor,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
          color: containColor ?? Colors.deepPurple,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ledgerDate ?? 'Ledger မရွေးရသေးပါ',
                          style: labelStyle),
                      Text(
                        'Break - ${breakAmount ?? 0}',
                        style: TextStyle(
                            color: textColor ?? Colors.white, fontSize: 15),
                      ),
                      Text(
                        'Za - ${za ?? 0}',
                        style: TextStyle(
                            color: textColor ?? Colors.white, fontSize: 15),
                      ),
                    ],
                  )),
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 70,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(1, 2),
                            color: Colors.black54,
                            blurRadius: 2)
                      ],
                      color: boxColor ?? Colors.amber,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    poukTeeNo ?? '',
                    style: TextStyle(
                        fontFamily: 'Boldon',
                        fontSize: 22,
                        color: boxTextColor ?? Colors.black87,
                        shadows: const [
                          Shadow(
                              offset: Offset(1, 2),
                              color: Colors.black54,
                              blurRadius: 2)
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
