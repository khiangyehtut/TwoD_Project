import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constant {
  static Color secColor = const Color.fromARGB(255, 230, 221, 248);

  static double phoneWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double phoneHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static String formateDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static Future<DateTime?> pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  static String formatTime12Hour(BuildContext context, TimeOfDay time) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      time,
      alwaysUse24HourFormat: false, // forces 12-hour with AM/PM
    );
  }
}
