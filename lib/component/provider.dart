import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class GroupIdProvider with ChangeNotifier {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String? _groupId;

  GroupIdProvider() {
    someFunction();
  }

  Future<String> getGroupId() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final groupId = userDoc['groupId'];
    if (groupId == null) {
      throw Exception('GroupId is null for userId: $userId');
    }
    return groupId;
  }

  void someFunction() async {
    try {
      final groupId = await getGroupId();
      _groupId = groupId;
      notifyListeners();
    } catch (e) {
      print('Error getting groupId: $e');
    }
  }

  String? get groupId => _groupId;

  set groupId(String? value) {
    _groupId = value;
    notifyListeners();
  }
}
