import 'package:flutter/material.dart';
import 'package:joanda0/component/schedule_card.dart';

class SelectedScheduleList extends StatefulWidget {
  final List<ScheduleCard>? scheduleList;
  const SelectedScheduleList({required this.scheduleList, super.key});

  @override
  State<SelectedScheduleList> createState() => _SelectedScheduleListState();
}

class _SelectedScheduleListState extends State<SelectedScheduleList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.scheduleList?.length,
      itemBuilder: (context, index) {
        return ScheduleCard(
          isEventList: false,
          year: widget.scheduleList?[index].year,
          month: widget.scheduleList?[index].month,
          day: widget.scheduleList?[index].day,
          // startTime: widget.scheduleList?[index].startTime,
          // endTime: widget.scheduleList?[index].endTime,
          content: widget.scheduleList?[index].content.toString(),
        );
      },
    );
  }
}
