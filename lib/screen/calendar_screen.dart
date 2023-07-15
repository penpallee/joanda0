import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:joanda0/component/main_calendar.dart';
import 'package:joanda0/component/schedule_bottom_sheet.dart';
import 'package:joanda0/component/schedule_card.dart';
import 'package:joanda0/component/selected_schedule_list.dart';
import 'package:joanda0/component/today_banner.dart';
import 'package:joanda0/const/colors.dart';
import 'package:joanda0/database/drift_database.dart';
import 'package:joanda0/screen/home_screen.dart';
import 'package:joanda0/screen/list_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static List<ScheduleCard> scheduleList = [
    ScheduleCard(month: 6, day: 22, startTime: 0, endTime: 1, content: 'test')
  ];
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  List<ScheduleCard>? selectedScheduleList = [];
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // scheduleList = [];
  }

  void addSchedule(ScheduleCard? scheduleCard) {
    setState(() {
      CalendarScreen.scheduleList.add(scheduleCard!);
      CalendarScreen.scheduleList.sort();
    });
  }

  void onSavedPressedbtn() async {
    GlobalKey<FormState> gFormkey = ScheduleBottomSheet.formKey;
    if (gFormkey.currentState!.validate()) {
      gFormkey.currentState!.save();

      await GetIt.I<LocalDatabase>().createSchedule(SchedulesCompanion(
          startTime: drift.Value(int.parse(startTimeController.text)),
          endTime: drift.Value(int.parse(endTimeController.text)),
          content: drift.Value(contentController.text),
          date: drift.Value(selectedDate)));
    }

    addSchedule(ScheduleCard(
        month: selectedDate.month,
        day: selectedDate.day,
        startTime: int.parse(startTimeController.text),
        endTime: int.parse(endTimeController.text),
        content: '${contentController.text}'));
    startTimeController.clear();
    endTimeController.clear();
    contentController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              isDismissible: true,
              builder: (_) => ScheduleBottomSheet(
                  startTimeController: startTimeController,
                  endTimeController: endTimeController,
                  contentController: contentController,
                  onSavedPressedbtn: onSavedPressedbtn));
        },
        child: Icon(Icons.add),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: SafeArea(
          child: Column(
        children: [
          MainCalendar(
            selectedDate: selectedDate,
            onDaySelected: OnDaySelected,
            focusedDay: focusedDay,
          ),
          SizedBox(height: 16),
          TodayBanner(
            selectedDate: selectedDate,
            count: selectedScheduleList!.length,
          ),
          SizedBox(height: 16),
          SelectedScheduleList(scheduleList: selectedScheduleList),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.pinkAccent,
        onTap: (value) {
          switch (value) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarScreen(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListScreen(),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home', tooltip: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
              tooltip: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'List', tooltip: 'List'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.settings),
          //     label: 'Settings',
          //     tooltip: 'Settings')
        ],
      ),
    );
  }

  void OnDaySelected(DateTime selectedDate, DateTime focusedDay) {
    setState(() {
      this.selectedDate = selectedDate;
      this.focusedDay = focusedDay;
      selectedScheduleList = [];

      for (var element in CalendarScreen.scheduleList) {
        if (element.month == selectedDate.month &&
            element.day == selectedDate.day) {
          selectedScheduleList?.add(element);
        }
      }
    });
  }
}
