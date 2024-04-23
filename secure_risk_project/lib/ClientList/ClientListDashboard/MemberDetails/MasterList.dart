import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:http_parser/http_parser.dart';

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
   bool isChecked;

  Master({
    required this.employeeNo,
    required this.name,
    required this.relationShip,
    required this.email,
    required this.phoneNumber,
    required this.sumInsured,
    required this.month,
   this.isChecked = false,
  });
}

class MasterList extends StatefulWidget {
  int clientId;
  String productId;
  MasterList({Key? key, required this.clientId, required this.productId})
      : super(key: key);

  @override
  State<MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<MasterList> {
  String? _selectedFilter;
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
  List<String> _filterOptions = [
    'Employee No',
    'Name',
    'Relationship',
    'Email'
  ];
  TextEditingController _searchController = TextEditingController();

  void _handleAll(String? newValue) {
    setState(() {});
  }

  void _handleFilterByChange(String? newValue) {
    setState(() {
      // _selectedFilter = newValue;
      // _filteredData = getFilteredData();
      // totalPages = (_filteredData.length / _pageSize).ceil();
      // _currentPage = 1;
    });
  }

  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.getAllMasterList_EndPoint)
              .replace(queryParameters: {
        "clientListId": (widget.clientId).toString(),
        "productId": widget.productId,
        "month": "all",
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

  // List<Client> getFilteredData() {
  //   if (_selectedFilter == null) {
  //     return _data;
  //   } else {
  //     return _data
  //         // .where((item) => item.clientName == _selectedFilter)
  //         .where((item) => item.location == _selectedFilter)
  //         .toList();
  //   }
  // }

// ...

  void _handleSearch(String value) {
    // setState(() {
    //   _searchText = value;
    //   _filteredData = getFilteredData();
    //   if (_searchText.isNotEmpty) {
    //     _filteredData = _filteredData
    //         .where((item) =>
    //             item.insurerId.contains(_searchText) ||
    //             item.clientName
    //                 .toLowerCase()
    //                 .contains(_searchText.toLowerCase()) ||
    //             item.location.toLowerCase().contains(_searchText.toLowerCase()))
    //         .toList();
    //   }
    //   totalPages = (_filteredData.length / _pageSize).ceil();
    //   _currentPage = 1;
    // });
  }
  http.MultipartRequest jsonToFormData(
      http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  List<Master> _masterList = [];
  int currentPage = 1;
  int pageSize = 6;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int? indexNumber;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    int snum = startIndex + 1;
    int totalInsurers = _masterList.length;
    bool _isChecked = false;

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
                        width: 240,
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
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        width: 220,
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
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
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
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  child: SizedBox(
                    //  height: MediaQuery.of(context).size.height - 200,
                    // scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columnSpacing: 45,
                        //columnSpacing: 250,
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
                          //buildDataColumn('Action'),
                        ],
                        rows: [
                          // ..._masterList
                          //     .map((ends) =>
                          for (int index = 0;
                              index < currentPageInsurers.length;
                              index++)
                            DataRow(cells: [
                              DataCell(                              
                                    Text(currentPageInsurers[index].employeeNo),
                                
                              ),                              
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
                              //  DataCell(Text("Actions")),
                            ])
                          //)
                          //     .toList()
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
