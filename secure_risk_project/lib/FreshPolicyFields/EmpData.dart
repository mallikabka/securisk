import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/EditCover.dart';
import 'package:loginapp/FreshPolicyFields/CorporateDetails.dart';
import 'dart:convert';
import 'package:loginapp/FreshPolicyFields/CoverageDetails.dart';
import 'package:loginapp/FreshPolicyFields/NonEbCoverage.dart';
import 'package:loginapp/FreshPolicyFields/PolicyTerms.dart';
import 'package:loginapp/Service.dart';
import 'package:loginapp/Utilities/CircularLoader.dart';
import 'package:toastification/toastification.dart';
import 'package:velocity_x/velocity_x.dart';

class EmpData {
  final GlobalKey<CorporateDetailsState>? corporateDetailsKey;
  final GlobalKey<CoverageDetailsState>? coverageDetailsKey;
  final GlobalKey<PolicyTermsState>? policyTermsKey;
  final GlobalKey<CoverageDetailsState1>? coverageDetails1Key;
  final GlobalKey<EditCoverState>? coverDetails1Key;
  final List<String> empheaders;
  final GlobalKey<CoverageDetailsState>? CoverageDetailsKey;
  EmpData(
      {this.corporateDetailsKey,
      this.coverageDetailsKey,
      this.policyTermsKey,
      this.coverageDetails1Key,
      this.coverDetails1Key,
      required this.empheaders,
      this.CoverageDetailsKey});

