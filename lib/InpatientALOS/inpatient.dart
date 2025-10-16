import 'dart:convert';

import 'package:avihealth_provider/InpatientALOS/episode_details.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http show post;
import 'package:intl/intl.dart';

class Inpatient extends StatefulWidget {
  const Inpatient({Key? key, required this.locationCode}) : super(key: key);
  final String locationCode;

  @override
  State<Inpatient> createState() => _InpatientState();
}

class _InpatientState extends State<Inpatient> {

  Map<String, dynamic>? inpatientData;
  DateTime _selectedDate = DateTime.now();

  final storage = const FlutterSecureStorage();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    fetchInpatient();
  }

  Future<void> fetchInpatient() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/listCurrentInpatient');

    final Map<String, dynamic> body = {
      'trakcareCode': storedCode,
      'hospital': widget.locationCode,
    };

    try {
      final response = await http.post(uri, body: body);
      print('terst ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          inpatientData = jsonDecode(response.body);
          print('start $inpatientData');
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inpatient',
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : inpatientData!['code'] != '1'
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
        child: ListView(
          children: [
            SizedBox(height: _height * 0.02),
            ...((inpatientData!['listWard'] as List? ?? []).map((wardData) {
              final wardMap = wardData as Map<String, dynamic>? ?? {};
              String ward = wardMap['ward'] ?? 'Unknown Ward';
              List patients = wardMap['listPatient'] as List? ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: _height * 0.02
                      ),
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
                    final patient = p as Map<String, dynamic>? ?? {};
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
                                          fontFamily: 'Roboto'
                                      ),
                                    ),
                                    SizedBox(height: _height * 0.005),
                                    Text(
                                      "Room Number: ${patient['roomNo'] ?? '-'}",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'Roboto'
                                      ),
                                    ),
                                    SizedBox(height: _height * 0.005),
                                    Text(
                                      "LOS: ${patient['los'] ?? '-'}",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'Roboto'
                                      ),
                                    ),
                                    SizedBox(height: _height * 0.005),
                                    Text(
                                      "admission ID: ${patient['admissionID'] ?? '-'}",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'Roboto'
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                    Icons.arrow_forward_ios_rounded ,
                                    size: _width  * 0.05,
                                    color: Colors.black
                                ),
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
    );
  }
}