// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loginapp/Colours.dart';
// import 'package:loginapp/EditRfq/EditClaimsMisCard.dart';
// import 'package:loginapp/EditRfq/RenewalEditClaimsMisData.dart';
// import 'package:loginapp/EditRfq/RenewalEditCoveragecard.dart';
// import 'package:loginapp/EditRfq/RenewalEditEmpData.dart';
// import 'package:loginapp/FreshPolicyFields/UploadedFileCard.dart';
// import 'package:toastification/toastification.dart';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'dart:html' as html;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../FreshPolicyFields/CustonDropdown.dart';
// import '../Service.dart';
// import 'package:http_parser/http_parser.dart';

// List<String> productCategories = ['Floater', 'Non-Floater'];
// List<String> Definations = ['Fixed', 'Varied'];

// enum SingingCharacter { lafayette, jefferson }

// enum SingingCharacter1 {
//   fixed1,
//   fixed2,
//   fixed3,
// }

// enum SingingCharacter2 { fixed1, fixed2, fixed3 }

// List<String> insured = ['Fixed', 'Varied'];
// List<String> str = [
//   "Fill details of the employee only along with email ID and phone number.",
//   "Mentioning Family definition is important (ex: 1+3 or 1+5 or Parents only).",
//   "Please do not forget to upload other files (claims MIS, policy copy, mandate letter, etc...).",
//   "Please upload the data as per the downloaded template."
// ];

// String fileName = "";

// SingingCharacter? _character;
// SingingCharacter1? _character1;
// String? _characterError;
// String? _characterError1;
// String? policyType;
// String? familyDefination;
// String? SumInsureded;
// bool? hasEmpData = false;
// String? policyTypeError;
// String? familyDefinationError;
// String? sumInsurededError;
// List<String> addedItems = [''];
// List<String> OneThree = [''];
// List<String> OneFive = [''];
// List<String> ParentOnly = [''];

// bool isfamilyDefication13 = false;
// bool isfamilyDefication15 = false;
// bool isfamilyDeficationParents = false;
// List<double> familyDefication13 = [0.0];
// List<double> familyDefication15 = [0.0];
// List<double> familyDeficationParents = [0.0];

// final ButtonStyle style =
//     ElevatedButton.styleFrom(textStyle: GoogleFonts.poppins(fontSize: 20));

// Map<String, dynamic> fileResponses = {};
// Set<SingingCharacter2> _selectedCharacters = {};

// // ignore: must_be_immutable
// class RenewalEditCoverageDetails extends StatefulWidget {
//   late String rfid;
//   final GlobalKey<RenewalEditCoverageDetailsState>? coverageDetailsKey;
//   RenewalEditCoverageDetails(
//       {Key? key, required this.rfid, this.coverageDetailsKey})
//       : super(key: key);
//   // RenewalEditCoverageDetails({super.key, required this.rfqId});
//   static final GlobalKey<RenewalEditCoverageDetailsState> step2Key =
//       GlobalKey<RenewalEditCoverageDetailsState>();
//   @override
//   State<RenewalEditCoverageDetails> createState() =>
//       RenewalEditCoverageDetailsState();

//   void updateRenewalCoverageDetails(BuildContext context) async {
//     String selectedRadioOption = '';
//     if (_character1 == SingingCharacter1.fixed1 ||
//         _selectedCharacters == SingingCharacter2.fixed1) {
//       selectedRadioOption = '1 + 3';
//       isfamilyDefication13 = true;
//     } else if (_character1 == SingingCharacter1.fixed2 ||
//         _selectedCharacters == SingingCharacter2.fixed2) {
//       selectedRadioOption = '1 + 5';
//       isfamilyDefication15 = true;
//     } else if (_character1 == SingingCharacter1.fixed3 ||
//         _selectedCharacters == SingingCharacter2.fixed3) {
//       selectedRadioOption = 'Parents Only';
//       isfamilyDeficationParents = true;
//     }

//     if (selectedRadioOption == '1 + 3') {
//       if (familyDefication13.isNotEmpty) {
//         OneThree = familyDefication13.map((value) => value.toString()).toList();
//       }
//     } else if (selectedRadioOption == '1 + 5') {
//       if (familyDefication15.isNotEmpty) {
//         OneFive = familyDefication15.map((value) => value.toString()).toList();
//       }
//     } else if (selectedRadioOption == 'Parents Only') {
//       if (familyDeficationParents.isNotEmpty) {
//         ParentOnly =
//             familyDeficationParents.map((value) => value.toString()).toList();
//       }
//     }
//     final data = {
//       'rfqId': rfid,
//       'policyType': policyType,
//       'familyDefination': familyDefination,
//       'sumInsured': SumInsureded,
//       "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
//       "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
//       "coveragesFilePath": fileResponses["CoverageSought"] ?? "",
//       "claimsMiscFilePath": fileResponses["ClaimsMis"] ?? "",
//       "claimsSummaryFilePath": fileResponses["ClaimsSummary"] ?? "",
//       "templateFilePath": fileResponses["EmpData"] ?? "",
//       "policyCopyFilePath": fileResponses["PolicyCopy"] ?? "",
//       "familyDefication13": isfamilyDefication13,
//       "familyDefication15": isfamilyDefication15,
//       "familyDeficationParents": isfamilyDeficationParents,
//       "familyDefication13Amount": OneThree,
//       "familyDefication15Amount": OneFive,
//       "familyDeficationParentsAmount": ParentOnly,
//       "empData": hasEmpData
//     };

//     var headers = await ApiServices.getHeaders();
//     final url = Uri.parse(ApiServices.baseUrl +
//         ApiServices.renewal_Coverage_UpdateCoverage +
//         rfid);

//     final response = await http.put(
//       url,
//       headers: headers,
//       body: jsonEncode(data),
//     );
//     if (response.statusCode == 200) {
//       ("File uploaded successfully");
//     } else {
//       ('file upload failed');
//     }
//   }
// }

// http.MultipartRequest jsonToFormData(
//     http.MultipartRequest request, Map<String, dynamic> data) {
//   for (var key in data.keys) {
//     request.fields[key] = data[key].toString();
//   }
//   return request;
// }
 
// List<Map<String, dynamic>> empDataList = [];

// class RenewalEditCoverageDetailsState
//     extends State<RenewalEditCoverageDetails> {
//   late RenewalEditEmpData renewalEditEmpData;
//   late RenewalEditClaimsMisData renewalEditClaimsEditData;
//   bool _formSubmitted = false;
//   bool nextClicked = false;
//   bool uploadMandateText = false;
//   bool uploadMandateLettererror = false;
//   bool uploadClaimsMisError = false;
//   String? tpaName;
//   List<String> missingColumnDropdown = [];
//   Future<void> fetchFieldMappings() async {
//     try {
//       var headers = await ApiServices.getHeaders();
//       final response = await http.get(
//           Uri.parse(ApiServices.baseUrl + ApiServices.GetAllEmployeeHeaders),
//           headers: headers);
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         missingColumnDropdown =
//             List<String>.from(data.where((element) => element != null));
//       } else {
//         throw Exception('Failed to fetch field mappings');
//       }
//     } catch (e) {
//       throw Exception('Error fetching field mappings: $e');
//     }
//     renewalEditEmpData = RenewalEditEmpData(
//         renewalEditCoverageDetailsStateKey: widget.coverageDetailsKey,
//         empheaders: missingColumnDropdown);
//   }

//   @override
//   void initState() {
//     (" key");
//     (widget.coverageDetailsKey);
//     super.initState();
//     getCoveragesById();
//     fetchFieldMappings();
//     renewalEditClaimsEditData = RenewalEditClaimsMisData(
//         renewalEditCoverageDetailsState: widget.coverageDetailsKey);
//     getTpaNameFromLocalStorage();
//   }

//   Future<String?> getTpaNameFromLocalStorage() async {
//     final prefs1 = await SharedPreferences.getInstance();
//     setState(() {
//       tpaName = prefs1.getString('tpaName');
//     });
//     return null;
//   }


//   Future<void> getCoveragesById() async {
//     try {
//       var headers = await ApiServices.getHeaders();
//       final res = await http.get(
//         Uri.parse(ApiServices.baseUrl +
//             ApiServices.getcoveragesByIdDetails_Endpoint +
//             widget.rfid),
//         headers: headers,
//       );

//       if (res.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(res.body);
//         policyType = responseData['policyType'];
//         SumInsureded = responseData['sumInsured'];
//         familyDefination = responseData['familyDefination'];
//         fileResponses['MandateLetter'] = responseData['mandateLetterFilePath'];

//         fileResponses['CoveragesSought'] = responseData['coveragesFilePath'];

//         fileResponses['EmpDepData'] = responseData['empDepDataFilePath'];

//         fileResponses['ClaimsMis'] = responseData['claimsMiscFilePath'];

//         fileResponses['Dependentdata'] = responseData['claimsSummaryFilePath'];

//         fileResponses['PolicyCopy'] = responseData['policyCopyFilePath'];

//         fileResponses['EmpData'] = responseData['templateFilePath'];
//         isfamilyDefication13 = responseData['familyDefication13'] ?? false;
//         isfamilyDefication15 = responseData['familyDefication15'] ?? false;
//         isfamilyDeficationParents =
//             responseData['familyDeficationParents'] ?? false;
//         bool empDataField = responseData['empData'] ?? false;
//         if (empDataField) {
//           _character = SingingCharacter.lafayette;
//           hasEmpData = true;
//           // Add your criteria here
//         } else {
//           _character = SingingCharacter.jefferson;
//           hasEmpData = false;
//         }
//         if (isfamilyDefication13) {
//           _character1 = SingingCharacter1.fixed1;
//         }

