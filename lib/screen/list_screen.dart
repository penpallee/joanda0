import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:joanda0/component/provider.dart';
import 'package:joanda0/component/schedule_card.dart';
import 'package:joanda0/model/schedule_model.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          appBar: AppBar(
            title: const Text(
              'Event List',
              textAlign: TextAlign.center,
            ),
            bottom: const TabBar(
              // controller: TabController(length: 3, vsync: ScaffoldState()),
              tabs: [
                Tab(icon: Icon(Icons.calendar_view_day), text: "All List"),
                // Tab(icon: Icon(Icons.calendar_view_month), text: "Week"),
                Tab(
                    icon: Icon(Icons.calendar_view_month),
                    text: "Monthly List"),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
          body: const TabBarView(
            children: [
              _DayList(),
              // Icon(Icons.search),
              _MonthList(),
            ],
          )
          // body: StreamBuilder<QuerySnapshot>(
          //   stream: FirebaseFirestore.instance
          //       .collection('schedule')
          //       .orderBy('date', descending: false)
          //       .snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return Text('Something went wrong');
          //     }

          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Container(
          //         decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          //       );
          //     }
          //     final schedules = snapshot.data!.docs
          //         .map(
          //           (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
          //               json: (e.data() as Map<String, dynamic>)),
          //         )
          //         .toList();
          //     if (snapshot.hasData) {
          //       return ListView.builder(
          //           padding: EdgeInsets.only(top: 12.0),
          //           itemCount: schedules.length,
          //           itemBuilder: (context, index) {
          //             final schedule = schedules[index];
          //             return Dismissible(
          //               key: ObjectKey(schedule.id),
          //               direction: DismissDirection.startToEnd,
          //               onDismissed: (DismissDirection direction) {},
          //               child: Padding(
          //                   padding: const EdgeInsets.only(
          //                       bottom: 8.0, left: 8.0, right: 8.0),
          //                   child: ScheduleCard(
          //                     month: schedule.date.month,
          //                     day: schedule.date.day,
          //                     startTime: schedule.startTime,
          //                     endTime: schedule.endTime,
          //                     content: schedule.content,
          //                   )),
          //             );
          //           });
          //     } else {
          //       return Center(
          //         child: CircularProgressIndicator(semanticsLabel: 'Loading'),
          //       );
          //     }
          //   },
          // ),
          ),
    );
  }
}

// class _ListViewNav extends StatelessWidget {
//   const _ListViewNav({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text('My App'),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.home),
//           onPressed: () {
//             // Handle home button press
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {
//             // Handle search button press
//           },
//         ),
//         // ... other actions
//       ],
//     );
//   }
// }

class _DayList extends StatelessWidget {
  const _DayList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(
            'groups',
          )
          .doc(Provider.of<GroupIdProvider>(context, listen: false).groupId)
          .collection('schedules')
          // .where('date', isGreaterThanOrEqualTo: DateTime.now())
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          );
        }
        final schedules = snapshot.data!.docs
            .map(
              (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                  json: (e.data() as Map<String, dynamic>)),
            )
            .toList();
        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 12.0),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Dismissible(
                  key: ObjectKey(schedule.id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (DismissDirection direction) {},
                  child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8.0, right: 8.0),
                      child: ScheduleCard(
                        isEventList: true,
                        year: schedule.date.year,
                        month: schedule.date.month,
                        day: schedule.date.day,
                        // startTime: schedule.startTime,
                        // endTime: schedule.endTime,
                        content: schedule.content,
                      )),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(semanticsLabel: 'Loading'),
          );
        }
      },
    );
  }
}

class _MonthList extends StatelessWidget {
  const _MonthList({super.key});

  @override
  Widget build(BuildContext context) {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    var formattedMonth = month < 10 ? '0$month' : '$month'; // 두 자리 형식으로 변환

    var startDate = '$year$formattedMonth' + '01'; // 20231101
    var endDate = '$year$formattedMonth' + '31'; // 20231131
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(
            'groups',
          )
          .doc(Provider.of<GroupIdProvider>(context, listen: false).groupId)
          .collection('schedules')
          .orderBy('date', descending: false)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          );
        }
        final schedules = snapshot.data!.docs
            .map(
              (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                  json: (e.data() as Map<String, dynamic>)),
            )
            .toList();
        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 12.0),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Dismissible(
                  key: ObjectKey(schedule.id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (DismissDirection direction) {},
                  child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8.0, right: 8.0),
                      child: ScheduleCard(
                        year: schedule.date.year,
                        isEventList: true,
                        month: schedule.date.month,
                        day: schedule.date.day,
                        // startTime: schedule.startTime,
                        // endTime: schedule.endTime,
                        content: schedule.content,
                      )),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(semanticsLabel: 'Loading'),
          );
        }
      },
    );
  }
}
