import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClinicHour extends StatefulWidget {
  const ClinicHour({Key? key}) : super(key: key);

  @override
  State<ClinicHour> createState() => _ClinicHourState();
}

class _ClinicHourState extends State<ClinicHour> {

  DateTime _selectedDate = DateTime.now();

  dynamic _height;
  dynamic _width;

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
          'Clinic Hour',
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
            // SizedBox(
            //   height: _height * 0.03,
            // ),

            // Center(
            //   child: Card(
            //     elevation: 5,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(14.0),
            //       child: Column(
            //         children: [
            //           const CircleAvatar(
            //             backgroundImage: AssetImage('assets/images/demo_image.jpg'),
            //             radius: 50,
            //           ),
            //           SizedBox(
            //             height: _height * 0.04,
            //           ),
            //           Text(
            //             'Ayu Sleeping Ayu Sleeping Brother John',
            //             style: TextStyle(
            //               fontFamily: 'Roboto',
            //               fontSize: _width * 0.04,
            //               fontWeight: FontWeight.bold
            //             ),
            //           ),
            //           SizedBox(
            //             height: _height * 0.02,
            //           ),
            //           const Text(
            //             'Heart and Lung Specialist Unit',
            //             style: TextStyle(
            //               fontFamily: 'Roboto'
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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
            SizedBox(
              height: _height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'This Week',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: _width * 0.04
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.05,
                    ),
                    Text(
                      'This Month',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: _width * 0.04
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('35 Hours'),
                    SizedBox(
                      height: _height * 0.05,
                    ),
                    const Text('120 Hours'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