//         if (isfamilyDefication15) {
//           _character1 = SingingCharacter1.fixed2;
//         }
//         if (isfamilyDeficationParents) {
//           _character1 = SingingCharacter1.fixed3;
//         }
//         bool mandateLetterPathHasData =
//             responseData['mandateLetterFilePath'] != null &&
//                 responseData['mandateLetterFilePath'].isNotEmpty;
//         bool coveragesSoughtPathHasData =
//             responseData['coveragesFilePath'] != null &&
//                 responseData['coveragesFilePath'].isNotEmpty;
//         bool claimsSummaryPathHasData =
//             responseData['claimsSummaryFilePath'] != null &&
//                 responseData['claimsSummaryFilePath'].isNotEmpty;
//         bool policyCopyHasData = responseData['policyCopyFilePath'] != null &&
//             responseData['policyCopyFilePath'].isNotEmpty;
//         // Update uploadSuccessMap based on path data
//         uploadSuccessMap = {
//           "MandateLetter": mandateLetterPathHasData,
//           "CoveragesSought": coveragesSoughtPathHasData,
//           "ClaimsSummary": claimsSummaryPathHasData,
//           "PolicyCopy": policyCopyHasData,
//         };

//         String empPath = responseData['empDepDataFilePath'];
//         if (empPath != "") {
//           isEmpDataUploadSuccessful = true;
//           showEmpDataCard = true;
//         }
//         String claimPath = responseData['claimsMiscFilePath'];
//         if (claimPath != "") {
//           claimsMisCardDispaly = true;

//           isClaimsUploadSuccessful = true;
//         }
//         // showEmpDataCard = empDataField;
//         // Update isEmpDataUploadSuccessful based on your criteria
//         // isEmpDataUploadSuccessful = true;
//         // bool claimsDataField = responseData['empData'] ?? false;
//         // claimsMisCardDispaly = empDataField;
//         // isClaimsUploadSuccessful = true;
//         // claimsMisCardDispaly = true;
//         setState(() {}); // Update the UI with the new values
//       } else {
//         ('API error: ${res.statusCode}');
//       }
//     } catch (e) {
//       ('Error: $e');
//     }
//   }

//   bool validateRenewalEditCoverageDetails() {
//     (policyType);
//     if (policyType == null) {
//       setState(() {
//         policyTypeError = 'Please select a product category';
//       });
//     } else {
//       setState(() {
//         policyTypeError = null;
//       });
//     }

//     if (familyDefination == null) {
//       setState(() {
//         familyDefinationError = 'Please select a product type';
//       });
//     } else {
//       setState(() {
//         familyDefinationError = null;
//       });
//     }

//     if (SumInsureded == null) {
//       setState(() {
//         sumInsurededError = 'Please select a policy type';
//       });
//     } else {
//       setState(() {
//         sumInsurededError = null;
//       });
//     }
//     if (_character != null) {
//       setState(() {
//         _characterError = 'Field is mandatory';
//       });
//     } else {
//       setState(() {
//         _characterError = null;
//       });
//     }
//     if (_character1 != null) {
//       setState(() {
//         _characterError1 = 'Field is mandatory';
//       });
//     } else {
//       setState(() {
//         _characterError1 = null;
//       });
//     }
//     setState(() {
//       _formSubmitted = true;
//     });
//     if (showEmpDataCard == false && nextClicked == true) {
//       setState(() {
//         uploadMandateText = true;
//       });
//     }

//     if (claimsMisCardDispaly == false && nextClicked == true) {
//       setState(() {
//         uploadClaimsMisError = true;
//       });
//     }

//     (policyType);
//     (familyDefination);
//     (SumInsureded);
//     if (policyType != null &&
//         familyDefination != null &&
//         SumInsureded != null &&
//         _character != null &&
//         _character1 != null &&
//         uploadMandateText == false &&
//         uploadClaimsMisError == false) {
//       return true;
//     }
//     return false;
//   }

//   bool showEmpDataCard = false;
//   bool claimsMisCardDispaly = false;
//   bool isEmpDataUploadSuccessful = false;
//   bool isClaimsUploadSuccessful = false;

//   // downloadFile() async {
//   //   final urlString = ApiServices.baseUrl + ApiServices.Download_Template;
//   //   html.AnchorElement anchorElement = html.AnchorElement(href: urlString);
//   //   anchorElement.download = urlString;
//   //   anchorElement.click();
//   // }

//   downloadFile() async {
//     final urlString = ApiServices.baseUrl + ApiServices.Download_Template;

//     try {
//       var headers = await ApiServices.getHeaders();
//       final response = await http.get(
//         Uri.parse(urlString),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         // Extract filename from Content-Disposition header

//         final blob = html.Blob([response.bodyBytes]);
//         final url = html.Url.createObjectUrlFromBlob(blob);

//         final anchor = html.AnchorElement(href: url)
//           ..target = 'blank'
//           ..download = "RfqTemplate.xlsx";

