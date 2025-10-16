import 'dart:convert';
import 'dart:io';

import 'package:avihealth_provider/Login/login.dart';
import 'package:avihealth_provider/Profile/components/change_password.dart';
import 'package:avihealth_provider/Profile/components/my_account.dart';
import 'package:avihealth_provider/Profile/components/privacy_policy.dart';
import 'package:avihealth_provider/Profile/components/term_of_use.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:avihealth_provider/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  File? image;

  dynamic _height;
  dynamic _width;

  var opacity = 0.0;
  String? name;
  var email;
  var profileImage;

  final storage = const FlutterSecureStorage();

  bool position = false;

  String? _base64Image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // credential();
    Future.delayed(Duration.zero, () {
      animator();

      setState(() {});
    });
    _loadProfilePhoto();
  }

  // Future<void> _loadProfilePhoto() async {
  //   // print('sdd');
  //   // final base64Image = await storage.read(key: 'image');
  //   // print('adsdsa $_base64Image');
  //   // if (base64Image != null) {
  //   //   setState(() {
  //   //     _base64Image = base64Image;
  //   //     image = File.fromRawPath(base64Decode(base64Image));
  //   //   });
  //   // }
  //
  //   // await storage.delete(key: 'profile_photo');
  // }

  Future<void> _loadProfilePhoto() async {
    final storedName = await storage.read(key: 'name');
    final storedEmail = await storage.read(key: 'email');
    final storedImage = await storage.read(key: 'image');

    setState(() {
      name = storedName;
      email = storedEmail;

      if (storedImage != null && storedImage.startsWith('data:image')) {
        final base64Str = storedImage.split(',').last;
        final bytes = base64Decode(base64Str);
        image = File.fromRawPath(bytes);
        _base64Image = storedImage;
      } else if (storedImage != null && storedImage.startsWith('http')) {
        profileImage = storedImage;
      }
    });
  }

  credential() async {
    name = await storage.read(key: 'name');
  }

  animator() {
    if (opacity == 1) {
      opacity = 0;
      position = false;
    } else {
      opacity = 1;
      position = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: turquoise,
          title: Text(
            "Profile",
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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: _width * 0.05,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // borderRadius: const BorderRadius.all(Radius.circular(15)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Constants.skyblue,turquoise],
              stops: const [0.2, 1.0],
            ),
          ),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          //     Color(0xFFA92389),
          //     Color(0xFF2290AA),
          //     Color(0xFF2290AA),
          //   ],
          //   ),
          // ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(//box on top of background
                margin: EdgeInsets.only(top: _height / 3.7),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1.0),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    )
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: _height * 0.15,
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                        elevation: 10,
                        child: SizedBox(
                          width: _width * 0.80,
                          child: ListTile(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyAccount()
                                ),
                              );
                            },
                            leading: const Icon(Icons.person, color: turquoise),
                            title: const Text(
                              'My Account',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'WorkSans',
                              ),
                            ),
                            trailing: const Wrap(
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_right_rounded
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                        elevation: 10,
                        child: SizedBox(
                          width: _width * 0.80,
                          child: ListTile(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChangePassword()
                                ),
                              );
                            },
                            leading: const Icon(Icons.password, color: turquoise),
                            title: const Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'WorkSans',
                              ),
                            ),
                            trailing: const Wrap(
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_right_rounded
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                        elevation: 10,
                        child: SizedBox(
                          width: _width * 0.80,
                          child: ListTile(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TermOfUse(),
                                ),
                              );
                            },
                            leading: const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: turquoise
                            ),
                            title: const Text(
                              'Term Of Use',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'WorkSans',
                              ),
                            ),
                            trailing: const Wrap(
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_right_rounded
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                        elevation: 10,
                        child: SizedBox(
                          width: _width * 0.80,
                          child: ListTile(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy(),
                                ),
                              );
                            },
                            leading: const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: turquoise
                            ),
                            title: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'WorkSans',
                              ),
                            ),
                            trailing: const Wrap(
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_right_rounded
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                        elevation: 10,
                        child: SizedBox(
                          width: _width * 0.80,
                          child: ListTile(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            leading: const Icon(Icons.logout, color: turquoise),
                            title: const Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'WorkSans',
                              ),
                            ),
                            trailing: const Wrap(
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_right_rounded
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * 0.18),
                padding: const EdgeInsets.symmetric(horizontal: 1),
                width: 350,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(20)),
                  color: Colors.white.withOpacity(0.90),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 5.0), //(x,y)
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'WorkSans'
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5,),
                        Text(
                          email ?? '',
                          style: const TextStyle(
                            fontSize: 17.5,
                            color: Colors.black54,
                            fontFamily: 'WorkSans',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    // const Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       '+60 12 3456789',
                    //       style: TextStyle(
                    //         fontSize: 17.5,
                    //         color: Colors.black54,
                    //         fontFamily: 'Roboto',
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
              Container(//profile image
                height: 145, width: 145,
                margin: EdgeInsets.only(top: _height * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  border: Border.all(width: 1.5, color: const Color(0xFFFFFFFF)),
                  image: DecorationImage(
                    // image: image != null
                    //     ? FileImage(image!)
                    //     : (_base64Image != null)
                    //     ? NetworkImage(profileImage)
                    //     : const AssetImage('assets/images/demo_image.jpg') as ImageProvider,
                    image: image != null
                        ? FileImage(image!)
                        : (_base64Image != null && _base64Image!.startsWith('data:image'))
                        ? MemoryImage(base64Decode(_base64Image!.split(',').last))
                        : (profileImage != null && profileImage!.startsWith('http'))
                        ? NetworkImage(profileImage!)
                        : const AssetImage('assets/images/demo_image.jpg') as ImageProvider,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 5.0), //(x,y)
                      blurRadius: 8.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}
