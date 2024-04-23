import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:loginapp/Utilities/CircularLoader.dart';

import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';

class UploadFile {
  final String employeeId;
  final String employeeName;
  final String dateOfBirth;
  final String relationship;
  final String gender;
  final String dateOfJoining;
  final String ecardNumber;
  final String policyCommencementDate;
  final String policyValidUpto;
  final String baseSumInsured;
  final String topUpSumInsured;
  final String groupName;
  final String insuredCompanyName;
  final String month;
  UploadFile(
      {required this.employeeId,
      required this.employeeName,
      required this.dateOfBirth,
      required this.relationship,
      required this.gender,
      required this.dateOfJoining,
      required this.ecardNumber,
      required this.policyCommencementDate,
      required this.policyValidUpto,
      required this.baseSumInsured,
      required this.topUpSumInsured,
      required this.groupName,
      required this.insuredCompanyName,
      required this.month});
}

class EntrollementDetail extends StatefulWidget {
  int? clientId;
  String? productIdvar;
  String? tpaName;

  EntrollementDetail(
      {Key? key,
      required this.clientId,
      required this.productIdvar,
      required this.tpaName})
      : super(key: key);

  @override
  _EntrollementDetailState createState() => _EntrollementDetailState();
}

class _EntrollementDetailState extends State<EntrollementDetail> {
  void initState() {
    super.initState();
    _fetchData(_selectedMonth);
  }

  int get totalPages {
    return (_data.length / pageSize).ceil();
  }

