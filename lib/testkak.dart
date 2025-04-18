import 'package:flutter/material.dart';

class TestKak extends StatefulWidget {
  const TestKak({Key? key}) : super(key: key);

  @override
  State<TestKak> createState() => _TestKakState();
}

class _TestKakState extends State<TestKak> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Fees'),

      ),
      body: Center(
      ),
    );
  }
}
