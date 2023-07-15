import 'package:flutter/material.dart';
import 'package:joanda0/const/colors.dart';

class ScheduleCard extends StatelessWidget {
  final int? month;
  final int? day;
  final int? startTime;
  final int? endTime;
  final String? content;
  const ScheduleCard(
      {required this.month,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.content,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Time(startTime: startTime!, endTime: endTime!),
                const SizedBox(width: 8.0),
                _Content(content: content!),
              ],
            ),
          ),
        ));
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({required this.startTime, required this.endTime, super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${startTime.toString().padLeft(2, '0')}:00', style: textStyle),
        Text('${endTime.toString().padLeft(2, '0')}:00',
            style: textStyle.copyWith(
              fontSize: 10.0,
            )),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}
