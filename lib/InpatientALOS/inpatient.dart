import 'package:avihealth_provider/InpatientALOS/episode_details.dart';
import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';

class Inpatient extends StatefulWidget {
  const Inpatient({Key? key}) : super(key: key);

  @override
  State<Inpatient> createState() => _InpatientState();
}

class _InpatientState extends State<Inpatient> {

  dynamic _height;
  dynamic _width;

  final Map<String, List<Map<String, String>>> monthlyPatients = {
    '7 February 2025': [
      {'name': 'MARK ALI QAYYUM BIN MARK FAKHRI QAYYUM', 'floor': 'Level 7', 'room': '1', 'los': '2'},
      {'name': 'ABDULLAH HUKUM', 'floor': 'Level 7', 'room': '3', 'los': '4'},
      {'name': 'SYED KARTINI BIN SYED ALHADAD', 'floor': 'Level 8', 'room': '1', 'los': '1'},
      {'name': 'YEOW RUO MING', 'floor': 'Level 8', 'room': '17', 'los': '2'},
      {'name': 'TANABATENUM', 'floor': 'Level 11', 'room': '1', 'los': '3'},
      {'name': 'LAKIMONOREL', 'floor': 'Level 11', 'room': '7', 'los': '1'},
      {'name': 'CHI CHONG CHEW', 'floor': 'Level 15', 'room': '1', 'los': '2'},
    ]
  };

  Map<String, List<Map<String, String>>> groupByFloor(List<Map<String, String>> patients) {
    Map<String, List<Map<String, String>>> groupedPatients = {};
    for (var patient in patients) {
      String floor = patient['floor'] ?? 'Unknown Floor';
      if (groupedPatients[floor] == null) {
        groupedPatients[floor] = [];
      }
      groupedPatients[floor]?.add(patient);
    }
    return groupedPatients;
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    String date = '7 February 2025';
    List<Map<String, String>> patients = monthlyPatients[date] ?? [];
    Map<String, List<Map<String, String>>> groupedPatients = groupByFloor(patients);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inpatient',
          style: TextStyle(
            color: turquoise,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
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
        elevation: 20,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: _height * 0.05),
              child: Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _width * 0.05,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: _height * 0.02),
            ...groupedPatients.entries.map((entry) {
              String floor = entry.key;
              List<Map<String, String>> patientsOnFloor = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: _height * 0.02),
                    child: Text(
                      floor,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _width * 0.045,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: _height * 0.01),
                  ...patientsOnFloor.asMap().entries.map((entry) {
                    Map<String, String> patient = entry.value;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EpisodeDetails(
                              name: patient['name'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.04),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: _height * 0.005),
                                    Text(
                                      'Room: ${patient['room']!}',
                                      style: TextStyle(color: Colors.grey[700]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: _height * 0.005),
                                    Text(
                                      'LOS: ${patient['los']!} days',
                                      style: TextStyle(color: Colors.grey[700]),
                                      overflow: TextOverflow.ellipsis,
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
                  // SizedBox(
                  //   height: _height * 0.03,
                  // ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
