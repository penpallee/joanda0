import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joanda0/screen/home_screen.dart';
import 'package:uuid/uuid.dart';

class Invitation {
  static Future<String?> acceptInvitation(
      String inviteCode, BuildContext context) async {
    // 초대 코드를 이용하여 초대 정보 찾기
    DocumentSnapshot? invitationDoc = await FirebaseFirestore.instance
        .collection('invitations')
        .doc(inviteCode)
        .get();

    if (!invitationDoc.exists) {
      return 'Invitation Code does not exist';
    }

    String createdBy = invitationDoc['createdBy'];
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(createdBy)
        .get();

    String? targetgroupId = userDoc.get('groupId');

    if (targetgroupId == null) {
      // throw Exception('GroupId is null');
      return 'GroupId is null';
    }

    // 새로운 그룹 생성 및 사용자들에게 그룹 ID 할당
    // DocumentReference groupDoc =
    //     await FirebaseFirestore.instance.collection('groups').add({
    //   'members': [createdBy, currentUserId],
    // });
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(targetgroupId)
        .update({
      'members': FieldValue.arrayUnion([currentUserId])
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({'groupId': targetgroupId});

    // 초대 코드 삭제
    await FirebaseFirestore.instance
        .collection('invitations')
        .doc(inviteCode)
        .delete();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );

    return null;
  }

  static Future<String> sendInvitation() async {
    // 초대 코드 생성
    String inviteCode = const Uuid().v4();

    // 초대 코드를 Firestore에 저장
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('invitations')
        .doc(inviteCode)
        .set({
      'createdBy': currentUserId,
      'createdAt': Timestamp.now(),
    });

    return inviteCode;
  }
}
