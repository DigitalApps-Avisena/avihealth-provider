import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OperationTheatre extends StatefulWidget {
  const OperationTheatre({Key? key}) : super(key: key);

  @override
  State<OperationTheatre> createState() => _OperationTheatreState();
}

class _OperationTheatreState extends State<OperationTheatre> {

  dynamic _height;
  dynamic _width;

  bool expand1 = false;
  bool expand2 = false;
  bool expand3 = false;
  bool expand4 = false;
  bool expand5 = false;
  bool expand6 = false;
  bool expand7 = false;
  bool expand8 = false;
  bool expand9 = false;

  String selectedData = 'ASH';

  DateTime _selectedDate = DateTime.now();

  void showASHData() {
    setState(() {
      selectedData = 'ASH';
    });
  }

  void showAWCSHData() {
    setState(() {
      selectedData = 'AWCSH';
    });
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
          'Operation Theatre',
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
        child: Column(
          children: [
            SizedBox(
              height: _height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Card(
                  // shadowColor: Colors.grey,
                  // elevation: 10,
                  // color: const Color(0xFF40e0d0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                        color: turquoise,
                        width: 2
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: _height * 0.02),
                      // Text(
                      //   '     Select Date',
                      //   style: TextStyle(fontSize: _width * 0.035),
                      // ),
                      // SizedBox(
                      //   height: _height * 0.01,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '   $formattedDate',
                            style: TextStyle(
                              fontSize: _width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: _width * 0.03),
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                size: _width * 0.07,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:12.0),
              child: Card(
                color: Constants.skyblue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: showASHData,
                      child: Card(
                        color: selectedData == 'ASH'
                            ? Colors.white
                            : Constants.skyblue,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: _width * 0.15, vertical: _width * 0.02),
                          child: const Text(
                            'ASH'
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: showAWCSHData,
                      child: Card(
                        color: selectedData == 'AWCSH'
                            ? Colors.white
                            : Constants.skyblue,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: _width * 0.15, vertical: _width * 0.02),
                          child: const Text(
                            'AWCSH'
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            selectedData == 'ASH' ?
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:12.0),
                  child: Card(
                    child: Column(
                      children: [
                        Card(
                          color: Constants.skyblue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                      'Booked'
                                  ),
                                  SizedBox(
                                    height: _height * 0.02,
                                  ),
                                  const Text(
                                    '18',
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                      'Arrived'
                                  ),
                                  SizedBox(
                                    height: _height * 0.02,
                                  ),
                                  const Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                      'Done'
                                  ),
                                  SizedBox(
                                    height: _height * 0.02,
                                  ),
                                  const Text(
                                    '18',
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand1 = true;
                              expand2 = false;
                              expand3 = false;
                              expand4 = false;
                              expand5 = false;
                              expand6 = false;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'NURSE COUNTER OT',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand1 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand1 = false;
                              expand2 = true;
                              expand3 = false;
                              expand4 = false;
                              expand5 = false;
                              expand6 = false;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT1',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand2 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand1 = false;
                              expand2 = false;
                              expand3 = true;
                              expand4 = false;
                              expand5 = false;
                              expand6 = false;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT2',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand3 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand1 = false;
                              expand2 = false;
                              expand3 = false;
                              expand4 = true;
                              expand5 = false;
                              expand6 = false;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT3',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand4 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand1 = false;
                              expand2 = false;
                              expand3 = false;
                              expand4 = false;
                              expand5 = true;
                              expand6 = false;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding( 
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT4',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand5 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand1 = false;
                              expand2 = false;
                              expand3 = false;
                              expand4 = false;
                              expand5 = false;
                              expand6 = true;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT5',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand6 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _height * 0.03,
                ),
              ],
            ) : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:12.0),
                  child: Card(
                    child: Column(
                      children: [
                        Card(
                          color: Constants.skyblue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                      'Booked'
                                  ),
                                  SizedBox(
                                    height: _height * 0.02,
                                  ),
                                  const Text(
                                    '9',
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                      'Arrived'
                                  ),
                                  SizedBox(
                                    height: _height * 0.02,
                                  ),
                                  const Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                      'Done'
                                  ),
                                  SizedBox(
                                    height: _height * 0.02,
                                  ),
                                  const Text(
                                    '9',
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand7 = true;
                              expand8 = false;
                              expand9 = false;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT1',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand7 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand7 = false;
                              expand8 = true;
                              expand9 = false;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT2',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand8 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              expand7 = false;
                              expand8 = false;
                              expand9 = true;
                            });
                          },
                          child: Card(
                            color: Constants.skyblue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'OT2',
                                  ),
                                  Text(
                                    '3',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(expand9 == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: const [
                                            Text(
                                              '09:00AM',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: _width * 0.05),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'M0044618 - IP0241675  Current',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                              Text(
                                                'Dr. Loganathan A/L ATHANABI',
                                                style: TextStyle(
                                                  fontSize: _width * 0.035,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _height * 0.03,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
