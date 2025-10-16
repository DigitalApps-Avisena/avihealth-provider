import 'dart:convert';

import 'package:avihealth_provider/Login/login.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController controllerDoctorID = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  dynamic _width;
  dynamic _height;

  var password;

  final storage = const FlutterSecureStorage();

  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  bool _passwordVisible3 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    credential();
  }

  credential() async {
    password = await storage.read(key: 'password');
    print('lek $password');
  }

  changePassword() async {
    var doctorID = controllerDoctorID.text;
    var password = controllerPassword.text;
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/changePassword');

    final Map<String, dynamic> body = {
      "doctorID": doctorID,
      "password": password,
    };

    try {
      final response = await http.post(
          uri,
          body: body
      );
      final data = jsonDecode(response.body);
      print('apa $data');
      print('dasd ${data['code']}');

      if(data['code'] == '1') {
        print('siapp');
        await storage.deleteAll();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } else if (data['code'] == '01') {
        AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Wrong Doctor ID",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Change password fail, doctor ID not found",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePassword(),
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
          title: "Password Empty",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Change password fail, password is empty",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePassword(),
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
          title: "Internal Error",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Change password fail, internal error",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePassword(),
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
                builder: (context) => const ChangePassword(),
              ),
            );
          },
        ).show();
      }
    } catch (e) {
      print('salah');
    }
  }

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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: turquoise,
          title: Text(
            "Change Password",
            style: TextStyle(
                fontSize: _width * 0.05,
                fontFamily: 'WorkSans',
                color: Colors.white
            ),
          ),
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
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFf8fbfc),
                Color(0xFFe8f4f8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.08),
              child: Column(
                children: [
                  SizedBox(height: _height * 0.06),
                  // Header Icon
                  Container(
                    height: _width * 0.25,
                    width: _width * 0.25,
                    decoration: BoxDecoration(
                      color: turquoise.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(_width * 0.125),
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      color: turquoise,
                      size: _width * 0.12,
                    ),
                  ),
                  SizedBox(height: _height * 0.03),
                  // Title and subtitle
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: _width * 0.065,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'WorkSans',
                    ),
                  ),
                  SizedBox(height: _height * 0.01),
                  Text(
                    'Enter your Doctor ID and new password to update your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _width * 0.038,
                      color: Colors.black54,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: _height * 0.05),
                  // Form fields
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor ID Field
                          Text(
                            'Doctor ID',
                            style: TextStyle(
                              fontSize: _width * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: _height * 0.012),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: controllerDoctorID,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: turquoise,
                                  size: _width * 0.06,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: _height * 0.022,
                                  horizontal: _width * 0.04,
                                ),
                                hintText: "Enter your Doctor ID",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontFamily: 'Roboto',
                                  fontSize: _width * 0.038,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(
                                fontSize: _width * 0.04,
                                fontFamily: 'Roboto',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.03),
                          // New Password Field
                          Text(
                            'New Password',
                            style: TextStyle(
                              fontSize: _width * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: _height * 0.012),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: controllerPassword,
                              obscureText: !_passwordVisible2,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: turquoise,
                                  size: _width * 0.06,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible2
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey.shade500,
                                    size: _width * 0.06,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible2 = !_passwordVisible2;
                                    });
                                  },
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: _height * 0.022,
                                  horizontal: _width * 0.04,
                                ),
                                hintText: "Enter your new password",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontFamily: 'Roboto',
                                  fontSize: _width * 0.038,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(
                                fontSize: _width * 0.04,
                                fontFamily: 'Roboto',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.02),
                          // Password requirements info
                          Container(
                            padding: EdgeInsets.all(_width * 0.04),
                            decoration: BoxDecoration(
                              color: turquoise.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: turquoise.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: turquoise,
                                  size: _width * 0.05,
                                ),
                                SizedBox(width: _width * 0.03),
                                Expanded(
                                  child: Text(
                                    'Make sure your new password is secure and different from your previous password.',
                                    style: TextStyle(
                                      fontSize: _width * 0.035,
                                      color: turquoise.withOpacity(0.8),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: _height * 0.04),
                          // Save Button integrated in body
                          Container(
                            width: double.infinity,
                            height: _height * 0.07,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  turquoise,
                                  turquoise.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: turquoise.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  changePassword();
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _width * 0.045,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.03),
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
    );
  }
}