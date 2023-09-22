import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joanda0/component/main_calendar.dart';
import 'package:joanda0/screen/calendar_screen.dart';

final FIRST_DAY = DateTime(2022, 7, 30);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MainCalendar? mainCalendar;
  DateTime firstDate = DateTime.now();
  // String? backgroundImageUrl;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _loadBackground();
  // }

  // Future<void> _loadBackground() async {
  //   String? imageUrl = await getBackgroundSetting();
  //   if (imageUrl != null) {
  //     setState(() {
  //       backgroundImageUrl = imageUrl;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        // appBar: AppBar(
        //   title: Text("data"),
        // ),

        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SizedBox(
                  height: 35,
                ),
              ),
              _CoupleImage(),
              _DDay(
                onHeartPressed: onHeartPressed,
                firstDay: FIRST_DAY,
              ),
              Container(
                color: Colors.black.withOpacity(0.8),
                child: SizedBox(
                  height: 45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Since',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${FIRST_DAY.year}.${FIRST_DAY.month}.${FIRST_DAY.day}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  // Future<String?> getBackgroundSetting() async {
  //   //현재 로그인한 사용자 가져오기
  //   // if (user != null) {
  //   final doc = await FirebaseFirestore.instance
  //       .collection('backgroundSettings')
  //       .doc('123')
  //       .get();
  //   print(123);
  //   print(doc.data()?['imageUrl'] as String?);
  //   return doc.data()?['imageUrl'] as String?;
  //   // }
  //   // return null;
  // }

  void onHeartPressed() {
    // print('123');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(),
      ),
    );

    setState(() {});
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
    return Container(
      // color: Colors.redAccent.withOpacity(0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(height: 20),
          Text(
            'D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}',
            style: TextStyle(fontSize: 20),
          ),
          // const SizedBox(height: 8),
          IconButton(
            iconSize: 50,
            onPressed: onHeartPressed,
            icon: Icon(Icons.favorite_border, color: Colors.redAccent),
          ),
          Text(
            '항상 곁에 있을게요, 사랑해요.',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            '같이 행복하자구요',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class _CoupleImage extends StatefulWidget {
  const _CoupleImage({super.key});

  @override
  State<_CoupleImage> createState() => _CoupleImageState();
}

class _CoupleImageState extends State<_CoupleImage> {
  File? _image;
  final picker = ImagePicker();
  String? backgroundImageUrl;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    saveBackgroundSetting(_image!.path);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBackground();
  }

  Future<void> _loadBackground() async {
    String? imageUrl = await getBackgroundSetting();
    if (imageUrl != null) {
      setState(() {
        _image = File(imageUrl);
      });
    }
  }

  Future<String?> getBackgroundSetting() async {
    //현재 로그인한 사용자 가져오기
    // if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('backgroundSettings')
        .doc('123')
        .get();
    print(doc.data()?['imageUrl'] as String?);
    return doc.data()?['imageUrl'] as String?;
    // }
    // return null;
  }

  Future<void> saveBackgroundSetting(String imageUrl) async {
    //  final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 가져오기
    const user = '123';
    // if (user != null) {
    await FirebaseFirestore.instance
        .collection('backgroundSettings')
        // .doc(user.uid)
        .doc(user)
        .set({'imageUrl': imageUrl});

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      color: Theme.of(context).colorScheme.primary,
      child: TextButton(
        onPressed: () {},
        onLongPress: () {
          getImage();
        },
        child: _image == null
            ? Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer, // 테두리 색상
                    width: 8.0,
                  ),
                ), // 테두리 두께
                child: Image.asset(
                  'asset/img/middle_image.png',
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                ),
              )
            : Image.file(
                _image!,
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
