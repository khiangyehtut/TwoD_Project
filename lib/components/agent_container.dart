import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:two_d_project/constant/constant.dart';

// ignore: must_be_immutable
class AgentContainer extends StatelessWidget {
  String? name,
      total,
      percent,
      poukTeeAmount,
      poukTeeNo,
      earnMoney,
      finalTotal,
      date;
  AgentContainer(
      {this.name,
      this.total,
      this.percent,
      this.poukTeeAmount,
      this.poukTeeNo,
      this.earnMoney,
      this.finalTotal,
      this.date,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Constant.secColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            name ?? '',
            style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ရောင်းရငွေ'),
              Text(total ?? '0'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ကော်'),
              Text(percent ?? '0'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ကော်နုတ်ပြီး'),
              Text((int.parse(total ?? '0') - int.parse(percent ?? '0'))
                  .toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'ပေါက်သီး ${(poukTeeAmount != null) ? '($poukTeeAmount)' : ''}'),
              Text(
                earnMoney ?? '0',
                style: TextStyle(
                    color:
                        (int.parse(earnMoney ?? '0') > 0) ? Colors.red : null),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (poukTeeNo != null) {
                            await FlutterClipboard.copy(
                                '$date\nY = $total\n P(${poukTeeNo ?? ''}) = ${(poukTeeAmount != '0') ? poukTeeAmount : 'No'} ');
                            Fluttertoast.showToast(
                              msg: "Copy C1",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: const Icon(
                          Icons.copy,
                          color: Colors.black54,
                        ),
                      ),
                      const Text(
                        'C1',
                        style: TextStyle(color: Colors.black54, fontSize: 10),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (poukTeeNo != null) {
                            await FlutterClipboard.copy(
                                '$date\nရောင်းရငွေ = $total\nကော် = $percent\nကော်နုတ်ပြီး = ${int.parse(total ?? '0') - int.parse(percent ?? '0')}\nပေါက်သီး($poukTeeAmount) = $earnMoney\n------------------------------\n${(finalTotal!.contains('-') ? '             (-) ${finalTotal!.replaceAll('-', '')}' : '             (+) $finalTotal')}');
                            Fluttertoast.showToast(
                              msg: "Copy C2",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: const Icon(
                          Icons.copy,
                          color: Colors.black54,
                        ),
                      ),
                      const Text(
                        'C2',
                        style: TextStyle(color: Colors.black54, fontSize: 10),
                      )
                    ],
                  )
                ],
              )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: (finalTotal?.startsWith('-') ?? false)
                              ? Colors.red
                              : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(50)),
                      width: 20,
                      height: 20,
                      child: Icon(
                        (finalTotal?.startsWith('-') ?? false)
                            ? Icons.remove
                            : Icons.add,
                        size: 20,
                        color: Colors.white,
                      )),
                  Text(
                    finalTotal?.replaceAll('-', '') ?? '0',
                    style: TextStyle(
                        color: finalTotal?.contains('-') ?? false
                            ? Colors.red
                            : Colors.black),
                  )
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
