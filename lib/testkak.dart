import 'package:flutter/material.dart';

import 'Widgets/const.dart';

class TestKak extends StatefulWidget {
  const TestKak({Key? key}) : super(key: key);

  @override
  State<TestKak> createState() => _TestKakState();
}

class _TestKakState extends State<TestKak> {

  dynamic _height;
  dynamic _width;

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Professional Fees',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: turquoise,
        centerTitle: true,
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: _width * 0.05,
          ),
        ),
        elevation: 20,
      ),
      backgroundColor: const Color(0xFFf4f9fa),
      body: Center(
      ),
    );
  }
}
