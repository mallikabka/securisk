import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginapp/FreshPolicyFields/UploadedFileCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../Colours.dart';
import '../Service.dart';

import 'package:http_parser/http_parser.dart';

enum SingingCharacter { lafayette, jefferson }

final TextEditingController SumInsureded = TextEditingController();
final TextEditingController policyType = TextEditingController();

String fileName = "";
List<int>? _selectedFile;
Uint8List? _bytesData;
SingingCharacter? _character;

final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: GoogleFonts.poppins(fontSize: 20));
Map<String, dynamic> fileResponses = {};

class CoverageDetails1 extends StatefulWidget {
  final GlobalKey<CoverageDetailsState1>? coverageDetails1Key;
  CoverageDetails1({Key? key, this.coverageDetails1Key}) : super(key: key);

  @override
  State<CoverageDetails1> createState() => CoverageDetailsState1();
  static void nonEbClearFields() {
    policyType.text = "";
    SumInsureded.text = "";
    _character = null;
  }

  Future<void> createCoverageDetails1(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final rfqId = prefs.getString('responseBody');
    var headers = await ApiServices.getHeaders();
    final data = {
      'rfqId': rfqId,
      'policyType': policyType.text,
      'sumInsured': SumInsureded.text,
      "uploadedDocumentsPath": fileResponses["UploadedDocuments"] ?? "",
      "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
      "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
      "coveragesFilePath": fileResponses["CoveragesSought"] ?? "",
      "claimsMiscFilePath": fileResponses["FilledTemplate"] ?? "",
      "claimsSummaryFilePath": fileResponses["Dependentdata"] ?? "",
      "templateFilePath": fileResponses["EmpData"] ?? "",
      "policyCopyFilePath": fileResponses["EmpData"] ?? "",
    };

    final url = Uri.parse(
        ApiServices.baseUrl + ApiServices.createcoverageDetails_Endpoint);

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CoverageDetails saved successfully',
      );
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CoverageDetails failed to  save.....!',
      );
    }
  }
}

http.MultipartRequest jsonToFormData(
    http.MultipartRequest request, Map<String, dynamic> data) {
  for (var key in data.keys) {
    request.fields[key] = data[key].toString();
  }
  return request;
}

class CoverageDetailsState1 extends State<CoverageDetails1> {
  final alphabetsAndSpace = RegExp(r'[a-zA-Z ]');
  String? PolicyTypeError = "";
  String? SumInsuredError = "";
  bool nextClicked = false;
  bool uploadMandateText = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool validateDemoCoverageDetails() {
    _formSubmitted = true;
    formKey.currentState!.validate();
    nextClicked = true;
    if (formKey.currentState == null) {
      return false; // Handle the case when formKey or currentState is null
    }

    bool status = formKey.currentState!.validate();
    if (_character == null) {}
    if (_character != null) {}
    if (_character != null && status == true) {
      return true;
    }

    return false;
  }

  Map<String, bool> uploadSuccessMap = {
    "MandateLetter": false,
    "UploadedDocuments": false

    // Add more file types as needed
  };

