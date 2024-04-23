import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Service.dart';

class EmployeeEardssmenu {
  final int ecardId;
  final String filename;
  EmployeeEardssmenu({required this.filename, required this.ecardId});
}

class EmployeeEards extends StatefulWidget {
  // int? clientId;

  // String? productId;
  EmployeeEards({
    Key? key,
    // required this.clientId,
    // required this.productId,
  }) : super(key: key);

  @override
  State<EmployeeEards> createState() => _EmployeeEardsState();
}

class _EmployeeEardsState extends State<EmployeeEards> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  List<EmployeeEardssmenu> _dataList = [];
  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      // String clientListId = widget.clientId.toString();
      // String? productId = widget.productId;
      String? clientListId = "1552";
      String? productId = "1001";
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.getAllEcards)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
      });
      var response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<EmployeeEardssmenu> dataList = jsonData.map((item) {
          return EmployeeEardssmenu(
            ecardId: item['ecardId'],
            filename: item['fileName'] ?? '',
          );
        }).toList();

        setState(() {
          _dataList = dataList;
        });

        // Show the dialog after data is fetched
        _showDataDialog(context);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Ecards'),
      ),
      body: Center(
        child: Container(), // Placeholder while loading data
      ),
    );
  }

  void _showDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
            contentPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          
          content: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('E-Card ID')),
                  DataColumn(label: Text('Filename')),
                ],
                rows: _dataList.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data.ecardId.toString())),
                      DataCell(Text(data.filename)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
//       body: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5), // Shadow color
//                   spreadRadius: 5, // Spread radius
//                   blurRadius: 7, // Blur radius
//                   offset: Offset(0, 3), // Offset
//                 ),
//               ],
//             ),
//             child: Container(
//               height: screenHeight * 0.6,
//               width: screenWidth * 0.8,
//               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
//               child: SingleChildScrollView(
//                 physics: AlwaysScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 child: DataTable(
//                     //columnSpacing: 305,
//                     columnSpacing: 300,
//                     headingRowColor: MaterialStateProperty.resolveWith<Color>(
//                         (Set<MaterialState> states) {
//                       return SecureRiskColours
//                           .Table_Heading_Color; // Use any color of your choice
//                     }),
//                     columns: [
//                       DataColumn(
//                         label: Text(
//                           'S.No',
//                           style: GoogleFonts.poppins(
//                               color: Colors.white, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'File',
//                           style: GoogleFonts.poppins(
//                               color: Colors.white, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Actions',
//                           style: GoogleFonts.poppins(
//                               color: Colors.white, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ],
//                     rows: [
//                       // ..._filteredData
//                       //     .map((ends) => DataRow(cells: [
//                       //           DataCell(Text((_filteredData.indexOf(ends) + 1)
//                       //               .toString())),
//                       //           DataCell(
//                       //             InkWell(
//                       //               onTap: () {
//                       //                 downloadFile(ends.ecardId.toString(),
//                       //                     ends.filename);
//                       //               },
//                       //               child: Text(
//                       //                 ends.filename ?? "N/A",
//                       //                 overflow: TextOverflow.ellipsis,
//                       //                 style: GoogleFonts.poppins(
//                       //                     color:
//                       //                         Color.fromARGB(255, 7, 79, 138),
//                       //                     decoration: TextDecoration.underline),
//                       //               ),
//                       //             ),
//                       //           ),
//                       //           DataCell(Row(
//                       //             children: [
//                       //               IconButton(
//                       //                   onPressed: () {
//                       //                     print('Edit button pressed');
//                       //                     updateEndorsementForm(
//                       //                         ends.ecardId.toString());
//                       //                   },
//                       //                   icon: Icon(Icons.edit)),
//                       //               IconButton(
//                       //                 onPressed: () async {
//                       //                   await deleteEcards(
//                       //                       ends.ecardId.toString());
//                       //                 },
//                       //                 icon: Icon(Icons.delete),
//                       //                 style: ButtonStyle(
//                       //                   foregroundColor:
//                       //                       MaterialStateProperty.all(
//                       //                           Colors.red),
//                       //                 ),
//                       //               )
//                       //             ],
//                       //           ))
//                       //         ]))
//                       //     .toList()
//                     ]),
//               ),
//             ),
//           )),
    
    
    
//     );
//   }
// }