//         anchor.click();
//         html.Url.revokeObjectUrl(url);
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title:
//                   Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Failed to download...!',
//                     style: GoogleFonts.poppins(fontSize: 18.0),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child: Text(
//                     'close',
//                     style: GoogleFonts.poppins(
//                       color: Colors.red,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } catch (e) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title:
//                 Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
//                 SizedBox(height: 16.0),
//                 Text(
//                   'Failed to download...!',
//                   style: GoogleFonts.poppins(fontSize: 18.0),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: Text(
//                   'close',
//                   style: GoogleFonts.poppins(
//                     color: Colors.red,
//                     fontSize: 16.0,
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   Map<String, bool> uploadSuccessMap = {
//     "MandateLetter": false,
//     "CoveragesSought": false,
//     // "ClaimsMis": false,
//     "ClaimsSummary": false,
//     "PolicyCopy": false,
//     // Add more file types as needed
//   };

//   Future<void> uploadRenewalEditEmpdataFile(
//       Uint8List? fileBytes, String fileType, String fileName) async {
//     var headers = await ApiServices.getHeaders();
//     try {
//       final uploadApiUrl =
//           Uri.parse(ApiServices.baseUrl + ApiServices.Coverage_Upload_Endpoint);
//       var request = http.MultipartRequest("POST", uploadApiUrl)
//         ..headers.addAll(headers);

//       var multipartFile = http.MultipartFile.fromBytes(
//         'file',
//         fileBytes!,
//         filename: fileName,
//         contentType: MediaType('application', 'octet-stream'),
//         // headers: headers,
//       );
//       request.files.add(multipartFile);

//       request.fields['fileType'] = 'EmpDepData';
//       request.fields['rfqId'] = widget.rfid;

//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         fileResponses[fileType] = responseBody; // Store the response

//         Fluttertoast.showToast(
//           msg: '$fileType uploaded successfully',
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//         setState(() {
//           isEmpDataUploadSuccessful = true;
//           showEmpDataCard = true; // Set the flag to show the empdata card
//           uploadMandateText = false;
//         });
//       } else {
//         Fluttertoast.showToast(
//           msg: '$fileType failed. Please try again.',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'An error occurred. Please try again.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

//   Future<void> uploadRenewalEditClaimsMis(
//       Uint8List? fileBytes, String fileType, String fileName) async {
//     var headers = await ApiServices.getHeaders();
//     try {
//       final uploadApiUrl =
//           Uri.parse(ApiServices.baseUrl + ApiServices.Coverage_Upload_Endpoint);
//       var request = http.MultipartRequest("POST", uploadApiUrl)
//         ..headers.addAll(headers);

//       var multipartFile = http.MultipartFile.fromBytes(
//         'file',
//         fileBytes!,
//         filename: '$fileType-file',
//         contentType: MediaType('application', 'octet-stream'),
//       );
//       request.files.add(multipartFile);

//       request.fields['fileType'] = fileType;
//       request.fields['rfqId'] = widget.rfid;
//       request.fields['tpaName'] = tpaName!;

//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         fileResponses[fileType] = responseBody; // Store the response
//         ("Response for $fileType: $responseBody"); //  the response
//         ("Checking renewal"); //  the response
//         Fluttertoast.showToast(
//           msg: '$fileType uploaded successfully',
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//         setState(() {
//           isClaimsUploadSuccessful = true;
//           claimsMisCardDispaly = true; // Set the flag to show the empdata card
//           uploadClaimsMisError = false;
//         });
//       } else {
//         Fluttertoast.showToast(
//           msg: 'Upload failed. Please try again.',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'An error occurred. Please try again.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

//   Future<void> _uploadFile(String fileType) async {
//     var headers = await ApiServices.getHeaders();
//     try {
//       final uploadApiUrl =
//           Uri.parse(ApiServices.baseUrl + ApiServices.Coverage_Upload_Endpoint);
//       var request = http.MultipartRequest("POST", uploadApiUrl)
//         ..headers.addAll(headers);
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//       );

//       if (result != null && result.files.isNotEmpty) {
//         var fileBytes = result.files.first.bytes;

//         var multipartFile = http.MultipartFile.fromBytes(
//           'file',
//           fileBytes!,
//           filename: '$fileType-file',
//           contentType: MediaType('application', 'octet-stream'),
//         );

//         request.files.add(multipartFile);

//         request.fields['fileType'] = fileType;
//         request.fields['rfqId'] = widget.rfid;

//         final response = await request.send();
//         final responseBody = await response.stream.bytesToString();

//         if (response.statusCode == 200 || response.statusCode == 201) {
//           fileResponses[fileType] = responseBody; // Store the response
//           setState(() {
//             uploadSuccessMap[fileType] =
//                 true; // Set the success flag for the fileType
//           });
//           ("Response for $fileType: $responseBody"); //  the response
//           Fluttertoast.showToast(
//             msg: '$fileType uploaded successfully',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//           );
//         } else {
//           Fluttertoast.showToast(
//             msg: '$fileType failed. Please try again.',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//         }
//       } else {
//         return; // File picker was canceled or failed
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'An error occurred. Please try again.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

//   Future<void> uploadMandateLetter(String fileType) async {
//     try {
//       var result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//       );

//       if (result == null || result.files.isEmpty) {
//         return; // File picker was canceled or failed
//       }

//       var file = result.files.first;
//       var fileName = file.name;
//       var fileExtension = fileName.split('.').last.toLowerCase();

//       if (fileExtension != 'pdf') {
//         // Show an error message because the selected file is not a PDF
//         toastification.showError(
//           context: context,
//           autoCloseDuration: Duration(seconds: 2),
//           title: 'Please select a PDF file.',
//         );
//         return;
//       }

//       var fileBytes = file.bytes;
//       var multipartFile = http.MultipartFile.fromBytes(
//         'file',
//         fileBytes!,
//         filename: fileName,
//         contentType: MediaType('application', 'pdf'),
//       );
//       var headers = await ApiServices.getHeaders();
//       final uploadApiUrl =
//           Uri.parse(ApiServices.baseUrl + ApiServices.Coverage_Upload_Endpoint);
//       var request = http.MultipartRequest("POST", uploadApiUrl)
//         ..headers.addAll(headers);
//       request.files.add(multipartFile);
//       request.fields['fileType'] = fileType;
//       request.fields['rfqId'] = widget.rfid;

//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Store the response
//         fileResponses[fileType] = responseBody;
//         // Set the success flag for the fileType
//         setState(() {
//           uploadSuccessMap[fileType] = true;
//         });
//         // Show a success notification

//         toastification.showSuccess(
//           context: context,
//           autoCloseDuration: Duration(seconds: 2),
//           title: '$fileType uploaded successfully.....!',
//         );
//       } else {
//         // Show an error notification
//         toastification.showError(
//           context: context,
//           autoCloseDuration: Duration(seconds: 2),
//           title: '$fileType upload failed.....!',
//         );
//       }
//     } catch (e) {
//       // Show an error notification in case of an exception
//       toastification.showError(
//         context: context,
//         autoCloseDuration: Duration(seconds: 2),
//         title: '$fileType upload failed.....!',
//       );
//     }
//   }

//   Future<bool> sendEmail(String recipientEmail) async {
//     var headers = await ApiServices.getHeaders();
//     final apiUrl = ApiServices.baseUrl +
//         ApiServices
//             .Send_Email_Downloaded_Template; // Replace with your actual API URL

//     final jsonBody = {
//       "email": recipientEmail,
//     };

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: headers,
//       body: json.encode(jsonBody),
//     );

//     if (response.statusCode == 200) {
//       ('Email sent successfully');
//       return true;
//     } else {
//       ('Failed to send email: ${response.statusCode}');
//       return true;
//     }
//   }

//   void _emailSenderDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController emailController = TextEditingController();

//         return AlertDialog(
//           title: Container(
//             color: SecureRiskColours.Button_Color,
//             padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
//             child: Text(
//               'Send Email',
//               style: GoogleFonts.poppins(),
//             ),
//           ),
//           content: Container(
//             height: 180, // Increased the height to accommodate the note
//             width: 300,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Enter Email',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 8), // Add a small space
//                 Text(
//                   'Note: If sending to multiple emails, separate them with commas.',
//                   style: GoogleFonts.poppins(color: Colors.grey),
//                 ),
//                 SizedBox(height: 16),
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           Color.fromRGBO(199, 55, 125, 1.0), // Hovered color
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                     onPressed: () async {
//                       bool success = await sendEmail(emailController.text);
//                       if (success) {
//                         Navigator.pop(context); // Close the dialog
//                         Fluttertoast.showToast(
//                           msg: 'Email sent! Check your mailbox.',
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           timeInSecForIosWeb: 4,
//                         );
//                       }
//                     },
//                     child: Text(
//                       'Send Email',
//                       style: GoogleFonts.poppins(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context as BuildContext).size.height;
//     double screenWidth = MediaQuery.of(context as BuildContext).size.width;
//     return Container(
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Container(
//                     // height: 700,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(top: 0, bottom: 0),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: screenWidth * 0.4,
//                                 child: AppBar(
//                                   toolbarHeight: SecureRiskColours.AppbarHeight,
//                                   backgroundColor:
//                                       SecureRiskColours.Table_Heading_Color,
//                                   title: Text(
//                                     "Details",
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   elevation: 5,
//                                   automaticallyImplyLeading: false,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 10.0),
//                           child: Container(
//                             color: Colors.white,
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 0),
//                                     child: CustomDropdown(
//                                       value: policyType,
//                                       onChanged: (String? newValue) {
//                                         setState(() {
//                                           policyType = newValue;
//                                           _formSubmitted = false;
//                                         });
//                                       },
//                                       items: [
//                                         DropdownMenuItem<String>(
//                                           child: Text(
//                                             'Policy Type',
//                                             style: GoogleFonts.poppins(
//                                               fontSize: 14.0,
//                                             ),
//                                           ), // default label
//                                         ),
//                                         ...productCategories
//                                             .map((String option) {
//                                           return DropdownMenuItem<String>(
//                                             value: option,
//                                             child: Text(
//                                               option,
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: 14.0,
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ],
//                                     ),
//                                   ),
//                                   if (policyTypeError != null)
//                                     Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 15),
//                                       child: Text(
//                                         policyTypeError!,
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.red),
//                                       ),
//                                     ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 0),
//                                     child: CustomDropdown(
//                                       value: familyDefination,
//                                       onChanged: (String? newValue) {
//                                         setState(() {
//                                           familyDefination = newValue;
//                                           _formSubmitted = false;
//                                         });
//                                       },
//                                       items: [
//                                         DropdownMenuItem<String>(
//                                           child: Text(
//                                             'Family Defination',
//                                             style: GoogleFonts.poppins(
//                                               fontSize: 14.0,
//                                             ),
//                                           ),
//                                         ),
//                                         ...Definations.map((String option) {
//                                           return DropdownMenuItem<String>(
//                                             value: option,
//                                             child: Text(
//                                               option,
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: 14.0,
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ],
//                                     ),
//                                   ),
//                                   if (familyDefinationError != null)
//                                     Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 15),
//                                       child: Text(
//                                         familyDefinationError!,
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.red),
//                                       ),
//                                     ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 0),
//                                     child: CustomDropdown(
//                                       value: SumInsureded,
//                                       onChanged: (String? newValue) {
//                                         setState(() {
//                                           SumInsureded = newValue;
//                                           _formSubmitted = false;
//                                         });
//                                       },
//                                       items: [
//                                         DropdownMenuItem<String>(
//                                           child: Text(
//                                             'Sum Insured',
//                                             style: GoogleFonts.poppins(
//                                               fontSize: 14.0,
//                                             ),
//                                           ), // default label
//                                         ),
//                                         ...insured.map((String option) {
//                                           return DropdownMenuItem<String>(
//                                             value: option,
//                                             child: Text(
//                                               option,
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: 14.0,
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ],
//                                     ),
//                                   ),
//                                   if (sumInsurededError != null)
//                                     Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 15),
//                                       child: Text(
//                                         sumInsurededError!,
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.red),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment
//                                 .start, // Align children to the left
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment
//                                       .start, // Align children to the left
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(left: .0),
//                                       child: ListTile(
//                                         title: Text(
//                                           'I have employee data',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Radio<SingingCharacter>(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                                   (states) => SecureRiskColours
//                                                       .Button_Color),
//                                           value: SingingCharacter.lafayette,
//                                           groupValue: _character,
//                                           onChanged: (SingingCharacter? value) {
//                                             setState(() {
//                                               hasEmpData = true;
//                                               _character = value;
//                                               isEmpDataUploadSuccessful = false;
//                                               showEmpDataCard = false;
//                                               claimsMisCardDispaly = false;
//                                               isClaimsUploadSuccessful = false;
//                                               uploadSuccessMap[
//                                                   "MandateLetter"] = false;
//                                               uploadSuccessMap[
//                                                   "CoveragesSought"] = false;
//                                               uploadSuccessMap["ClaimsMis"] =
//                                                   false;
//                                               uploadSuccessMap[
//                                                   "ClaimsSummary"] = false;
//                                               fileResponses["EmpDepData"] = "";
//                                               fileResponses["MandateLetter"] =
//                                                   "";
//                                               fileResponses["CoveragesSought"] =
//                                                   "";
//                                               fileResponses["ClaimsMis"] = "";
//                                               fileResponses["ClaimsSummary"] =
//                                                   "";
//                                               fileResponses["PolicyCopy"] = "";
//                                               _formSubmitted = false;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     ListTile(
//                                       title: Text(
//                                         'I dont have data',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14.0,
//                                         ),
//                                       ),
//                                       leading: Radio<SingingCharacter>(
//                                         fillColor:
//                                             MaterialStateColor.resolveWith(
//                                                 (states) => SecureRiskColours
//                                                     .Button_Color),
//                                         value: SingingCharacter.jefferson,
//                                         groupValue: _character,
//                                         onChanged: (SingingCharacter? value) {
//                                           setState(() {
//                                             hasEmpData = false;
//                                             _character = value;
//                                             isEmpDataUploadSuccessful = false;
//                                             showEmpDataCard = false;
//                                             claimsMisCardDispaly = false;
//                                             isClaimsUploadSuccessful = false;
//                                             uploadSuccessMap[
//                                                 "CoveragesSought"] = false;
//                                             uploadSuccessMap["ClaimsMis"] =
//                                                 false;
//                                             uploadSuccessMap["ClaimsSummary"] =
//                                                 false;
//                                             uploadSuccessMap["PolicyCopy"] =
//                                                 false;
//                                             fileResponses["EmpDepData"] = "";
//                                             fileResponses["MandateLetter"] = "";
//                                             fileResponses["CoveragesSought"] =
//                                                 "";
//                                             fileResponses["ClaimsMis"] = "";
//                                             fileResponses["ClaimsSummary"] = "";
//                                             fileResponses["PolicyCopy"] = "";
//                                             _formSubmitted = false;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),

