import 'dart:convert';

import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http show post;
import 'package:intl/intl.dart';

class OperationTheatre extends StatefulWidget {
  const OperationTheatre({Key? key, required this.locationCode}) : super(key: key);
  final String locationCode;

  @override
  State<OperationTheatre> createState() => _OperationTheatreState();
}

class _OperationTheatreState extends State<OperationTheatre> {
  DateTime _selectedDate = DateTime.now();

  dynamic _height;
  dynamic _width;

  final storage = const FlutterSecureStorage();

  var totalBooked = 0;
  var totalArrived = 0;
  var totalDone = 0;
  var otData;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    fetchOT();
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
              dialogBackgroundColor: Colors.white),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        fetchOT();
      });
    }
  }

  Future<void> fetchOT() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getOtDetail');
    final String dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    final Map<String, dynamic> body = {
      'date': dateStr,
      // 'trakcareCode': storedCode,
      'trakcareCode': 'PHY11',
      'hospital': widget.locationCode,
    };

    try {
      final response = await http.post(uri, body: body);
      print('terst ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          otData = jsonDecode(response.body);
          totalBooked = otData!['totalBooked'];
          totalArrived = otData!['totalArrived'];
          totalDone = otData!['totalDone'];
          print('start $otData');
          loading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
    DateFormat('EEE, MMM d').format(_selectedDate);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Operation Theatre',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: turquoise,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: _width * 0.05,
          ),
        ),
        elevation: 20,
      ),
      body: SingleChildScrollView(
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
                children: [
                  _buildSummaryCard("Total\nBooked", totalBooked),
                  SizedBox(width: _width * 0.05),
                  _buildSummaryCard("Total\nArrived", totalArrived),
                  SizedBox(width: _width * 0.05),
                  _buildSummaryCard("Total\n  Done  ", totalDone),
                ],
              ),
            ),
            // SizedBox(height: _height * 0.03),
            loading
                ? const Center(child: CircularProgressIndicator())
                : (otData == null || otData!['code'] != '1')
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: _height * 0.2,
                      ),
                      Icon(
                        Icons.data_exploration_rounded,
                        color: Colors.grey.shade500,
                        size: _width * 0.25,
                      ),
                      Text(
                        'No Data For Inpatient',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _width * 0.035,
                          fontFamily: 'Roboto',
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                )
                : Padding(
              padding:
              EdgeInsets.symmetric(horizontal: _width * 0.05),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(height: _height * 0.02),
                  ...((otData!['listOtRoom'] as List? ?? []).map(
                          (wardData) {
                        final wardMap =
                            wardData as Map<String, dynamic>? ?? {};
                        String ward = wardMap['otRoom'] ?? 'Unknown Ward';
                        List patients =
                            wardMap['listPatient'] as List? ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: _height * 0.02),
                                child: Text(
                                  ward,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _width * 0.045,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: _height * 0.01),
                            ...patients.map((p) {
                              final patient =
                                  p as Map<String, dynamic>? ?? {};
                              return SizedBox(
                                width: double.infinity,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 3,
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
                                    child: Padding(
                                      padding: EdgeInsets.all(_width * 0.04),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "MRN: ${patient['mrn'] ?? '-'}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                    fontFamily: 'Roboto'),
                                              ),
                                              SizedBox(height: _height * 0.005),
                                              Text(
                                                "Episode Number: ${patient['episode'] ?? '-'}",
                                                style:
                                                TextStyle(color: Colors.grey[700], fontFamily: 'Roboto'),
                                              ),
                                              SizedBox(height: _height * 0.005),
                                              Text(
                                                "OT Time: ${patient['otTime'] ?? '-'}",
                                                style:
                                                TextStyle(color: Colors.grey[700], fontFamily: 'Roboto'),
                                              ),
                                              // SizedBox(height: _height * 0.005),
                                              // Text(
                                              //   "Status: ${patient['otStatus'] ?? '-'}",
                                              //   style:
                                              //   TextStyle(color: Colors.grey[700], fontFamily: 'Roboto'),
                                              // ),
                                            ],
                                          ),
                                          // Icon(Icons.arrow_forward_ios_rounded,
                                          //     size: _width * 0.05, color: Colors.black),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int value) {
    return GestureDetector(
      onTap: () {},
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
                value.toString(),
                style: TextStyle(
                    fontSize: _width * 0.08,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: _width * 0.03,
                    fontFamily: 'Roboto',
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}