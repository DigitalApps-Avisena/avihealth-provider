import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}) : super(key: key);

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {

  dynamic _height;
  dynamic _width;

  final Map<String, List<Map<String, String>>> monthlyPatients = {
    'February 2025': [
      {'id': 'M00442545', 'name': 'MARK ALI QAYYUM BIN MARK FAKHRI QAYYUM'},
      {'id': 'M00149214', 'name': 'AHMAD KHAKI'},
      {'id': 'M00343434', 'name': 'ROLISA MANORAB'},
    ]
  };

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Patient',
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
        child: ListView.builder(
          itemCount: monthlyPatients.keys.length,
          itemBuilder: (context, monthIndex) {
            String month = monthlyPatients.keys.elementAt(monthIndex);
            List<Map<String, String>> patients = monthlyPatients[month]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _height * 0.05),
                  child: Text(
                    month,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _width * 0.05,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: _height * 0.02),
                ...patients.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Map<String, String> patient = entry.value;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(_width * 0.04),
                      child: Row(
                        children: [
                          // Text(
                          //   '$index.',
                          //   style: const TextStyle(
                          //     fontWeight: FontWeight.bold
                          //   ),
                          // ),
                          SizedBox(width: _width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient['id']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  height: _height * 0.005
                                ),
                                Text(
                                  patient['name']!,
                                  style: TextStyle(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}