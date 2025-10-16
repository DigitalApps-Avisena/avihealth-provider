import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  late PdfControllerPinch pdfControllerPinch;

  @override
  void initState() {
    super.initState();
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openAsset(
        'assets/pdf/Privacy_Policy.pdf'
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
          ),
        ),
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        backgroundColor: turquoise,
      ),
      backgroundColor: Colors.white,
      body: PdfViewPinch(
        scrollDirection: Axis.vertical,
        controller: pdfControllerPinch,
      ),
    );
  }
}