  Future<void> _uploadFile(String fileType, String fileNmae) async {
    final prefs = await SharedPreferences.getInstance();
    final rfqId = prefs.getString('responseBody');
    try {
      var headers = await ApiServices.getHeaders();
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.Coverage_Upload_Endpoint);
      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        var fileBytes = result.files.first.bytes;
        var multipartFile = http.MultipartFile.fromBytes(
          'file',
          fileBytes!,
          filename: fileName,
          contentType: MediaType('application', 'octet-stream'),
        );
        request.files.add(multipartFile);
        request.fields['fileType'] = fileType;
        request.fields['rfqId'] = rfqId!;
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200 || response.statusCode == 201) {
          fileResponses[fileType] = responseBody; // Store the response
          ("Response for $fileType: $responseBody"); //  the response
          setState(() {
            uploadSuccessMap[fileType] =
                true; // Set the success flag for the fileType
          });
          toastification.showSuccess(
            context: context,
            autoCloseDuration: Duration(seconds: 2),
            title: 'File uploaded successfully.....!',
          );
        } else {
          toastification.showError(
            context: context,
            autoCloseDuration: Duration(seconds: 2),
            title: 'File upload failed.....!',
          );
        }
      } else {
        return; // File picker was canceled or failed
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'An error occurred Please try again.....!',
      );
    }
  }

  Future<void> uploadMandateLetter(String fileType) async {
    final prefs = await SharedPreferences.getInstance();
    final rfqId = prefs.getString('responseBody');
    var headers = await ApiServices.getHeaders();
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) {
        return; // File picker was canceled or failed
      }

      var file = result.files.first;
      var fileName = file.name;
      var fileExtension = fileName.split('.').last.toLowerCase();

      if (fileExtension != 'pdf') {
        // Show an error message because the selected file is not a PDF
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Please select a PDF file.',
        );
        return;
      }

      var fileBytes = file.bytes;
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes!,
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      );

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.Coverage_Upload_Endpoint);
      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);
      request.files.add(multipartFile);
      request.fields['fileType'] = fileType;
      request.fields['rfqId'] = rfqId!;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Store the response
        fileResponses[fileType] = responseBody;
        // Set the success flag for the fileType
        setState(() {
          uploadSuccessMap[fileType] = true;
        });

        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File uploaded successfully.....!',
        );
      } else {
        // Show an error notification
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File upload failed.....!',
        );
      }
    } catch (e) {
      // Show an error notification in case of an exception
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File upload failed.....!',
      );
    }
  }

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _formSubmitted = false;
  bool uploadMandateLettererror = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        child: Row(
                          children: [
                            Container(
                              width: screenWidth * 0.35,
                              child: AppBar(
                                toolbarHeight: SecureRiskColours.AppbarHeight,
                                backgroundColor:
                                    SecureRiskColours.Table_Heading_Color,
                                title: Text(
                                  "Details",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 17,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Container(
                          //color: Colors.white,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text("Policy Type",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(25, 26, 25, 1))),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    height: PolicyTypeError == null ||
                                            PolicyTypeError!.isEmpty
                                        ? 40.0
                                        : 65.0,
                                    width: screenWidth * 0.23,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 2),
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              alphabetsAndSpace) // Allow only numeric input
                                        ],
                                        controller: policyType,
                                        // maxLength: 100,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                          hintText: 'Policy Type',
                                          hintStyle:
                                              GoogleFonts.poppins(fontSize: 13),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(3),
                                            ),
                                            borderSide: BorderSide(
                                                // color: Colors.white,
                                                ),
                                          ),
                                        ),
                                        validator: (value) {
                                          setState(() {
                                            PolicyTypeError =
                                                validateString(value);
                                          });
                                          return PolicyTypeError;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text("Sum Insured",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(25, 26, 25, 1))),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    height: SumInsuredError == null ||
                                            SumInsuredError!.isEmpty
                                        ? 40.0
                                        : 65.0,
                                    width: screenWidth * 0.23,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 2),
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: SumInsureded,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                          hintText: 'Sum Insured',
                                          hintStyle:
                                              GoogleFonts.poppins(fontSize: 13),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(3),
                                            ),
                                            borderSide: BorderSide(
                                                // color: Colors.white,
                                                ),
                                          ),
                                        ),
                                        validator: (value) {
                                          setState(() {
                                            SumInsuredError =
                                                validateString(value);
                                          });
                                          return SumInsuredError;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align children to the left
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Align children to the left
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: .0),
                                    child: ListTile(
                                      title: Text(
                                        'I have employee data',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      leading: Radio<SingingCharacter>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => SecureRiskColours
                                                    .Button_Color),
                                        value: SingingCharacter.lafayette,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                            uploadSuccessMap["MandateLetter"] =
                                                false;
                                            uploadSuccessMap[
                                                "UploadedDocuments"] = false;
                                            fileResponses["EmpDepData"] = "";
                                            fileResponses["MandateLetter"] = "";
                                            fileResponses["CoveragesSought"] =
                                                "";
                                            fileResponses["ClaimsMis"] = "";
                                            fileResponses["ClaimsSummary"] = "";
                                            fileResponses["PolicyCopy"] = "";
                                            fileResponses["UploadedDocuments"] =
                                                "";
                                            formKey.currentState!.validate(); //
                                            _formSubmitted = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'I need to get the data from employees',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Radio<SingingCharacter>(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              SecureRiskColours.Button_Color),
                                      value: SingingCharacter.jefferson,
                                      groupValue: _character,
                                      onChanged: (SingingCharacter? value) {
                                        setState(() {
                                          _character = value;
                                          _formSubmitted = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_character == SingingCharacter.lafayette) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // Align children to the left
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 300),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Upload Documents ",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (uploadSuccessMap.containsKey(
                                                      "UploadedDocuments") &&
                                                  !uploadSuccessMap[
                                                      "UploadedDocuments"]!) {
                                                _uploadFile("UploadedDocuments",
                                                    fileName);
                                              }
                                            },
                                            icon: uploadSuccessMap.containsKey(
                                                        "UploadedDocuments") &&
                                                    uploadSuccessMap[
                                                        "UploadedDocuments"]!
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Color.fromARGB(
                                                        255, 62, 233, 105),
                                                    size: 40,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .drive_folder_upload_rounded,
                                                    color: SecureRiskColours
                                                        .Button_Color,
                                                    size: 40,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    if (uploadSuccessMap["UploadedDocuments"] ==
                                        true)
                                      UploadedFileCard(
                                        fileType: "Uploaded Docs..!",
                                        onClose: () {
                                          // Handle card's cross mark action
                                          setState(() {
                                            uploadSuccessMap[
                                                "UploadedDocuments"] = false;
                                            fileResponses["UploadedDocuments"] =
                                                "";
                                          });
                                        },
                                      ),
                                    SizedBox(height: 10),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 300),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Mandate Letter ",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (uploadSuccessMap.containsKey(
                                                      "MandateLetter") &&
                                                  !uploadSuccessMap[
                                                      "MandateLetter"]!) {
                                                uploadMandateLetter(
                                                    "MandateLetter");
                                              }
                                            },
                                            icon: uploadSuccessMap.containsKey(
                                                        "MandateLetter") &&
                                                    uploadSuccessMap[
                                                        "MandateLetter"]!
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Color.fromARGB(
                                                        255, 62, 233, 105),
                                                    size: 40,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .drive_folder_upload_rounded,
                                                    color: SecureRiskColours
                                                        .Button_Color,
                                                    size: 40,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    if (uploadSuccessMap["MandateLetter"] ==
                                        true)
                                      UploadedFileCard(
                                        fileType: "Mandate Letter",
                                        onClose: () {
                                          // Handle card's cross mark action
                                          setState(() {
                                            uploadSuccessMap["MandateLetter"] =
                                                false;
                                          });
                                        },
                                      ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 10,
                            ),
                            // Validation message
                            if (_formSubmitted && _character == null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please select an option.',
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 12.0,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
