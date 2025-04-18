import 'package:animate_do/animate_do.dart';
import 'package:avihealth_provider/ForgetPassword/forgot_password.dart';
import 'package:avihealth_provider/Sign%20Up/sign_up.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:avihealth_provider/home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

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
  var password;

  final formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();

  bool _passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCredential();
  }

  fetchCredential() async {
    // await storage.write(key: 'username', value: 'test');
    // await storage.write(key: 'password', value: '1234');
    // await storage.write(key: 'phone', value: '+60123456789');
    username = await storage.read(key: 'username');
    password = await storage.read(key: 'password');
    print('passsword $password');
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
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
                height: _height * 0.1,
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
                  height: _height * 0.75,
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
                            '\nAvihealth Provider',
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
                                        style: TextButton.styleFrom(
                                          primary: Colors.grey,
                                        ),
                                        child: Text(
                                          'Forgot Your Password?',
                                          style: TextStyle(
                                            fontSize: _width * 0.033,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.underline,
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
                                    color: turquoise,
                                    child: MaterialButton(
                                      minWidth: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                      onPressed: controllerEmail.text == username && controllerPassword.text == password ? () {
                                        login();
                                      } : () {
                                        AwesomeDialog(
                                          padding: const EdgeInsets.all(20),
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.topSlide,
                                          showCloseIcon: true,
                                          title: "Incorrect Credentials",
                                          btnOkColor: turquoise,
                                          btnOkText: "Okay",
                                          desc:
                                          "The email or password you entered is incorrect.",
                                          btnOkOnPress: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const Login(),
                                              ),
                                            );
                                          },
                                        ).show();
                                      },
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
                                        style: TextButton.styleFrom(
                                          primary: turquoise,
                                        ),
                                        child: const Text(
                                          'Biometric Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () {
                                          authenticateWithBiometrics();
                                        },
                                      ),
                                      Lottie.asset(
                                        'assets/images/biometric_auth.json',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Don\'t have an account?',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Roboto',
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: turquoise,
                                        ),
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              decoration: TextDecoration.underline,
                                              fontSize: _width * 0.033
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SignUp(),
                                            ),
                                          );
                                        },
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
