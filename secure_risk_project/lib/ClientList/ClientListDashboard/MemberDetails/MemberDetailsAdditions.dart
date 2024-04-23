import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:html' as html;
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class Master {
  final String employeeNo;
  final String name;
  final String relationShip;
  final String email;
  final String phoneNumber;
  final int sumInsured;
  final String month;

  Master({
    required this.employeeNo,
    required this.name,
    required this.relationShip,
    required this.email,
    required this.phoneNumber,
    required this.sumInsured,
    required this.month,
  });
}

class AdditionsList extends StatefulWidget {
  int clientId;
  String productId;
  AdditionsList({Key? key, required this.clientId, required this.productId})
      : super(key: key);
  @override
  State<AdditionsList> createState() => _AdditionsListState();
}

//List<Master> _masterList = [];
int currentPage = 1;
int pageSize = 6;

class _AdditionsListState extends State<AdditionsList> {
  String? _selectedFilter;

  List<String> _filterOptions = [
    'Employee No',
    'Name',
    'Relationship',
    'Email'
  ];

  List<String> _allOptions = [
    'All',
    'January',
    'February ',
    'March ',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  TextEditingController _searchController = TextEditingController();

  void _handleAll(String? newValue) {
    setState(() {});
  }

  void _handleFilterByChange(String? newValue) {
    setState(() {});
  }

  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();

      final uploadApiUrl = Uri.parse(ApiServices.baseUrl +
              ApiServices.getAllMemberdetailsForAdditions_Endpoint)
          .replace(queryParameters: {
        "clientListId": (widget.clientId).toString(),
        "productId": widget.productId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (data != null && data.isNotEmpty) {
          final List<Master> masterList = data
              .map((item) => Master(
                    employeeNo: item['employeeNo'] ?? '',
                    name: item['name'] ?? '',
                    relationShip: item['relationShip'] ?? '',
                    email: item['email'] ?? '',
                    phoneNumber: item['phoneNumber'] ?? '',
                    sumInsured: item['sumInsured'] ?? '',
                    month: item['month'] ?? '',
                  ))
              .toList();

          setState(() {
            _masterList = masterList;
          });
        } else {
          print('Unexpected response format: $data');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (exception) {
      print('Exception: $exception');
    }
  }

  Map<String, dynamic> fileResponses = {};

  void _handleSearch(String value) {}
  http.MultipartRequest jsonToFormData(
      http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  List<Master> _masterList = [];

  exportActiveMemberDetails(String fileName) async {
    int clientListId = widget.clientId;
    int? productId = int.tryParse(widget.productId);

    String urlString =
        "${ApiServices.baseUrl}${ApiServices.exportMemberDetailsActiveApi}clientListId=$clientListId&productId=$productId";

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // final blob = html.Blob([response.bodyBytes]);
        final blob = html.Blob([
          response.bodyBytes
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = fileName;

        anchor.click();
        html.Url.revokeObjectUrl(url);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFFFFFFFF),
              surfaceTintColor: Colors.white,
              title:
                  Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                  SizedBox(height: 16.0),
                  Text(
                    'Failed to download...!',
                    style: GoogleFonts.poppins(fontSize: 18.0),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'close',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                SizedBox(height: 16.0),
                Text(
                  'Failed to download...!',
                  style: GoogleFonts.poppins(fontSize: 18.0),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  'close',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  activeMemberDetailsDownloadTemplate(String fileName) async {
    String urlString =
        "${ApiServices.baseUrl}${ApiServices.additionsDownloadTemplate}";

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // final blob = html.Blob([response.bodyBytes]);
        final blob = html.Blob([
          response.bodyBytes
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = fileName;

        anchor.click();
        html.Url.revokeObjectUrl(url);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFFFFFFFF),
              surfaceTintColor: Colors.white,
              title:
                  Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                  SizedBox(height: 16.0),
                  Text(
                    'Failed to download...!',
                    style: GoogleFonts.poppins(fontSize: 18.0),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'close',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                SizedBox(height: 16.0),
                Text(
                  'Failed to download...!',
                  style: GoogleFonts.poppins(fontSize: 18.0),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  'close',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int? indexNumber;

    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    int snum = startIndex + 1;
    int totalInsurers = _masterList.length;

    final List<Master> currentPageInsurers = startIndex < totalInsurers
        ? _masterList.sublist(
            startIndex, endIndex < totalInsurers ? endIndex : totalInsurers)
        : [];
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: 250,
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            onChanged: _handleAll,
                            items: _allOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:
                                    Text(value, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            hint: Text('All', style: GoogleFonts.poppins()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    Flexible(
                      child: Container(
                        width: 300,
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            onChanged: _handleFilterByChange,
                            items: _filterOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:
                                    Text(value, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            hint:
                                Text('Filter By', style: GoogleFonts.poppins()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        width: 1000,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _handleSearch,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            labelText: 'Search',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black26,
                              ),
                              onPressed: () {
                                _handleSearch(_searchController.text);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(width: 10),
                    Spacer(),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            exportActiveMemberDetails(
                                "member_details_addition");
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Export',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Align(
                    //   child: Container(
                    //     height: 40,
                    //     child: ElevatedButton(
                    //       style: SecureRiskColours.customButtonStyle(),
                    //       onPressed: () {},
                    //       child: Container(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             SizedBox(width: 5),
                    //             Text(
                    //               'upload',
                    //               style:
                    //                   GoogleFonts.poppins(color: Colors.white),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Align(
                    //   child: Container(
                    //     height: 40,
                    //     child: ElevatedButton(
                    //       style: SecureRiskColours.customButtonStyle(),
                    //       onPressed: () {},
                    //       child: Container(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             SizedBox(width: 5),
                    //             Text(
                    //               'clear',
                    //               style:
                    //                   GoogleFonts.poppins(color: Colors.white),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            activeMemberDetailsDownloadTemplate(
                                "additionsList");
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Download Template',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      child: Container(
                        height: 37,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                SecureRiskColours.Button_Color),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings, size: 20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.6,
                width: screenWidth * 0.8,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: DataTable(
                        columnSpacing:
                            (MediaQuery.of(context).size.width) / 50, //65,
                        headingRowColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return SecureRiskColours.Table_Heading_Color;
                        }),
                        columns: [
                          buildDataColumn('Emp No'),
                          buildDataColumn('Name'),
                          buildDataColumn('Relationship'),
                          buildDataColumn('Email'),
                          buildDataColumn('Phone'),
                          buildDataColumn('Sum Insured'),
                          buildDataColumn('Status'),
                          buildDataColumn('Month'),
                          // buildDataColumn('Action'),
                        ],
                        rows: [
                          // ..._masterList
                          //     .map((ends) => DataRow(cells: [
                          //           DataCell(Text(ends.employeeNo)),
                          //           DataCell(Text(ends.name)),
                          //           DataCell(Text(ends.relationShip)),
                          //           DataCell(Text(ends.email)),
                          //           DataCell(Text(ends.phoneNumber)),
                          //           DataCell(Text(ends.sumInsured.toString())),
                          //           DataCell(Text("Active")),
                          //           DataCell(Text(ends.month)),
                          //          // DataCell(Text("Actions")),
                          //         ]))
                          //     .toList()

                          for (int index = 0;
                              index < currentPageInsurers.length;
                              index++)
                            DataRow(cells: [
                              DataCell(
                                  Text(currentPageInsurers[index].employeeNo)),
                              DataCell(Text(currentPageInsurers[index].name)),
                              DataCell(Text(
                                  currentPageInsurers[index].relationShip)),
                              DataCell(Text(currentPageInsurers[index].email)),
                              DataCell(
                                  Text(currentPageInsurers[index].phoneNumber)),
                              DataCell(Text(currentPageInsurers[index]
                                  .sumInsured
                                  .toString())),
                              DataCell(Text("Active")),
                              DataCell(Text(currentPageInsurers[index].month)),
                              // DataCell(buildActionButtons(currentPageInsurers[index].memberId)),
                              // DataCell(Text("Actions")),
                            ])
                        ]),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (totalPages > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 1
                          ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                          : null,
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 8.0),
                    Text('$currentPage'),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: currentPage < totalPages
                          ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                          : null,
                      child: Text(
                        'Next',
                      ),
                    ),
                  ],
                ),
              // ])),
            ])),
      ),
    ));
  }

  int get totalPages {
    return (_masterList.length / pageSize).ceil();
  }

  DataColumn buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
