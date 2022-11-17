import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfresh_delivery_app/screens/home_screen.dart';
import 'package:gfresh_delivery_app/screens/login_screen.dart';




class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 2,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if(user==null){
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    }
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/logo-1.png',
              height: 125,
              width: 125,
            ),
            const Text(
                'G-Fresh Delivery App',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      );
  }
}
