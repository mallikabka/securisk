import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/RenewalEditCover.dart';
import 'package:loginapp/EditRfq/RenewalEditCoverage.dart';
import 'dart:convert';
import 'package:loginapp/RenewalPolicy/RenewalCoverageDetails.dart';
import 'package:loginapp/Service.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:toastification/toastification.dart';

class RenewalEditClaimsMisData {
  final GlobalKey<RenewalEditCoverState>? renewalEditCoverageDetailsState;

  RenewalEditClaimsMisData({this.renewalEditCoverageDetailsState});

  Future<void> renewalEditClaimsMisUpload(
      String tpaName, BuildContext context, String fileType) async {
    var headers = await ApiServices.getHeaders();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'XLSX', 'XLS'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      if (result.files.first.extension == 'xlsx' ||
          result.files.first.extension == 'xls') {
        try {
          final apiUrl = Uri.parse(ApiServices.baseUrl +
              ApiServices.ClaimsMis_Headers_validation +
              "?tpaName=" +
              tpaName);

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

          if (response.statusCode == 200) {
            final validationResponse = await response.stream.bytesToString();
            final validationResult = json.decode(validationResponse);

            final bool status = validationResult['status'];

            if (status == true) {
              // When 'status' is true, you can proceed with further actions.
              await _postAdditionalApiCall(
                  context, fileBytes, fileType, tpaName, fileName);
            } else {
              _showClaimsValidationDialog(context, validationResult);
              // When 'status' is not true, you can handle it as needed.
              // For example, you can show a message or take other actions.
            }
          } else {
            toastification.showError(
              context: context,
              autoCloseDuration: Duration(seconds: 2),
              title: 'Please select correct tpa...!',
            );
            // _showClaimsValidationDialog(context, {}); // API error, show dialog with crosses
          }
        } catch (e) {
          toastification.showError(
            context: context,
            autoCloseDuration: Duration(seconds: 2),
            title: 'Please select a file......!',
          );
          // _showClaimsValidationDialog(context, {}); // Error, show dialog with crosses
        }
      }
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Please pick a file...!',
      );
      // File picker was canceled
    }
  }

  Future<void> _postAdditionalApiCall(
      BuildContext context, fileBytes, fileType, tpaName, fileName) async {
    try {
      var headers = await ApiServices.getHeaders();
      final apiUrl = Uri.parse(ApiServices.baseUrl +
          ApiServices.GetAllClaimsMisWithStatus +
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
        final responseStream = await response.stream.bytesToString();
        renewalempDataList =
            List<Map<String, dynamic>>.from(json.decode(responseStream));
        showEmpDetails(context, renewalempDataList, fileBytes, fileName);
      } else {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Please try again.....!',
        );
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Please try again.....!',
      );
    }
  }

  void showEmpDetails(
      BuildContext context,
      List<Map<String, dynamic>> renewalempDataList,
      Uint8List fileBytes,
      String fileName) {
    int successRecords = renewalempDataList.where((data) {
      return data['status'];
    }).length;
    int failedRecords = renewalempDataList.length - successRecords;
    bool showUploadButton = successRecords == renewalempDataList.length;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Claims Data',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
              //SizedBox(height: 10),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align the row to the right
                children: [
                  Text(
                    'Success Records - $successRecords',
                    style: GoogleFonts.poppins(
                        color: SecureRiskColours.Button_Color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Failed Records - $failedRecords',
                    style: GoogleFonts.poppins(
                        color: SecureRiskColours.Button_Color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 10.0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ScrollableTableView(
              headerBackgroundColor: SecureRiskColours.Table_Heading_Color,
              // headers: [
              //   'Policy Number',
              //   'Claim Number',
              //   'Employee Id',
              //   'Employee Name',
              //   'Relation Ship',
              //   'Gender',
              //   'Age',
              //   'Beneficiary Name',
              //   'SumInsured',
              //   'Claimed Amount',
              //   'Paid Amount',
              //   'Date Of Claim',
              //   'Claim Type',
              //   'Network Type',
              //   'Hospital Name',
              //   'Location',
              //   'Billed Amount',
              //   'Admission Date',
              //   'Disease',
              //   'Treatment',
              //   'Category',
              //   'Status',
              // ].map((label) {
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
                    'Outstanding Amount',
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
                    color: Colors.white,
                  ), // Customize the text color
                  // backgroundColor: Color.fromRGBO(189, 75, 73, 0.871),
                  minWidth: double.parse("190"),
                );
              }).toList(),
              rows: renewalempDataList.map((data) {
                return TableViewRow(
                  backgroundColor: Color.fromARGB(255, 242, 243, 245),
                  height: 60,
                  // cells: [
                  //   'policyNumber',
                  //   'claimsNumber',
                  //   'employeeId',
                  //   'employeeName',
                  //   'relationship',
                  //   'gender',
                  //   'age',
                  //   'beneficiaryName',
                  //   'sumInsured',
                  //   'claimedAmount',
                  //   'paidAmount',
                  //   'dateOfClaim',
                  //   'claimType',
                  //   'networkType',
                  //   'hospitalName',
                  //   'location',
                  //   'billedAmount',
                  //   'admissionDate',
                  //   'disease',
                  //   'treatment',
                  //   'category',
                  //   'status',
                  // ].map((key) {
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
                          style: GoogleFonts.poppins(color: Colors.black),
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
          actions: [
            if (showUploadButton)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromRGBO(199, 55, 125, 1.0), // Hovered color

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  renewalEditCoverageDetailsState?.currentState
                      ?.uploadRenewalEditClaimsMis(
                          fileBytes, "ClaimsMis", fileName);
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
  }

  // Map<String, String> claimsfields = {
  //   'policyNumberStatus': 'Policy Number',
  //   'claimsNumberStatus': 'Claim Number',
  //   'employeeIdStatus': 'Employee Id',
  //   'employeeNameStatus': 'Employee Name',
  //   'relationshipStatus': 'Relation Ship',
  //   'genderStatus': 'Gender',
  //   'ageStatus': 'Age',
  //   // 'dataOfBirth': 'Date Of Birth',
  //   'beneficiaryNameStatus': 'Beneficiary Name',
  //   'sumInsuredStatus': 'SumInsured',
  //   'claimedAmountStatus': 'Claimed Amount',
  //   'paidAmountStatus': 'Paid Amount',
  //   'dateOfClaimStatus': 'Date Of Claim',
  //   'typeStatus': 'Type',
  //   'status': '	Status',
  //   'networkTypeStatus': 'Network Type',
  //   'hospitalNameStatus': 'Hospital Name',
  //   'locationStatus': 'Location',
  //   'billedAmountStatus': 'Billed Amount',
  //   'admissionDateStatus': 'Admission Date',
  //   'diseaseStatus': '	Disease',
  //   'treatmentStatus': 'Treatment',
  //   'categoryStatus': 'Category',
  // };
 Map<String, String> claimsfields = {
    'policyNumberStatus': 'Policy Number',
    'claimsNumberStatus': 'Claim Number',
    'employeeIdStatus': 'Employee Id',
    'employeeNameStatus': 'Employee Name',
    'relationshipStatus': 'Relation Ship',
    'genderStatus': 'Gender',
    'ageStatus': 'Age',
    'patientNameStatus': 'Patient Name',
    'sumInsuredStatus': 'SumInsured',
    'claimedAmountStatus': 'Claimed Amount',
    'paidAmountStatus': 'Paid Amount',
    'dateOfClaimStatus': 'Date Of Claim',
    'status': '	Status',
    'networkTypeStatus': 'Network Type',
    'hospitalNameStatus': 'Hospital Name',
    // 'locationStatus': 'Location',
    // 'billedAmountStatus': 'Billed Amount',
    'admissionDateStatus': 'Admission Date',
    'diseaseStatus': 'Disease',
    // 'treatmentStatus': 'Treatment',
    // 'categoryStatus': 'Category',
    "outstandingAmountStatus": 'Outstanding Amount',
    "claimStatus": "Claim Status Value",
    "claimTypeStatus": 'Claim Type',//'ClaimType ',
    "dischargeDateStatus": 'Discharge Date',
    "memberCodeStatus": 'Member Code',
    "policyStartDateStatus": 'Policy StartDate',
    "policyEndDateStatus": 'Policy EndDate',
    "hospitalStateStatus": 'Hospital State',
    "hospitalCityStatus": 'Hospital City',
  };

  void _showClaimsValidationDialog(
      BuildContext context, Map<String, dynamic> validationResponse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Container(
            color: SecureRiskColours.Button_Color,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Text('Claims Header Validation'),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // for (String fieldKey in claimsfields.keys)
                  for (String responseKey in validationResponse.keys)
                    if (claimsfields.containsKey(responseKey))
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  claimsfields[responseKey]!,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // validationResponse.containsKey(fieldKey)
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
          ),
          // actions: [
          //   Center(
          //     child: ElevatedButton(
          //       onPressed: () {
          //         _showAddColumnDialog(context, validationResponse);
          //       },
          //       child: Text('Add Missing Column'),
          //     ),
          //   ),
          // ],
        );
      },
    );
  }

  Widget _buildStatusIcon(bool isValid) {
    return Icon(
      isValid ? Icons.check_circle : Icons.cancel,
      color: isValid ? Colors.green : Colors.red,
    );
  }
}
