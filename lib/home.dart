import 'dart:convert';
import 'dart:io';

import 'package:avihealth_provider/Appointment/appointment.dart';
import 'package:avihealth_provider/Appointment/scheduled_appointment.dart';
import 'package:avihealth_provider/CensusStatistic/census_statistic.dart';
import 'package:avihealth_provider/ClinicHour/clinic_hour.dart';
import 'package:avihealth_provider/InpatientALOS/inpatient.dart';
import 'package:avihealth_provider/NewPatient/new_patient.dart';
import 'package:avihealth_provider/OnCall%20Roster/oncall_roster.dart';
import 'package:avihealth_provider/OperationTheatre/operation_theatre.dart';
import 'package:avihealth_provider/Profile/profile.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:avihealth_provider/testkak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? image;

  final storage = const FlutterSecureStorage();

  dynamic _height;
  dynamic _width;

  var totalpatient = '3';
  var totalappointment = '2';
  var totalalos = '2.8';

  String? _base64Image;
  String selectedLocation = 'Avisena Specialist Hospital';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    print('sdd');
    final base64Image = await storage.read(key: 'profile_photo');
    print('adsdsa $_base64Image');
    if (base64Image != null) {
      setState(() {
        _base64Image = base64Image;
        image = File.fromRawPath(base64Decode(base64Image));
        print('goggog $_base64Image');
      });
    }
    // await storage.delete(key: 'profile_photo');
  }

  void _showHospitalSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Hospital',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: const Text('Avisena Specialist Hospital'),
                leading: Radio<String>(
                  value: 'Avisena Specialist Hospital',
                  groupValue: selectedLocation,
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    selectedLocation = 'Avisena Specialist Hospital';
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: const Text('Avisena Women\'s & Children\'s Specialist Hospital'),
                leading: Radio<String>(
                  value: 'Avisena Women\'s & Children\'s Specialist Hospital',
                  groupValue: selectedLocation,
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    selectedLocation = 'Avisena Women\'s & Children\'S Specialist Hospital';
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
              Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: turquoise,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: _width * 0.05, vertical: _height * 0.02),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const Profile()));
                                          },
                                          child: CircleAvatar(
                                            backgroundImage: image != null
                                              ? FileImage(image!)
                                              : (_base64Image != null)
                                              ? MemoryImage(base64Decode(_base64Image!))
                                              : const AssetImage('assets/images/demo_image.jpg') as ImageProvider,
                                            radius: 24,
                                          ),
                                        ),
                                        SizedBox(width: _width * 0.03),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: _width * 0.5,
                                              child: Text(
                                                'Hi, Dr. John Doe',
                                                style: TextStyle(
                                                  fontSize: _width * 0.045,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'WorkSans',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: _height * 0.01),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: _width * 0.04,
                                                ),
                                                SizedBox(width: _width * 0.02),
                                                InkWell(
                                                  onTap: () {
                                                    _showHospitalSelection();
                                                  },
                                                  child: SizedBox(
                                                    width: _width * 0.4,
                                                    child: Text(
                                                      selectedLocation,
                                                      style: TextStyle(
                                                        fontSize: _width * 0.035,
                                                        color: Colors.yellow,
                                                        fontFamily: 'WorkSans',
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                        size: _width * 0.06,
                                      ),
                                      SizedBox(
                                        width: _width * 0.05,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
                                child: Text(
                                  "Today's Overview",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w100,
                                    fontSize: _width * 0.04
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: _height * 0.12
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          'assets/images/avisena_logo_white.png',
                          height: _height * 0.2,
                          width: _width * 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                width: _width * 0.9,
                height: _height * 0.2,
                top: _height * 0.15,
                right: _width * 0.05,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewPatient(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: _width * 0.24,
                              child: Text(
                              totalpatient,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: turquoise,
                                  fontSize: _width * 0.15,
                                ),
                              ),
                            ),
                            SizedBox(height: _height * 0.02),
                            SizedBox(
                              width: _width * 0.24,
                              child: const Text(
                                'New\nPatient',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScheduledAppointment(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: _width * 0.24,
                              child: Text(
                                totalappointment,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: turquoise,
                                  fontSize: _width * 0.15,
                                ),
                              ),
                            ),
                            SizedBox(height: _height * 0.02),
                            SizedBox(
                              width: _width * 0.24,
                              child: const Text(
                                'Scheduled\nAppointment',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Inpatient(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: _width * 0.24,
                              child: Text(
                                totalalos,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: turquoise,
                                  fontSize: _width * 0.15,
                                ),
                              ),
                            ),
                            SizedBox(height: _height * 0.02),
                            SizedBox(
                              width: _width * 0.24,
                              child: const Text(
                                'Inpatient\nALOS',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: _height * 0.37,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: _width * 0.04,
                          ),
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: _width * 0.04,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: GridView.builder(
                            padding: EdgeInsets.only(top: _height * 0.01),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              String title;
                              String image;
                              Widget navigate;

                              switch (index) {
                                case 0:
                                  title = "New Patient";
                                  image = "assets/icons/new_patient.png";
                                  navigate = const NewPatient();
                                  break;
                                case 1:
                                  title = "Appointment";
                                  image = "assets/icons/appointment.png";
                                  navigate = const Appointment();
                                  break;
                                case 2:
                                  title = "Census and Statistic";
                                  image = "assets/icons/census_and_statistics.png";
                                  navigate = const CensusStatistic();
                                  break;
                                case 3:
                                  title = "Operation Theatre";
                                  image = "assets/icons/operation_theatre.png";
                                  navigate = const OperationTheatre();
                                  break;
                                case 4:
                                  title = "Professional Fees";
                                  image = "assets/icons/professional_fees.png";
                                  // navigate = const HomePage();
                                  navigate = const TestKak();
                                  break;
                                case 5:
                                  title = "On-call Roster";
                                  image = "assets/icons/oncall_roster.png";
                                  navigate = const OncallRoster();
                                  break;
                                case 6:
                                  title = "Clinic Hour";
                                  image = "assets/icons/clinic_hour.png";
                                  navigate = const ClinicHour();
                                  break;
                                default:
                                  title = "Item";
                                  image = "assets/icons/new_patient.png";
                                  navigate = const HomePage();
                                  break;
                              }

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => navigate,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      shadowColor: Colors.grey,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Image.asset(
                                              image,
                                              width: _width * 0.15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: _width * 0.03,
                                          fontFamily: 'WorkSans',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}