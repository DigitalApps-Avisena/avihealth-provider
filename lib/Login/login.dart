import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:avihealth_provider/ForgetPassword/forgot_password.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:avihealth_provider/home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _LoginState extends State<Login> {

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  dynamic _height;
  dynamic _width;

  var username;
  var email;
  var password;

  final formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  bool _passwordVisible = false;
  bool _canLogin = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFirstTimeUser();
    // fetchCredential();
  }

  Future<void> checkFirstTimeUser() async {
    final accepted = await storage.read(key: 'acceptedTerms');

    if (accepted != 'true') {
      Future.delayed(const Duration(milliseconds: 500), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Reminder",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "All patient and hospital information accessed through the AviHealth Specialist App is strictly confidential. By continuing, you acknowledge and agree to handle such information in strict confidence. You confirm that you will use it only for authorized healthcare purposes in line with your professional obligations, hospital policies, and the Personal Data Protection Act 2010, and that you are responsible for safeguarding access to this Application on your device.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 12),
                // const Text(
                //   "By tapping 'Accept', you consent to the use of these technologies. You won't be able to access the app without providing this consent.",
                //   style: TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.w500,
                //     height: 1.5,
                //   ),
                //   textAlign: TextAlign.justify,
                // ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            actions: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _canLogin = false;
                  });
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Decline",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await storage.write(key: 'acceptedTerms', value: 'true');
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Accept",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  fetchCredential() async {
    // await storage.write(key: 'username', value: 'test');
    // await storage.write(key: 'password', value: '1234');
    // await storage.write(key: 'phone', value: '+60123456789');
    // username = await storage.read(key: 'username');
    // password = await storage.read(key: 'password');
    // print('passsword $password');
    // await storage.deleteAll();
  }

  /// Ambil token device (Android/iOS)
  Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  /// Semak kalau akaun dah login di phone lain
  Future<bool> canLogin(String doctorID) async {
    try {
      final doc = await db.collection('users').doc(doctorID).get();
      if (!doc.exists) return true; // kalau belum wujud dalam Firestore

      final savedToken = doc.data()?['deviceToken'];
      final currentToken = await getDeviceToken();

      if (savedToken == null || savedToken == currentToken) return true;
      return false; // token lain -> dah login di phone lain
    } catch (e) {
      print('Error check login: $e');
      return true; // fallback allow login
    }
  }

  Future<void> updateDoctorDeviceToken(String doctorID, Map<String, dynamic> userData) async {
    final token = await getDeviceToken();
    if (token != null) {
      await db.collection('users').doc(doctorID).set({
        'doctorID': doctorID,
        'email': userData['email'],
        'image': userData['image'],
        'name': userData['name'],
        'trakcareCode': userData['trakcareCode'],
        'craeted_at': userData['created_at'],
        'deviceToken': token,
      }, SetOptions(merge: true));
    }
  }

  Future<void> authenticateWithBiometrics() async {
    var email = await storage.read(key: 'email');
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with fingerprint or Face ID',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (!mounted) {
        return;
      }

      if (authenticated) {
        if(email != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          return AwesomeDialog(
            padding: const EdgeInsets.all(20),
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: "Biometric Authentication",
            btnOkColor: turquoise,
            btnOkText: "Okay",
            desc:
            "Please login by using email for first time login",
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
          ).show();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      return;
    }
  }

  login() async {
    print('pp ${controllerEmail.text}');
    print('sf ${controllerPassword.text}');
    var emaill = controllerEmail.text;
    var pw = controllerPassword.text;

    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/loginCareProvider');

    try {
      final response = await http.post(
        uri,
        body: {
          'email' : emaill,
          'password' : pw
        }
      );
      final data = jsonDecode(response.body);
      print('apa $data');
      print('dasd ${data['code']}');

      if (data['code'] == '1') {
        final doctorID = data['doctorID'];
        final allowed = await canLogin(doctorID);

        if (!allowed) {
          // Sudah login di phone lain
          AwesomeDialog(
            padding: const EdgeInsets.all(20),
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: "Account Already Logged In",
            btnOkColor: turquoise,
            btnOkText: "Okay",
            desc: "This account is already logged in on another device. "
                "Please logout from the previous device first.",
            btnOkOnPress: () {},
          ).show();
          return;
        }

        // Jika boleh login — store data + update token
        await storage.write(key: 'email', value: controllerEmail.text);
        await storage.write(key: 'password', value: controllerPassword.text);
        await storage.write(key: 'doctorId', value: doctorID);
        await storage.write(key: 'image', value: data['image']);
        await storage.write(key: 'name', value: data['name']);
        await storage.write(key: 'trakcareCode', value: data['trakcareCode']);

        final userData = {
          'email': controllerEmail.text,
          'image': data['image'],
          'name': data['name'],
          'trakcareCode': data['trakcareCode'],
          'created_at' : DateTime.now()
        };

        // ✅ Update Firestore token
        await updateDoctorDeviceToken(doctorID, userData);

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (data['code'] == '01') {
        AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Email Password",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Login fail, email not found",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
        ).show();
      } else if (data['code'] == '02') {
        AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Wrong Password",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Login fail, wrong password",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
        ).show();
      } else if (data['code'] == '03') {
        AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Account Inactive",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Login fail, care provider account is not active",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
        ).show();
      } else {
        AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Field Empty",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Please Enter Email And Password",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
        ).show();
      }
    } catch (e) {
      print('salah $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    TextStyle style = TextStyle(fontSize: _width * 0.04);

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
          //     begin: Alignment.topCenter,
          //     colors: [
          //       Color(0xFFA92389),
          //       Color(0xFF2290AA),
          //       Color(0xFF2290AA),
          //     ],
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: _height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.all(_width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _width * 0.01,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: Text(
                        "With Us, It’s Always Personal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _width * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _height * 0.02
              ),
              Expanded(
                child: Container(
                  height: _height * 0.7,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      _width * 0.075
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: _height * 0.01
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/avisena_healthcare_logo.png',
                              width: _width * 0.43,
                            ),
                          ),
                          Text(
                            '\nAvihealth Doctor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: turquoise,
                              fontSize:  _width * 0.05
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.05
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
                                    padding: EdgeInsets.all(
                                      _width * 0.005
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: controllerEmail,
                                            obscureText: false,
                                            style: style,
                                            validator: (val) {
                                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
                                                  ? null
                                                  : "Please Enter Correct Email";
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
                                          SizedBox(
                                            height: _height * 0.04
                                          ),
                                          TextFormField(
                                            controller: controllerPassword,
                                            obscureText: !_passwordVisible,
                                            style: style,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                  color: Colors.grey,
                                                  size: _width * 0.06,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _passwordVisible = !_passwordVisible;
                                                  });
                                                },
                                              ),
                                              isDense: true,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(top: _height * 0.01),
                                                child: Icon(
                                                  Icons.lock,
                                                  color: Colors.grey,
                                                  size: _width * 0.06,
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02, horizontal: _width * 0.05),
                                              hintText: "Password",
                                              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: _width * 0.033),
                                              border: InputBorder.none,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: _height * 0.025
                            ),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        // style: TextButton.styleFrom(
                                        //   backgroundColor: Colors.blueGrey,
                                        // ),
                                        child: Text(
                                          'Forgot Your Password?',
                                          style: TextStyle(
                                            fontSize: _width * 0.033,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.red
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const ForgotPassword(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: _height * 0.03
                                  ),
                                  Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: _canLogin == true ? turquoise : Colors.grey,
                                    child: MaterialButton(
                                      minWidth: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                      onPressed: _canLogin == true ? () {
                                        print('lo $_canLogin');
                                        login();
                                        // Navigator.of(context).push(
                                        //           MaterialPageRoute(
                                        //             builder: (context) => const HomePage(),
                                        //           ),
                                        //         );
                                      } : null,
                                      // onPressed: controllerEmail.text == username && controllerPassword.text == password ? () {
                                      //   login();
                                      // } : () {
                                      //   AwesomeDialog(
                                      //     padding: const EdgeInsets.all(20),
                                      //     context: context,
                                      //     dialogType: DialogType.error,
                                      //     animType: AnimType.topSlide,
                                      //     showCloseIcon: true,
                                      //     title: "Incorrect Credentials",
                                      //     btnOkColor: turquoise,
                                      //     btnOkText: "Okay",
                                      //     desc:
                                      //     "The email or password you entered is incorrect.",
                                      //     btnOkOnPress: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //           builder: (context) => const Login(),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ).show();
                                      // },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Login",
                                            textAlign: TextAlign.center,
                                            style: style.copyWith(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _height * 0.02
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Expanded(child: Divider()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Text(
                                          "Or",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: _width * 0.033,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Divider()
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        // style: TextButton.styleFrom(
                                        //   backgroundColor: turquoise,
                                        // ),
                                        child: Text(
                                          'Biometric Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            // decoration: TextDecoration.underline,
                                            color: _canLogin == true ? turquoise : Colors.grey
                                          ),
                                        ),
                                        onPressed: _canLogin == true ? () {
                                          authenticateWithBiometrics();
                                        } : null,
                                      ),
                                      if (_canLogin == true) Lottie.asset(
                                        'assets/images/biometric_auth.json',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     const Text(
                                  //       'Don\'t have an account?',
                                  //       style: TextStyle(
                                  //         color: Colors.grey,
                                  //         fontFamily: 'Roboto',
                                  //         fontSize: 15,
                                  //       ),
                                  //     ),
                                  //     TextButton(
                                  //       style: TextButton.styleFrom(
                                  //         backgroundColor: turquoise,
                                  //       ),
                                  //       child: Text(
                                  //         'Sign Up',
                                  //         style: TextStyle(
                                  //           fontWeight: FontWeight.w900,
                                  //           decoration: TextDecoration.underline,
                                  //           fontSize: _width * 0.033,
                                  //           color: Colors.white
                                  //         ),
                                  //       ),
                                  //       onPressed: () {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) => const SignUp(),
                                  //           ),
                                  //         );
                                  //       },
                                  //     ),
                                  //   ],
                                  // ),
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
