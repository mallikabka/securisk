import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'dart:html' as html;

//import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:html' as html;
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../RenewalPolicy/RenewalClaimsMisData.dart';

class Master {
  final String claimsNumber;
  final String employeeId;
  final String employeeName;
  final String relationship;
  final String gender;
  final int age;
  final String patientName;
  final double sumInsured;
  final double claimedAmount;
  final double paidAmount;
  final double outstandingAmount;
  final String claimStatus;
  final DateTime? dateOfClaim;
  final String claimType;
  final String networkType;
  final String hospitalName;
  final DateTime? admissionDate;
  final String disease;
  final DateTime? dateOfDischarge;
  final String memberCode;
  final DateTime? policyStartDate;
  final DateTime? policyEndDate;
  final String hospitalState;
  final String hospitalCity;
  // final String month;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String recordStatus;
  final String policyNumber;

  Master({
    required this.claimsNumber,
    required this.employeeId,
    required this.employeeName,
    required this.relationship,
    required this.gender,
    required this.age,
    required this.patientName,
    required this.sumInsured,
    required this.claimedAmount,
    required this.paidAmount,
    required this.outstandingAmount,
    required this.claimStatus,
    required this.dateOfClaim,
    required this.claimType,
    required this.networkType,
    required this.hospitalName,
    required this.admissionDate,
    required this.disease,
    required this.dateOfDischarge,
    required this.memberCode,
    required this.policyStartDate,
    required this.policyEndDate,
    required this.hospitalState,
    required this.hospitalCity,
    // required this.month,
    required this.createDate,
    required this.updateDate,
    required this.recordStatus,
    required this.policyNumber,
  });
}

class CountList {
  final String approved;
  final String pending;
  final String rejected;
  final String outstandingAmount;
  final String repudiatedAmount;
  final String approvedAmount;
  CountList({
    required this.approved,
    required this.pending,
    required this.rejected,
    required this.outstandingAmount,
    required this.repudiatedAmount,
    required this.approvedAmount,
  });
}

class Claims_MasterList extends StatefulWidget {
  int clientId;
  String productId;
  String tpaNameVar;
  Claims_MasterList(
      {Key? key,
      required this.clientId,
      required this.productId,
      required this.tpaNameVar})
      : super(key: key);
  @override
  State<Claims_MasterList> createState() => _Claims_MasterListState();
}

List<Map<String, dynamic>> renewalMisDataList = [];
int approved = 0;
int pending = 0;
int rejected = 0;
double outstandingAmount = 0.0;
double repudiatedAmount = 0.0;
double approvedAmount = 0.0;

class _Claims_MasterListState extends State<Claims_MasterList> {
  String? _selectedFilter;
  String? _seletedMonth = "All";
  List<String> _filterOptions = [' ', ' ', ' ', ' '];
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

  void _handleFilterByChange(String? newValue) {
    setState(() {});
  }

  void initState() {
    super.initState();
    _fetchData(_seletedMonth);
    _fetchCount();
  }

