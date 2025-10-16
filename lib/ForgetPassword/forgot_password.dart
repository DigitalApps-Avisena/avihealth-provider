import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {


  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerIc = TextEditingController();

  dynamic _height;
  dynamic _width;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return KeyboardDismisser(
      gestures: const [
        GestureType.onPanUpdateDownDirection,
        GestureType.onTap
      ],
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: turquoise,
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter, colors: [
          //       Color(0xFFA92389),
          //       Color(0xFF2290AA),
          //       Color(0xFF2290AA),
          //     ],
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: const Text(
                        "With Us, It’s Always Personal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/avisena_healthcare_logo.png'
                            ),
                            width: 212,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: const <Widget>[
                                    Text(
                                      'Insert your email and IC number for which you want to reset your password.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(219, 211, 219, 1.0),
                                    blurRadius: 20,
                                    offset: Offset(0, 10)
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200
                                        ),
                                      ),
                                    ),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            controller: controllerEmail,
                                            obscureText: false,
                                            style: TextStyle(
                                              fontSize: _width * 0.04,
                                              color: Colors.black
                                            ),
                                            validator: (val) {
                                              return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                                              ).hasMatch(val!) ? null : "Please Enter Correct Email";
                                            },
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    top: _height * 0.02
                                                ),
                                                isDense: true,
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: _height * 0.01
                                                  ),
                                                  child: Icon(
                                                    Icons.email,
                                                    color: Colors.grey,
                                                    size: _width * 0.06,
                                                  ),
                                                ),
                                                hintText: "Email",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: 'Roboto',
                                                    fontSize: _width * 0.033
                                                ),
                                                border: InputBorder.none,
                                              ),
                                          ),
                                          // const SizedBox(height: 30.0),
                                          // TextFormField(
                                          //   controller: controllerIc,
                                          //   obscureText: false,
                                          //   style: const TextStyle(
                                          //     fontSize: 20.0,
                                          //     color: Colors.black
                                          //   ),
                                          //   validator: (val) {
                                          //     return RegExp(
                                          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                                          //     ).hasMatch(val!) ? null : "Please Enter Correct Email";
                                          //   },
                                          //   decoration: const InputDecoration(
                                          //     contentPadding:
                                          //     EdgeInsets.only(top: 20), // add padding to adjust text
                                          //     isDense: true,
                                          //     prefixIcon: Padding(
                                          //       padding: EdgeInsets.only(top: 10), // add padding to adjust icon
                                          //       child: Icon(
                                          //         Icons.person_sharp,
                                          //         color: Colors.grey,
                                          //       ),
                                          //     ),
                                          //     hintText: "Doctor ID.",
                                          //     hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                                          //     border: InputBorder.none
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 70,
                                  ),
                                  Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: turquoise,
                                    child: MaterialButton(
                                      minWidth: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                      onPressed: () async {
                                        var email = controllerEmail.text;
                                        final uri = Uri.parse('http://10.10.0.37/trakcare/web/custom/demc/csp/AVS/APP/API/restAPIcareProvider.csp?reqNumber=2&email=${email}');
                                        try {
                                          final response = await http.post(
                                              uri
                                          );
                                          final data = jsonDecode(response.body);
                                          print('apa $data');
                                          print('dasd ${data['code']}');
                                        } catch (e) {
                                          print('salah');
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Submit",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
