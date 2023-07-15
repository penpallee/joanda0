import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected? onDaySelected;
  final DateTime selectedDate;
  final DateTime focusedDay;
  const MainCalendar(
      {required this.onDaySelected,
      required this.selectedDate,
      required this.focusedDay,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      firstDay: DateTime.utc(1988, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      focusedDay: focusedDay,
      headerVisible: true,
    );
  }
}
