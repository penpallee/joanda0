import 'package:flutter/material.dart';
import 'package:joanda0/screen/calendar_screen.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List'),
        ),
        body: ListView.builder(
            itemCount: CalendarScreen.scheduleList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                    'Item $index : ${CalendarScreen.scheduleList[index].content}'),
              );
            }));
  }
}
