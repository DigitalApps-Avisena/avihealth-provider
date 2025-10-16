import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class TermOfUse extends StatefulWidget {
  const TermOfUse({Key? key}) : super(key: key);

  @override
  State<TermOfUse> createState() => _TermOfUseState();
}

class _TermOfUseState extends State<TermOfUse> {

  late PdfControllerPinch pdfControllerPinch;

  @override
  void initState() {
    super.initState();
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openAsset(
        'assets/pdf/Terms_of_Use.pdf'
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Terms of Use",
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
          ),
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
