import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:avihealth_provider/Widgets/const.dart';

class NewPatientYTD extends StatefulWidget {
  const NewPatientYTD({Key? key, required this.locationCode}) : super(key: key);
  final String locationCode;

  @override
  State<NewPatientYTD> createState() => _NewPatientYTDState();
}

class _NewPatientYTDState extends State<NewPatientYTD> {
  dynamic _height;
  dynamic _width;

  final Map<String, List<Map<String, String>>> monthlyPatients = {};
  final Map<String, bool> isLoadingMonth = {};
  final storage = const FlutterSecureStorage();
  List<String> expandedMonths = [];

  var trakCareCode;
  var yearlyTotal;
  String selectedYear = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final String currentMonthYear = DateFormat('MMMM yyyy').format(now);
    expandedMonths.add(currentMonthYear);
    fetchPatientsForMonth(now.month, now.year);
    fetchYearlyPatientCount();
  }

  Future<void> fetchPatientsForMonth(int month, int year) async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final String key = '${DateFormat('MMMM').format(DateTime(year, month))} $year';

    setState(() {
      isLoadingMonth[key] = true;
      trakCareCode = storedCode ?? '';
    });

    final dateFrom = DateFormat('dd/MM/yyyy').format(DateTime(year, month, 1));
    final dateTo = DateFormat('dd/MM/yyyy').format(
      month == DateTime.now().month && year == DateTime.now().year
          ? DateTime.now()
          : DateTime(year, month + 1, 0),
    );

    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getNewPatient');
    final Map<String, dynamic> body = {
      "dateFrom": dateFrom,
      "dateToo": dateTo,
      "trakcareCode": trakCareCode,
      "hospital" : widget.locationCode
    };

    try {
      final response = await http.post(
        uri,
        body: body,
      );
      final data = jsonDecode(response.body);

      List<Map<String, String>> listPatients = [];
      print('sembang $data');

      if (data['listPatient'] != null) {
        for (var item in data['listPatient']) {
          listPatients.add({
            'name': item['patientMRN'] ?? '',
            'mrn': item['patientName'] ?? '',
            'date': item['registerDate'] ?? '',
          });
        }
      }

      setState(() {
        monthlyPatients[key] = listPatients;
        isLoadingMonth[key] = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        monthlyPatients[key] = [];
        isLoadingMonth[key] = false;
      });
    }
  }

  Future<void> fetchYearlyPatientCount() async {
    final storedCode = await storage.read(key: 'trakcareCode');
    final String dateFrom = "01/01/$selectedYear";
    final String dateTo = "31/12/$selectedYear";

    setState(() {
      trakCareCode = storedCode ?? '';
    });

    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/getNewPatient');
    final Map<String, dynamic> body = {
      "dateFrom": dateFrom,
      "dateToo": dateTo,
      "trakcareCode": trakCareCode,
      "hospital" : widget.locationCode
    };

    try {
      final response = await http.post(
        uri,
        body: body,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> patients = json['listPatient'] ?? [];

        print('haha $patients');

        final validPatients = patients.where((p) =>
        p['patientMRN'] != null &&
            p['patientName'] != null &&
            p['registerDate'] != null
        ).toList();
        print('gores $validPatients');
        setState(() {
          yearlyTotal = validPatients.length;
          print('sabjek $yearlyTotal');
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching yearly patient count: $e');
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    final currentYear = DateTime.now().year;
    int tempSelectedYear = int.parse(selectedYear);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: DateTime(tempSelectedYear),
              selectedDate: DateTime(tempSelectedYear),
              onChanged: (DateTime dateTime) {
                setState(() {
                  selectedYear = dateTime.year.toString();
                  monthlyPatients.clear();
                  expandedMonths.clear();
                  fetchYearlyPatientCount();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    final now = DateTime.now();
    final currentMonth = selectedYear == now.year.toString() ? now.month : 12;
    final monthOrder = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final List<String> monthsOfYear = List.generate(
      currentMonth,
          (i) => '${monthOrder[currentMonth - i - 1]} $selectedYear',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Patient YTD', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
        child: Column(
          children: [
            SizedBox(height: _height * 0.02),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _selectYear(context),
                        child: Card(
                          color: const Color(0xFFc5e5ed),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _width * 0.05,
                              vertical: _height * 0.015,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedYear,
                                  style: TextStyle(
                                    fontSize: _width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: _width * 0.025),
                                Icon(Icons.calendar_month_rounded, color: turquoise, size: _width * 0.07),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ...monthsOfYear.map((monthKey) {
                    final patients = monthlyPatients[monthKey] ?? [];
                    final isLoading = isLoadingMonth[monthKey] ?? false;
                    final isExpanded = expandedMonths.contains(monthKey);

                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(10),
                        // side: const BorderSide(color: turquoise, width: 1.5),
                      ),
                      // elevation: 2,
                      child: ExpansionTile(
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            if (expanded) {
                              expandedMonths.add(monthKey);
                              if (!monthlyPatients.containsKey(monthKey)) {
                                final split = monthKey.split(' ');
                                final monthIndex = monthOrder.indexOf(split[0]) + 1;
                                final year = int.parse(split[1]);
                                fetchPatientsForMonth(monthIndex, year);
                              }
                            } else {
                              expandedMonths.remove(monthKey);
                            }
                          });
                        },
                        tilePadding: EdgeInsets.symmetric(horizontal: _width * 0.04),
                        title: Text(
                          monthKey,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.05,
                            color: Colors.black,
                          ),
                        ),

                        trailing: isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : isExpanded
                            ? Text(
                          '${patients.length}',
                          style: TextStyle(fontSize: _width * 0.04, color: Colors.black),
                        )
                            : const SizedBox.shrink(),
                        children: isLoading
                            ? [SizedBox(height: _height * 0.02)]
                            : patients.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          Map<String, String> patient = entry.value;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _width * 0.04,
                              vertical: _height * 0.001,
                            ),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                // borderRadius: BorderRadius.circular(15),
                                // side: const BorderSide(color: turquoise, width: 1.5),
                              ),
                              elevation: 1,
                              child: Padding(
                                padding: EdgeInsets.all(_width * 0.04),
                                child: Row(
                                  children: [
                                    // Text(
                                    //   '$index.',
                                    //   style: TextStyle(
                                    //     fontSize: _width * 0.04,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    SizedBox(width: _width * 0.03),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            patient['name']!,
                                            style: TextStyle(
                                              fontSize: _width * 0.04,
                                              fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                fontFamily: 'Roboto'
                                            ),
                                          ),
                                          SizedBox(height: _height * 0.01),
                                          Text(
                                            patient['date']!,
                                            style: TextStyle(
                                              fontSize: _width * 0.037,
                                              color: Colors.grey.shade600,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: _height * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: _height * 0.08,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: turquoise, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Year New Patient: ',
                style: TextStyle(
                  fontSize: _width * 0.04,
                  fontFamily: 'Roboto'
                ),
              ),
              Text(
                '  $yearlyTotal  ',
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
    );
  }
}