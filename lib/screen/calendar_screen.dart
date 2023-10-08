import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:joanda0/component/main_calendar.dart';
import 'package:joanda0/component/provider.dart';
import 'package:joanda0/component/schedule_bottom_sheet.dart';
import 'package:joanda0/component/schedule_card.dart';
import 'package:joanda0/component/today_banner.dart';
import 'package:joanda0/model/schedule_model.dart';
import 'package:joanda0/screen/home_screen.dart';
import 'package:joanda0/screen/invitation_screen.dart';
import 'package:joanda0/screen/list_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController contentController = TextEditingController();

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
  }

  void onSavedPressedbtn() async {
    GlobalKey<FormState> gFormkey = ScheduleBottomSheet.formKey;
    if (gFormkey.currentState!.validate()) {
      gFormkey.currentState!.save();
    }
    final Schedule = ScheduleModel(
      id: const Uuid().v4(),
      content: contentController.text,
      date: selectedDate,
    );

    Navigator.pop(context);

    await FirebaseFirestore.instance
        .collection(
          'groups',
        )
        .doc(Provider.of<GroupIdProvider>(context, listen: false).groupId)
        .collection('schedules')
        .doc(Schedule.id)
        .set(Schedule.toJson());

    contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.onSecondary,
        //   title: const Text('Calendar'),
        //   centerTitle: true,
        // ),
        // backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          child: const Icon(Icons.add),
        ),
        // backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        body: SafeArea(
            child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
              focusedDay: focusedDay,
            ),
            Container(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                child: SizedBox(
                  height: 16,
                  child: Container(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                )),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                      'groups',
                    )
                    .doc(Provider.of<GroupIdProvider>(context, listen: false)
                        .groupId)
                    .collection('schedules')
                    .where('date',
                        isEqualTo:
                            '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}')
                    .snapshots(),
                builder: (context, snapshot) {
                  return TodayBanner(
                    selectedDate: selectedDate,
                    count: snapshot.data?.docs.length ?? 0,
                  );
                }),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            )),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(
                    'groups',
                  )
                  .doc(Provider.of<GroupIdProvider>(context, listen: false)
                      .groupId)
                  .collection('schedules')
                  .where('date',
                      isEqualTo:
                          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    // decoration:
                    //     BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  );
                }
                final schedules = snapshot.data!.docs
                    .map(
                      (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                          json: (e.data() as Map<String, dynamic>)),
                    )
                    .toList();
                if (snapshot.hasData) {
                  return Container(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: ListView.builder(
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          return Dismissible(
                            key: ObjectKey(schedule.id),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (DismissDirection direction) {
                              FirebaseFirestore.instance
                                  .collection(
                                    'groups',
                                  )
                                  .doc(Provider.of<GroupIdProvider>(context,
                                          listen: false)
                                      .groupId)
                                  .collection('schedules')
                                  .doc(schedule.id)
                                  .delete();
                            },
                            confirmDismiss: (direction) async {
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('확인'),
                                  content: const Text('정말로 이 항목을 제거하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('확인'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 8.0, right: 8.0),
                                child: ScheduleCard(
                                  isEventList: false,
                                  year: schedule.date.year,
                                  month: schedule.date.month,
                                  day: schedule.date.day,
                                  content: schedule.content,
                                )),
                          );
                        }),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(semanticsLabel: 'Loading'),
                  );
                }
              },
            ))
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          onTap: (value) {
            switch (value) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvitationScreen(),
                  ),
                );
                // _sendInvitation();
// invitation code
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListScreen(),
                  ),
                );
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.emoji_people_rounded,
                color: Colors.pinkAccent,
              ),
              label: 'Heart',
              tooltip: 'Heart',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.group_add),
                label: 'Invitation',
                tooltip: 'Invitation'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category_rounded,
                color: Colors.pinkAccent,
              ),
              label: 'List',
              tooltip: 'List',
            ),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.settings),
            //     label: 'Settings',
            //     tooltip: 'Settings')
          ],
          selectedItemColor: Colors.pinkAccent,
          unselectedItemColor: Colors.pinkAccent,
        ));
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDay) {
    setState(() {
      this.selectedDate = selectedDate;
      this.focusedDay = focusedDay;
    });
  }
}
