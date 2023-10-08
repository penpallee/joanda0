import 'package:flutter/material.dart';
import 'package:joanda0/component/invitation.dart';

class InvitationScreen extends StatelessWidget {
  final inviteCodeController = TextEditingController();

  InvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Input Invitation Code'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...[
                TextField(
                  controller: inviteCodeController,
                  decoration: const InputDecoration(labelText: '초대 코드'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Invitation.acceptInvitation(
                        inviteCodeController.text, context);
                  },
                  child: const Text('초대 수락'),
                ),
              ],
              ElevatedButton(
                onPressed: () async {
                  final inviteCode = await Invitation.sendInvitation();
                  // 초대 코드를 사용자에게 전달 (다이얼로그, 토스트 메시지, 클립보드 복사 등을 통해)

                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: const Text('초대 코드'),
                              content: Text(inviteCode),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('확인'),
                                ),
                              ]));
                },
                child: const Text('Create Invitation Code'),
              ),
            ])));
  }
}
