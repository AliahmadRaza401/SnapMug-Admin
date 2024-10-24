import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:snapmug_for_admins/splash_screen.dart';

import 'HomePage.dart';
import 'SignIn.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
          apiKey: "AIzaSyB8fudufdb81EmsK-XLAuzeTf57b5d9LEA",
          authDomain: "snapmugflutter.firebaseapp.com",
          databaseURL: "https://snapmugflutter-default-rtdb.firebaseio.com",
          projectId: "snapmugflutter",
          storageBucket: "snapmugflutter.appspot.com",
          messagingSenderId: "534586490308",
          appId: "1:534586490308:web:34855af66e8f09953d7891",
          measurementId: "G-45DKZST0LV");
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and macOS
      return const FirebaseOptions(
        apiKey: 'AIzaSyB8fudufdb81EmsK-XLAuzeTf57b5d9LEA',
        appId: '1:534586490308:ios:e1daa37ba5400e473d7891',
        messagingSenderId: '534586490308',
        projectId: 'snapmugflutter',
        storageBucket: 'snapmugflutter.appspot.com',
        iosClientId: 'YOUR_IOS_CLIENT_ID',
        iosBundleId: 'YOUR_IOS_BUNDLE_ID',
      );
    } else {
      // Android
      return const FirebaseOptions(
        apiKey: 'AIzaSyB8fudufdb81EmsK-XLAuzeTf57b5d9LEA',
        appId: '1:534586490308:android:37951f7c55c0a8603d7891',
        messagingSenderId: '534586490308',
        projectId: 'snapmugflutter',
        storageBucket: 'snapmugflutter.appspot.com',
      );
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'Snapmug for admin',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Snapmug for admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/signin',
        // Navigate to /editpage initially
        routes: {
          '/editpage': (context) => MyHomePage(),
          '/edituser': (context) => MyHomePage(),
          '/signin': (context) => SignInActivity(),
          '/withdrawals': (context) => MyHomePage(),
        });
  }
}
