import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:productprice/pages/home.dart';
import 'package:productprice/pages/signin.dart';
import 'package:productprice/pages/signinorsignup.dart';
import 'package:productprice/pages/signup.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            importance: NotificationImportance.Max,
            enableVibration: true)
      ]);
  await FirebaseMessaging.instance.subscribeToTopic('topic');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String initialroute = '/';
  Future<void> checkLogin(initialroute) async {
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      initialroute = '/home';
    } else {
      initialroute = '/';
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    checkLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AwesomeNotifications()
    //     .actionStream
    //     .listen((ReceivedNotification receivedNotification) {
    //   Navigator.of(context).pushNamed('/NotificationPage', arguments: {
    //     // your page params. I recommend you to pass the
    //     // entire *receivedNotification* object
    //     receivedNotification
    //   });
    // });

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialroute,
      routes: {
        '/': (context) => SignInORSignUp(),
        '/signup': (context) => SignUp(),
        '/signin': (context) => SignIn(),
        '/home': (context) => Home()
      },
    );
  }
}
