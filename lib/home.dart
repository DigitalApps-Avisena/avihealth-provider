import 'dart:convert';
import 'dart:io';

import 'package:avihealth_provider/Appointment/appointment.dart';
import 'package:avihealth_provider/Appointment/scheduled_appointment.dart';
import 'package:avihealth_provider/CensusStatistic/census_statistic.dart';
import 'package:avihealth_provider/ClinicHour/clinic_hour.dart';
import 'package:avihealth_provider/InpatientALOS/inpatient.dart';
import 'package:avihealth_provider/NewPatient/new_patient_mtd.dart';
import 'package:avihealth_provider/NewPatient/new_patient_ytd.dart';
import 'package:avihealth_provider/OnCall%20Roster/oncall_roster.dart';
import 'package:avihealth_provider/OperationTheatre/operation_theatre.dart';
import 'package:avihealth_provider/Profile/profile.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:avihealth_provider/testkak.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http show post;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? image;
  DateTime _selectedDate = DateTime.now();

  final storage = const FlutterSecureStorage();

  dynamic _height;
  dynamic _width;

  var totalalos = '0';
  var name;
  var profileImage;
  var trakCareCode;
  var newPatientTotal = 0;
  var appointmentTotal = 0;

  String? _base64Image;
  String selectedLocation = 'Avisena Specialist Hospital';
  String locationCode = '1';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    _loadProfilePhoto();
    fetchPatientList();
    fetchAppointments();
    fetchAlos();
  }

  Future<void> _loadProfilePhoto() async {
    final storedName = await storage.read(key: 'name');
    final storedEmail = await storage.read(key: 'email');
    final storedImage = await storage.read(key: 'image');

    setState(() {
      name = storedName ?? '';

      // If base64 image (e.g., stored from File -> base64Encode)
      if (storedImage != null && storedImage.startsWith('data:image')) {
        final base64Str = storedImage.split(',').last;
        final bytes = base64Decode(base64Str);
        image = File.fromRawPath(bytes); // Will still fail if not a path-based file
        _base64Image = storedImage;
      } else if (storedImage != null && storedImage.startsWith('http')) {
        profileImage = storedImage;
      }
    });
    // await storage.delete(key: 'profile_photo');
  }

  void _showHospitalSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                const Text(
                  'Select Hospital',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // Hospital options
                _buildHospitalOption(
                  title: 'Avisena Specialist Hospital',
                  locationCode: '1',
                ),

                const SizedBox(height: 12),

                _buildHospitalOption(
                  title: 'Avisena Women\'s & Children\'s Specialist Hospital',
                  locationCode: '2',
                ),

                const SizedBox(height: 16),

                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHospitalOption({
    required String title,
    required String locationCode,
  }) {
    final bool isSelected = selectedLocation == title;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              selectedLocation = title;
              this.locationCode = locationCode;
            });

            HapticFeedback.lightImpact();

            Future.delayed(const Duration(milliseconds: 150), () {
              fetchPatientList();
              fetchAppointments();
              fetchAlos();
              Navigator.pop(context);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Hospital title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue[900] : Colors.black87,
                    ),
                  ),
                ),

                // Selection indicator
                AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchPatientList() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedNow = formatter.format(now);
    String formattedStartOfMonth = formatter.format(startOfMonth);

    print('ha $formattedNow');
    print('haha $formattedStartOfMonth');

    setState(() {
      trakCareCode = storedCode ?? '';
    });

    final uri = Uri.parse(
        'http://10.10.0.37/avstc/appRestApiCareProvider/getNewPatient'
    );
    print('manaaa $trakCareCode');
    try {
      final response = await http.post(
          uri,
          body: {
            'dateFrom' : formattedStartOfMonth,
            'dateToo' : formattedNow,
            'trakcareCode' : trakCareCode,
            'hospital' : locationCode
          }
      );
      final data = jsonDecode(response.body);
      print('queen $data');

      List<Map<String, String>> listPatients = [];
      print('format ${data['listPatient'].length}');

      if (data['listPatient'] != null) {
        for (var item in data['listPatient']) {
          listPatients.add({
            'name': item['patientMRN'] ?? '',
            'mrn': item['patientName'] ?? '',
            'date': item['registerDate'] ?? '',
          });
        }
      }

      print('what ${listPatients.length}');

      setState(() {
        newPatientTotal = listPatients.length;
      });
    } catch (e) {
      print('Errorweh: $e');
      setState(() {
        // newPatient = [];
        // isLoading = false;
      });
    }
  }

  Future<void> fetchAppointments() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedNow = formatter.format(now);

    setState(() {
      trakCareCode = storedCode ?? '';
    });

    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getDoctorAppointment');

    final Map<String, dynamic> body = {
      "dateFrom": formattedNow,
      "dateToo": formattedNow,
      "trakcareCode": trakCareCode,
      'hospital' : locationCode
    };

    print('Sending request: $body');

    try {
      final response = await http.post(
        uri,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['listPatient'] ?? [];

        print('Decoded data: $data');
        print('diaz ${list.length}');

        appointmentTotal = list.length;

        setState(() {
        });
      } else {
        print('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  fetchAlos() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getTotalPatient');
    final String dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    final Map<String, dynamic> body = {
      'date': dateStr,
      'trakcareCode': storedCode,
      'hospital': locationCode,
    };

    final response = await http.post(uri, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        final currentIn = data['currentInpatient'] ?? [];
        if (currentIn.isNotEmpty) {
          final item = currentIn.first;
          totalalos = item['ALOS'] ?? 0;
        }
        print('sickblidn $totalalos');

        if(totalalos == 'No data') {
          setState(() {
            totalalos = '0';
          });
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
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
        backgroundColor: const Color(0xFFf4f9fa),
        body: SafeArea(
          child: Stack(
            children: [
              // SizedBox(
              //   width: double.infinity,
              //   height: double.infinity,
              // ),
              Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            // borderRadius: const BorderRadius.all(Radius.circular(15)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Constants.skyblue, turquoise],
                              stops: const [0.2, 1.0],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: _height * 0.04,
                              ),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const Profile()),
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: image != null
                                              ? FileImage(image!)
                                              : (_base64Image != null &&
                                              _base64Image!.startsWith('data:image'))
                                              ? MemoryImage(
                                              base64Decode(_base64Image!.split(',').last))
                                              : (profileImage != null &&
                                              profileImage!.startsWith('http'))
                                              ? NetworkImage(profileImage!)
                                              : const AssetImage('assets/images/demo_image.jpg')
                                          as ImageProvider,
                                          radius: 24,
                                        ),
                                      ),
                                      SizedBox(width: _width * 0.03),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name ?? '',
                                            style: TextStyle(
                                              fontSize: _width * 0.045,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSans',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                                              SizedBox(
                                                width: _width * 0.6, // control lebar
                                                child: InkWell(
                                                  onTap: () {
                                                    _showHospitalSelection();
                                                  },
                                                  child: Text(
                                                    selectedLocation,
                                                    style: TextStyle(
                                                      fontSize: _width * 0.035,
                                                      color: Colors.white,
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
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: _width * 0.03, vertical:  _height * 0.005),
                                child: Text(
                                  "Today's Overview",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: _width * 0.042
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
                      Positioned(
                        left: _width * 0.056,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/images/avisena_logo_white.png',
                              height: _height * 0.325,
                              width: _width * 1.8,
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   left: _width * 0.056,
                      //   top: 0,
                      //   right: 0,
                      //   bottom: 0,
                      //   child: IgnorePointer(
                      //     ignoring: true, // Allows taps to pass through the image
                      //     child: Opacity(
                      //       opacity: 0.3,
                      //       child: Image.asset(
                      //         'assets/images/avisena_logo_white.png',
                      //         fit: BoxFit.cover, // Ensures the image doesn't block unnecessarily
                      //         height: _height * 0.325,
                      //         width: _width * 1.8,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              Positioned(
                width: _width * 0.95,
                height: _height * 0.17,
                top: _height * 0.21,
                right: _width * 0.02,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewPatientMTD(
                                  locationCode: locationCode,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: _width * 0.24,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    newPatientTotal.toString() ?? '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'CenturyGothic',
                                      fontSize: _width * 0.125,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: _width * 0.24,
                                child: const Text(
                                  'New Patient\n(MTD)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Roboto'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScheduledAppointment(
                                  locationCode: locationCode,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: _width * 0.24,
                                child: FittedBox( // Automatically adjusts the font size
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    appointmentTotal.toString() ?? '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'CenturyGothic',
                                      fontSize: _width * 0.125,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: _width * 0.24,
                                child: const Text(
                                  'Scheduled\nAppointment',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Roboto'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Inpatient(
                                  locationCode: locationCode,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: _width * 0.24,
                                child: FittedBox( // Automatically adjusts the font size
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    totalalos,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'CenturyGothic',
                                      fontSize: _width * 0.125,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: _width * 0.24,
                                child: const Text(
                                  'Inpatient\nALOS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Roboto'
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
              Positioned.fill(
                top: _height * 0.425,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: _height * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: _width * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      SizedBox(height: _height * 0.015),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _width * 0.04,
                              vertical: _height * 0.02,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: _width * 0.04,
                                mainAxisSpacing: _height * 0.02,
                                childAspectRatio: 0.68,
                              ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                String title;
                                String image;
                                Widget navigate;

                                switch (index) {
                                  case 0:
                                    title = "New Patient (YTD)";
                                    image = "assets/icons/newpatient3.png";
                                    navigate = NewPatientYTD(locationCode: locationCode,);
                                    break;
                                  case 1:
                                    title = "Appointment";
                                    image = "assets/icons/appointment3.png";
                                    navigate = Appointment(locationCode: locationCode,);
                                    break;
                                  case 2:
                                    title = "Census & Statistic";
                                    image = "assets/icons/census3.png";
                                    navigate = CensusStatistic(locationCode: locationCode,);
                                    break;
                                  case 3:
                                    title = "Operation Theatre";
                                    image = "assets/icons/ot3.png";
                                    navigate = OperationTheatre(locationCode: locationCode,);
                                    break;
                                  case 4:
                                    title = "Professional Fees";
                                    image = "assets/icons/fees3.png";
                                    navigate = const TestKak();
                                    break;
                                  case 5:
                                    title = "On-call Roster";
                                    image = "assets/icons/oncall3.png";
                                    navigate = OncallRoster(locationCode: locationCode,);
                                    break;
                                  // case 6:
                                  //   title = "Clinic Hour";
                                  //   image = "assets/icons/clinichour3.png";
                                  //   navigate = ClinicHour(locationCode: locationCode,);
                                  //   break;
                                  default:
                                    title = "Item";
                                    image = "assets/icons/newpatient3.png";
                                    navigate = const HomePage();
                                    break;
                                }

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => navigate),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Image.asset(
                                          image,
                                          color: Color(0xFF3B4D77),
                                          width: _width * 0.1,
                                          height: _width * 0.1,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(height: _height * 0.001),
                                      Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: _width * 0.0275,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
    );
  }
}