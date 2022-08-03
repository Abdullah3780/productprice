import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailAddress;
  var password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Sign In')),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () async {
                      await signInWithGoogle().then((value) {
                        print('object');
                        return ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: const Text('Signed In Succesfully'),
                          duration: const Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'ACTION',
                            onPressed: () {},
                          ),
                        ));
                      });
                      if (!mounted) return;
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child:
                        SvgPicture.asset('assets/googleicon.svg', height: 30)),
                IconButton(
                    icon: Icon(Icons.login),
                    onPressed: () async {
                      emailAddress = emailController.text.toString();
                      password = passwordController.text.toString();
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailAddress, password: password);
                        Navigator.pushReplacementNamed(context, '/home');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                const Text('No user found for that email.'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'ACTION',
                              onPressed: () {},
                            ),
                          ));
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                'Wrong password provided for that user.'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'ACTION',
                              onPressed: () {},
                            ),
                          ));
                          print('Wrong password provided for that user.');
                        }
                      }
                    }),
              ],
            ),
          ],
        ));
  }
}
