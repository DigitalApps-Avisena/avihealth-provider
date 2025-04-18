import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';

class CensusStatistic extends StatefulWidget {
  const CensusStatistic({Key? key}) : super(key: key);

  @override
  State<CensusStatistic> createState() => _CensusStatisticState();
}

class _CensusStatisticState extends State<CensusStatistic> {

  dynamic _height;
  dynamic _width;

  int? _expandedIndex = 0;

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 16 : 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget tableCellWithSubData(String mainData, [String? subData1, String? subData2]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            mainData,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: turquoise,
            ),
            textAlign: TextAlign.center,
          ),
          if (subData1 != null) ...[
            const SizedBox(height: 4),
            Text(
              subData1,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
          if (subData2 != null) ...[
            Text(
              subData2,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Census and Statistics',
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
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(
                  title: Text("Total of Today's Patients"),
                );
              },
              body: Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Patients Overview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(2),  // Type column is wider
                        1: FlexColumnWidth(1),  // ASH
                        2: FlexColumnWidth(1),  // AWCSH
                      },
                      children: [
                        TableRow(
                          children: [
                            tableCell('Type', isHeader: true),
                            tableCell('ASH', isHeader: true),
                            tableCell('AWCSH', isHeader: true),
                          ],
                        ),
                        TableRow(
                          children: [
                            tableCell('Daily Outpatient'),
                            tableCellWithSubData('9', 'Arrive: 7', 'Seen: 2'), // ASH
                            tableCellWithSubData('3', 'Arrive: 2', 'Seen: 1'), // AWCSH
                          ],
                        ),
                        TableRow(
                          children: [
                            tableCell('Monthly Outpatient'),
                            tableCell('50'),
                            tableCell('0'),
                          ],
                        ),
                        TableRow(
                          children: [
                            tableCell('Current Inpatient'),
                            tableCellWithSubData('1', 'ALOS: 2.00'), // ASH
                            tableCellWithSubData('0', 'ALOS: 0.00'), // AWCSH
                          ],
                        ),
                        TableRow(
                          children: [
                            tableCell('Daycare'),
                            tableCell('2'),
                            tableCell('0'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isExpanded: _expandedIndex == 0,
            ),
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(
                  title: Text("Total of Admission"),
                );
              },
              body: Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '5',
                                  style: TextStyle(
                                    color: turquoise,
                                    fontSize: _width * 0.05
                                  ),
                                ),
                                SizedBox(
                                  height: _height * 0.02,
                                ),
                                const Text(
                                  'Total Admission',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300
                                  ),
                                )
                              ],
                            ),
                            Image.asset(
                              'assets/icons/admission.png',
                              width: _width * 0.1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        title: Text('Abdullah Kasim'),
                        subtitle: Text('OT1'),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        title: Text('Abdul Kerim bin Fadlulmin Auf'),
                        subtitle: Text('OT3'),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        title: Text('Fakhri Rozaidi bin Manaf'),
                        subtitle: Text('OT1'),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        title: Text('Nanalina Mas Akid'),
                        subtitle: Text('OT2'),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        title: Text('Noor Farahin'),
                        subtitle: Text('OT4'),
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded: _expandedIndex == 1,
            ),
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(
                  title: Text("Total of Discharge"),
                );
              },
              body: Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '20',
                                  style: TextStyle(
                                      color: turquoise,
                                      fontSize: _width * 0.05
                                  ),
                                ),
                                SizedBox(
                                  height: _height * 0.02,
                                ),
                                const Text(
                                  'Total Discharge',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300
                                  ),
                                )
                              ],
                            ),
                            Image.asset(
                              'assets/icons/discharge.png',
                              width: _width * 0.1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded: _expandedIndex == 2,
            ),
          ],
        ),
      ),
    );
  }
}