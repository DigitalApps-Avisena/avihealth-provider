import 'dart:convert';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key, required this.locationCode}) : super(key: key);
  final String locationCode;

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, String>> appointments = [];
  final storage = const FlutterSecureStorage();

  dynamic _height;
  dynamic _width;

  var trakCareCode;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    fetchAppointments(); // Load initial data
  }

  String convertToAmPm(String time24h) {
    try {
      final time = DateFormat("HH:mm:ss").parse(time24h);
      return DateFormat("h:mm a").format(time);
    } catch (e) {
      return '';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Waiting':
        return const Color(0xFFFFCE1B);
      case 'Arrived':
        return const Color(0xFF305CDE);
      case 'Seen':
        return const Color(0xFF4CBB17);
      default:
        return Colors.grey;
    }
  }

  Future<void> fetchAppointments() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getDoctorAppointment');
    final String dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    setState(() {
      trakCareCode = storedCode ?? '';
    });

    final Map<String, dynamic> body = {
      "dateFrom": dateStr,
      "dateToo": dateStr,
      "trakcareCode": trakCareCode,
      "hospital" : widget.locationCode
    };

    try {
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['listPatient'] ?? [];

        setState(() {
          appointments = list.map<Map<String, String>>((item) {
            return {
              'mrn': item['patientMRN'] ?? '',
              'name': item['patientName'] ?? '',
              'time': convertToAmPm(item['admissionTime'] ?? ''),
              'status': item['admissionType'] ?? '',
            };
          }).toList();
        });
      } else {
        print('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
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
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
      fetchAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('d MMMM yyyy').format(_selectedDate);
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment', style: TextStyle(color: Colors.white)),
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
      body: Container(
        color: const Color(0xFFf4f9fa),
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
            SizedBox(height: _height * 0.015),
            Expanded(
              child: appointments.isEmpty
                  ? Center(
                child: Text(
                  'No appointments',
                  style: TextStyle(
                    fontSize: _width * 0.045,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemCount: appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  final timeParts = appointment['time']?.split(' ') ?? [''];
                  final hour = timeParts[0];
                  final period = timeParts.length > 1 ? timeParts[1] : '';
                  final status = appointment['status'] ?? 'Unknown';
                  final isLast = index == appointments.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Timeline section
                        SizedBox(
                          width: _width * 0.08,
                          child: Column(
                            children: [
                              // Timeline dot
                              Container(
                                width: 10,
                                height: 9,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: turquoise
                                ),
                              ),
                              // Timeline line (don't show for last item)
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 1,
                                    color: turquoise,
                                    margin: const EdgeInsets.only(top: 4),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Content section
                        Expanded(
                          child: Container(
                            height: _height * 0.06,
                            margin: EdgeInsets.only(left: _width * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: _width * 0.04),
                                // Time display
                                SizedBox(
                                  width: _width * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$hour $period',
                                        style: TextStyle(
                                          fontSize: _width * 0.04,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // MRN display
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      appointment['mrn'] != '' ? appointment['mrn'] ?? '' : 'New Patient',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: _width * 0.045,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: _width * 0.04),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}