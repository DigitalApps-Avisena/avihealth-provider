import 'dart:convert';
import 'dart:io';

import 'package:avihealth_provider/Profile/profile.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:avihealth_provider/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  final storage = const FlutterSecureStorage();

  dynamic _height;
  dynamic _width;

  var name;
  var email;
  var phone;

  String? selectedImagePath;
  String? _base64Image;

  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    credential();
    _loadProfilePhoto();

  }

  credential() async {
    // name = await storage.read(key: 'username');
    name = 'Dr. John Doe';
    phone = await storage.read(key: 'phone');

    setState(() {
      controllerName.text = name;
      controllerEmail.text = 'test@avisena.com.my';
      controllerPhone.text = phone;
    });
  }

  Future<void> _saveProfilePhoto(File file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);
    await storage.write(key: 'profile_photo', value: base64Image);
    setState(() {
      _base64Image = base64Image;
      image = file;
    });
  }

  Future<void> _loadProfilePhoto() async {
    final base64Image = await storage.read(key: 'profile_photo');
    if (base64Image != null) {
      setState(() {
        _base64Image = base64Image;
        image = File.fromRawPath(base64Decode(base64Image));
      });
    }
    // await storage.delete(key: 'profile_photo');
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _saveProfilePhoto(file);
    }
  }

  Future<void> selectImage() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'Select Image From :',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await _pickImage(ImageSource.gallery);
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                Icon(Icons.photo_camera_back_outlined, size: 60),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await _pickImage(ImageSource.camera);
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                Icon(Icons.camera_alt_outlined, size: 60),
                                Text('Camera'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _gallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    setState(() {
      if(pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  _camera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
    setState(() {
      if(pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "My Account",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _height * 0.05,
            ),
            Center(
              child: InkWell(
                onTap: selectImage,
                child: CircleAvatar(
                  backgroundImage: image != null
                      ? FileImage(image!)
                      : (_base64Image != null
                      ? MemoryImage(base64Decode(_base64Image!))
                      : const AssetImage('assets/images/demo_image.jpg') as ImageProvider),
                  radius: 80,
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text('Name'),
                    ],
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  TextFormField(
                    controller: controllerName,
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: turquoise,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: turquoise,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Text('Email'),
                    ],
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  TextFormField(
                    controller: controllerEmail,
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: turquoise,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: turquoise,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Text('Phone'),
                    ],
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  TextFormField(
                    controller: controllerPhone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: turquoise,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: turquoise,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
        child: ElevatedButton(
          onPressed: () {
            // _postData();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
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
    );
  }
}
