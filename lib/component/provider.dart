import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class GroupIdProvider with ChangeNotifier {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String _groupId = '';

  Future<String> getGroupId() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['groupId'];
  }

  void someFunction() async {
    final groupId = await getGroupId();
    _groupId = groupId;
  }

  String get groupId => _groupId;

  set groupId(String value) {
    _groupId = value;
    notifyListeners();
  }
}
