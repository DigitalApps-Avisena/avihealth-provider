import 'package:avihealth_provider/Login/login.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController controllerOldPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();

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
    if(controllerOldPassword.text == password) {
      if(controllerNewPassword.text == controllerConfirmPassword.text) {
        await storage.write(key: 'password', value: controllerNewPassword.text);
        return AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Success",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Please Login With Your New Password.",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              )
            );
          },
        ).show();
      } else {
        return AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Re-enter New Pasword",
          btnOkColor: turquoise,
          btnOkText: "Okay",
          desc:
          "Password Does Not Match.",
          btnOkOnPress: () {
            // Navigator.of(context).pop();
          },
        ).show();
      }
    } else {
      return AwesomeDialog(
        padding: const EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Wrong Current Password",
        btnOkColor: turquoise,
        btnOkText: "Okay",
        desc:
        "Please fill right current password to change your password",
        btnOkOnPress: () {
          // Navigator.of(context).pop();
        },
      ).show();
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
          backgroundColor: Colors.white,
          title: Text(
            "Change Password",
            style: TextStyle(
              fontSize: _width * 0.05,
              fontFamily: 'WorkSans',
              color: turquoise
            ),
          ),
          iconTheme: const IconThemeData(
            color: turquoise
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
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text('Current Password'),
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      TextFormField(
                        controller: controllerOldPassword,
                        obscureText: !_passwordVisible1,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible1 ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                              size: _width * 0.06,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible1 = !_passwordVisible1;
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text('New Password'),
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      TextFormField(
                        controller: controllerNewPassword,
                        obscureText: !_passwordVisible2,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                              size: _width * 0.06,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible2 = !_passwordVisible2;
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Text('Confirm New Password'),
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      TextFormField(
                        controller: controllerConfirmPassword,
                        obscureText: !_passwordVisible3,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible3 ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                              size: _width * 0.06,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible3 = !_passwordVisible3;
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
          child: ElevatedButton(
            onPressed: () {
              changePassword();
              // _postData();
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddDependents(name: widget.name, email: widget.email, phone: widget.phone)));
            },
            child: const Text(
              'Save',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: turquoise,
              padding: EdgeInsets.all(_width * 0.05),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
