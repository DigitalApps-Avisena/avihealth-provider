import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../Widgets/const.dart';

class OncallRoster extends StatefulWidget {
  const OncallRoster({Key? key, required this.locationCode}) : super(key: key);
  final String locationCode;

  @override
  State<OncallRoster> createState() => _OncallRosterState();
}

class _OncallRosterState extends State<OncallRoster> {

  dynamic _height;
  dynamic _width;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Set platform-specific implementation for Android
    // WebViewPlatform.instance = AndroidWebView();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://avisena.com.my/web/roster/specialistAppRoster.php',));
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'On Call',
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
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
