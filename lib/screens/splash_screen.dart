import 'package:doc_saver_app/screens/authentication_screen.dart';
import 'package:doc_saver_app/screens/home_screen.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splashScreen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigate() async {
    await Future.delayed(const Duration(seconds: 1)).then((value) {
      bool value = FirebaseAuth.instance.currentUser == null;
      if (value) {
        Navigator.pushReplacementNamed(context, AuthenticationScreen.routeName);
      }else{
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });

  }
@override
  void initState() {
    navigate();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Center(child: Image.asset("assets/app_icon.png"))),
    );
  }
}
