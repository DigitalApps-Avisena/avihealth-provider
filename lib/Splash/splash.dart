import 'package:avihealth_provider/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final storage = const FlutterSecureStorage();
  bool? firstTimeUser;

  @override
  void initState() {
    super.initState();
    splashSetting();
  }

  Future<void> splashSetting() async {
    await Future.delayed(const Duration(seconds: 2));
    final accepted = await storage.read(key: 'acceptedTerms');
    if (accepted == 'true') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      await storage.write(key: 'firstTime', value: 'true');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/avisena_splashscreen.png'),
      ),
    );
  }
}