//                                     // Validation message
//                                     if (_formSubmitted && _character == null)
//                                       Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Text(
//                                           'Please select an option.',
//                                           style: GoogleFonts.poppins(
//                                             color: Colors.red,
//                                             fontSize: 12.0,
//                                           ),
//                                         ),
//                                       )
//                                   ],
//                                 ),
//                               ),
//                               if (_character == SingingCharacter.lafayette) ...[
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     top: 10.0,
//                                     bottom: 10.0,
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         constraints:
//                                             BoxConstraints(maxWidth: 300),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "Employee & Dependent Data ",
//                                               style: GoogleFonts.poppins(
//                                                   fontSize: 13,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 if (!isEmpDataUploadSuccessful) {
//                                                   renewalEditEmpData
//                                                       .renewalEdithandleUpload(
//                                                           context,
//                                                           "EmpDepData");
//                                                 }
//                                               },
//                                               icon: isEmpDataUploadSuccessful
//                                                   ? Icon(
//                                                       Icons.check_circle,
//                                                       color: Color.fromARGB(
//                                                           255, 62, 233, 105),
//                                                       size: 40,
//                                                     )
//                                                   : Icon(
//                                                       Icons
//                                                           .drive_folder_upload_rounded,
//                                                       color: SecureRiskColours
//                                                           .Button_Color,
//                                                       size: 40,
//                                                     ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 if (showEmpDataCard)
//                                   Row(
//                                     children: [
//                                       RenewalEditCoverageCard(
//                                         onClose: () {
//                                           setState(() {
//                                             isEmpDataUploadSuccessful = false;
//                                             showEmpDataCard = false;
//                                             fileResponses["EmpDepData"] = "";
//                                             // Hide the card
//                                           });
//                                         },
//                                         rfid: widget.rfid,
//                                         rfqId: widget.rfid,
//                                       ),
//                                     ],
//                                   ),
//                                 if (uploadMandateText)
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Please Upload a file..!",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.red),
//                                       )
//                                     ],
//                                   ),
//                                 SizedBox(
//                                     height: 10), // Add spacing between sections
//                                 Container(
//                                   constraints: BoxConstraints(maxWidth: 300),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Mandate Letter",
//                                         style: GoogleFonts.poppins(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {
//                                           if (uploadSuccessMap.containsKey(
//                                                   "MandateLetter") &&
//                                               !uploadSuccessMap[
//                                                   "MandateLetter"]!) {
//                                             uploadMandateLetter(
//                                                 "MandateLetter");
//                                           }
//                                         },
//                                         icon: uploadSuccessMap.containsKey(
//                                                     "MandateLetter") &&
//                                                 uploadSuccessMap[
//                                                     "MandateLetter"]!
//                                             ? Icon(
//                                                 Icons.check_circle,
//                                                 color: Color.fromARGB(
//                                                     255, 62, 233, 105),
//                                                 size: 40,
//                                               )
//                                             : Icon(
//                                                 Icons
//                                                     .drive_folder_upload_rounded,
//                                                 color: SecureRiskColours
//                                                     .Button_Color,
//                                                 size: 40,
//                                               ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 if (uploadSuccessMap["MandateLetter"] == true)
//                                   UploadedFileCard(
//                                     fileType: "Mandate Letter",
//                                     onClose: () {
//                                       // Handle card's cross mark action
//                                       setState(() {
//                                         uploadSuccessMap["MandateLetter"] =
//                                             false;
//                                         fileResponses["MandateLetter"] = "";
//                                       });
//                                     },
//                                   ),

