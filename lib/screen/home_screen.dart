import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joanda0/component/cloud_firestore.dart';
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
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(
              //   height: 5,
              // ),
              Expanded(flex: 3, child: const _CoupleImage()),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.transparent,
                  child: _DDay(
                    onHeartPressed: onHeartPressed,
                    firstDay: FIRST_DAY,
                  ),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Since',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${FIRST_DAY.year}.${FIRST_DAY.month}.${FIRST_DAY.day}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],

                  // ),
                ),
              ),
            ]),
      ),
    );
  }

  void onHeartPressed() {
    // print('123');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalendarScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> createGroupAndInvitation() async {
    String userId = "현재 사용자 ID"; // 현재 사용자 ID를 가져와야 합니다.
    try {
      String groupId = await GroupService().createGroupAndInvitation(userId);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invitation Code'),
          content: Text('Your invitation code is $groupId'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  const _DDay({required this.onHeartPressed, required this.firstDay});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      color: Colors.redAccent.withOpacity(0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 20),
          Text(
            'D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}',
            style: const TextStyle(fontSize: 20),
          ),
          // const SizedBox(height: 8),
          IconButton(
            iconSize: 50,
            onPressed: onHeartPressed,
            icon: const Icon(Icons.favorite_border, color: Colors.redAccent),
          ),
          const Text(
            '항상 곁에 있을게요, 사랑해요.',
            style: TextStyle(fontSize: 15),
          ),
          const Text(
            '같이 행복하자구요',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class _CoupleImage extends StatefulWidget {
  const _CoupleImage();

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
      } else {}
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

    if (await File(imageUrl!).exists()) {
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
      padding: const EdgeInsets.only(bottom: 20),
      color: Theme.of(context).colorScheme.primary,
      child: TextButton(
        onPressed: () {},
        onLongPress: () {
          getImage();
        },
        child: _image == null
            ? Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer, // 테두리 색상
                    width: 0,
                  ),
                ), // 테두리 두께
                child: Image.asset('asset/img/middle_image.png',
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    cacheWidth: 996,
                    cacheHeight: 1402,
                    fit: BoxFit.cover),
              )
            : Image.file(
                _image!,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                cacheWidth: 996,
                cacheHeight: 1635,
              ),
      ),
    );
  }
}
