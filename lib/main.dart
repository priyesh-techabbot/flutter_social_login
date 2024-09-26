import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_login/auth_screen.dart';
import 'package:flutter_social_login/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (Platform.isIOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBJydVjVy3-jdYYDNXUf__Bj7sFz4Z22Kc",
        authDomain: "flutter-social-login-1f174.firebaseapp.com",
        projectId: "flutter-social-login-1f174",
        storageBucket: "flutter-social-login-1f174.appspot.com",
        messagingSenderId: "591705112607",
        appId: "1:591705112607:web:01b64595c91ca2886e152a",
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
            ),
          ),
          home: snapshot.data == null ? const AuthScreen() : const HomeScreen(),
        );
      },
    );
  }
}
