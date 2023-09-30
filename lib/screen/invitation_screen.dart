import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class InvitationScreen extends StatelessWidget {
  final _inviteCodeController = TextEditingController();

  Future<void> _acceptInvitation(
      String inviteCode, BuildContext context) async {
    // 초대 코드를 이용하여 초대 정보 찾기
    DocumentSnapshot? invitationDoc = await FirebaseFirestore.instance
        .collection('invitations')
        .doc(inviteCode)
        .get();

    if (!invitationDoc.exists) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('fail'),
          content: Text('fail'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    String createdBy = invitationDoc['createdBy'];
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // 새로운 그룹 생성 및 사용자들에게 그룹 ID 할당
    DocumentReference groupDoc =
        await FirebaseFirestore.instance.collection('groups').add({
      'members': [createdBy, currentUserId],
      'schedules': [],
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({'groupId': groupDoc.id});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(createdBy)
        .update({'groupId': groupDoc.id});

    // 초대 코드 삭제
    await FirebaseFirestore.instance
        .collection('invitations')
        .doc(inviteCode)
        .delete();
  }

  Future<void> _sendInvitation(BuildContext context) async {
    // 초대 코드 생성
    String inviteCode = Uuid().v4();

    // 초대 코드를 Firestore에 저장
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('invitations')
        .doc(inviteCode)
        .set({
      'createdBy': currentUserId,
      'createdAt': Timestamp.now(),
    });

    // 초대 코드를 사용자에게 전달 (다이얼로그, 토스트 메시지, 클립보드 복사 등을 통해)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('초대 코드'),
        content: Text(inviteCode),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Input Invitation Code'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...[
                TextField(
                  controller: _inviteCodeController,
                  decoration: InputDecoration(labelText: '초대 코드'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _acceptInvitation(_inviteCodeController.text, context);
                  },
                  child: Text('초대 수락'),
                ),
              ],
              ElevatedButton(
                onPressed: () {
                  _sendInvitation(context);
                },
                child: Text('Create Invitation Code'),
              ),
            ])));
  }
}
