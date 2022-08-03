import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var emailAddress;
  var password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Sign UP')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(label: Text('Email')),
              controller: emailController,
            ),
            TextField(
              decoration: InputDecoration(label: Text('Password')),
              controller: passwordController,
            ),
            IconButton(
                icon: Icon(Icons.login),
                onPressed: () async {
                  emailAddress = emailController.text.toString();
                  password = passwordController.text.toString();
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailAddress,
                      password: password,
                    );
                    Navigator.pushReplacementNamed(context, '/signin');
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                }),
          ],
        ));
  }
}
