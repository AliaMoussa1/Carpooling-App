import 'dart:async';
import 'package:carpool/assistants/assistant_methods.dart';
import 'package:carpool/screens/login_screen.dart';
import 'package:carpool/screens/main_screen.dart';
import 'package:carpool/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:carpool/global/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() {
    Timer(Duration(seconds: 3), () async{
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;
        Navigator.push(context, MaterialPageRoute(builder: (c) => ProfileScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Carpool',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent
          ),
        ),
      ),
    );
  }
}
