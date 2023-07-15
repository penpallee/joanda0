import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joanda0/screen/calendar_screen.dart';

final FIRST_DAY = DateTime(2022, 7, 30);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pinkAccent,
        appBar: AppBar(
          title: Text("data"),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DDay(
                onHeartPressed: onHeartPressed,
                firstDay: FIRST_DAY,
              ),
              _CoupleImage()
            ],
          ),
        ));
  }

  void onHeartPressed() {
    // print('123');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(),
      ),
    );
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  const _DDay(
      {required this.onHeartPressed, required this.firstDay, super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'U&I',
        ),
        const SizedBox(height: 16),
        Text(
          'The day we met',
        ),
        Text('${firstDay.year}.${firstDay.month}.${firstDay.day}'),
        const SizedBox(height: 16),
        IconButton(
          iconSize: 60,
          onPressed: onHeartPressed,
          icon: Icon(Icons.favorite_border),
        ),
        const SizedBox(height: 16),
        Text(
            'D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}'),
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget {
  const _CoupleImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'asset/img/middle_image.png',
        height: MediaQuery.of(context).size.height / 2,
      ),
    );
  }
}
