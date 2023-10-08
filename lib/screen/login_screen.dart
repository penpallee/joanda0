import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joanda0/screen/home_screen.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final currentUser = FirebaseAuth.instance.currentUser;
  bool _isLogin = true; // 로그인 모드인지 회원가입 모드인지 구분하는 변수

  Future<bool> _submit() async {
    User? currentUser = _auth.currentUser;
    String? userId;
    if (currentUser != null) {
      userId = currentUser.uid;
      debugPrint(userId);
    } else {
      const AlertDialog(
        content: Text('invalid information'),
      );
    }

    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      // 이메일과 비밀번호가 모두 입력되었는지 확인
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')));
      return false;
    }
    try {
      if (_isLogin) {
        // 로그인
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return true;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const HomeScreen(),
        //   ),
        // );
      } else {
        // 회원가입
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        debugPrint(userCredential.toString());
        // Firestore에 사용자 정보 저장
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': email,
          'groupId': const Uuid().v4(),
          // 필요한 다른 필드들...
        });
        String currentUserId = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();
        String currentgroupId = userDoc.get('groupId');

        await FirebaseFirestore.instance
            .collection('groups')
            .doc(currentgroupId)
            .set({
          'members': [currentUserId],
        });
        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(currentUserId)
        //     .set({
        //   'groupId': [groupDoc.id]
        // });
        return true;
      }
    } catch (e) {
      _showError(e.toString());
      return false;
    }
  }

  void _handleLoginOrSignup() async {
    bool isSuccess = await _submit();
    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  void _showError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $errorMessage')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? '로그인' : '회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLoginOrSignup,
              child: Text(_isLogin ? '로그인' : '회원가입'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin; // 모드 전환
                });
              },
              child: Text(_isLogin ? '회원가입하기' : '로그인하기'),
            ),
          ],
        ),
      ),
    );
  }
}
