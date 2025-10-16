import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClinicHour extends StatefulWidget {
  const ClinicHour({Key? key, required this.locationCode}) : super(key: key);
  final String locationCode;

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
