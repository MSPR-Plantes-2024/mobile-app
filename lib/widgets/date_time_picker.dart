import 'package:flutter/material.dart';

class DateTimePicker {
  DateTimePicker(BuildContext context);
  static Future<DateTime?> getDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now().hour + 1 < 21 &&
          TimeOfDay.now().hour + 1 > 8
          ? TimeOfDay.now()
          .replacing(hour: TimeOfDay.now().hour + 1)
          : TimeOfDay(hour: 8, minute: 0),
    );
    if (pickedDate != null && pickedTime != null) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    } else {
      return null; // return current DateTime as default
    }
  }
}
