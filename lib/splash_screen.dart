import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../SignIn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late AppLifecycleReactor _appLifecycleReactor;

  Timer? timer;

  @override
  void initState() {
    if (mounted) {
      timer = Timer.periodic(const Duration(seconds: 3), (val) {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyHomePage()));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignInActivity()));
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Image.asset('assets/splash.png')),
    );
  }
}
class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: CircularProgressIndicator(backgroundColor: yellowColor));
  }
}
