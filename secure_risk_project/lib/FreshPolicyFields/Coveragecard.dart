import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/RenewalEditCoverage.dart';
import 'package:loginapp/Service.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CardExample extends StatefulWidget {
  final VoidCallback onClose;

  CardExample({required this.onClose});
  @override
  _CardExampleState createState() => _CardExampleState();
}

List<Map<String, dynamic>> apiResponse = [];

class _CardExampleState extends State<CardExample> {
  void _clearData() {
    setState(() {
      apiResponse.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchApiData().then((data) {
      setState(() {
        apiResponse = data;
      });
    }).catchError((error) {
      ('Error fetching API data: $error');
    });
  }

  Future<List<Map<String, dynamic>>> fetchApiData() async {
    final prefs = await SharedPreferences.getInstance();
    final rfqId = prefs.getString('responseBody');
    var headers = await ApiServices.getHeaders();

    final apiUrl = Uri.parse(
        ApiServices.baseUrl + ApiServices.Coverage_EmpDepData + '$rfqId');
    final response = await http.get(apiUrl, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> apiResponse =
          decodedData.cast<Map<String, dynamic>>();
      return apiResponse;
    } else {
      throw Exception('Failed to load API data');
    }
  }

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.20;
    return Center(
      child: Container(
        width: cardWidth,
        child: Card(
          elevation: isHovered ? 8 : 4, // Add elevation based on hover state
          color: isHovered
              ? Color.fromARGB(255, 239, 241, 242)
              : Colors.white, // Change color based on hover state
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (event) {
              setState(() {
                isHovered = false;
              });
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ListTile(
                title: Text(
                  'Employee Data',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold
                  ),
                ),
                
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        // showDataTableDialog(context);
                        if (apiResponse.isNotEmpty) {
                          showDataTableDialog(context);
                        } else {
                          showNoDataDialog(context);
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        widget.onClose();
                        _clearData();
                      },
                      icon: Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showNoDataDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.infoReverse,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 2,
    ),
    width: 280,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    dismissOnTouchOutside: true,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: true,
    animType: AnimType.bottomSlide,
    title: 'INFO',
    desc: 'Loading please wait...!',
    descTextStyle: TextStyle(fontWeight: FontWeight.bold),
    showCloseIcon: true,
    btnCancelOnPress: () {
      //  Navigator.of(context).pop();
    },
    btnOkOnPress: () {
      //  Navigator.of(context).pop();
    },
  ).show();
}

void showDataTableDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Color(0xFFFFFFFF),
      surfaceTintColor: Colors.white,
      // title: Text(
      //   'Employee Data ',
      //   style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      // ),      
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Employee Data ',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: LazyLoadingDataTable(
              empDataList: apiResponse,
            ),
          ),
        ),
      ),
    ),
  );
}

class LazyLoadingDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> empDataList;

  LazyLoadingDataTable({
    required this.empDataList,
  });

  @override
  _LazyLoadingDataTableState createState() => _LazyLoadingDataTableState();
}

class _LazyLoadingDataTableState extends State<LazyLoadingDataTable> {

  // int visibleRecords =  10;//100; // Number of records initially visible
  // int increment = 100; // Number of records to load on each lazy load

    late int visibleRecords;
  int increment = 100; // Number of records to load on each lazy load

  @override
  void initState() {
    super.initState();
    visibleRecords = widget.empDataList.length;
  }


  @override
  Widget build(BuildContext context) {    
    return Column(
      children: [
        SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 25.0,
              headingRowColor: MaterialStateColor.resolveWith((states) {
                return SecureRiskColours
                    .Table_Heading_Color; // Your style here...
              }),
              columns: [
                DataColumn(
                  label: Text(
                    'S.No',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                DataColumn(
                    label: Text('Employee No',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text('EmployeeName',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(
                  'Relationship',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
                DataColumn(
                    label: Text('Gender',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text('Age',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                  label: Text(
                    'SumInsured',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                // DataColumn(
                //     label: Text(
                //   'Status',
                //   style: GoogleFonts.poppins(
                //       fontWeight: FontWeight.bold, color: Colors.white),
                // )), // Add the "Actions" column
              ],
              // rows: widget.empDataList.take(visibleRecords).map((data) {
              rows: List<DataRow>.generate(
                visibleRecords,
                (index) {
                  if (index < widget.empDataList.length) {
                    Map<String, dynamic> data = widget.empDataList[index];

                    return DataRow(
                      cells: [
                        // DataCell(Text(data['id'].toString())),
                        DataCell(Text((index + 1).toString())),

                        DataCell(Text(data['employeeId'])),
                        DataCell(Text(data['employeeName'])),
                        DataCell(Text(data['relationship'])),
                        DataCell(Text(data['gender'])),
                        DataCell(Text(data['age'].toString())),
                        DataCell(Text(data['sumInsured'].toString())),
                      ],
                    );
                  } else {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(''), // Placeholder for additional cells
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
        ElevatedButton(
          style: SecureRiskColours.customButtonStyle(),
          onPressed: () {
            setState(() {
              visibleRecords += increment;
              if (visibleRecords >= widget.empDataList.length) {
                visibleRecords = widget.empDataList.length;
              }
            });
          },
          child: shouldShowLoadMore()
              ? Text('Load More',
                  style: GoogleFonts.poppins(color: Colors.white))
              : Text('End', style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }

  bool shouldShowLoadMore() {
    return visibleRecords < widget.empDataList.length;
  }
}