  int _currentPage = 1;
  int totalPage = 1;
  int _pageSize = 10;
  void _handleFilterByChange(String? newValue) {
    setState(() {
      _selectedFilter = newValue;
      _data = getFilteredData();
      totalPage = (_data.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  List<UploadFile> getFilteredData() {
    if (_selectedFilter == null) {
      return _data;
    } else {
      return _data
          // .where((item) => item.clientName == _selectedFilter)
          .where((item) =>
              item.employeeId == _selectedFilter ||
              item.employeeName == _selectedFilter ||
              item.gender == _selectedFilter)
          .toList();
    }
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
      _data = getFilteredData();
      if (_searchText.isNotEmpty) {
        _data = _data
            .where((item) =>
                item.employeeId.contains(_searchText) ||
                item.employeeName
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                item.gender.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();
      }
      totalPage = (_data.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  List<String> empheaders = [];
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  List<UploadFile> _data = [];
  String _responseData = '';
  List<String> _filterOptions = [
    "employeeId",
    "employeeName",
    "dateOfBirth",
    "gender",
    "relation",
    "age",
    "dateOfJoining",
    "policyStartDate",
    "policyEndDate",
    "baseSumInsured",
    "topUpSumInsured",
    "groupName",
    "insuredCompanyName",
    "ecardNumber"
  ];
  int? successRecords;
  int _page = 1;
  // int _pageSize = 20; // Adjust the page size as needed
  bool _loading = false;
  int? failedRecords;
  List<String> _monthOption = [
    'All',
    'January',
    'February',
    'March',
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

  String? _selectedFilter;
  String? _selectedMonth = 'All';
  // void _handleFilterByChange(String? newValue) {
  //   setState(() {
  //     print("Selected Filter: $newValue");
  //     _selectedFilter = newValue;
  //     // _filteredData = getFilteredData();
  //     // _updateDataTable();
  //   });
  // }

  void _handleMonthByChange(String? newValue) {
    setState(() {
      print("Selected Filter: $newValue");
      _selectedMonth = newValue;

      if (_selectedMonth != 'All' || _selectedMonth == 'All') {
        _fetchData(newValue);
      } else {}
    });
  }

  http.MultipartRequest jsonToFormData(
      http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  String? pickedFileName;

  List<PlatformFile>? pickedFiles;

  Future<void> _uploadFile(BuildContext context) async {
    String? tpaName = widget.tpaName;
    print(tpaName);
    Fluttertoast.showToast(
      msg: '$tpaName is tpa',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP_RIGHT,
      backgroundColor: Color.fromRGBO(4, 7, 17, 1),
      textColor: Colors.white,
    );
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.files.isNotEmpty) {
        pickedFiles = result.files; // Use result.files to assign pickedFiles
        pickedFileName = pickedFiles!.first.name;

        var fileName = pickedFileName!;
        Uint8List fileBytes =
            await pickedFiles!.first.bytes!; // Ensure bytes are loaded

        var fileExtension = fileName.split('.').last;
        var contentType = getContentType(fileExtension);

        var apiUrl =
            Uri.parse(ApiServices.baseUrl + ApiServices.headerValiderApi)
                .replace(queryParameters: {"tpaName": tpaName});

        var headers = await ApiServices.getHeaders();
        var request = http.MultipartRequest('POST', apiUrl);
        request.headers.addAll(headers);

        var multipartFile = http.MultipartFile.fromBytes(
          'multipartFile',
          fileBytes,
          filename: fileName,
          contentType: contentType,
        );

        request.files.add(multipartFile);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          Map<String, dynamic> validationData = jsonDecode(responseBody);
          bool employeeIdStatus = validationData['employeeIdStatus'];
          bool employeeNameStatus = validationData['employeeNameStatus'];
          bool dateOfBirthStatus = validationData['dateOfBirthStatus'];
          bool genderStatus = validationData['genderStatus'];
          bool relationStatus = validationData['relationStatus'];
          bool ageStatus = validationData['ageStatus'];
          bool policyStartDateStatus = validationData['policyStartDateStatus'];
          bool policyEndDateStatus = validationData['policyEndDateStatus'];
          bool ecardNumber = validationData['ecardNumber'];
          bool baseSumInsuredStatus = validationData['baseSumInsuredStatus'];
          bool topUpSumInsured = validationData['topUpSumInsured'];
          bool groupNameStatus = validationData['groupNameStatus'];
          bool insuredCompanyNameStatus =
              validationData['insuredCompanyNameStatus'];

          // Determine overall validation result
          bool overallValidationResult = employeeIdStatus ||
              employeeNameStatus ||
              dateOfBirthStatus ||
              genderStatus ||
              relationStatus ||
              ageStatus ||
              policyStartDateStatus ||
              policyEndDateStatus ||
              ecardNumber ||
              baseSumInsuredStatus ||
              topUpSumInsured ||
              groupNameStatus ||
              insuredCompanyNameStatus;

          if (overallValidationResult) {
            _postAdditionalApiCall(context, fileBytes, fileName);
          } else {
            _showErrorDialog(
                context, 'Tpa is not matching . Please try again.');
          }
        } else {
          _showErrorDialog(context, 'HTTP error ${response.statusCode}');
        }
      } else {
        _showErrorDialog(context, 'Please pick a file first.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: $e');
    }
  }

  DataColumn _createDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  DataCell _buildDataCell(String? value) {
    //Color textColor = status == true ? Colors.black : Colors.red;
    return DataCell(
      Text(
        value ?? '',
        style: TextStyle(
            // color: textColor,
            ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _createDataColumn('EMPLOYEE ID'),
      _createDataColumn('EMPLOYEE NAME'),
      _createDataColumn('DATE OF BIRTH'),
      _createDataColumn('GENDER'),
      _createDataColumn('RELATION'),
      _createDataColumn('AGE'),
      _createDataColumn('DATE OF JOINING'),
      _createDataColumn('ECARD NUMBER'),
      _createDataColumn('POLICY COMMENCEMENT DATE'),
      _createDataColumn('POLICY VALID UPTO'),
      _createDataColumn('BASE SUM INSURED'),
      _createDataColumn('TOPUP SUM INSURED'),
      _createDataColumn('GROUP NAME'),
      _createDataColumn('INSURANCE COMPANY NAME'),
    ];
  }

  List<DataCell> _buildDataCells(Map<String, dynamic> data) {
    return [
      //
      _buildDataCell(
        data['employeeId'],
      ),
      _buildDataCell(
        data['employeeName'],
      ),
      _buildDataCell(
        data['dateOfBirth'],
      ),
      _buildDataCell(
        data['gender'],
      ),
      _buildDataCell(
        data['relationship'],
      ),
      _buildDataCell(
        data['age'],
      ),
      _buildDataCell(
        data['dateOfJoining'],
      ),
      _buildDataCell(
        data['ecardNumber'],
      ),
      _buildDataCell(
        data['policyStartDate'],
      ),
      _buildDataCell(
        data['policyEndDate'],
      ),
      _buildDataCell(
        data['baseSumInsured'],
      ),
      _buildDataCell(
        data['topUpSumInsured'],
      ),
      _buildDataCell(
        data['groupName'],
      ),
      _buildDataCell(
        data['insuredCompanyName'],
      ),
    ];
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Successful'),
          content: Text('All validations passed!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  MediaType getContentType(String fileExtension) {
    switch (fileExtension.toLowerCase()) {
      case 'xlsx':
      case 'xls':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  List<Map<String, dynamic>> entrollerdata = [];
  Future<void> _postAdditionalApiCall(
      BuildContext context, fileBytes, String fileName) async {
    try {
      String? tpaName = widget.tpaName;

      var headers = await ApiServices.getHeaders();

      final apiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.valueValidaterApi)
              .replace(queryParameters: {'tpaName': tpaName});

      var request = http.MultipartRequest("POST", (apiUrl))
        ..headers.addAll(headers);

      var multipartFile = http.MultipartFile.fromBytes(
        'multipartFile',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseStream = await response.stream.bytesToString();
        entrollerdata =
            List<Map<String, dynamic>>.from(json.decode(responseStream));

        showEmpDetails(context, entrollerdata, fileBytes, fileName);
      } else {
        _showErrorDialog(context, 'HTTP error ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
    }
  }

  bool isEmpDataUploadSuccessful = false;

  Map<String, dynamic> fileResponses = {};

  Future<void> uploadEntrollementWithTpaNmae(
    List<Map<String, dynamic>> empDataList,
  ) async {
    try {
      var headers = await ApiServices.getHeaders();
      int? clientListId = widget.clientId;
      String? productId = widget.productIdvar;

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.uploadEntrollermentDetail)
              .replace(queryParameters: {
        "clientListId": clientListId.toString(),
        "productId": productId.toString(),
      });

      final response = await http.post(
        uploadApiUrl,
        headers: headers, // Set headers in options
        body: jsonEncode(empDataList), // Convert list to JSON string
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful upload
        Loader.hideLoader();
        _fetchData(
            _selectedMonth); // Fetch updated data after successful upload
        Fluttertoast.showToast(
          msg: 'Uploaded successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        setState(() {
          isEmpDataUploadSuccessful = true;
        });
      } else {
        // Handle upload failure
        Loader.hideLoader();
        Fluttertoast.showToast(
          msg: 'Upload failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      // Handle any exceptions
      Loader.hideLoader();
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print('Error: ${e.toString()}'); // Log the error message
    }
  }

  Future<void> showEmpDetails(
      BuildContext context,
      List<Map<String, dynamic>> entrollerdata,
      Uint8List fileBytes,
      String fileName) async {
    Loader.hideLoader();
    print("data showing");

    if (entrollerdata == null) {
      // Handle case where entrollerdata is null
      print('entrollerdata is null');
      return;
    }

    int successRecords = entrollerdata.where((data) {
      return data['employeeIdStatus'] ??
          false || data['employeeNameStatus'] ??
          false || data['dateOfBirthStatus'] ??
          false || data['genderStatus'] ??
          false || data['relationStatus'] ??
          false || data['ageStatus'] ??
          false || data['dateOfJoiningStatus'] ??
          false || data['insuredCompanyNameStatus'] ??
          false || data['groupNameStatus'] ??
          false || data['ecardNumber'] ??
          false || data['policyStartDateStatus'] ??
          false || data['policyEndDateStatus'] ??
          false || data['baseSumInsuredStatus'] ??
          false || data['topUpSumInsured'] ??
          false;
    }).length;
    int failedRecords = entrollerdata.length - successRecords;
    bool showUploadButton = successRecords == entrollerdata.length;
    print(showUploadButton);
    print(failedRecords);
    print(successRecords);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              //  Color(0xFFFFFFFF),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          '  Entrollerment Upload ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  // SizedBox(height: 1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          // Your style here...
                          child: Text(
                            'Success Records - $successRecords',
                            style: GoogleFonts.poppins(
                                color: SecureRiskColours.Button_Color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            // Your style here...
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: GestureDetector(
                              onTap: () {
                                print("dfhgf");
                                showEmpFailedRecords(context, entrollerdata,
                                    fileBytes, fileName);
                              },
                              child: Text(
                                'Failed Records - $failedRecords',
                                style: GoogleFonts.poppins(
                                    color: Colors
                                        .red, //SecureRiskColours.Button_Color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decorationColor: Colors.red,
                                    decoration: TextDecoration.underline),
                                // Your style here...
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              content: SingleChildScrollView(
                child: Container(
                  child: LazyLoadingDataTable(
                    entrollerList: entrollerdata,
                  ),
                ),
              ),
              actions: [
                if (showUploadButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: SecureRiskColours.Button_Color,
                    ),
                    onPressed: () async {
                      // Perform upload operation
                      await uploadEntrollementWithTpaNmae(entrollerdata);

                      // Close the dialog after upload completes
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Upload',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void showEmpFailedRecords(
      BuildContext context,
      List<Map<String, dynamic>> empDataList,
      Uint8List fileBytes,
      String fileName) {
    Loader.hideLoader();
    int successRecords = empDataList.where((data) {
      return data['employeeIdStatus'] &&
          data['employeeNameStatus'] &&
          data['dateOfBirthStatus'] &&
          data['genderStatus'] &&
          data['relationStatus'] &&
          data['ageStatus'] &&
          data['dateOfJoiningStatus'] &&
          data['insuredCompanyNameStatus'] &&
          data['groupNameStatus'] &&
          data['ecardNumber'] &&
          data['policyStartDateStatus'] &&
          data['policyEndDateStatus'] &&
          data['baseSumInsuredStatus'] &&
          data['topUpSumInsured'];
    }).length;
    List<Map<String, dynamic>> empFailedRecords = empDataList.where((data) {
      return !(data['employeeIdStatus'] &&
          data['employeeNameStatus'] &&
          data['dateOfBirthStatus'] &&
          data['genderStatus'] &&
          data['relationStatus'] &&
          data['ageStatus'] &&
          data['dateOfJoiningStatus'] &&
          data['insuredCompanyNameStatus'] &&
          data['groupNameStatus'] &&
          data['ecardNumber'] &&
          data['policyStartDateStatus'] &&
          data['policyEndDateStatus'] &&
          data['baseSumInsuredStatus'] &&
          data['topUpSumInsured']);
    }).toList();
    int failedRecords = empDataList.length - successRecords;
    bool showUploadButton = successRecords == empDataList.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          '  Failed Records Employee Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Text(
                              'Failed  Records - $failedRecords',
                              style: GoogleFonts.poppins(
                                  color: SecureRiskColours.Button_Color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              // Your style here...
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                  child: LazyLoadingDataTable(
                    entrollerList: empFailedRecords,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
// Import 'html' for web-specific operations

  Future<void> _handleWebDownload(String name, BuildContext context) async {
    try {
      var headers = await ApiServices.getHeaders();
      String clientListId = widget.clientId.toString();
      String? productId = widget.productIdvar;

      final apiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.exportEntrollermentDetail)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
      });

      final response = await http.get(apiUrl, headers: headers);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Ensure response body is not empty
        if (response.bodyBytes.isNotEmpty) {
          // Create a blob from the response body bytes
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          // Create an anchor element to initiate the file download
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = "$name.xlsx";
          anchor.click();

          // Revoke the object URL to free up resources
          html.Url.revokeObjectUrl(url);
        } else {
          // Show error dialog for empty response body
          _showErrorDialog(context, 'Download failed: Empty response');
        }
      } else if (response.statusCode == 204) {
        // Show info dialog for no data uploaded
        _showInfoDialog(context, 'No Data Uploaded...!');
      } else {
        // Show error dialog for other HTTP errors
        _showErrorDialog(context, 'HTTP error ${response.statusCode}');
      }
    } catch (e) {
      // Show error dialog for caught exceptions
      _showErrorDialog(context, 'Error: $e');
    }
  }

  void _showInfoDialog(BuildContext context, String message) {
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
      desc: message,
      showCloseIcon: true,
      btnCancelOnPress: () {
        //  Navigator.of(context).pop();
      },
      btnOkOnPress: () {
        //  Navigator.of(context).pop();
      },
    ).show();
  }

  Future<void> _fetchData(String? selectedMonth) async {
    if (_loading) return; // Prevent multiple simultaneous requests
    setState(() {
      _loading = true;
    });

    var headers = await ApiServices.getHeaders();
    String clientListId = widget.clientId.toString();
    String? productId = widget.productIdvar;

    try {
      final uploadApiUrl = Uri.parse(
              ApiServices.baseUrl + ApiServices.getAllClientEntrollmentDetails)
          .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
        "month": _selectedMonth
        // "page": _page.toString(),
        // "pageSize": _pageSize.toString(),
      });
      final response = await http.get(uploadApiUrl, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          _data.clear();
          _data.addAll(jsonResponse
              .map((item) => UploadFile(
                  employeeId: item['employeeId'] ?? ' ',
                  employeeName: item['employeeName'] ?? ' ',
                  dateOfBirth: item['dateOfBirth'] ?? ' ',
                  relationship: item['relation'] ?? ' ',
                  gender: item['gender'] ?? ' ',
                  dateOfJoining: item['dateOfJoining'] ?? ' ',
                  ecardNumber: item['ecardNumber'] ?? ' ',
                  policyCommencementDate: item['policyCommencementDate'] ?? ' ',
                  policyValidUpto: item['policyValidUpto'] ?? ' ',
                  baseSumInsured: item['baseSumInsured'] ?? ' ',
                  topUpSumInsured: item['topUpSumInsured'] ?? ' ',
                  groupName: item['groupName'] ?? ' ',
                  insuredCompanyName: item['insuredCompanyName'] ?? ' ',
                  month: item['month'] ?? ' '))
              .toList());
          _page++; // Increment page for the next request
          _loading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  String _searchText = '';
  // void _handleSearch(String value) {
  //   setState(() {
  //     _searchText = value;
  //     // _filteredData = getFilteredData();
  //     // _updateDataTable();
  //   });
  // }

// List<Endorsement> _filteredData = [];
  void _clearTable() {
    setState(() {
      // _filteredData.clear(); // Clear the list of rows
    });
  }

  int currentPage = 1;
  int pageSize = 7;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    int snum = startIndex + 1;
    int totalInsurers = _data.length;

    final List<UploadFile> currentPageInsurers = startIndex < totalInsurers
        ? _data.sublist(
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
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
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
                              value: _selectedMonth,
                              onChanged: _handleMonthByChange,
                              items: _monthOption.map((String value) {
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
                              labelText: 'Search',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
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
                              hint: Text('Filter By',
                                  style: GoogleFonts.poppins()),
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
                            onPressed: () async {
                              await _handleWebDownload(
                                  "entrollermentfile", context);
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    'Export ',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Align(
                        child: Container(
                          height: 40,
                          child: ElevatedButton(
                            style: SecureRiskColours.customButtonStyle(),
                            onPressed: () {
                              // enrollmentHandleUpload(context);
                              _uploadFile(context);
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    'Upload ',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Align(
                        child: Container(
                          height: 40,
                          child: ElevatedButton(
                            style: SecureRiskColours.customButtonStyle(),
                            onPressed: () {
                              // _clearTable();
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    'Clear ',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
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
                                    color: Colors.white.withOpacity(
                                        0.2), // Light black border color
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Adjust the border radius as needed
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: IconButton(
                              onPressed: () {
                                // Handle edit button action for the current row
                              },
                              icon: Icon(Icons.settings, size: 20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    height: screenHeight * 0.7,
                    child: _loading
                        ? Center(child: CircularProgressIndicator())
                        : _data.isEmpty // Check if _data is empty
                            ? Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Scrollbar(
                                thumbVisibility: true,
                                controller: _horizontalScrollController,
                                child: SingleChildScrollView(
                                  controller: _horizontalScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    controller: _verticalScrollController,
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                        columnSpacing: 20,
                                        headingRowColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            return SecureRiskColours
                                                .Table_Heading_Color;
                                          },
                                        ),
                                        columns: [
                                          DataColumn(
                                              label: Text(
                                            'EMPLOYEE ID',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                          DataColumn(
                                              label: Text('EMPLOYEE NAME',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('DATE OF BIRTH',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('GENDER',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('RELATION',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('DATE OF JOINING',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('ECARD NUMBER',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text(
                                                  'POLICY COMMENCEMENT DATE',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('POLICY VALID UPTO',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('BASE SUM INSURED',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('TOPUP SUM INSURED',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text('GROUP NAME',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ))),
                                          DataColumn(
                                              label: Text(
                                                  'INSURANCE COMPANY NAME',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          DataColumn(
                                              label: Text("MONTH",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ],
                                        rows: [
                                          for (int index = 0;
                                              index <
                                                  currentPageInsurers.length;
                                              index++)
                                            DataRow(cells: [
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .employeeId)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .employeeName)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .dateOfBirth)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .gender)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .relationship)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .dateOfJoining)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .ecardNumber)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .policyCommencementDate)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .policyValidUpto)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .baseSumInsured)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .topUpSumInsured)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .groupName)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .insuredCompanyName)),
                                              DataCell(Text(
                                                  currentPageInsurers[index]
                                                      .month)),
                                            ])
                                        ]),
                                  ),
                                ),
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
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // Set the button's background color based on its state
                              if (states.contains(MaterialState.disabled)) {
                                // Disabled color
                                return Colors
                                    .grey; // Use any color for disabled state
                              }
                              // Enabled color
                              return SecureRiskColours
                                  .Button_Color; // Set the button color to purple
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // Set the text color based on button's state
                              return Colors.white; // Set text color to white
                            },
                          ),
                        ),
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
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // Set the button's background color based on its state
                              if (states.contains(MaterialState.disabled)) {
                                // Disabled color
                                return Colors
                                    .grey; // Use any color for disabled state
                              }
                              // Enabled color
                              return SecureRiskColours
                                  .Button_Color; // Set the button color to purple
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // Set the text color based on button's state
                              return Colors.white; // Set text color to white
                            },
                          ),
                        ),
                        child: Text('Next'),
                      ),
                    ],
                  ),
                // ElevatedButton(
                //   onPressed: _loadMoreRecords,
                //   child: shouldShowLoadMore()
                //       ? Text('Load More', style: TextStyle(color: Colors.black))
                //       : Text('End', style: TextStyle(color: Colors.black)),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LazyLoadingDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> entrollerList;

  LazyLoadingDataTable({required this.entrollerList});

  @override
  _LazyLoadingDataTableState createState() => _LazyLoadingDataTableState();
}

class _LazyLoadingDataTableState extends State<LazyLoadingDataTable> {
  int visibleRecords = 10; // Number of records initially visible
  int increment = 10; // Number of records to load on each lazy load

  @override
  Widget build(BuildContext context) {
    final ScrollController _horizontalScrollController = ScrollController();
    final ScrollController _verticalScrollController = ScrollController();

    return Column(
      children: [
        Scrollbar(
          thumbVisibility: true,
          controller: _horizontalScrollController,
          thickness: 8,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.grey[300]!; // Set your heading row color
                  },
                ),
                columns: _buildColumns(),
                rows: _buildDataRows(),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: shouldShowLoadMore() ? _loadMoreRecords : _closeScreen,
          child: shouldShowLoadMore()
              ? Text('Load More', style: TextStyle(color: Colors.black))
              : Text('End', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _createDataColumn('EMPLOYEE ID'),
      _createDataColumn('EMPLOYEE NAME'),
      _createDataColumn('DATE OF BIRTH'),
      _createDataColumn('GENDER'),
      _createDataColumn('RELATION'),
      _createDataColumn('AGE'),
      _createDataColumn('DATE OF JOINING'),
      _createDataColumn('ECARD NUMBER'),
      _createDataColumn('POLICY COMMENCEMENT DATE'),
      _createDataColumn('POLICY VALID UPTO'),
      _createDataColumn('BASE SUM INSURED'),
      _createDataColumn('TOPUP SUM INSURED'),
      _createDataColumn('GROUP NAME'),
      _createDataColumn('INSURANCE COMPANY NAME'),
    ];
  }

  DataColumn _createDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    return List.generate(visibleRecords, (index) {
      if (index < widget.entrollerList.length) {
        Map<String, dynamic> data = widget.entrollerList[index];
        return DataRow(cells: _buildDataCells(data));
      } else {
        return DataRow(cells: [
          DataCell(Text('')), // Placeholder for additional cells
        ]);
      }
    });
  }

  List<DataCell> _buildDataCells(Map<String, dynamic> data) {
    return [
      //
      _buildDataCell(data['employeeId'], data['employeeIdStatus']),
      _buildDataCell(data['employeeName'], data['employeeNameStatus']),
      _buildDataCell(data['dateOfBirth'], data['dateOfBirthStatus']),
      _buildDataCell(data['gender'], data['genderStatus']),
      _buildDataCell(data['relationship'], data['relationshipStatus']),
      _buildDataCell(data['age'], data['ageStatus']),
      _buildDataCell(data['dateOfJoining'], data['dateOfJoiningStatus']),
      _buildDataCell(data['ecardNumber'], data['ecardNumberStatus']),
      _buildDataCell(data['policyStartDate'], data['policyStartDateStatus']),
      _buildDataCell(data['policyEndDate'], data['policyEndDateStatus']),
      _buildDataCell(data['baseSumInsured'], data['baseSumInsuredStatus']),
      _buildDataCell(data['topUpSumInsured'], data['topUpSumInsuredStatus']),
      _buildDataCell(data['groupName'], data['groupNameStatus']),
      _buildDataCell(
          data['insuredCompanyName'], data['insuredCompanyNameStatus']),
    ];
  }

  DataCell _buildDataCell(String? value, bool? status) {
    return DataCell(
      Text(
        value ?? '',
        style: TextStyle(
          color: status == true ? Colors.black : Colors.red,
        ),
      ),
    );
  }

  void _loadMoreRecords() {
    setState(() {
      visibleRecords += increment;
      if (visibleRecords >= widget.entrollerList.length) {
        visibleRecords = widget.entrollerList.length;
      }
    });
  }

  void _closeScreen() {
    Navigator.pop(context); // Close the current screen
  }

  bool shouldShowLoadMore() {
    return visibleRecords < widget.entrollerList.length;
  }
}

Widget _buildStatusIcon(bool isValid) {
  return Icon(
    isValid ? Icons.check_circle : Icons.cancel,
    color: isValid ? Colors.green : Colors.red,
  );
}
