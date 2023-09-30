import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGroupAndInvite(
      String senderId, String recipientEmail) async {
    // 초대받은 사람을 찾기
    QuerySnapshot recipientSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: recipientEmail)
        .get();

    if (recipientSnapshot.docs.isEmpty) {
      // 초대받을 사람을 찾을 수 없음
      throw Exception('Recipient not found');
    }

    String recipientId = recipientSnapshot.docs.first.id;

    // 그룹 문서 생성
    DocumentReference groupDoc = await _firestore.collection('groups').add({
      'members': [senderId, recipientId],
      'schedules': [],
    });

    // 사용자 문서 업데이트
    await _firestore.collection('users').doc(senderId).update({
      'groupId': groupDoc.id,
    });
    await _firestore.collection('users').doc(recipientId).update({
      'groupId': groupDoc.id,
    });
  }
}
