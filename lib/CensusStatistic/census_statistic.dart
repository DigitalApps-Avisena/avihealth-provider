import 'dart:convert';

import 'package:avihealth_provider/Discharge/discharge.dart';
import 'package:avihealth_provider/Admission/admission.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CensusStatistic extends StatefulWidget {
  const CensusStatistic({Key? key, required this.locationCode}) : super(key: key);
  final String locationCode;

  @override
  State<CensusStatistic> createState() => _CensusStatisticState();
}

class _CensusStatisticState extends State<CensusStatistic> {

  dynamic _height;
  dynamic _width;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _patientKey = GlobalKey();
  final storage = const FlutterSecureStorage();

  var totalPatient;
  var totalAdmission;
  var totalDischarge;
  var outPatient;
  var arrive;
  var seen;
  var monthlyOutpatient;
  var currentInpatient;
  var alos;
  var dayCare;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    fetchCensusStatistic();
    fetchTotalAdmission();
    fetchTotalDischarge();
  }

  fetchCensusStatistic() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getTotalPatient');
    final String dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    final Map<String, dynamic> body = {
      'date': dateStr,
      'trakcareCode': storedCode,
      'hospital': widget.locationCode,
    };

    final response = await http.post(uri, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        // dailyOutpatient
        final dailyOutpatient = data['dailyOutpatient'] ?? [];
        if (dailyOutpatient.isNotEmpty) {
          final item = dailyOutpatient.first;
          outPatient = item['total'] ?? 0;
          arrive = item['arrive'] ?? 0;
          seen = item['seen'] ?? 0;
        }

        // monthlyOutpatient (sekarang integer terus)
        monthlyOutpatient = data['monthlyOutpatient'] ?? 0;

        // currentInpatient
        final currentIn = data['currentInpatient'] ?? [];
        if (currentIn.isNotEmpty) {
          final item = currentIn.first;
          currentInpatient = item['total'] ?? 0;
          alos = item['ALOS'] ?? 0;
        }

        if(alos == 'No data') {
          setState(() {
            alos = '0';
          });
        }

        // dayCare (sekarang integer terus)
        dayCare = data['dayCare'] ?? 0;

        // total patient = outpatient + inpatient + daycare (kalau nak kira)
        totalPatient = (outPatient ?? 0) + (currentInpatient ?? 0) + (dayCare ?? 0);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  fetchTotalAdmission() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getTotalAdmission');
    final String dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    final Map<String, dynamic> body = {
      'date' : dateStr,
      'trakcareCode': storedCode,
      'hospital': widget.locationCode,
    };

    try {
      final response = await http.post(uri, body: body);
      print('terst ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          var admissionDataTO = jsonDecode(response.body);
          print('hwasa $admissionDataTO');
          totalAdmission = admissionDataTO['totalAdmission'];
          print('ss $totalAdmission');
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  fetchTotalDischarge() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getTotalDischarge');
    final String dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    final Map<String, dynamic> body = {
      'date' : '15/08/2025',
      'trakcareCode': 'SURG 9',
      'hospital': widget.locationCode,
    };

    try {
      final response = await http.post(uri, body: body);
      print('terst ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          var dischargeDataTO = jsonDecode(response.body);
          print('hwasa $dischargeDataTO');
          totalDischarge = dischargeDataTO['totalDischarge'];
          print('ss $totalDischarge');
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: turquoise,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
      fetchCensusStatistic();
    }
  }

  @override
  Widget build(BuildContext context) {

    final String formattedDate = DateFormat('EEE, MMM d').format(_selectedDate);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Census and Statistics',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: turquoise,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: _width * 0.05),
        ),
        elevation: 20,
      ),
      backgroundColor: const Color(0xFFf4f9fa),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(height: _height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Card(
                  color: const Color(0xFFc5e5ed),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _height * 0.02,
                      horizontal: _width * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                          style: TextStyle(
                            fontSize: _width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.calendar_month_rounded, color: turquoise, size: _width * 0.07),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: _width * 0.05,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15),),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [turquoise, Constants.skyblue],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(_width * 0.07),
                        child: Column(
                          children: [
                            Text(
                              totalPatient == null? '0' : totalPatient.toString(),
                              style: TextStyle(
                                fontSize: _width * 0.08,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            Text(
                              'Total\n  Patient  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: _width * 0.03,
                                  fontFamily: 'Roboto',
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Admission(
                            locationCode: widget.locationCode
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [turquoise, Constants.skyblue],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(_width * 0.07),
                        child: Column(
                          children: [
                            Text(
                              totalAdmission == null? '0' : totalAdmission.toString(),
                              style: TextStyle(
                                fontSize: _width * 0.08,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            Text(
                              'Total\nAdmission',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _width * 0.03,
                                fontFamily: 'Roboto',
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Discharge(
                              locationCode: widget.locationCode
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [turquoise, Constants.skyblue],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(_width * 0.07),
                        child: Column(
                          children: [
                            Text(
                              totalDischarge == null? '0' : totalDischarge.toString(),
                              style: TextStyle(
                                  fontSize: _width * 0.08,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            Text(
                              'Total\nDischarge',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _width * 0.03,
                                fontFamily: 'Roboto',
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: _height * 0.03,
            ),

            Padding(
              key: _patientKey,
              padding: EdgeInsets.symmetric(horizontal: _width * 0.04,),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.grey.shade200, Colors.white],
                      stops: const [0.5, 1.0, 1.5],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      bottom: BorderSide(
                        color: widget.locationCode == '1' ? turquoise : violet,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * 0.1, vertical: _height * 0.015),
                        child: Row(
                          children: [
                            Text(
                              'Daily Outpatient',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: _width * 0.035
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '     '
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          Text(
                            outPatient == null? '0' : outPatient.toString(),
                            style: TextStyle(
                              fontSize: _width * 0.1,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                arrive == null? 'Arrive: 0' : 'Arrive: ${outPatient.toString()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _width * 0.03,
                                  fontFamily: 'Roboto',
                                  // color: Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                seen == null? 'Seen: 0' : 'Seen: ${seen.toString()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _width * 0.03,
                                  fontFamily: 'Roboto',
                                  // color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.04,),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.grey.shade200, Colors.white],
                      stops: const [0.5, 1.0, 1.5],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      bottom: BorderSide(
                        color: widget.locationCode == '1' ? turquoise : violet,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * 0.1, vertical: _height * 0.015),
                        child: Row(
                          children: [
                            Text(
                              'Monthly Outpatient',
                              style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: _width * 0.035
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              '     '
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          Text(
                            monthlyOutpatient == null? '0' : monthlyOutpatient.toString(),
                            style: TextStyle(
                              fontSize: _width * 0.1,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '          ',
                              ),
                              Text(
                                '          ',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.04,),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.grey.shade200, Colors.white],
                      stops: const [0.5, 1.0, 1.5],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      bottom: BorderSide(
                        color: widget.locationCode == '1' ? turquoise : violet,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * 0.1, vertical: _height * 0.015),
                        child: Row(
                          children: [
                            Text(
                              'Current Inpatient',
                              style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: _width * 0.035
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              '     '
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          Text(
                            currentInpatient == null? '0' : currentInpatient.toString(),
                            style: TextStyle(
                              fontSize: _width * 0.1,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          Text(
                            alos == null? 'ALOS: 0' : 'ALOS: ${alos.toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: _width * 0.03,
                              fontFamily: 'Roboto',
                              // color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: _width * 0.04,),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.grey.shade200, Colors.white],
                      stops: const [0.5, 1.0, 1.5],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      bottom: BorderSide(
                        color: widget.locationCode == '1' ? turquoise : violet,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * 0.1, vertical: _height * 0.015),
                        child: Row(
                          children: [
                            Text(
                              'Daycare',
                              style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: _width * 0.035
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              '     '
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          Text(
                            dayCare == null? '0' : dayCare.toString(),
                            style: TextStyle(
                              fontSize: _width * 0.1,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: _width * 0.05,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '          ',
                              ),
                              Text(
                                '          ',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: _height * 0.03),
          ],
        ),
      ),
    );
  }
}