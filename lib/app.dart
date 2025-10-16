import 'package:avihealth_provider/Splash/splash.dart';
import 'package:avihealth_provider/login/login.dart';
import 'package:avihealth_provider/home.dart';
import 'package:avihealth_provider/login/presentation/login_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Splash()
    );
  }
}