//                                 SizedBox(height: 10),
//                                 // Add spacing between sections
//                                 Container(
//                                   constraints: BoxConstraints(maxWidth: 300),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Coverage Sought",
//                                         style: GoogleFonts.poppins(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {
//                                           if (uploadSuccessMap.containsKey(
//                                                   "CoveragesSought") &&
//                                               !uploadSuccessMap[
//                                                   "CoveragesSought"]!) {
//                                             _uploadFile("CoveragesSought");
//                                           }
//                                         },
//                                         icon: uploadSuccessMap.containsKey(
//                                                     "CoveragesSought") &&
//                                                 uploadSuccessMap[
//                                                     "CoveragesSought"]!
//                                             ? Icon(
//                                                 Icons.check_circle,
//                                                 color: Color.fromARGB(
//                                                     255, 62, 233, 105),
//                                                 size: 40,
//                                               )
//                                             : Icon(
//                                                 Icons
//                                                     .drive_folder_upload_rounded,
//                                                 color: SecureRiskColours
//                                                     .Button_Color,
//                                                 size: 40,
//                                               ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 if (uploadSuccessMap["CoveragesSought"] == true)
//                                   UploadedFileCard(
//                                     fileType: "Coverages Sought",
//                                     onClose: () {
//                                       // Handle card's cross mark action
//                                       setState(() {
//                                         uploadSuccessMap["CoveragesSought"] =
//                                             false;
//                                         fileResponses["CoveragesSought"] = "";
//                                       });
//                                     },
//                                   ),
//                                 SizedBox(
//                                     height: 10), // Add spacing between sections
//                                 Container(
//                                   constraints: BoxConstraints(maxWidth: 300),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Claims Mis(Excel)",
//                                         style: GoogleFonts.poppins(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {
//                                           // debugger();
//                                           if (!isClaimsUploadSuccessful) {
//                                             //  _claimsMisUpload("claimsMis");
//                                             getTpaNameFromLocalStorage().then(
//                                                 (value) => renewalEditClaimsEditData
//                                                     .renewalEditClaimsMisUpload(
//                                                         tpaName!,
//                                                         context,
//                                                         "ClaimsMis"));
//                                           }
//                                         },
//                                         icon: isClaimsUploadSuccessful
//                                             ? Icon(
//                                                 Icons.check_circle,
//                                                 color: Color.fromARGB(
//                                                     255, 62, 233, 105),
//                                                 size: 40,
//                                               )
//                                             : Icon(
//                                                 Icons
//                                                     .drive_folder_upload_rounded,
//                                                 color: SecureRiskColours
//                                                     .Button_Color,
//                                                 size: 40,
//                                               ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 if (claimsMisCardDispaly)
//                                   Row(
//                                     children: [
//                                       EditClaimsMisCard(
//                                           onClose: () {
//                                             setState(() {
//                                               isClaimsUploadSuccessful = false;
//                                               claimsMisCardDispaly = false;
//                                               fileResponses["ClaimsMis"] = "";
//                                               // Hide the card
//                                             });
//                                           },
//                                           rfqId: widget.rfid),
//                                     ],
//                                   ),
//                                 if (uploadClaimsMisError)
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Please Upload a file..!",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.red),
//                                       )
//                                     ],
//                                   ),
//                                 SizedBox(height: 10),
//                                 // Add spacing between sections
//                                 Container(
//                                   constraints: BoxConstraints(maxWidth: 300),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Claims Summary ",
//                                         style: GoogleFonts.poppins(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {
//                                           if (uploadSuccessMap.containsKey(
//                                                   "ClaimsSummary") &&
//                                               !uploadSuccessMap[
//                                                   "ClaimsSummary"]!) {
//                                             _uploadFile("ClaimsSummary");
//                                           }
//                                         },
//                                         icon: uploadSuccessMap.containsKey(
//                                                     "ClaimsSummary") &&
//                                                 uploadSuccessMap[
//                                                     "ClaimsSummary"]!
//                                             ? Icon(
//                                                 Icons.check_circle,
//                                                 color: Color.fromARGB(
//                                                     255, 62, 233, 105),
//                                                 size: 40,
//                                               )
//                                             : Icon(
//                                                 Icons
//                                                     .drive_folder_upload_rounded,
//                                                 color: SecureRiskColours
//                                                     .Button_Color,
//                                                 size: 40,
//                                               ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 if (uploadSuccessMap["ClaimsSummary"] == true)
//                                   UploadedFileCard(
//                                     fileType: "Claims Summary",
//                                     onClose: () {
//                                       // Handle card's cross mark action
//                                       setState(() {
//                                         uploadSuccessMap["ClaimsSummary"] =
//                                             false;
//                                         fileResponses["ClaimsSummary"] = "";
//                                       });
//                                     },
//                                   ),
//                                 SizedBox(
//                                     height: 10), // Add spacing between sections
//                               ],
//                               if (_character == SingingCharacter.jefferson) ...[
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment
//                                       .start, // Align children to the left
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                           top: 10.0, bottom: 10.0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment
//                                             .start, // Align children to the left
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Please download the template",
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 14),
//                                           ),
//                                           SizedBox(width: 25),
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 bottom: 10.0,
//                                                 left: 15.0,
//                                                 right: 10.0),
//                                             child: IconButton(
//                                               style: style,
//                                               onPressed: () {
//                                                 // Handle the upload button action
//                                                 downloadFile();
//                                               },
//                                               icon: Icon(
//                                                 Icons
//                                                     .download_for_offline_rounded,
//                                                 size:
//                                                     35, // Increase the size of the icon
//                                                 color: Colors.blue,
//                                               ), // Use the f icon
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Color.fromRGBO(
//                                                     199,
//                                                     55,
//                                                     125,
//                                                     1.0), // Hovered color
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 _emailSenderDialog();
//                                               },
//                                               child: Text(
//                                                 'Send Email',
//                                                 style: GoogleFonts.poppins(
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     ListView.builder(
//                                       shrinkWrap: true,
//                                       itemCount: str.length,
//                                       itemBuilder:
//                                           (BuildContext context, int index) {
//                                         return Padding(
//                                           padding: EdgeInsets.all(0),
//                                           child: Padding(
//                                             padding: EdgeInsets.all(0),
//                                             child: Padding(
//                                               padding: EdgeInsets.all(0),
//                                               child: ListTile(
//                                                 title: Padding(
//                                                   padding: EdgeInsets.all(0),
//                                                   child: Text(
//                                                     str[index],
//                                                     style: GoogleFonts.poppins(
//                                                       fontSize: 13.0,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         top: 10.0,
//                                         bottom: 10.0,
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             constraints:
//                                                 BoxConstraints(maxWidth: 300),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   "Upload the filled Employee  Data ",
//                                                   style: GoogleFonts.poppins(
//                                                       fontSize: 13,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                                 IconButton(
//                                                   onPressed: () {
//                                                     if (!isEmpDataUploadSuccessful) {
//                                                       renewalEditEmpData
//                                                           .renewalEdithandleUpload(
//                                                               context,
//                                                               "EmpDepData");
//                                                     }
//                                                   },
//                                                   icon:
//                                                       isEmpDataUploadSuccessful
//                                                           ? Icon(
//                                                               Icons
//                                                                   .check_circle,
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       62,
//                                                                       233,
//                                                                       105),
//                                                               size: 40,
//                                                             )
//                                                           : Icon(
//                                                               Icons
//                                                                   .drive_folder_upload_rounded,
//                                                               color: SecureRiskColours
//                                                                   .Button_Color,
//                                                               size: 40,
//                                                             ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (showEmpDataCard)
//                                       Row(
//                                         children: [
//                                           RenewalEditCoverageCard(
//                                             onClose: () {
//                                               setState(() {
//                                                 isEmpDataUploadSuccessful =
//                                                     false;
//                                                 showEmpDataCard = false;
//                                                 fileResponses["EmpDepData"] =
//                                                     "";
//                                                 // Hide the card
//                                               });
//                                             },
//                                             rfqId: widget.rfid,
//                                             rfid: widget.rfid,
//                                           ),
//                                         ],
//                                       ),
//                                     if (uploadMandateText)
//                                       Row(
//                                         children: [
//                                           Text(
//                                             "Please Upload a file..!",
//                                             style: GoogleFonts.poppins(
//                                                 color: Colors.red),
//                                           )
//                                         ],
//                                       ),
//                                     SizedBox(
//                                         height:
//                                             10), // Add spacing between sections
//                                     Container(
//                                       constraints:
//                                           BoxConstraints(maxWidth: 300),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "Policy Copy",
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           IconButton(
//                                             onPressed: () {
//                                               if (uploadSuccessMap.containsKey(
//                                                       "PolicyCopy") &&
//                                                   !uploadSuccessMap[
//                                                       "PolicyCopy"]!) {
//                                                 _uploadFile("PolicyCopy");
//                                               }
//                                             },
//                                             icon: uploadSuccessMap.containsKey(
//                                                         "PolicyCopy") &&
//                                                     uploadSuccessMap[
//                                                         "PolicyCopy"]!
//                                                 ? Icon(
//                                                     Icons.check_circle,
//                                                     color: Color.fromARGB(
//                                                         255, 62, 233, 105),
//                                                     size: 40,
//                                                   )
//                                                 : Icon(
//                                                     Icons
//                                                         .drive_folder_upload_rounded,
//                                                     color: SecureRiskColours
//                                                         .Button_Color,
//                                                     size: 40,
//                                                   ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     if (uploadSuccessMap["PolicyCopy"] == true)
//                                       UploadedFileCard(
//                                         fileType: "Policy Copy",
//                                         onClose: () {
//                                           // Handle card's cross mark action
//                                           setState(() {
//                                             uploadSuccessMap["PolicyCopy"] =
//                                                 false;
//                                             fileResponses["PolicyCopy"] = "";
//                                           });
//                                         },
//                                       ),
//                                     SizedBox(height: 10),
//                                     Container(
//                                       constraints:
//                                           BoxConstraints(maxWidth: 300),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "Claims Mis(Excel)",
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           IconButton(
//                                             onPressed: () {
//                                               // debugger();
//                                               if (!isClaimsUploadSuccessful) {
//                                                 renewalEditClaimsEditData
//                                                     .renewalEditClaimsMisUpload(
//                                                         tpaName!,
//                                                         context,
//                                                         "ClaimsMis");
//                                               }
//                                             },
//                                             icon: isClaimsUploadSuccessful
//                                                 ? Icon(
//                                                     Icons.check_circle,
//                                                     color: Color.fromARGB(
//                                                         255, 62, 233, 105),
//                                                     size: 40,
//                                                   )
//                                                 : Icon(
//                                                     Icons
//                                                         .drive_folder_upload_rounded,
//                                                     color: SecureRiskColours
//                                                         .Button_Color,
//                                                     size: 40,
//                                                   ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (claimsMisCardDispaly)
//                                       Row(
//                                         children: [
//                                           EditClaimsMisCard(
//                                             onClose: () {
//                                               setState(() {
//                                                 isClaimsUploadSuccessful =
//                                                     false;
//                                                 claimsMisCardDispaly = false;
//                                                 fileResponses["ClaimsMis"] = "";

//                                                 // Hide the card
//                                               });
//                                             },
//                                             rfqId: widget.rfid,
//                                           ),
//                                         ],
//                                       ),
//                                     if (uploadClaimsMisError)
//                                       Row(
//                                         children: [
//                                           Text(
//                                             "Please Upload a file..!",
//                                             style: GoogleFonts.poppins(
//                                                 color: Colors.red),
//                                           )
//                                         ],
//                                       ),
//                                     SizedBox(
//                                         height:
//                                             10), // Add spacing between sections
//                                     Container(
//                                       constraints:
//                                           BoxConstraints(maxWidth: 300),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "Claims Summary ",
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           IconButton(
//                                             onPressed: () {
//                                               if (uploadSuccessMap.containsKey(
//                                                       "ClaimsSummary") &&
//                                                   !uploadSuccessMap[
//                                                       "ClaimsSummary"]!) {
//                                                 _uploadFile("ClaimsSummary");
//                                               }
//                                             },
//                                             icon: uploadSuccessMap.containsKey(
//                                                         "ClaimsSummary") &&
//                                                     uploadSuccessMap[
//                                                         "ClaimsSummary"]!
//                                                 ? Icon(
//                                                     Icons.check_circle,
//                                                     color: Color.fromARGB(
//                                                         255, 62, 233, 105),
//                                                     size: 40,
//                                                   )
//                                                 : Icon(
//                                                     Icons
//                                                         .drive_folder_upload_rounded,
//                                                     color: SecureRiskColours
//                                                         .Button_Color,
//                                                     size: 40,
//                                                   ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     if (uploadSuccessMap["ClaimsSummary"] ==
//                                         true)
//                                       UploadedFileCard(
//                                         fileType: "Claims Summary",
//                                         onClose: () {
//                                           // Handle card's cross mark action
//                                           setState(() {
//                                             uploadSuccessMap["ClaimsSummary"] =
//                                                 false;
//                                             fileResponses["ClaimsSummary"] = "";
//                                           });
//                                         },
//                                       ),
//                                     SizedBox(height: 10),
//                                     // Add spacing between sections
//                                     Container(
//                                       constraints:
//                                           BoxConstraints(maxWidth: 300),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "Coverage Sought",
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           IconButton(
//                                             onPressed: () {
//                                               if (uploadSuccessMap.containsKey(
//                                                       "CoveragesSought") &&
//                                                   !uploadSuccessMap[
//                                                       "CoveragesSought"]!) {
//                                                 _uploadFile("CoveragesSought");
//                                               }
//                                             },
//                                             icon: uploadSuccessMap.containsKey(
//                                                         "CoveragesSought") &&
//                                                     uploadSuccessMap[
//                                                         "CoveragesSought"]!
//                                                 ? Icon(
//                                                     Icons.check_circle,
//                                                     color: Color.fromARGB(
//                                                         255, 62, 233, 105),
//                                                     size: 40,
//                                                   )
//                                                 : Icon(
//                                                     Icons
//                                                         .drive_folder_upload_rounded,
//                                                     color: SecureRiskColours
//                                                         .Button_Color,
//                                                     size: 40,
//                                                   ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     if (uploadSuccessMap["CoveragesSought"] ==
//                                         true)
//                                       UploadedFileCard(
//                                         fileType: "Coverage Sought",
//                                         onClose: () {
//                                           // Handle card's cross mark action
//                                           setState(() {
//                                             uploadSuccessMap[
//                                                 "CoveragesSought"] = false;
//                                             fileResponses["CoveragesSought"] =
//                                                 "";
//                                           });
//                                         },
//                                       ),
//                                     SizedBox(height: 10),
//                                   ],
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: screenHeight * 0.7,
//               child: VerticalDivider(
//                 color: Color.fromARGB(255, 82, 81, 81),
//                 thickness: 1,
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Container(
//                     // height: 700,
//                     alignment: Alignment.centerLeft,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (familyDefination == 'Fixed' &&
//                             SumInsureded == 'Fixed')
//                           Padding(
//                             padding: EdgeInsets.only(left: 20.0),
//                             child: Container(
//                                 child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 AppBar(
//                                   toolbarHeight: SecureRiskColours.AppbarHeight,
//                                   // backgroundColor:
//                                   //     SecureRiskColours.appBarColor,
//                                   title: Text(
//                                     "Select Family Defination",
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   elevation: 5,
//                                   automaticallyImplyLeading: false,
//                                 ),
//                                 Column(
//                                   children: [
//                                     ListTile(
//                                       title: Text(
//                                         '1 + 3',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14.0,
//                                         ),
//                                       ),
//                                       leading: Radio<SingingCharacter1>(
//                                         fillColor:
//                                             MaterialStateColor.resolveWith(
//                                                 (states) => SecureRiskColours
//                                                     .Button_Color),
//                                         value: SingingCharacter1.fixed1,
//                                         groupValue: _character1,
//                                         onChanged: (SingingCharacter1? value) {
//                                           setState(() {
//                                             _character1 = value;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     ListTile(
//                                       title: Text(
//                                         '1+5',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14.0,
//                                         ),
//                                       ),
//                                       leading: Radio<SingingCharacter1>(
//                                         fillColor:
//                                             MaterialStateColor.resolveWith(
//                                                 (states) => SecureRiskColours
//                                                     .Button_Color),
//                                         value: SingingCharacter1.fixed2,
//                                         groupValue: _character1,
//                                         onChanged: (SingingCharacter1? value) {
//                                           setState(() {
//                                             _character1 = value;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     ListTile(
//                                       title: Text(
//                                         'Parents Only',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14.0,
//                                         ),
//                                       ),
//                                       leading: Radio<SingingCharacter1>(
//                                         fillColor:
//                                             MaterialStateColor.resolveWith(
//                                                 (states) => SecureRiskColours
//                                                     .Button_Color),
//                                         value: SingingCharacter1.fixed3,
//                                         groupValue: _character1,
//                                         onChanged: (SingingCharacter1? value) {
//                                           setState(() {
//                                             _character1 = value;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     if (_formSubmitted &&
//                                         _character1 == null &&
//                                         policyType != null)
//                                       Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Text(
//                                           'Please select an option.',
//                                           style: GoogleFonts.poppins(
//                                             color: Colors.red,
//                                             fontSize: 12.0,
//                                           ),
//                                         ),
//                                       )
//                                   ],
//                                 ),
//                                 Container(
//                                   width: screenWidth * 0.48,
//                                   child: AppBar(
//                                     toolbarHeight:
//                                         SecureRiskColours.AppbarHeight,
//                                     backgroundColor:
//                                         SecureRiskColours.appBarColor,
//                                     title: Text(
//                                       "Sum Insured",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         // fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     elevation: 5,
//                                     automaticallyImplyLeading: false,
//                                   ),
//                                 ),
//                                 if (_character1 ==
//                                     SingingCharacter1.fixed1) ...[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 10.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               bottom: 5, left: 5),
//                                           child: Text(
//                                             "1+3",
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 14),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(),
//                                           child: SizedBox(
//                                             height: 60.0,
//                                             width: 245.0,
//                                             child: Padding(
//                                               padding:
//                                                   EdgeInsets.only(bottom: 14),
//                                               child: Material(
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(10)),
//                                                 child: TextField(
//                                                   inputFormatters: [
//                                                     FilteringTextInputFormatter
//                                                         .digitsOnly
//                                                   ],
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       familyDefication13[0] =
//                                                           double.parse(value);
//                                                       familyDeficationParents
//                                                           .clear();
//                                                       familyDefication15
//                                                           .clear();
//                                                       isfamilyDefication13 =
//                                                           true;
//                                                       isfamilyDefication15 =
//                                                           false;
//                                                       isfamilyDeficationParents =
//                                                           false;
//                                                     });
//                                                   },
//                                                   decoration: InputDecoration(
//                                                     labelText: 'Sum Insured',
//                                                     filled: true,
//                                                     fillColor: Colors.white,
//                                                     enabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                         Radius.circular(4),
//                                                       ),
//                                                       borderSide: BorderSide(
//                                                         color: Color.fromARGB(
//                                                             188,
//                                                             188,
//                                                             188,
//                                                             220), //
//                                                       ),
//                                                     ),
//                                                     focusedBorder:
//                                                         OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                         Radius.circular(4),
//                                                       ),
//                                                       borderSide: BorderSide(
//                                                         color: Color.fromARGB(
//                                                             188,
//                                                             188,
//                                                             188,
//                                                             220), //
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                                 if (_character1 ==
//                                     SingingCharacter1.fixed2) ...[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 10.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 5.0, bottom: 5),
//                                           child: Text(
//                                             "1+5",
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 14),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(),
//                                           child: SizedBox(
//                                             height: 60.0,
//                                             width: 245.0,
//                                             child: Padding(
//                                               padding:
//                                                   EdgeInsets.only(bottom: 14),
//                                               child: Material(
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(10)),
//                                                 child: TextField(
//                                                   inputFormatters: [
//                                                     FilteringTextInputFormatter
//                                                         .digitsOnly // Allow only numeric input
//                                                   ],
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       familyDefication15[0] =
//                                                           double.parse(value);
//                                                       familyDefication13
//                                                           .clear();
//                                                       familyDeficationParents
//                                                           .clear();
//                                                       isfamilyDefication13 =
//                                                           false;
//                                                       isfamilyDefication15 =
//                                                           true;
//                                                       isfamilyDeficationParents =
//                                                           false;
//                                                     });
//                                                   },
//                                                   decoration: InputDecoration(
//                                                     labelText: 'Sum Insured',
//                                                     filled: true,
//                                                     fillColor: Colors.white,
//                                                     enabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                         Radius.circular(4),
//                                                       ),
//                                                       borderSide: BorderSide(
//                                                         color: Color.fromARGB(
//                                                             188,
//                                                             188,
//                                                             188,
//                                                             220), //
//                                                       ),
//                                                     ),
//                                                     focusedBorder:
//                                                         OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                         Radius.circular(4),
//                                                       ),
//                                                       borderSide: BorderSide(
//                                                         color: Color.fromARGB(
//                                                             188,
//                                                             188,
//                                                             188,
//                                                             220), //
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                                 if (_character1 ==
//                                     SingingCharacter1.fixed3) ...[
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 10.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Parents only",
//                                           style:
//                                               GoogleFonts.poppins(fontSize: 14),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(),
//                                           child: SizedBox(
//                                             height: 60.0,
//                                             width: 245.0,
//                                             child: Padding(
//                                               padding:
//                                                   EdgeInsets.only(bottom: 14),
//                                               child: Material(
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(10)),
//                                                 child: TextField(
//                                                   inputFormatters: [
//                                                     FilteringTextInputFormatter
//                                                         .digitsOnly // Allow only numeric input
//                                                   ],
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       familyDeficationParents[
//                                                               0] =
//                                                           double.parse(value);
//                                                       familyDefication13
//                                                           .clear();
//                                                       familyDefication15
//                                                           .clear();
//                                                       isfamilyDefication13 =
//                                                           false;
//                                                       isfamilyDefication15 =
//                                                           false;
//                                                       isfamilyDeficationParents =
//                                                           true;
//                                                     });
//                                                   },
//                                                   decoration: InputDecoration(
//                                                     labelText: 'Sum Insured',
//                                                     filled: true,
//                                                     fillColor: Colors.white,
//                                                     enabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                         Radius.circular(4),
//                                                       ),
//                                                       borderSide: BorderSide(
//                                                         color: Color.fromARGB(
//                                                             188,
//                                                             188,
//                                                             188,
//                                                             220), //
//                                                       ),
//                                                     ),
//                                                     focusedBorder:
//                                                         OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                         Radius.circular(4),
//                                                       ),
//                                                       borderSide: BorderSide(
//                                                         color: Color.fromARGB(
//                                                             188,
//                                                             188,
//                                                             188,
//                                                             220), //
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ],
//                             )),
//                           ),
//                         if (familyDefination == 'Fixed' &&
//                             SumInsureded == 'Varied')
//                           Padding(
//                             padding: EdgeInsets.only(top: 0),
//                             child: Container(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppBar(
//                                     toolbarHeight:
//                                         SecureRiskColours.AppbarHeight,
//                                     // backgroundColor:
//                                     //     SecureRiskColours.appBarColor,
//                                     title: Text(
//                                       "Select Family Defination",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     elevation: 5,
//                                     automaticallyImplyLeading: false,
//                                   ),
//                                   Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text(
//                                           '1 + 3',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Radio<SingingCharacter1>(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                                   (states) => SecureRiskColours
//                                                       .Button_Color),
//                                           value: SingingCharacter1.fixed1,
//                                           groupValue: _character1,
//                                           onChanged:
//                                               (SingingCharacter1? value) {
//                                             setState(() {
//                                               _character1 = value;
//                                               addedItems = [''];
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       ListTile(
//                                         title: Text(
//                                           '1+5',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Radio<SingingCharacter1>(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                                   (states) => SecureRiskColours
//                                                       .Button_Color),
//                                           value: SingingCharacter1.fixed2,
//                                           groupValue: _character1,
//                                           onChanged:
//                                               (SingingCharacter1? value) {
//                                             setState(() {
//                                               _character1 = value;
//                                               addedItems = [''];
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       ListTile(
//                                         title: Text(
//                                           'Parents Only',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Radio<SingingCharacter1>(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                                   (states) => SecureRiskColours
//                                                       .Button_Color),
//                                           value: SingingCharacter1.fixed3,
//                                           groupValue: _character1,
//                                           onChanged:
//                                               (SingingCharacter1? value) {
//                                             setState(() {
//                                               _character1 = value;
//                                               addedItems = [''];
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   // Text(
//                                   //   "Sum Insured",
//                                   //   style: GoogleFonts.poppins(
//                                   //     color: Color.fromRGBO(0, 0, 0, 1),
//                                   //     fontSize: 16,
//                                   //     fontWeight: FontWeight.bold,
//                                   //     backgroundColor:
//                                   //         Color.fromARGB(255, 255, 255, 255),
//                                   //   ),
//                                   // ),
//                                   Container(
//                                     width: screenWidth * 0.48,
//                                     child: AppBar(
//                                       toolbarHeight:
//                                           SecureRiskColours.AppbarHeight,
//                                       backgroundColor:
//                                           SecureRiskColours.appBarColor,
//                                       title: Text(
//                                         "Sum Insured",
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       elevation: 5,
//                                       automaticallyImplyLeading: false,
//                                     ),
//                                   ),
//                                   if (_character1 ==
//                                       SingingCharacter1.fixed1) ...[
//                                     Padding(
//                                       padding: EdgeInsets.only(top: 10.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.only(top: 15.0),
//                                             child: Text(
//                                               "1+3",
//                                               style: GoogleFonts.poppins(
//                                                 color: Color.fromRGBO(
//                                                     113, 114, 111, 1),
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(top: 15.0),
//                                             child: ListView.builder(
//                                               shrinkWrap: true,
//                                               itemCount: addedItems.length,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                       int index) {
//                                                 return Row(
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 60.0,
//                                                       width: 245.0,
//                                                       child: Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 bottom: 14),
//                                                         child: Material(
//                                                           elevation: 5,
//                                                           shadowColor:
//                                                               Color.fromRGBO(
//                                                                   113,
//                                                                   114,
//                                                                   111,
//                                                                   1),
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           10)),
//                                                           child: TextField(
//                                                             onChanged: (value) {
//                                                               setState(() {
//                                                                 addedItems[
//                                                                         index] =
//                                                                     value; // Update item value
//                                                               });
//                                                             },
//                                                             decoration:
//                                                                 InputDecoration(
//                                                               hintText:
//                                                                   'Sum Insured',
//                                                               hintStyle: GoogleFonts
//                                                                   .poppins(
//                                                                       fontSize:
//                                                                           14),
//                                                               border:
//                                                                   OutlineInputBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           4),
//                                                                 ),
//                                                                 borderSide:
//                                                                     BorderSide(
//                                                                   color: Color
//                                                                       .fromRGBO(
//                                                                           113,
//                                                                           114,
//                                                                           111,
//                                                                           1),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 25),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           addedItems.add(
//                                                               ''); // Add a new empty item
//                                                         });
//                                                         (addedItems);
//                                                       },
//                                                       child: Text(
//                                                         'Add',
//                                                         style: GoogleFonts
//                                                             .poppins(),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 10),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           addedItems.removeAt(
//                                                               index); // Remove the item at the current index
//                                                         });
//                                                       },
//                                                       child: Text(
//                                                         'Delete',
//                                                         style: GoogleFonts
//                                                             .poppins(),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                   if (_character1 ==
//                                       SingingCharacter1.fixed2) ...[
//                                     Padding(
//                                       padding: EdgeInsets.only(top: 10.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.only(top: 15.0),
//                                             child: Text(
//                                               "1+5",
//                                               style: GoogleFonts.poppins(
//                                                 color: Color.fromRGBO(
//                                                     113, 114, 111, 1),
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(top: 15.0),
//                                             child: ListView.builder(
//                                               shrinkWrap: true,
//                                               itemCount: addedItems.length,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                       int index) {
//                                                 return Row(
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 60.0,
//                                                       width: 245.0,
//                                                       child: Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 bottom: 14),
//                                                         child: Material(
//                                                           elevation: 5,
//                                                           shadowColor:
//                                                               Color.fromRGBO(
//                                                                   113,
//                                                                   114,
//                                                                   111,
//                                                                   1),
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           10)),
//                                                           child: TextField(
//                                                             onChanged: (value) {
//                                                               setState(() {
//                                                                 addedItems[
//                                                                         index] =
//                                                                     value; // Update item value
//                                                               });
//                                                             },
//                                                             decoration:
//                                                                 InputDecoration(
//                                                               hintText:
//                                                                   'Sum Insured',
//                                                               hintStyle: GoogleFonts
//                                                                   .poppins(
//                                                                       fontSize:
//                                                                           14),
//                                                               border:
//                                                                   OutlineInputBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           4),
//                                                                 ),
//                                                                 borderSide:
//                                                                     BorderSide(
//                                                                   color: Color
//                                                                       .fromRGBO(
//                                                                           113,
//                                                                           114,
//                                                                           111,
//                                                                           1),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 25),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           addedItems.add(
//                                                               ''); // Add a new empty item
//                                                         });
//                                                       },
//                                                       child: Text(
//                                                         'Add',
//                                                         style: GoogleFonts
//                                                             .poppins(),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 10),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           addedItems.removeAt(
//                                                               index); // Remove the item at the current index
//                                                         });
//                                                       },
//                                                       child: Text(
//                                                         'Delete',
//                                                         style: GoogleFonts
//                                                             .poppins(),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                   if (_character1 ==
//                                       SingingCharacter1.fixed3) ...[
//                                     Padding(
//                                       padding: EdgeInsets.only(top: 10.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.only(top: 15.0),
//                                             child: Text(
//                                               "Parents only",
//                                               style: GoogleFonts.poppins(
//                                                 color: Color.fromRGBO(
//                                                     113, 114, 111, 1),
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(top: 15.0),
//                                             child: ListView.builder(
//                                               shrinkWrap: true,
//                                               itemCount: addedItems.length,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                       int index) {
//                                                 return Row(
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 60.0,
//                                                       width: 245.0,
//                                                       child: Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 bottom: 14),
//                                                         child: Material(
//                                                           elevation: 5,
//                                                           shadowColor:
//                                                               Color.fromRGBO(
//                                                                   113,
//                                                                   114,
//                                                                   111,
//                                                                   1),
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           10)),
//                                                           child: TextField(
//                                                             onChanged: (value) {
//                                                               setState(() {
//                                                                 addedItems[
//                                                                         index] =
//                                                                     value; // Update item value
//                                                               });
//                                                             },
//                                                             decoration:
//                                                                 InputDecoration(
//                                                               hintText:
//                                                                   'Sum Insured',
//                                                               hintStyle: GoogleFonts
//                                                                   .poppins(
//                                                                       fontSize:
//                                                                           14),
//                                                               border:
//                                                                   OutlineInputBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           4),
//                                                                 ),
//                                                                 borderSide:
//                                                                     BorderSide(
//                                                                   color: Color
//                                                                       .fromRGBO(
//                                                                           113,
//                                                                           114,
//                                                                           111,
//                                                                           1),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 25),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           addedItems.add(
//                                                               ''); // Add a new empty item
//                                                         });
//                                                       },
//                                                       child: Text(
//                                                         'Add',
//                                                         style: GoogleFonts
//                                                             .poppins(),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 10),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           addedItems.removeAt(
//                                                               index); // Remove the item at the current index
//                                                         });
//                                                       },
//                                                       child: Text(
//                                                         'Delete',
//                                                         style: GoogleFonts
//                                                             .poppins(),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ]
//                                 ],
//                               ),
//                             ),
//                           ),
//                         if (familyDefination == 'Varied' &&
//                             SumInsureded == 'Fixed')
//                           Padding(
//                             padding: EdgeInsets.only(top: 0),
//                             child: Container(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppBar(
//                                     toolbarHeight:
//                                         SecureRiskColours.AppbarHeight,
//                                     // backgroundColor:
//                                     //     SecureRiskColours.appBarColor,
//                                     title: Text(
//                                       "Select Family Defination",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     elevation: 5,
//                                     automaticallyImplyLeading: false,
//                                   ),
//                                   Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text(
//                                           '1 + 3',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Checkbox(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                             (states) {
//                                               // Change this to your desired color
//                                               return _selectedCharacters
//                                                       .contains(
//                                                           SingingCharacter2
//                                                               .fixed1)
//                                                   ? SecureRiskColours
//                                                       .Button_Color
//                                                   : Colors.transparent;
//                                             },
//                                           ),
//                                           value: _selectedCharacters.contains(
//                                               SingingCharacter2.fixed1),
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               if (value == true) {
//                                                 _selectedCharacters.add(
//                                                     SingingCharacter2.fixed1);
//                                               } else {
//                                                 _selectedCharacters.remove(
//                                                     SingingCharacter2.fixed1);
//                                               }
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       ListTile(
//                                         title: Text(
//                                           '1 + 5',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Checkbox(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                             (states) {
//                                               // Change this to your desired color
//                                               return _selectedCharacters
//                                                       .contains(
//                                                           SingingCharacter2
//                                                               .fixed2)
//                                                   ? SecureRiskColours
//                                                       .Button_Color
//                                                   : Colors.transparent;
//                                             },
//                                           ),
//                                           value: _selectedCharacters.contains(
//                                               SingingCharacter2.fixed2),
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               if (value == true) {
//                                                 _selectedCharacters.add(
//                                                     SingingCharacter2.fixed2);
//                                               } else {
//                                                 _selectedCharacters.remove(
//                                                     SingingCharacter2.fixed2);
//                                               }
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       ListTile(
//                                         title: Text(
//                                           'Parents Only',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Checkbox(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                             (states) {
//                                               // Change this to your desired color
//                                               return _selectedCharacters
//                                                       .contains(
//                                                           SingingCharacter2
//                                                               .fixed3)
//                                                   ? SecureRiskColours
//                                                       .Button_Color
//                                                   : Colors.transparent;
//                                             },
//                                           ),
//                                           value: _selectedCharacters.contains(
//                                               SingingCharacter2.fixed3),
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               if (value == true) {
//                                                 _selectedCharacters.add(
//                                                     SingingCharacter2.fixed3);
//                                               } else {
//                                                 _selectedCharacters.remove(
//                                                     SingingCharacter2.fixed3);
//                                               }
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   if (_selectedCharacters.isNotEmpty)
//                                     Column(
//                                       children: [
//                                         // Text(
//                                         //   "Sum Insured",
//                                         //   style: GoogleFonts.poppins(
//                                         //     color: Color.fromRGBO(0, 0, 0, 1),
//                                         //     fontSize: 16,
//                                         //     fontWeight: FontWeight.bold,
//                                         //     backgroundColor: Color.fromARGB(
//                                         //         255, 255, 255, 255),
//                                         //   ),
//                                         // ),
//                                         Container(
//                                           width: screenWidth * 0.48,
//                                           child: AppBar(
//                                             toolbarHeight:
//                                                 SecureRiskColours.AppbarHeight,
//                                             backgroundColor:
//                                                 SecureRiskColours.appBarColor,
//                                             title: Text(
//                                               "Sum Insured",
//                                               style: GoogleFonts.poppins(
//                                                 color: Colors.black,
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             elevation: 5,
//                                             automaticallyImplyLeading: false,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(top: 10.0),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               for (var selectedCharacter
//                                                   in _selectedCharacters)
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       selectedCharacter ==
//                                                               SingingCharacter2
//                                                                   .fixed1
//                                                           ? "1 + 3"
//                                                           : selectedCharacter ==
//                                                                   SingingCharacter2
//                                                                       .fixed2
//                                                               ? "1 + 5"
//                                                               : "Parents Only",
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         color: Color.fromRGBO(
//                                                             113, 114, 111, 1),
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: EdgeInsets.only(
//                                                           top: 15.0),
//                                                       child: ListView.builder(
//                                                         shrinkWrap: true,
//                                                         itemCount:
//                                                             addedItems.length,
//                                                         itemBuilder:
//                                                             (BuildContext
//                                                                     context,
//                                                                 int index) {
//                                                           return Row(
//                                                             children: [
//                                                               SizedBox(
//                                                                 height: 60.0,
//                                                                 width: 245.0,
//                                                                 child: Padding(
//                                                                   padding: EdgeInsets
//                                                                       .only(
//                                                                           bottom:
//                                                                               14),
//                                                                   child:
//                                                                       Material(
//                                                                     elevation:
//                                                                         5,
//                                                                     shadowColor:
//                                                                         Color.fromRGBO(
//                                                                             113,
//                                                                             114,
//                                                                             111,
//                                                                             1),
//                                                                     borderRadius:
//                                                                         BorderRadius
//                                                                             .all(
//                                                                       Radius.circular(
//                                                                           10),
//                                                                     ),
//                                                                     child:
//                                                                         TextField(
//                                                                       onChanged:
//                                                                           (value) {
//                                                                         setState(
//                                                                             () {
//                                                                           addedItems[index] =
//                                                                               value; // Update item value
//                                                                         });
//                                                                       },
//                                                                       decoration:
//                                                                           InputDecoration(
//                                                                         hintText:
//                                                                             'Sum Insured',
//                                                                         hintStyle:
//                                                                             GoogleFonts.poppins(fontSize: 14),
//                                                                         border:
//                                                                             OutlineInputBorder(
//                                                                           borderRadius:
//                                                                               BorderRadius.all(
//                                                                             Radius.circular(4),
//                                                                           ),
//                                                                           borderSide:
//                                                                               BorderSide(
//                                                                             color: Color.fromRGBO(
//                                                                                 113,
//                                                                                 114,
//                                                                                 111,
//                                                                                 1),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   width: 25),
//                                                             ],
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         if (familyDefination == 'Varied' &&
//                             SumInsureded == 'Varied')
//                           Padding(
//                             padding: EdgeInsets.only(top: 0),
//                             child: Container(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AppBar(
//                                     toolbarHeight:
//                                         SecureRiskColours.AppbarHeight,
//                                     // backgroundColor:
//                                     //     SecureRiskColours.appBarColor,
//                                     title: Text(
//                                       "Select Family Defination",
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     elevation: 5,
//                                     automaticallyImplyLeading: false,
//                                   ),
//                                   Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text(
//                                           '1 + 3',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Checkbox(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                             (states) {
//                                               // Change this to your desired color
//                                               return _selectedCharacters
//                                                       .contains(
//                                                           SingingCharacter2
//                                                               .fixed1)
//                                                   ? SecureRiskColours
//                                                       .Button_Color
//                                                   : Colors.transparent;
//                                             },
//                                           ),
//                                           value: _selectedCharacters.contains(
//                                               SingingCharacter2.fixed1),
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               if (value == true) {
//                                                 _selectedCharacters.add(
//                                                     SingingCharacter2.fixed1);
//                                               } else {
//                                                 _selectedCharacters.remove(
//                                                     SingingCharacter2.fixed1);
//                                               }
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       ListTile(
//                                         title: Text(
//                                           '1 + 5',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Checkbox(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                             (states) {
//                                               // Change this to your desired color
//                                               return _selectedCharacters
//                                                       .contains(
//                                                           SingingCharacter2
//                                                               .fixed2)
//                                                   ? SecureRiskColours
//                                                       .Button_Color
//                                                   : Colors.transparent;
//                                             },
//                                           ),
//                                           value: _selectedCharacters.contains(
//                                               SingingCharacter2.fixed2),
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               if (value == true) {
//                                                 _selectedCharacters.add(
//                                                     SingingCharacter2.fixed2);
//                                               } else {
//                                                 _selectedCharacters.remove(
//                                                     SingingCharacter2.fixed2);
//                                               }
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       ListTile(
//                                         title: Text(
//                                           'Parents Only',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14.0,
//                                           ),
//                                         ),
//                                         leading: Checkbox(
//                                           fillColor:
//                                               MaterialStateColor.resolveWith(
//                                             (states) {
//                                               // Change this to your desired color
//                                               return _selectedCharacters
//                                                       .contains(
//                                                           SingingCharacter2
//                                                               .fixed3)
//                                                   ? SecureRiskColours
//                                                       .Button_Color
//                                                   : Colors.transparent;
//                                             },
//                                           ),
//                                           value: _selectedCharacters.contains(
//                                               SingingCharacter2.fixed3),
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               if (value == true) {
//                                                 _selectedCharacters.add(
//                                                     SingingCharacter2.fixed3);
//                                               } else {
//                                                 _selectedCharacters.remove(
//                                                     SingingCharacter2.fixed3);
//                                               }
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   if (_selectedCharacters.isNotEmpty)
//                                     Column(
//                                       children: [
//                                         // Text(
//                                         //   "Sum Insured",
//                                         //   style: GoogleFonts.poppins(
//                                         //     color: Color.fromRGBO(0, 0, 0, 1),
//                                         //     fontSize: 16,
//                                         //     fontWeight: FontWeight.bold,
//                                         //     backgroundColor: Color.fromARGB(
//                                         //         255, 255, 255, 255),
//                                         //   ),
//                                         // ),
//                                         Container(
//                                           width: screenWidth * 0.48,
//                                           child: AppBar(
//                                             toolbarHeight:
//                                                 SecureRiskColours.AppbarHeight,
//                                             backgroundColor:
//                                                 SecureRiskColours.appBarColor,
//                                             title: Text(
//                                               "Sum Insured",
//                                               style: GoogleFonts.poppins(
//                                                 color: Colors.black,
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             elevation: 5,
//                                             automaticallyImplyLeading: false,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(top: 10.0),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               for (var selectedCharacter
//                                                   in _selectedCharacters)
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       selectedCharacter ==
//                                                               SingingCharacter2
//                                                                   .fixed1
//                                                           ? "1 + 3"
//                                                           : selectedCharacter ==
//                                                                   SingingCharacter2
//                                                                       .fixed2
//                                                               ? "1 + 5"
//                                                               : "Parents Only",
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         color: Color.fromRGBO(
//                                                             113, 114, 111, 1),
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: EdgeInsets.only(
//                                                           top: 15.0),
//                                                       child: ListView.builder(
//                                                         shrinkWrap: true,
//                                                         itemCount:
//                                                             addedItems.length,
//                                                         itemBuilder:
//                                                             (BuildContext
//                                                                     context,
//                                                                 int index) {
//                                                           return Row(
//                                                             children: [
//                                                               SizedBox(
//                                                                 height: 60.0,
//                                                                 width: 245.0,
//                                                                 child: Padding(
//                                                                   padding: EdgeInsets
//                                                                       .only(
//                                                                           bottom:
//                                                                               14),
//                                                                   child:
//                                                                       Material(
//                                                                     elevation:
//                                                                         5,
//                                                                     shadowColor:
//                                                                         Color.fromRGBO(
//                                                                             113,
//                                                                             114,
//                                                                             111,
//                                                                             1),
//                                                                     borderRadius:
//                                                                         BorderRadius
//                                                                             .all(
//                                                                       Radius.circular(
//                                                                           10),
//                                                                     ),
//                                                                     child:
//                                                                         TextField(
//                                                                       onChanged:
//                                                                           (value) {
//                                                                         setState(
//                                                                             () {
//                                                                           addedItems[index] =
//                                                                               value; // Update item value
//                                                                         });
//                                                                       },
//                                                                       decoration:
//                                                                           InputDecoration(
//                                                                         hintText:
//                                                                             'Sum Insured',
//                                                                         hintStyle:
//                                                                             GoogleFonts.poppins(fontSize: 14),
//                                                                         border:
//                                                                             OutlineInputBorder(
//                                                                           borderRadius:
//                                                                               BorderRadius.all(
//                                                                             Radius.circular(4),
//                                                                           ),
//                                                                           borderSide:
//                                                                               BorderSide(
//                                                                             color: Color.fromRGBO(
//                                                                                 113,
//                                                                                 114,
//                                                                                 111,
//                                                                                 1),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   width: 25),
//                                                               TextButton(
//                                                                 onPressed: () {
//                                                                   setState(() {
//                                                                     addedItems.add(
//                                                                         ''); // Add a new empty item
//                                                                   });
//                                                                 },
//                                                                 child: Text(
//                                                                   'Add',
//                                                                   style: GoogleFonts
//                                                                       .poppins(),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   width: 10),
//                                                               TextButton(
//                                                                 onPressed: () {
//                                                                   setState(() {
//                                                                     addedItems
//                                                                         .removeAt(
//                                                                             index); // Remove the item at the current index
//                                                                   });
//                                                                 },
//                                                                 child: Text(
//                                                                   'Delete',
//                                                                   style: GoogleFonts
//                                                                       .poppins(),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         SizedBox(
//                           height: 150.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

