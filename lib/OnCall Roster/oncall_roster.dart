import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OncallRoster extends StatefulWidget {
  const OncallRoster({Key? key}) : super(key: key);

  @override
  State<OncallRoster> createState() => _OncallRosterState();
}

class _OncallRosterState extends State<OncallRoster> {

  DateTime _selectedDate = DateTime.now();

  dynamic _height;
  dynamic _width;

  bool showAshDataList = false;
  bool showAwcshDataList = false;
  bool isLoading = true;

  String selectedData = 'ASH';

  List<Map<String, String>> ASHDataList = [
    {'specialist' : 'ANAESTHESIOLOGIST', 'name' : 'DR MUHD HILMI', 'ext' : '*0804'},
    {'specialist' : 'ANAESTHESIOLOGIST', 'name' : 'DR HOI YA HUI', 'ext' : '*0805'},
    {'specialist' : 'ANAESTHESIOLOGIST', 'name' : 'DR PANASTHIARIAWAN', 'ext' : '*0806'},
  ];

  List<Map<String, String>> AWCSHDataList = [
    {'specialist' : 'ANAESTHESIOLOGIST', 'name' : 'DR NUR IZZAH', 'ext' : '*1901'},
    {'specialist' : 'ANAESTHESIOLOGIST', 'name' : 'DR YONG TAU FOO', 'ext' : '*1902'},
    {'specialist' : 'ANAESTHESIOLOGIST', 'name' : 'DR TIAHSHE', 'ext' : '*1903'},
  ];

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

  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView();
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
          'On-Call Roster',
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
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://avisena.com.my/web/roster/specialistAppRoster.php',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (url) {
              setState(() {
                isLoading = false;
              });
            },
            onWebViewCreated: (controller) {
              controller.runJavascript(
                "navigator.userAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Mobile/14E5239e Safari/602.1';"
              );
            },
          ),
          isLoading ?
          const Center(
            child: CircularProgressIndicator(),
          ) : Container(),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.all(12.0),
      //         child: GestureDetector(
      //           onTap: () => _selectDate(context),
      //           child: Card(
      //             shadowColor: Colors.grey,
      //             elevation: 10,
      //             color: Constants.lightpurple,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(20),
      //             ),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 SizedBox(height: _height * 0.02),
      //                 Text(
      //                   '     Select Date',
      //                   style: TextStyle(fontSize: _width * 0.035),
      //                 ),
      //                 SizedBox(
      //                   height: _height * 0.01,
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(
      //                       '   $formattedDate',
      //                       style: TextStyle(fontSize: _width * 0.05, fontWeight: FontWeight.bold),
      //                     ),
      //                     Padding(
      //                       padding: EdgeInsets.only(right: _width * 0.03),
      //                       child: GestureDetector(
      //                         onTap: () => _selectDate(context),
      //                         child: Icon(
      //                           Icons.calendar_month_rounded,
      //                           size: _width * 0.05,
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(height: _height * 0.02),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal:12.0),
      //         child: Card(
      //           color: Constants.lightpurple,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //               GestureDetector(
      //                 onTap: showASHData,
      //                 child: Card(
      //                   color: selectedData == 'ASH'
      //                       ? Colors.white
      //                       : Constants.lightpurple,
      //                   child: Padding(
      //                     padding: EdgeInsets.symmetric(horizontal: _width * 0.15, vertical: _width * 0.02),
      //                     child: const Text(
      //                         'ASH'
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               GestureDetector(
      //                 onTap: showAWCSHData,
      //                 child: Card(
      //                   color: selectedData == 'AWCSH'
      //                       ? Colors.white
      //                       : Constants.lightpurple,
      //                   child: Padding(
      //                     padding: EdgeInsets.symmetric(horizontal: _width * 0.15, vertical: _width * 0.02),
      //                     child: const Text(
      //                         'AWCSH'
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       (selectedData == 'ASH') ?
      //       Column(
      //         children: const [
      //           Padding(
      //             padding: EdgeInsets.symmetric(horizontal:12.0),
      //             child: Card(
      //               child: ListTile(
      //                 leading: Text(
      //                   'ANAESTHESIOLOGIST',
      //                 ),
      //                 subtitle: Text(
      //                   '*0804',
      //                 ),
      //                 title: Text(
      //                   'DR MUHD HILMI'
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.symmetric(horizontal:12.0),
      //             child: Card(
      //               child: ListTile(
      //                 leading: Text(
      //                   'ANAESTHESIOLOGIST',
      //                 ),
      //                 subtitle: Text(
      //                   '*0804',
      //                 ),
      //                 title: Text(
      //                     'DR MUHD HILMI'
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.symmetric(horizontal:12.0),
      //             child: Card(
      //               child: ListTile(
      //                 leading: Text(
      //                   'ANAESTHESIOLOGIST',
      //                 ),
      //                 subtitle: Text(
      //                   '*0804',
      //                 ),
      //                 title: Text(
      //                     'DR MUHD HILMI'
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.symmetric(horizontal:12.0),
      //             child: Card(
      //               child: ListTile(
      //                 leading: Text(
      //                   'ANAESTHESIOLOGIST',
      //                 ),
      //                 subtitle: Text(
      //                   '*0804',
      //                 ),
      //                 title: Text(
      //                     'DR MUHD HILMI'
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.symmetric(horizontal:12.0),
      //             child: Card(
      //               child: ListTile(
      //                 leading: Text(
      //                   'ANAESTHESIOLOGIST',
      //                 ),
      //                 subtitle: Text(
      //                   '*0804',
      //                 ),
      //                 title: Text(
      //                     'DR MUHD HILMI'
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.symmetric(horizontal:12.0),
      //             child: Card(
      //               child: ListTile(
      //                 leading: Text(
      //                   'ANAESTHESIOLOGIST',
      //                 ),
      //                 subtitle: Text(
      //                   '*0804',
      //                 ),
      //                 title: Text(
      //                     'DR MUHD HILMI'
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ) : const Center(),
      //     ],
      //   ),
      // ),
    );
  }
}