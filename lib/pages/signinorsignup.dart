import 'package:flutter/material.dart';

class SignInORSignUp extends StatelessWidget {
  const SignInORSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ))
          ],
        )
      ],
    ));
  }
}