  Future<void> handleUpload(BuildContext context, String fileName) async {
    var headers = await ApiServices.getHeaders();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name; // Get the selected file's name

      if (result.files.first.extension == 'xlsx' ||
          result.files.first.extension == 'XLSX' ||
          result.files.first.extension == 'xls' ||
          result.files.first.extension == 'XLS') {
        Loader.showLoader(context);
        try {
          final apiUrl = Uri.parse(ApiServices.baseUrl +
              ApiServices
                  .EmpData_Headers_validation); // Replace with actual API URL

          var request = http.MultipartRequest("POST", apiUrl)
            ..headers.addAll(headers);

          // Create multipart file
          var multipartFile = http.MultipartFile.fromBytes(
            'file',
            fileBytes!,
            filename: fileName, // Replace with your actual file name
            contentType: MediaType('application', 'octet-stream'),
          );

          // Add multipart file to request
          request.files.add(multipartFile);

          // Send the request and get response
          final response = await request.send();

          if (response.statusCode == 200) {
            final validationResponse = await response.stream.bytesToString();
            final validationResult = json.decode(validationResponse);

            final bool allHeadersMatch = validationResult.keys
                .where((key) => key != 'sno') // Exclude 'sno' from the check
                .every((key) => validationResult[key] == true);

            if (allHeadersMatch) {
              await _postAdditionalApiCall(context, fileBytes, fileName);
            } else {
              Loader.hideLoader();
              _showValidationDialog(context, validationResult);
            }
          } else {
            _showValidationDialog(
                context, {}); // API error, show dialog with crosses
          }
        } catch (e) {
          _showValidationDialog(context, {}); // Error, show dialog with crosses
        }
      } else {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Please select a Excel file....!',
        );
      }
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File upload failed.....!',
      );
    }
  }

  List<Map<String, dynamic>> empDataList = [];

  Future<void> _postAdditionalApiCall(
      BuildContext context, fileBytes, String fileName) async {
    var headers = await ApiServices.getHeaders();
    try {
      final apiUrl = Uri.parse(
          ApiServices.baseUrl + ApiServices.GetAllEmpDepDataWithStatus);
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
        final responseStream = await response.stream.bytesToString();
        empDataList =
            List<Map<String, dynamic>>.from(json.decode(responseStream));
        showEmpDetails(context, empDataList, fileBytes, fileName);
      } else {
        // Additional API call failed
      }
    } catch (e) {
      // Handle exception
    }
  }

  Map<String, String> fieldMappings = {
    'employeeId': 'Employee Id',
    'employeeName': 'Employee Name',
    'relationship': 'Relation Ship',
    'gender': 'Gender',
    'age': 'Age',
    'dateOfBirth': 'Date Of Birth',
    'sumInsured': 'Sum Insured',
  };

  void _showValidationDialog(
      BuildContext context, Map<String, dynamic> validationResponse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // bool allHeadersMatch = true;
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Container(
              color: SecureRiskColours
                  .Button_Color, // Set the background color for the title
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Text(
                'EmployeeData Header Validation',
                style: GoogleFonts.poppins(color: Colors.white),
              )),
          content: SizedBox(
            height: 310,
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // for (String field in fieldsToDisplay)
                for (String responseKey in validationResponse.keys)
                  if (fieldMappings.containsKey(
                      responseKey)) // Check if field is in mappings
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              fieldMappings[responseKey]!,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            validationResponse[responseKey] == true
                                ? Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 1,
                        ),
                      ],
                    ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _showAddColumnDialog(context, validationResponse);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromRGBO(199, 55, 125, 1.0), // Hovered color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Add Missing Column',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white // Hovered color
                    ,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddColumnDialog(context, Map<String, dynamic> validationResponse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String columnName = '';
        String selectedValidationField = '';

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Container(
              color: SecureRiskColours.Button_Color,
              // Set the background color for the title
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Text('Add Missing Column',
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
            content: SizedBox(
              height: 310,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 8),
                    child: Text(
                      'Column Name',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter Column Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      columnName = value;
                    },
                  ),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 8),
                    child: Text(
                      'Select Validation Field',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedValidationField.isNotEmpty
                        ? selectedValidationField
                        : null,
                    hint: Text('Select Validation Field'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: empheaders.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValidationField = value!;
                      });
                    },
                  ),
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(199, 55, 125, 1.0), // Hovered color

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        // Handle adding the missing column
                        if (columnName.isNotEmpty &&
                            selectedValidationField.isNotEmpty) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Adding Column'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Adding the missing column...'),
                                  ],
                                ),
                              );
                            },
                          );
                          await Future.delayed(
                            Duration(seconds: 2),
                            () {
                              // CircularProgressIndicator();
                            },
                          );
                          Navigator.pop(context);
                          final apiUrl = Uri.parse(
                              ApiServices.baseUrl + ApiServices.AddFileNames);
                          final requestBody = {
                            // selectedValidationField: columnName,
                            "headerName": selectedValidationField,
                            "headerCategory": "EmpDepData",
                            "headerAliasname": {
                              "aliasName": columnName,
                            },
                          };

                          try {
                            var headers = await ApiServices.getHeaders();
                            final response = await http.post(
                              (apiUrl),
                              body: json.encode(requestBody),
                              headers: headers,
                            );

                            if (response.statusCode == 200 ||
                                response.statusCode == 201) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pop();
                                  });

                                  return AlertDialog(
                                    title: Text('API Error'),
                                    content: Text(
                                        'An error occurred. Please try again.'),
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });

                                return AlertDialog(
                                  title: Text('API Error'),
                                  content: Text(
                                      'An error occurred. Please try again.'),
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Text(
                        'Add Column',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void showEmpDetails(
      BuildContext context,
      List<Map<String, dynamic>> empDataList,
      Uint8List fileBytes,
      String fileName) {
    Loader.hideLoader();
    int successRecords = empDataList.where((data) {
      return data['employeeIdValidationStatus'] &&
          data['employeeNameValidationStatus'] &&
          data['relationshipValidationStatus'] &&
          data['dateOfBirthValidationStatus'] &&
          data['genderValidationStatus'] &&
          data['ageValidationStatus'] &&
          data['sumInsuredValidationStatus'];
    }).length;

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
                          '   Employee Data',
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
                              'Success Records - $successRecords',
                              style: GoogleFonts.poppins(
                                  color: SecureRiskColours.Button_Color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              // Your style here...
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: GestureDetector(
                              onTap: () {
                                showEmpFailedRecords(
                                    context, empDataList, fileBytes, fileName);
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
                    empDataList: empDataList,
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
                        backgroundColor: SecureRiskColours.Button_Color),
                    onPressed: () async {
                      Loader.showLoader(context);
                      coverageDetailsKey!.currentState?.uploadEmpdataFile(
                          fileBytes, "EmpDepData", fileName);
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
      return data['employeeIdValidationStatus'] &&
          data['employeeNameValidationStatus'] &&
          data['relationshipValidationStatus'] &&
          data['dateOfBirthValidationStatus'] &&
          data['genderValidationStatus'] &&
          data['ageValidationStatus'] &&
          data['sumInsuredValidationStatus'];
    }).length;
    List<Map<String, dynamic>> empFailedRecords = empDataList.where((data) {
      return !(data['employeeIdValidationStatus'] &&
          data['employeeNameValidationStatus'] &&
          data['relationshipValidationStatus'] &&
          data['dateOfBirthValidationStatus'] &&
          data['genderValidationStatus'] &&
          data['ageValidationStatus'] &&
          data['sumInsuredValidationStatus']);
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
                        // SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                  child: LazyLoadingDataTable(
                    empDataList: empFailedRecords,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
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
  // int visibleRecords =  10;// 100 // Number of records initially visible
  // int increment = 100; // Number of records to load on each lazy load
  late int visibleRecords;
  int increment = 100; // Number of records to load on each lazy load

  @override
  void initState() {
    super.initState();
    visibleRecords = widget.empDataList.length;
  }

  final ScrollController _horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Scrollbar(
          showTrackOnHover: true,
          // isAlwaysShown: true, // Ensure that the scrollbar is always visible
          controller:
              _horizontalScrollController, // Assign the ScrollController
          thickness: 15,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 25.0,
              //dataRowHeight: 100,
              headingRowColor: MaterialStateColor.resolveWith((states) {
                return SecureRiskColours
                    .Table_Heading_Color; // Your style here...
              }),
              columns: [
                DataColumn(
                  label: Text(
                    'Employee No',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                DataColumn(
                    label: Text('EmployeeName',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text('Relationship',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(
                  'Date of Birth',
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
                DataColumn(
                    label: Text('Remarks',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(
                  'Status',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )), // Add the "Actions" column
              ],
              // rows: widget.empDataList.take(visibleRecords).map((data) {
              rows: [
                DataRow(cells: [
                  DataCell(Container(
                    height: 1, // Adjust the height of the horizontal bar
                    color: Colors.grey, // Set the color of the horizontal bar
                  )),
                ]),
                ...List<DataRow>.generate(
                  visibleRecords,
                  (index) {
                    if (index < widget.empDataList.length) {
                      Map<String, dynamic> data = widget.empDataList[index];
                      bool allFieldsValid =
                          data['employeeIdValidationStatus'] &&
                              data['employeeNameValidationStatus'] &&
                              data['relationshipValidationStatus'] &&
                              data['dateOfBirthValidationStatus'] &&
                              data['genderValidationStatus'] &&
                              data['ageValidationStatus'] &&
                              data['sumInsuredValidationStatus'] &&
                              data['ageValidationStatus'];

                      return DataRow(
                        cells: [
                          DataCell(Text(
                            data['employeeIdValue'] ?? '',
                            style: GoogleFonts.poppins(
                              color: data['employeeIdValidationStatus']
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          )),
                          DataCell(Text(
                            data['employeeNameValue'] ?? '',
                            style: GoogleFonts.poppins(
                              color: data['employeeNameValidationStatus']
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          )),
                          // Include other DataCell widgets here
                          DataCell(_buildStatusIcon(allFieldsValid)),
                        ],
                      );
                    } else {
                      return DataRow(cells: [
                        DataCell(Container(
                          height: 1, // Adjust the height of the horizontal bar
                          color: Colors
                              .grey, // Set the color of the horizontal bar
                        )),
                      ]);
                    }
                  },
                ),
              ],
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

Widget _buildStatusIcon(bool isValid) {
  return Icon(
    isValid ? Icons.check_circle : Icons.cancel,
    color: isValid ? Colors.green : Colors.red,
  );
}
