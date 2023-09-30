import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupService {
  final _groupCollection = FirebaseFirestore.instance.collection('groups');
  final _invitationCollection =
      FirebaseFirestore.instance.collection('invitations');
  final _userCollection = FirebaseFirestore.instance.collection('users');

  Future<String> createGroupAndInvitation(String userId) async {
    // 그룹 생성 및 초기 사용자 추가
    DocumentReference groupDoc = await _groupCollection.add({
      'members': [userId]
    });

    // 초대 코드 생성 및 저장
    String invitationCode = generateInvitationCode();
    await _invitationCollection.add({
      'code': invitationCode,
      'groupId': groupDoc.id,
    });

    // 사용자 문서에 그룹 ID 저장
    await _userCollection.doc(userId).update({'groupId': groupDoc.id});

    return invitationCode;
  }

  String generateInvitationCode() {
    // 여기에서 유니크한 초대 코드를 생성하세요.
    return 'someUniqueCode';
  }

  Future<void> joinGroupWithInvitationCode(
      String invitationCode, String userId) async {
    // 초대 코드로 그룹 찾기
    DocumentSnapshot invitationDoc =
        await _invitationCollection.doc(invitationCode).get();

    if (invitationDoc.exists) {
      String groupId = invitationDoc['groupId'];

      // 사용자를 그룹에 추가
      await _groupCollection.doc(groupId).update({
        'members': FieldValue.arrayUnion([userId])
      });

      // 사용자 문서에 그룹 ID 저장
      await _userCollection.doc(userId).update({'groupId': groupId});
    } else {
      // 유효하지 않은 초대 코드 처리
      throw Exception('Invalid Invitation Code');
    }
  }
}

class InvitationService {
  final CollectionReference _invitationCollection =
      FirebaseFirestore.instance.collection('invitations');

  Future<void> createInvitation(String groupId) async {
    String invitationCode = generateInvitationCode();
    await _invitationCollection.add({
      'code': invitationCode,
      'groupId': groupId,
    });
  }

  String generateInvitationCode() {
    // 여기에서 유니크한 초대 코드를 생성합니다.
    // 예를 들어, 랜덤 문자열을 사용할 수 있습니다.
    return 'someUniqueCode';
  }
}
