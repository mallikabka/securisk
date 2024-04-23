import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'dart:convert';

class CardEditExample extends StatefulWidget {
  final VoidCallback onClose;
  final String rfqId; // Add rfqId parameter here

  CardEditExample({required this.onClose, required this.rfqId});
  @override
  _CardExampleState createState() => _CardExampleState();
}

List<Map<String, dynamic>> apiResponse = [];

class _CardExampleState extends State<CardEditExample> {
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
    var headers = await ApiServices.getHeaders();

    final apiUrl = Uri.parse(ApiServices.baseUrl +
        ApiServices.Coverage_EmpDepData +
        '${widget.rfqId}');
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
          elevation: isHovered ? 8 : 4,
          color: isHovered ? Color.fromARGB(255, 239, 241, 242) : Colors.white,
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
                      onPressed: () =>
                          editshowDataTableDialog(context, apiResponse),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: widget.onClose,
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

void editshowDataTableDialog(
    BuildContext context, List<Map<String, dynamic>> apiResponse) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Color(0xFFFFFFFF),
      surfaceTintColor: Colors.white,
      // title: Text(
      //   'Employee Data',
      //   style: GoogleFonts.poppins(
      //       color: SecureRiskColours.Table_Heading_Color,
      //       fontWeight: FontWeight.bold),
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
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) {
            return SecureRiskColours
                .Table_Heading_Color; // Set your desired header background color
          }),
          headingRowHeight: 35,
          columns: [
            DataColumn(
                label: Text(
              'S.NO',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.white),
            )),
            DataColumn(
              label: Text(
                'EmployeeNo',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Employee Name',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Relationship',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Gender',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Age',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'SumInsured',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            // DataColumn(
            //     label: Text('Actions',
            //         style: GoogleFonts.poppins(
            //             fontWeight:
            //                 FontWeight.bold))), // Add the "Actions" column
          ],
          rows: apiResponse.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            // final String gender = data[
            //     'gender']; // Assuming gender is stored as a string 'Male' or 'Female'
            // bool isMale = gender.toLowerCase() == 'male';

            return DataRow(
              color: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.hovered)) {
                  return Color.fromARGB(255, 219, 216, 216);
                } else {
                  return index % 2 == 0
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Color.fromARGB(255, 222, 218, 218);
                }
              }),
              cells: [
                DataCell(Text(data['id'].toString())),
                DataCell(Text(data['employeeId'])),
                DataCell(Text(data['employeeName'])),
                DataCell(Text(data['relationship'])),
                DataCell(Text(data['gender'])),
                DataCell(Text(data['age'].toString())),
                DataCell(Text(data['sumInsured'].toString())),
                // DataCell(Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.more_vert),
                //       onPressed: () {
                //         // Implement the edit action here
                //         (
                //             'Edit icon tapped for Employee ID: ${data['employeeId']}');
                //       },
                //     ),
                //   ],
                // )),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}
