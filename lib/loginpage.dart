import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String _email;
  String _password;

  Future<void> _createUser() async {
    print('Email: $_email Password: $_password');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      print('User: $userCredential');
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      print('User: $userCredential');
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                _email = value;
              },
              decoration: InputDecoration(hintText: 'Enter Email...'),
            ),
            TextField(
              onChanged: (value) {
                _password = value;
              },
              decoration: InputDecoration(hintText: 'Enter Password...'),
              obscureText: true,
            ),
            MaterialButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            MaterialButton(
              onPressed: _createUser,
              child: Text('Create New Account'),
            ),
          ],
        ),
      ),
    );
  }
}
