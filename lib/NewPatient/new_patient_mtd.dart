import 'dart:convert';

import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http show post;
import 'package:intl/intl.dart';
import 'package:screen_protector/screen_protector.dart';

class NewPatientMTD extends StatefulWidget {
  const NewPatientMTD({Key? key, this.locationCode}) : super(key: key);
  final String? locationCode;

  @override
  State<NewPatientMTD> createState() => _NewPatientMTDState();
}

class _NewPatientMTDState extends State<NewPatientMTD> with WidgetsBindingObserver {
  dynamic _height;
  dynamic _width;

  final storage = const FlutterSecureStorage();

  var trakCareCode;
  var newPatient;

  bool isLoading = true;
  bool isProtectionEnabled = false;

  String monthYear = '';
  String patientMRN = '';
  String patientName = '';
  String registerDate = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Enable screen protection when page loads
    _enableScreenProtection();
    fetchPatientList();
  }

  @override
  void dispose() {
    // Remove observer and disable protection when leaving page
    WidgetsBinding.instance.removeObserver(this);
    _disableScreenProtection();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
      // Re-enable protection when app comes back to foreground
        if (mounted) {
          _enableScreenProtection();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      // Keep protection active when app goes to background
        break;
      case AppLifecycleState.detached:
        _disableScreenProtection();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Enable screen protection
  Future<void> _enableScreenProtection() async {
    try {
      await ScreenProtector.protectDataLeakageOn();
      setState(() {
        isProtectionEnabled = true;
      });
      print('Screen protection enabled for NewPatientMTD');

      // Show a brief snackbar to inform user (optional)
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Screenshot protection is active'),
        //     duration: Duration(seconds: 2),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      }
    } catch (e) {
      print('Failed to enable screen protection: $e');
      setState(() {
        isProtectionEnabled = false;
      });
    }
  }

  /// Disable screen protection
  Future<void> _disableScreenProtection() async {
    try {
      await ScreenProtector.protectDataLeakageOff();
      setState(() {
        isProtectionEnabled = false;
      });
      print('Screen protection disabled for NewPatientMTD');
    } catch (e) {
      print('Failed to disable screen protection: $e');
    }
  }

  /// Alternative: Enable protection with blur effect (Android only)
  Future<void> _enableScreenProtectionWithBlur() async {
    try {
      await ScreenProtector.protectDataLeakageWithBlur();
      setState(() {
        isProtectionEnabled = true;
      });
      print('Screen protection with blur enabled');
    } catch (e) {
      print('Failed to enable screen protection with blur: $e');
    }
  }

  /// Alternative: Enable protection with color overlay (Android only)
  Future<void> _enableScreenProtectionWithColor() async {
    try {
      // Use a semi-transparent black overlay
      await ScreenProtector.protectDataLeakageWithColor(const Color(0x80000000));
      setState(() {
        isProtectionEnabled = true;
      });
      print('Screen protection with color enabled');
    } catch (e) {
      print('Failed to enable screen protection with color: $e');
    }
  }

  fetchPatientList() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedNow = formatter.format(now);
    String formattedStartOfMonth = formatter.format(startOfMonth);
    monthYear = DateFormat('MMMM yyyy').format(now);

    setState(() {
      trakCareCode = storedCode ?? '';
    });

    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getNewPatient');
    final Map<String, dynamic> body = {
      "dateFrom": formattedStartOfMonth,
      "dateToo": formattedNow,
      "trakcareCode": trakCareCode,
      "hospital" : widget.locationCode
    };
    try {
      final response = await http.post(
        uri,
        body: body,
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
        newPatient = listPatients;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        newPatient = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Disable protection before popping
        await _disableScreenProtection();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text(
                'New Patient MTD',
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
              Spacer(),
              // Optional: Show protection status icon
              // if (isProtectionEnabled)
              //   const Icon(
              //     Icons.security,
              //     color: Colors.white,
              //     size: 20,
              //   ),
            ],
          ),
          backgroundColor: turquoise,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () async {
              // Disable protection before navigating back
              await _disableScreenProtection();
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: _width * 0.05,
            ),
          ),
          elevation: 20,
          actions: [
            // Optional: Toggle protection button for testing
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'normal':
                    await _enableScreenProtection();
                    break;
                  case 'blur':
                    await _enableScreenProtectionWithBlur();
                    break;
                  case 'color':
                    await _enableScreenProtectionWithColor();
                    break;
                  case 'disable':
                    await _disableScreenProtection();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'normal',
                  child: Text('Normal Protection'),
                ),
                const PopupMenuItem(
                  value: 'blur',
                  child: Text('Blur Protection'),
                ),
                const PopupMenuItem(
                  value: 'color',
                  child: Text('Color Protection'),
                ),
                const PopupMenuItem(
                  value: 'disable',
                  child: Text('Disable Protection'),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFFf4f9fa),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: ListView(
            children: [
              // Protection status indicator (optional)
              // if (isProtectionEnabled)
              //   Container(
              //     margin: const EdgeInsets.only(bottom: 10),
              //     padding: const EdgeInsets.symmetric(
              //         horizontal: 12, vertical: 8),
              //     decoration: BoxDecoration(
              //       color: Colors.green.shade100,
              //       borderRadius: BorderRadius.circular(8),
              //       border: Border.all(color: Colors.green.shade300),
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(Icons.security,
              //             color: Colors.green.shade700, size: 16),
              //         const SizedBox(width: 8),
              //         Text(
              //           'Screen protection is active',
              //           style: TextStyle(
              //             color: Colors.green.shade700,
              //             fontSize: _width * 0.035,
              //             fontFamily: 'Roboto',
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),

              // Always show the monthYear title
              Padding(
                padding: EdgeInsets.only(
                    top: _height * 0.01, left: _width * 0.02),
                child: Text(
                  monthYear,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _width * 0.04,
                    color: Colors.black87,
                    fontFamily: 'Monserrat',
                  ),
                ),
              ),

              if (newPatient == null || newPatient.isEmpty)
                Center(
                  child: Text(
                    'No new patients this month.',
                    style: TextStyle(
                        fontSize: _width * 0.045,
                        color: Colors.black54,
                        fontFamily: 'Roboto'),
                  ),
                )
              else
                ...newPatient.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Map<String, String> patient = entry.value;

                  return Card(
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(15),
                    ),
                    // elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(_width * 0.04),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient['mrn']!,
                                  style: TextStyle(
                                      fontSize: _width * 0.04,
                                      color: Colors.black87,
                                      fontFamily: 'Roboto'),
                                ),
                                SizedBox(height: _height * 0.01),
                                Text(
                                  patient['date']!,
                                  style: TextStyle(
                                      fontSize: _width * 0.037,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Roboto'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

              SizedBox(height: _height * 0.2),
            ],
          ),
        ),
        bottomSheet: newPatient == null
            ? null
            : Container(
          height: _height * 0.08,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: turquoise,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Month New Patient  : ',
                  style: TextStyle(
                    fontSize: _width * 0.04,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  '  ${newPatient.length}  ',
                  style: TextStyle(
                    fontSize: _width * 0.0425,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: turquoise,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}