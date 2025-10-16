import 'package:avihealth_provider/Widgets/const.dart';
import 'package:flutter/material.dart';

class EpisodeDetails extends StatefulWidget {
  const EpisodeDetails({Key? key, this.name}) : super(key: key);
  final String? name;

  @override
  State<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {

  dynamic _height;
  dynamic _width;

  var mrn;
  var episodeNo;
  var admissionDate;
  var dischargeDate;
  var payor;
  var notes;

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Episode Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: turquoise,
        centerTitle: true,
        iconTheme: const IconThemeData(
            color: Colors.white
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
      backgroundColor: const Color(0xFFf4f9fa),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _width * 0.05,
          vertical: _height * 0.05
        ),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(
                _width * 0.1
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MRN',
                    style: TextStyle(
                      color: turquoise,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Text(
                    'AAS032934',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.03,
                  ),
                  Text(
                    'Name',
                    style: TextStyle(
                        color: turquoise,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Text(
                    widget.name.toString(),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.03,
                  ),
                  Text(
                    'Admission Date',
                    style: TextStyle(
                        color: turquoise,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Text(
                    '4 February 2025',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.03,
                  ),
                  Text(
                    'Discharge Date',
                    style: TextStyle(
                        color: turquoise,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Text(
                    '6 February 2025',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.03,
                  ),
                  Text(
                    'Payor',
                    style: TextStyle(
                        color: turquoise,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Text(
                    'MARK FAKHRI QAYYUM BIN ABU HAS',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.03,
                  ),
                  Text(
                    'Notes',
                    style: TextStyle(
                        color: turquoise,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Text(
                    'Dengue, no serious injury',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: _width * 0.04
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
