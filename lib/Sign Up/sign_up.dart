import 'package:animate_do/animate_do.dart';
import 'package:avihealth_provider/Login/login.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerIc = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  dynamic _height;
  dynamic _width;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection
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
              SizedBox(
                height: _height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
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
                        "Connect with us now!",
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
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                                'assets/images/avisena_healthcare_logo.png'),
                            width: 200,
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
                                    offset: Offset(0, 10),
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
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black
                                            ),
                                            validator: (val) {
                                              return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                                              ).hasMatch(val!) ? null : "Please Enter Correct Email";
                                            },
                                            decoration: const InputDecoration(
                                              contentPadding:
                                              EdgeInsets.only(top: 20), // add padding to adjust text
                                              isDense: true,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(top: 10), // add padding to adjust icon
                                                child: Icon(
                                                  Icons.email,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              hintText: "Email",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15
                                              ),
                                              border: InputBorder.none
                                            ),
                                          ),
                                          const SizedBox(height: 30.0),
                                          TextFormField(
                                            controller: controllerIc,
                                            obscureText: false,
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black
                                            ),
                                            validator: (val) {
                                              return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                                              ).hasMatch(val!) ? null : "Please Enter Correct Email";
                                            },
                                            decoration: const InputDecoration(
                                              contentPadding:
                                              EdgeInsets.only(top: 20), // add padding to adjust text
                                              isDense: true,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(top: 10), // add padding to adjust icon
                                                child: Icon(
                                                  Icons.person_sharp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              hintText: "IC No.",
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                                              border: InputBorder.none
                                            ),
                                          ),
                                          const SizedBox(height: 30.0),
                                          TextFormField(
                                            controller: controllerIc,
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black
                                            ),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(top: 10), // add padding to adjust icon
                                                child: Icon(
                                                  Icons.phone,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                              hintText: "Phone No.",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15
                                              ),
                                              border: InputBorder.none
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
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: turquoise,
                                    child: MaterialButton(
                                      minWidth: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Sign Up",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Already have an account?',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Flexible(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: turquoise,
                                          ),
                                          child: Text(
                                            'Login Here',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              decoration: TextDecoration.underline,
                                              fontSize: _width * 0.03,
                                              color: Colors.white
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const Login(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
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
