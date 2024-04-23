import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginapp/FreshPolicyFields/UploadedFileCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../Colours.dart';
import '../Service.dart';

import 'package:http_parser/http_parser.dart';

List<String> productCategories = ['Floater', 'Non-Floater'];

List<String> Definations = ['Fixed', 'Varied'];

enum SingingCharacter { lafayette, jefferson }

final TextEditingController SumInsureded = TextEditingController();
final TextEditingController policyType = TextEditingController();

enum SingingCharacter1 {
  fixed1,
  fixed2,
  fixed3,
}

String fileName = "";
List<int>? _selectedFile;
Uint8List? _bytesData;
SingingCharacter? _character;
SingingCharacter1? _character1;

//String? policyType;
String? familyDefination;
//String? SumInsureded;
bool? hasEmpData = false;
String? empfileResponses;
String? mandatefileResponse;
final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: GoogleFonts.poppins(fontSize: 20));
Map<String, dynamic> fileResponses = {};

// ignore: must_be_immutable
class RenewalEditRestCoverageDetails extends StatefulWidget {
  late String rfid;
  final GlobalKey<RenewalEditRestCoverageDetailsState>? coverageDetails1Key;
  RenewalEditRestCoverageDetails(
      {Key? key, this.coverageDetails1Key, required this.rfid})
      : super(key: key);

  @override
  State<RenewalEditRestCoverageDetails> createState() =>
      RenewalEditRestCoverageDetailsState();

  Future<void> updateCoverageDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final rfqId = prefs.getString('responseBody');
    var headers = await ApiServices.getHeaders();
    final data = {
      'rfqId': rfid,
      'policyType': policyType.text,
      // 'familyDefination': familyDefination,
      'sumInsured': SumInsureded.text,
      //'UploadedDocuments':up
      'uploadedDocumentsPath': fileResponses['UploadedDocuments'],
      "empDepDataFilePath": fileResponses["EmpData"] ?? "",
      "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
      "uploadDocumentData": fileResponses['uploadDocumentData'] ?? "",
      "empData": hasEmpData
    };

    final url = Uri.parse(ApiServices.baseUrl +
        ApiServices.renewal_Coverage_UpdateCoverage +
        rfid);

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      ("File uploaded successfully");
    } else {
      ('file upload failed');
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

class RenewalEditRestCoverageDetailsState
    extends State<RenewalEditRestCoverageDetails> {
  String? _PolicyTypeError = "";
  String? _SumInsuredError = "";
  bool validateRenewalEditRestCoverageDetails() {
    _formSubmitted = true;

    if (formKey.currentState == null) {
      return false; // Handle the case when formKey or currentState is null
    }

    bool status = formKey.currentState!.validate();

    return status;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoveragesById();
  }

  Future<void> getCoveragesById() async {
    String rfid = widget.rfid;
    var headers = await ApiServices.getHeaders();
    try {
      final res = await http.get(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.getcoveragesByIdDetails_Endpoint +
            rfid),
        headers: headers,
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(res.body);
        policyType.text = responseData['policyType'];
        SumInsureded.text = responseData['sumInsured'];
        fileResponses['UploadedDocuments'] =
            responseData['uploadedDocumentsPath'];
        fileResponses['MandateLetter'] = responseData['mandateLetterFilePath'];
        bool empDataField = responseData['empData'] ?? false;
        if (empDataField) {
          _character = SingingCharacter.lafayette;
          hasEmpData = true;
          // Add your criteria here
        } else {
          _character = SingingCharacter.jefferson;
          hasEmpData = false;
        }
        bool mandateLetterPathHasData =
            responseData['mandateLetterFilePath'] != null &&
                responseData['mandateLetterFilePath'].isNotEmpty;
        bool uploadDocumentData =
            responseData['uploadedDocumentsPath'] != null &&
                responseData['uploadedDocumentsPath'].isNotEmpty;
        uploadSuccessMap = {
          "MandateLetter": mandateLetterPathHasData,
          "UploadedDocuments": uploadDocumentData,
        };
        // familyDefination = responseData['familyDefination'];
        _character = SingingCharacter.lafayette;
        setState(() {}); // Update the UI with the new values
      } else {
        ('API error: ${res.statusCode}');
      }
    } catch (e) {
      ('Error: $e');
    }
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
          Fluttertoast.showToast(
            msg: 'File uploaded successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Upload failed. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        return; // File picker was canceled or failed
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

  Future<void> uploadMandateLetter(String fileType) async {
    final prefs = await SharedPreferences.getInstance();
    final rfqId = prefs.getString('responseBody');
    try {
      var headers = await ApiServices.getHeaders();
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
        // Show a success notification
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
                              width: screenWidth * 0.4,
                              child: AppBar(
                                toolbarHeight: SecureRiskColours.AppbarHeight,
                                backgroundColor:
                                    SecureRiskColours.Table_Heading_Color,
                                title: Text(
                                  "Details",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                elevation: 5,
                                automaticallyImplyLeading: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Container(
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
                                    height: _PolicyTypeError == null ||
                                            _PolicyTypeError!.isEmpty
                                        ? 40.0
                                        : 65.0,
                                    width: screenWidth * 0.23,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 2),
                                      child: TextFormField(
                                        controller: policyType,
                                        decoration: InputDecoration(
                                           contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                                            _PolicyTypeError =
                                                validateString(value);
                                          });
                                          return _PolicyTypeError;
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
                                    height: _SumInsuredError == null ||
                                            _SumInsuredError!.isEmpty
                                        ? 40.0
                                        : 65.0,
                                    width: screenWidth * 0.23,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 2),
                                      child: TextFormField(
                                        controller: SumInsureded,
                                        decoration: InputDecoration(
                                           contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                                            _SumInsuredError =
                                                validateString(value);
                                          });
                                          return _SumInsuredError;
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
                                            hasEmpData = true;
                                            _character = value;
                                            uploadSuccessMap["MandateLetter"] =
                                                false;
                                            uploadSuccessMap[
                                                "UploadedDocuments"] = false;
                                            // formKey.currentState!.validate(); //
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
                                          uploadSuccessMap["MandateLetter"] =
                                              false;
                                          uploadSuccessMap[
                                              "UploadedDocuments"] = false;
                                          // formKey.currentState!.validate(); //

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
                                            "Upload documents ",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 50,
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
                                    if (uploadSuccessMap["UploadedDocuments"] ==
                                        true)
                                      UploadedFileCard(
                                        fileType: "Uploaded Docs..!",
                                        onClose: () {
                                          // Handle card's cross mark action
                                          setState(() {
                                            uploadSuccessMap[
                                                "UploadedDocuments"] = false;
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
                                          SizedBox(
                                            width: 68,
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