  Future<void> _fetchCount() async {
    try {
      var headers = await ApiServices.getHeaders();

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.clientListclaimsMisCount)
              .replace(queryParameters: {
        "clientlistId": (widget.clientId).toString(),
        "productId": widget.productId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final dynamic data = json.decode(response.body);

          if (data != null && data is Map<String, dynamic>) {
            // Extracting values for the variables
            approved = data["approved"] ?? 0;
            pending = data["pending"] ?? 0;
            rejected = data["rejected"] ?? 0;
            outstandingAmount = data["outstandingAmount"] ?? 0.0;
            repudiatedAmount = data["repudiatedAmount"] ?? 0.0;
            approvedAmount = data["approvedAmount"] ?? 0.0;
          } else {
            print('Unexpected response format: $data');
          }
        } else {
          print('Response body is empty');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (exception) {
      print('Exception: $exception');
    }
  }

  Future<void> _fetchData(String? _selectedMonth) async {
    try {
      var headers = await ApiServices.getHeaders();

      final uploadApiUrl = Uri.parse(ApiServices.baseUrl +
              ApiServices.Clientlist_claimsMis_masterList_Endpoint)
          //  getAllMasterList_EndPoint)
          .replace(queryParameters: {
        "clientListId": (widget.clientId).toString(),
        "productId": widget.productId,
        "month": _seletedMonth,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (data != null && data.isNotEmpty) {
          final List<Master> masterList = data
              .map((item) => Master(
                    claimsNumber: item['claimsNumber'] ?? '',
                    employeeId: item['employeeId'] ?? '',
                    employeeName: item['employeeName'] ?? '',
                    relationship: item['relationship'] ?? '',
                    sumInsured: item['sumInsured'] ?? '',
                    gender: item['gender'] ?? '',
                    age: item['age'] ?? 0,
                    patientName: item['patientName'] ?? '',
                    claimedAmount: item['claimedAmount'] ?? 0.0,
                    paidAmount: item['paidAmount'] ?? 0.0,

                    outstandingAmount: item['outstandingAmount'] ?? 0.0,
                    claimStatus: item['claimStatus'] ?? '',
                    dateOfClaim: item['dateOfClaim'] != null
                        ? DateTime.parse(item['dateOfClaim'])
                        : null,
                    // dateOfClaim:  item['dateOfClaim'] ?? '',
                    // DateTime.parse(
                    //     "2019-06-07"), // item['dateOfClaim'] ?? '',
                    claimType: item['claimType'] ?? '',
                    networkType: item['networkType'] ?? '',
                    hospitalName: item['hospitalName'] ?? '',
                    admissionDate: item['admissionDate'] != null
                        ? DateTime.parse(item['admissionDate'])
                        : null,
                    // admissionDate: DateTime.parse(
                    //     "2019-06-07"), //item['admissionDate'] ?? '',
                    disease: item['disease'] ?? '',

                    dateOfDischarge: item['dateOfDischarge'] != null
                        ? DateTime.parse(item['dateOfDischarge'])
                        : null,
                    // dateOfDischarge: DateTime.parse(
                    //     "2019-06-07"), // item['dateOfDischarge'] ?? '',
                    memberCode: item['memberCode'] ?? '',

                    policyStartDate: item['policyStartDate'] != null
                        ? DateTime.parse(item['policyStartDate'])
                        : null,
                    // policyStartDate: DateTime.parse(
                    //     "2019-06-07"), // item['policyStartDate'] ?? '',

                    policyEndDate: item['policyEndDate'] != null
                        ? DateTime.parse(item['policyEndDate'])
                        : null,
                    // policyEndDate: DateTime.parse(
                    //     "2019-06-07"), //item['policyEndDate'] ?? '',
                    hospitalState: item['hospitalState'] ?? '',
                    hospitalCity: item['hospitalCity'] ?? '',
                    // month:item['month'] ?? '',
                    createDate: item['createDate'] != null
                        ? DateTime.parse(item['createDate'])
                        : null,
                    // createDate: DateTime.parse(
                    //     "2019-06-07"), //item['createDate'] ?? '',

                    updateDate: item['updateDate'] != null
                        ? DateTime.parse(item['updateDate'])
                        : null,
                    // updateDate: DateTime.parse(
                    //     "2019-06-07"), //item['updateDate'] ?? '',
                    recordStatus: item['recordStatus'] ?? '',
                    policyNumber: item['policyNumber'] ?? '',
                  ))
              .toList();

          setState(() {
            _masterList = masterList;
            //  print('response data : $data');
            // print('masterList data : $masterList');
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

  final ScrollController _horizontalScrollController = ScrollController();

  List<DataRow> dataRows = [];
  int currentPage = 1;
  int pageSize = 6;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context as BuildContext).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
            padding: EdgeInsets.all(5.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Approved Claims: "),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            approved.toString(),
                            //  "0",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Rejected Claims: "),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            rejected.toString(),
                            //"0",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Pending Claims: "),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            pending.toString(),
                            // "0",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(5.0),
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
                            value: _seletedMonth,
                            onChanged: _handleFilterByChange,
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
                        width: 250,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _handleSearch,
                          decoration: InputDecoration(
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
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            exportClaimsMisDetails("ClaimsMisMasterList");
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
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            showUploadDialog(context);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'upload',
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
                child: Scrollbar(
                  controller:
                      _horizontalScrollController, // Assign the ScrollController
                  thickness: 10,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      // width: MediaQuery.of(context).size.width - 32,
                      height: MediaQuery.of(context).size.height - 200,
                      child: DataTable(
                          // columnSpacing: (MediaQuery.of(context).size.width) / 50,
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return SecureRiskColours.Table_Heading_Color;
                          }),
                          columns: [
                            buildDataColumn('Claims Number'),
                            buildDataColumn('employeeId'),
                            buildDataColumn('employeeName'),
                            buildDataColumn('TPA relationship'),
                            buildDataColumn('gender'),
                            buildDataColumn('Age'),
                            buildDataColumn('Patient Name'),
                            buildDataColumn('Sum Insured'),
                            buildDataColumn('claimedAmount'),
                            buildDataColumn('Paid amount'),
                            buildDataColumn('outStanding amount'),
                            buildDataColumn('claimStatus'),
                            buildDataColumn('dateOfClaim'),
                            buildDataColumn('claimType'),
                            buildDataColumn('networkType'),
                            buildDataColumn('hospitalName'),
                            buildDataColumn('admissionDate'),
                            buildDataColumn('disease'),
                            buildDataColumn('dateOfDischarge'),
                            buildDataColumn('memberCode'),
                            buildDataColumn('policyStartDate'),
                            buildDataColumn('policyEndDate'),
                            buildDataColumn('hospitalState'),
                            buildDataColumn('hospitalCity'),
                            buildDataColumn('createDate'),
                            buildDataColumn('updateDate'),
                            buildDataColumn('recordStatus'),
                            buildDataColumn('policyNumber'),
                          ],
                          rows: [
                            for (int index = 0;
                                index < currentPageInsurers.length;
                                index++)
                              DataRow(cells: [
                                // ..._masterList
                                //     .map((ends) => DataRow(cells: [
                                DataCell(Text(
                                    currentPageInsurers[index].claimsNumber)),
                                DataCell(Text(
                                    currentPageInsurers[index].employeeId)),
                                DataCell(Text(
                                    currentPageInsurers[index].employeeName)),
                                DataCell(Text(
                                    currentPageInsurers[index].relationship)),
                                DataCell(
                                    Text(currentPageInsurers[index].gender)),
                                DataCell(Text(
                                    currentPageInsurers[index].age.toString())),
                                DataCell(Text(
                                    currentPageInsurers[index].patientName)),
                                DataCell(Text(currentPageInsurers[index]
                                    .sumInsured
                                    .toString())),
                                DataCell(Text(currentPageInsurers[index]
                                    .claimedAmount
                                    .toString())),
                                DataCell(Text(currentPageInsurers[index]
                                    .paidAmount
                                    .toString())),
                                DataCell(Text(currentPageInsurers[index]
                                    .outstandingAmount
                                    .toString())),
                                DataCell(Text(
                                    currentPageInsurers[index].claimStatus)),

                                // DataCell(Text(currentPageInsurers[index]
                                //     .dateOfClaim
                                //     .toString())),
                                DataCell(Text(
                                  currentPageInsurers[index].dateOfClaim != null
                                      ? DateFormat('yyyy-MM-dd').format(
                                          currentPageInsurers[index]
                                              .dateOfClaim!)
                                      : 'Null', // Display empty string if dateOfClaim is null
                                )),

                                DataCell(
                                    Text(currentPageInsurers[index].claimType)),
                                DataCell(Text(
                                    currentPageInsurers[index].networkType)),
                                DataCell(Text(
                                    currentPageInsurers[index].hospitalName)),
                                // DataCell(Text(currentPageInsurers[index]
                                //     .admissionDate
                                //     .toString())),
                                DataCell(Text(
                                  currentPageInsurers[index].admissionDate !=
                                          null
                                      ? DateFormat('yyyy-MM-dd').format(
                                          currentPageInsurers[index]
                                              .admissionDate!)
                                      : 'Null', // Display empty string if dateOfClaim is null
                                )),

                                DataCell(
                                    Text(currentPageInsurers[index].disease)),
                                DataCell(Text(
                                  currentPageInsurers[index].dateOfDischarge !=
                                          null
                                      ? DateFormat('yyyy-MM-dd').format(
                                          currentPageInsurers[index]
                                              .dateOfDischarge!)
                                      : 'Null', // Display empty string if dateOfClaim is null
                                )),

                                // DataCell(Text(currentPageInsurers[index]
                                //     .dateOfDischarge
                                //     .toString())),
                                DataCell(Text(
                                    currentPageInsurers[index].memberCode)),

                                DataCell(Text(
                                  currentPageInsurers[index].policyStartDate !=
                                          null
                                      ? DateFormat('yyyy-MM-dd').format(
                                          currentPageInsurers[index]
                                              .policyStartDate!)
                                      : 'Null', // Display empty string if dateOfClaim is null
                                )),

                                // DataCell(Text(currentPageInsurers[index]
                                //     .policyStartDate
                                //     .toString())),
                                DataCell(Text(
                                  currentPageInsurers[index].policyEndDate !=
                                          null
                                      ? DateFormat('yyyy-MM-dd').format(
                                          currentPageInsurers[index]
                                              .policyEndDate!)
                                      : 'Null', // Display empty string if dateOfClaim is null
                                )),

                                // DataCell(Text(currentPageInsurers[index]
                                //     .policyEndDate
                                //     .toString())),
                                DataCell(Text(
                                    currentPageInsurers[index].hospitalState)),
                                DataCell(Text(
                                    currentPageInsurers[index].hospitalCity)),
                                DataCell(Text(currentPageInsurers[index]
                                    .createDate
                                    .toString())),
                                DataCell(Text(currentPageInsurers[index]
                                    .updateDate
                                    .toString())),
                                DataCell(Text(
                                    currentPageInsurers[index].recordStatus)),
                                DataCell(Text(
                                    currentPageInsurers[index].policyNumber)),
                              ])
                          ]),
                    ),
                  ),
                ),
              ),

              //  SizedBox(height: 20),
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

  exportClaimsMisDetails(String fileName) async {
    int clientListId = 1552; //widget.clientId;
    int? productId = 1001; //int.tryParse(widget.productId);

    String urlString =
        "${ApiServices.baseUrl}${ApiServices.clientListClaimsMisExportEndPoint}?clientListId=$clientListId&productId=$productId";

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Explicitly setting the MIME type for the .xlsx file
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
                    Navigator.of(context).pop();
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void showUploadDialog(BuildContext context) {
    DateTime selectedDate = DateTime.now(); // Initialize with current date
    String tpaName = widget.tpaNameVar;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Set border radius
            ),

            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors
                .white, // Colors.transparent, // Transparent background color
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.pink[50], // Background color for the label
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        "SELECT DATE",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        //  style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    // padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.pink), // Border color
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 10),
                          Text(
                            DateFormat('yyyy-MM-dd').format(selectedDate),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),

            actions: [
              ElevatedButton(
                onPressed: () {
                  // Implement submit logic here
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                  print("Selected date: $formattedDate");
                  renewalClaimsMisUpload(
                      tpaName, context, "ClaimsMis"); //HealthIndia

                  Navigator.of(context).pop(); // Close the dialog
                },

                child: Text("Submit"), // Submit button
              ),
            ],
          );
        });
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Future<void> renewalClaimsMisUpload(
  //     String tpaName, BuildContext context, String fileType) async {
  //   var headers = await ApiServices.getHeaders();
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['xlsx', 'xls', 'XLSX', 'XLS'],
  //     allowMultiple: false,
  //   );

  //   if (result != null && result.files.isNotEmpty) {
  //     final fileBytes = result.files.first.bytes;
  //     final fileName = result.files.first.name;
  //     print('inside if result not null');

  //     if (result.files.first.extension == 'xlsx' ||
  //         result.files.first.extension == 'xls') {

  //       try {
  //         final apiUrl = Uri.parse(ApiServices.baseUrl +
  //             ApiServices.clientList_ClaimsMis_headervalidation_endpoint +
  //             //  ClaimsMis_Headers_validation +
  //             "?tpaName=" +//"Alacriti");
  //            tpaName);

  //         var request = http.MultipartRequest("POST", apiUrl)
  //           ..headers.addAll(headers);

  //         var multipartFile = http.MultipartFile.fromBytes(
  //           'file',
  //           fileBytes!,
  //           filename: fileName,
  //           contentType: MediaType('application', 'octet-stream'),
  //         );

  //         request.files.add(multipartFile);

  //         final response = await request.send();
  //         print('status code:$response.statusCode');
  //         if (response.statusCode == 200) {
  //           toastification.showError(
  //             context: context,
  //             autoCloseDuration: Duration(seconds: 100),
  //             title: 'inside 200 Please select correct tpa...!',
  //           );
  //           final validationResponse = await response.stream.bytesToString();
  //           final validationResult = json.decode(validationResponse);

  //           final bool status = validationResult['status'];

  //           if (status == true) {
  //             await _postAdditionalApiCall(
  //                 context, fileBytes, fileType, tpaName, fileName);
  //           }
  //         } else {
  //           toastification.showError(
  //             context: context,
  //             autoCloseDuration: Duration(seconds: 100),
  //             title: 'Please select correct tpa...!',
  //           );
  //           print('inside please correct tpa ');
  //         }
  //       } catch (e) {
  //         toastification.showError(
  //           context: context,
  //           autoCloseDuration: Duration(seconds: 2),
  //           title: 'Please select a file......!',
  //         );
  //       }
  //     }
  //   } else {
  //     toastification.showError(
  //       context: context,
  //       autoCloseDuration: Duration(seconds: 2),
  //       title: 'Please pick a file...!',
  //     );
  //   }
  // }
  Future<void> renewalClaimsMisUpload(
      String? tpaName, BuildContext context, String fileType) async {
    BuildContext currentContext = context;

    var headers = await ApiServices.getHeaders();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'XLSX', 'XLS'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name ?? 'Unknown';

      // Check if the tpaName matches the fileName
      if (tpaName == fileName.split('.').first) {
        print("divya");
        if (result.files.first.extension == 'xlsx' ||
            result.files.first.extension == 'xls') {
          try {
            final apiUrl = Uri.parse(ApiServices.baseUrl +
                    ApiServices.clientList_ClaimsMis_headervalidation_endpoint)
                .replace(queryParameters: {"tpaName": tpaName});

            var request = http.MultipartRequest("POST", apiUrl)
              ..headers.addAll(headers);

            var multipartFile = http.MultipartFile.fromBytes(
              'file',
              fileBytes!,
              filename: fileName,
              contentType: MediaType('application', 'octet-stream'),
            );

            request.files.add(multipartFile);

            final response = await request.send();
            print('status code: ${response.statusCode}');
            if (response.statusCode == 200) {
              final validationResponse = await response.stream.bytesToString();
              final validationResult = json.decode(validationResponse);

              final bool status = validationResult['status'];

              if (status == true) {
                await _postAdditionalApiCall(
                    context, fileBytes, fileType, tpaName, fileName);
                Navigator.of(context).pop(); // Close the current dialog
              } else {
                // Show TPA Name Mismatch popup
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('TPA Name Mismatch'),
                      content: Text(
                          'The selected file does not match the provided TPA name.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the popup
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              // Show Error popup for incorrect TPA
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Please select the correct TPA.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the popup
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
              print('inside please correct TPA ');
            }
          } catch (e) {
            // Show Error popup for API request failure
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Please select a file.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('TPA Name Mismatch'),
              content:
                  Text('The selected TPA name does not match the file name.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show Error popup for not picking a file
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please pick a file.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _postAdditionalApiCall(
      BuildContext context, fileBytes, fileType, tpaName, fileName) async {
    var headers = await ApiServices.getHeaders();
    try {
      final apiUrl = Uri.parse(ApiServices.baseUrl +
          ApiServices.clamisMisGetAllStatus +
          "?tpaName=" +
          tpaName);
      var request = http.MultipartRequest("POST", apiUrl)
        ..headers.addAll(headers);

      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200) {
        ("checking validation");
        final responseStream = await response.stream.bytesToString();

        renewalMisDataList =
            List<Map<String, dynamic>>.from(json.decode(responseStream));
        uploadRenewalClaimsMis(
            fileBytes, "ClaimsMis", fileName, renewalMisDataList);
        Navigator.of(context).pop();
        // debugger();
        //  showEmpDetails(context, renewalempDataList, fileBytes, fileName);
      } else if (response.statusCode == 204) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          width: 300,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          headerAnimationLoop: true,
          animType: AnimType.bottomSlide,
          title: 'INFO',
          desc: 'Please Select Corect Tpa...!',
          descTextStyle: TextStyle(fontWeight: FontWeight.bold),
          showCloseIcon: true,
          btnCancelOnPress: () {
            //  Navigator.of(context).pop();
          },
          btnOkOnPress: () {
            //  Navigator.of(context).pop();
          },
        ).show();
      } else {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Please try again.....!',
        );
        // Additional API call failed
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Please try again.....!',
      );
    }
  }

  String? pickedFileName;
  PlatformFile? file;
  String? filePath;
  Future<PlatformFile?> pickFileToUpload() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) {
        return null; // File picker was canceled or failed
      }

      PlatformFile pickedFile = result.files.first;

      // You can optionally update the UI or show a success message here
      setState(() {
        pickedFileName = pickedFile.name;
        // Update your UI or show a success toast here, if needed
      });

      // Optionally, show a success message if a file was picked
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File $pickedFileName picked successfully!',
      );

      // Return the picked file
      return pickedFile;
    } catch (e) {
      // Optionally, handle exceptions or show an error message
      print("Error picking file: $e");
      return null;
    }
  }

  Future<void> uploadRenewalClaimsMis(Uint8List? fileBytes, String fileType,
      String fileName, List<Map<String, dynamic>> renewalMisDataList) async {
    //  final prefs = await SharedPreferences.getInstance();
    var headers = await ApiServices.getHeaders();
    //   final rfqId = prefs.getString('responseBody');
    //  PlatformFile? selectedFile = await pickFileToUpload();
    try {
      final uploadApiUrl = Uri.parse(
              ApiServices.baseUrl + ApiServices.clientList_ClaimsMis_uploadFile)
          .replace(queryParameters: {
        "clientlistId": (widget.clientId).toString(),
        "productId": widget.productId,
        "month": "All",
      });

      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);

      var multipartFile = http.MultipartFile.fromBytes(
        'file', // The key name for the file, as expected by the server
        fileBytes!, //selectedFile!.bytes!,
        filename: fileName, // selectedFile.name,
        contentType: MediaType('application', 'octet-stream'),
        // lookupMimeType(selectedFile
        //     .name)!), // Optionally set the MIME type of the file here, if known
      );

      request.files.add(multipartFile);

      request.fields['fileType'] = "ClaimsMis";
      request.fields['rfqId'] = "4567";
      request.fields['tpaName'] = "HealthIndia";

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      _fetchData(_seletedMonth);

      if (response.statusCode == 200 || response.statusCode == 201) {
        fileResponses[fileType] = responseBody;
        ("Response for $fileType: $responseBody");
        ("Checking renewal");
        Fluttertoast.showToast(
          msg: '$fileType uploaded successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        print("File uploaded successfully");
        setState(() {
          //  isClaimsUploadSuccessful = true;
          // claimsMisCardDispaly = true; //
          showMisDetailsCard(context, renewalMisDataList, fileBytes, fileName);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Upload failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void showMisDetailsCard(
      BuildContext context,
      List<Map<String, dynamic>> renewalMisDataList,
      Uint8List fileBytes,
      String fileName) {
    // debugger();
    int successRecords = renewalMisDataList.where((data) {
      return data['status'];
    }).length;
    int failedRecords = renewalMisDataList.length - successRecords;
    // bool showUploadButton = successRecords == renewalMisDataList.length;

    int currentPage = 1;
    int rowsPerPage = 5;
    int pageSize = 5;
//  int startIndex = currentPage * rowsPerPage;
//   int endIndex = (currentPage + 1) * rowsPerPage;
    void nextPage() {
      if ((currentPage + 1) * rowsPerPage < renewalMisDataList.length) {
        currentPage++;

        // showMisDetailsCard(context, renewalMisDataList, fileBytes, fileName);
      }
    }

    void previousPage() {
      if (currentPage > 1) {
        currentPage--;

        //  showMisDetailsCard(context, renewalMisDataList, fileBytes, fileName);
      }
    }

//  Calculate the indices for the current page

    var startIndex = (currentPage - 1) * pageSize;
    var endIndex = startIndex + pageSize;
    print('startIndex : $startIndex');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // print("object 1");
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Claims Data',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      // color: SecureRiskColours.Button_Color,
                      child: Text(
                        'Success Records - $successRecords',
                        style: GoogleFonts.poppins(
                            color: SecureRiskColours.Button_Color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      // color: SecureRiskColours.Button_Color,
                      child: Text(
                        'Failed Records - $failedRecords',
                        style: GoogleFonts.poppins(
                            color: SecureRiskColours.Button_Color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 10.0,
                height: MediaQuery.of(context).size.height * 10.0,
                child: ScrollableTableView(
                  headerBackgroundColor: SecureRiskColours.Table_Heading_Color,
                  headers: [
                    'Policy Number',
                    'Claim Number',
                    'Employee Id',
                    'Employee Name',
                    'Relation Ship',
                    'Gender',
                    'Age',
                    'Patient Name',
                    'SumInsured',
                    'Claimed Amount',
                    'Paid Amount',
                    'OutstandingAmount',
                    'Date Of Claim',
                    'Policy StartDate',
                    'Policy EndDate',
                    'Claim Type',
                    'Network Type',
                    'Hospital Name',
                    // 'Location',
                    // 'Billed Amount',
                    'Admission Date',
                    'Discharge Date',
                    'Disease',
                    // 'Treatment',
                    // 'Category',
                    'Member Code',
                    // 'ValidFrom',
                    // 'ValidTill',
                    // 'Ailment',
                    'Hospital State',
                    'Claim Status Value',
                    // 'SubStatus',
                    'Status',
                    'Remarks'
                  ].map((label) {
                    return TableViewHeader(
                      label: label,
                      textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white), // Customize the text color
                      minWidth: double.parse("190"),
                    );
                  }).toList(),
                  rows: renewalMisDataList
                      .sublist(startIndex,
                          endIndex) // Display rows for the current page
                      .map((data) {
                    // rows: renewalMisDataList.map((data) {
                    return TableViewRow(
                      backgroundColor: Color.fromARGB(255, 242, 243, 245),
                      height: 60,
                      cells: [
                        'policyNumber',
                        'claimsNumber',
                        'employeeId',
                        'employeeName',
                        'relationship',
                        'gender',
                        'age',
                        'patientName',
                        'sumInsured',
                        'claimedAmount',
                        'paidAmount',
                        'outstandingAmount',
                        'dateOfClaim',
                        'policyStartDate',
                        'policyEndDate',
                        'claimType',
                        'networkType',
                        'hospitalName',
                        // 'location',
                        // 'billedAmount',
                        'admissionDate',
                        'dischargeDate',
                        'disease',
                        // 'treatment',
                        // 'category',
                        'memberCode',
                        // 'validFrom',
                        // 'validTill',
                        // 'ailment',
                        'hospitalState',
                        'claimStatusValue',
                        // 'claimType'
                        // 'subStatus',
                        'status',
                        'remarks'
                      ].map((key) {
                        bool status = data['${key}Status'] ?? true;
                        dynamic value = data[key];
                        if (value == null || value == '') {
                          return TableViewCell(
                            child: Text(
                              '', // Display empty space for null or empty values
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return TableViewCell(
                            child: key == 'status'
                                ? (value == true
                                    ? Icon(
                                        Icons
                                            .check_circle_sharp, // Display check mark icon for "true"
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons
                                            .cancel, // Display close (cross) mark icon for "false"
                                        color: Colors.red,
                                      ))
                                : Text(
                                    value.toString(),
                                    style: GoogleFonts.poppins(
                                      color: status ? Colors.black : Colors.red,
                                      // Set text color to red if status is false
                                    ),
                                  ),
                          );
                        }
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 1
                        ? () {
                            setState(() {
                              currentPage--;
                              //    startIndex = (currentPage - 1) * pageSize;
                              //  endIndex = startIndex + pageSize;
                            });
                          }
                        : null,

                    //previousPage,
                    child: Text('Previous'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: currentPage < totalPages
                        ? () {
                            setState(() {
                              currentPage++;
                              //    startIndex = (currentPage - 1) * pageSize;
                              //  endIndex = startIndex + pageSize;
                            });
                          }
                        : null, // nextPage,
                    child: Text('Next'),
                  ),
                ],
              ),
              // if (showUploadButton)
              //   Padding(
              //     padding: const EdgeInsets.all(0.0),
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor:
              //             Color.fromRGBO(199, 55, 125, 1.0), // Hovered color
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(50),
              //         ),
              //       ),
              //       onPressed: () {
              //         renewalClaimsMisData?.currentState
              //             ?.uploadRenewalClaimsMis(
              //                 fileBytes, "ClaimsMis", fileName);

              //         Navigator.pop(context);
              //       },
              //       child: Text(
              //         'Upload',
              //         style: GoogleFonts.poppins(color: Colors.white),
              //       ),
              //     ),
              //   ),
            ],
          );
        });
      },
    );
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
