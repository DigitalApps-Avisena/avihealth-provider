import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';

class ScheduledAppointment extends StatefulWidget {
  const ScheduledAppointment({Key? key}) : super(key: key);

  @override
  State<ScheduledAppointment> createState() => _ScheduledAppointmentState();
}

class _ScheduledAppointmentState extends State<ScheduledAppointment> {

  final DateTime _selectedDate = DateTime(2024, 10, 28);

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

  dynamic _height;
  dynamic _width;

  final Map<DateTime, List<Map<String, String>>> _dummyData = {
    DateTime(2024, 10, 28): [
      {'time': '9:00 am', 'code': 'M00442545', 'name': 'MARK ALI QAYYUM BIN MARK FAKHRI QAYYUM', 'status': 'Seen'},
      {'time': '11:00 am', 'code': 'M00442567', 'name': 'LATIRA HAKIMAH', 'status': 'Waiting'},
    ],
    DateTime(2024, 10, 29): [
      {'time': '10:00 am', 'code': 'M00442546', 'name': 'JONATHAN FEBRUARY', 'status': 'Arrived'},
      {'time': '2:30 pm', 'code': 'M00442323', 'name': 'LEONA MAY', 'status': 'Seen'},
      {'time': '4:00 pm', 'code': 'M00478990', 'name': 'FABRESE JOY', 'status': 'Waiting'},
      {'time': '8:00 pm', 'code': 'M00477878', 'name': 'RIDSECT WANGI', 'status': ''},
    ],
    DateTime(2024, 11, 1): [
      {'time': '11:00 am', 'code': 'M00442547', 'name': 'LATIPA BINTI ABU', 'status': 'Arrived'},
    ],
    DateTime(2024, 11, 25): [
      {'time': '9:00 am', 'code': 'M00442545', 'name': 'MARK ALI QAYYUM BIN MARK FAKHRI QAYYUM', 'status': 'Seen'},
      {'time': '11:00 am', 'code': 'M00442567', 'name': 'LATIRA HAKIMAH', 'status': 'Waiting'},
    ],
    DateTime(2024, 11, 28): [
      {'time': '9:00 am', 'code': 'M00442545', 'name': 'MARK ALI QAYYUM BIN MARK FAKHRI QAYYUM', 'status': 'Seen'},
      {'time': '11:00 am', 'code': 'M00442567', 'name': 'LATIRA HAKIMAH', 'status': 'Waiting'},
    ]
  };

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    List<Map<String, String>> appointments = _dummyData[DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today\'s Appointments',
          style: TextStyle(
            color: turquoise,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: turquoise,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: _height * 0.07,
              bottom: _height * 0.01,
              left: _width * 0.05
            ),
            child: Text(
              '7 February 2025',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _width * 0.05,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final timeParts = appointment['time']?.split(' ') ?? [''];
                final hour = timeParts[0];
                final period = timeParts.length > 1 ? timeParts[1] : '';
                final status = appointment['status'] ?? 'Unknown';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4
                  ),
                  child: SizedBox(
                    height: _height * 0.12,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.grey,
                      child: Row(
                        children: [
                          SizedBox(
                            width: _width * 0.18,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hour,
                                  style: TextStyle(
                                    fontSize: _width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: turquoise,
                                  ),
                                ),
                                Text(
                                  period,
                                  style: TextStyle(
                                    fontSize: _width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: turquoise,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(color: Colors.black, thickness: 2),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment['code'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    appointment['name'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: _width * 0.04),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: _width * 0.04,
                                color: getStatusColor(appointment['status'] ?? ''),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
