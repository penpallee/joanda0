import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:joanda0/model/schedule_model.dart';
import 'package:joanda0/screen/home_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatefulWidget {
  final OnDaySelected? onDaySelected;
  final DateTime selectedDate;
  final DateTime focusedDay;
  const MainCalendar(
      {required this.onDaySelected,
      required this.selectedDate,
      required this.focusedDay,
      super.key});

  @override
  State<MainCalendar> createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  @override
  void initState() {
    super.initState();
    _loadEventsFromFirebase();
  }

  Map<DateTime, List<ScheduleModel>> _events = {};

  Future<void> _loadEventsFromFirebase() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('schedule')
        .orderBy('date')
        .get();

    final events = querySnapshot.docs
        .map((doc) => ScheduleModel.fromJson(json: doc.data()))
        .toList();

    // _events = _groupEventsByDate(events);

    setState(() {
      _events = _groupEventsByDate(events);
    });
  }

  Map<DateTime, List<ScheduleModel>> _groupEventsByDate(
      List<ScheduleModel> events) {
    Map<DateTime, List<ScheduleModel>> groupedEvents = {};
    for (var event in events) {
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (groupedEvents[date] == null) {
        groupedEvents[date] = [event];
      } else {
        groupedEvents[date]!.add(event);
      }
    }
    return groupedEvents;
  }

  List<ScheduleModel> _getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: TableCalendar(
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          weekendStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        eventLoader: _getEventsForDay,
        calendarBuilders: CalendarBuilders(
          singleMarkerBuilder: (context, date, event) {
            return const Positioned(
              right: 1,
              bottom: 1,
              child: Center(
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.blue,
                ),
              ),
            );
          },
        ),
        calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer),
            weekendTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimary.withRed(200)),
            // holidayTextStyle: TextStyle(color: Colors.white),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
              shape: BoxShape.circle,
            )),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        calendarFormat: CalendarFormat.month,
        locale: 'ko_KR',
        onDaySelected: widget.onDaySelected,
        selectedDayPredicate: (date) =>
            date.year == widget.selectedDate.year &&
            date.month == widget.selectedDate.month &&
            date.day == widget.selectedDate.day,
        firstDay: DateTime.utc(1988, 1, 1),
        lastDay: DateTime.utc(2050, 12, 31),
        focusedDay: widget.focusedDay,
        headerVisible: true,
      ),
    );
  }
}
