import 'package:flutter/material.dart';
import 'package:two_d_project/constant/constant.dart';

// ignore: must_be_immutable
class CustomListtile extends StatelessWidget {
  String? name;
  String? address;
  int? percent;
  CustomListtile({this.name, this.address, this.percent, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Constant.secColor, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(
            name ?? '',
            style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(address ?? ''),
          trailing: Text('$percent %'),
        ));
  }
}
