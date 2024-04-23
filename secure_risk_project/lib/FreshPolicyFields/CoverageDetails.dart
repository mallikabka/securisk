import 'dart:core';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/FreshPolicyFields/Coveragecard.dart';
import 'package:loginapp/FreshPolicyFields/EmpData.dart';
import 'package:loginapp/FreshPolicyFields/UploadedFileCard.dart';
import 'package:loginapp/Utilities/CircularLoader.dart';
import 'package:loginapp/Utilities/CustomAppbar.dart';
import 'package:toastification/toastification.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';
import '../Colours.dart';
import '../Service.dart';
import 'CustonDropdown.dart';
import 'package:http_parser/http_parser.dart';

List<String> productCategories = ['Floater', 'Non-Floater'];
List<String> Definations = ['Fixed', 'Varied'];

enum SingingCharacter { lafayette, jefferson }

enum SingingCharacter1 {
  fixed1,
  fixed2,
  fixed3,
}

class SelectedFamilyDefinition {
  bool? isSelected13;
  bool? isSelected15;
  bool? isSelectedParentsOnly;
}

SelectedFamilyDefinition _selectedFamilyDefinition = SelectedFamilyDefinition();

enum SingingCharacter2 { fixed1, fixed2, fixed3 }

// List<String> addedItems = [];
List<String> insured = ['Fixed', 'Varied'];
List<String> str = [
  "Fill details of the employee only along with email ID and phone number.",
  "Mentioning Family definition is important (ex: 1+3 or 1+5 or Parents only).",
  "Please do not forget to upload other files (claims MIS, policy copy, mandate letter, etc...).",
  "Please upload the data as per the downloaded template."
];

// String fileName = "";

SingingCharacter? _character;
SingingCharacter1? _character1;
String? _characterError;
String? _characterError1;
String? policyType;
String? familyDefination;
String? SumInsureded;
bool? hasEmpData = false;
String? policyTypeError;
String? familyDefinationError;
String? sumInsurededError;
List<String> addedItems = [''];
List<String> addedItems13 = [''];
List<String> addedItems15 = [''];
List<String> addedItemsParents = [''];
List<String> OneThree = [''];
List<String> OneFive = [''];
List<String> ParentOnly = [''];
TextEditingController default1 = TextEditingController();
TextEditingController default2 = TextEditingController();
TextEditingController default3 = TextEditingController();
bool? isfamilyDefication13 = false;
bool? isfamilyDefication15 = false;
bool? isfamilyDeficationParents = false;
List<double> familyDefication13 = [0.0];
List<double> familyDefication15 = [0.0];
List<double> familyDeficationParents = [0.0];
TextEditingController familyDefication13Controller = TextEditingController();
TextEditingController familyDefication15Controller = TextEditingController();
TextEditingController familyDeficationParentsController =
    TextEditingController();

final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: GoogleFonts.poppins(fontSize: 20));

Map<String, dynamic> fileResponses = {};
Set<SingingCharacter2> _selectedCharacters = {};

class CoverageDetails extends StatefulWidget {
  final GlobalKey<CoverageDetailsState>? coverageDetailsKey;

  // final Uint8List fileBytes;
  CoverageDetails({
    Key? key,
    this.coverageDetailsKey,
  }) : super(key: key);

  static void coverageClearFields() {
    policyType = null;
    familyDefination = null;
    SumInsureded = null;
    _character = null;
    _character1 = null;
    policyTypeError = null;
    familyDefinationError = null;
    sumInsurededError = null;
    _characterError1 = null;
    _characterError = null;
    addedItems = [''];
    addedItems13 = [''];
    addedItems15 = [''];
    addedItemsParents = [''];
    familyDefication15 = [];
    familyDefication13 = [];
    familyDeficationParents = [];
    isfamilyDefication13 = false;
    isfamilyDefication15 = false;
    isfamilyDeficationParents = false;
    OneThree.clear();
    OneFive.clear();
    ParentOnly.clear();
    familyDefication13Controller.clear();
    familyDefication15Controller.clear();
    familyDeficationParentsController.clear();
    _selectedCharacters.clear();
    default1.clear();
    default2.clear();
    default3.clear();
  }

  @override
  State<CoverageDetails> createState() => CoverageDetailsState();

  void printPayload() async {
    final prefs = await SharedPreferences.getInstance();
    final rfqId = prefs.getString('responseBody');

    if (familyDefination == 'Varied' && SumInsureded == 'Fixed') {
      if (_selectedCharacters.contains(SingingCharacter2.fixed1)) {
        if (familyDefication13.isNotEmpty) {
          OneThree =
              familyDefication13.map((value) => value.toString()).toList();
        }
      }
      if (_selectedCharacters.contains(SingingCharacter2.fixed2)) {
        if (familyDefication15.isNotEmpty) {
          OneFive =
              familyDefication15.map((value) => value.toString()).toList();
        }
      }
      if (_selectedCharacters.contains(SingingCharacter2.fixed3)) {
        if (familyDeficationParents.isNotEmpty) {
          ParentOnly =
              familyDeficationParents.map((value) => value.toString()).toList();
        }
      }
    }

// Determine which radio button is selected

    // Based on the selected option, retrieve the corresponding sum insured value
    if (familyDefination == 'Fixed' && SumInsureded == 'Fixed') {
      String selectedRadioOption = '';
      if (_character1 == SingingCharacter1.fixed1 ||
          _selectedCharacters == SingingCharacter2.fixed1) {
        selectedRadioOption = '1 + 3';
        // isfamilyDefication13 = true;
      } else if (_character1 == SingingCharacter1.fixed2 ||
          _selectedCharacters == SingingCharacter2.fixed2) {
        selectedRadioOption = '1 + 5';
        // isfamilyDefication15 = true;
      } else if (_character1 == SingingCharacter1.fixed3 ||
          _selectedCharacters == SingingCharacter2.fixed3) {
        selectedRadioOption = 'Parents Only';
        // isfamilyDeficationParents = true;
      }

      if (selectedRadioOption == '1 + 3') {
        if (familyDefication13.isNotEmpty) {
          OneThree =
              familyDefication13.map((value) => value.toString()).toList();
        }
      } else if (selectedRadioOption == '1 + 5') {
        if (familyDefication15.isNotEmpty) {
          OneFive =
              familyDefication15.map((value) => value.toString()).toList();
        }
      } else if (selectedRadioOption == 'Parents Only') {
        if (familyDeficationParents.isNotEmpty) {
          ParentOnly =
              familyDeficationParents.map((value) => value.toString()).toList();
        }
      }
    }

    if (familyDefination == 'Fixed' && SumInsureded == 'Varied') {
      final data = {
        'rfqId': rfqId,
        'policyType': policyType,
        'familyDefination': familyDefination,
        'sumInsured': SumInsureded,
        'uploadedDocumentsPath': fileResponses["UploadedDocuments"] ?? "",
        "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
        "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
        "coveragesFilePath": fileResponses["CoveragesSought"] ?? "",
        "claimsMiscFilePath": fileResponses["ClaimsMis"] ?? "",
        "claimsSummaryFilePath": fileResponses["ClaimsSummary"] ?? "",
        "templateFilePath": fileResponses["EmpData"] ?? "",
        "policyCopyFilePath": fileResponses["PolicyCopy"] ?? "",
        "familyDefication13": isfamilyDefication13,
        "familyDefication15": isfamilyDefication15,
        "familyDeficationParents": isfamilyDeficationParents,
        "familyDefication13Amount": isfamilyDefication13! ? addedItems : [],
        "familyDefication15Amount": isfamilyDefication15! ? addedItems : [],
        "familyDeficationParentsAmount":
            isfamilyDeficationParents! ? addedItems : [],
        "empData": hasEmpData
      };
    }
    if (familyDefination == 'Varied' && SumInsureded == 'Varied') {
      final data = {
        'rfqId': rfqId,
        'policyType': policyType,
        'familyDefination': familyDefination,
        'sumInsured': SumInsureded,
        'uploadedDocumentsPath': fileResponses["UploadedDocuments"] ?? "",
        "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
        "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
        "coveragesFilePath": fileResponses["CoveragesSought"] ?? "",
        "claimsMiscFilePath": fileResponses["ClaimsMis"] ?? "",
        "claimsSummaryFilePath": fileResponses["ClaimsSummary"] ?? "",
        "templateFilePath": fileResponses["EmpData"] ?? "",
        "policyCopyFilePath": fileResponses["PolicyCopy"] ?? "",
        "familyDefication13": isfamilyDefication13,
        "familyDefication15": isfamilyDefication15,
        "familyDeficationParents": isfamilyDeficationParents,
        "familyDefication13Amount": isfamilyDefication13! ? addedItems13 : [],
        "familyDefication15Amount": isfamilyDefication15! ? addedItems15 : [],
        "familyDeficationParentsAmount":
            isfamilyDeficationParents! ? addedItemsParents : [],
        "empData": hasEmpData
      };
    }
    if (familyDefination == 'Fixed' && SumInsureded == 'Fixed' ||
        familyDefination == 'Varied' && SumInsureded == 'Fixed') {
      final data = {
        'rfqId': rfqId,
        'policyType': policyType,
        'familyDefination': familyDefination,
        'sumInsured': SumInsureded,
        'uploadedDocumentsPath': fileResponses["UploadedDocuments"] ?? "",
        "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
        "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
        "coveragesFilePath": fileResponses["CoveragesSought"] ?? "",
        "claimsMiscFilePath": fileResponses["ClaimsMis"] ?? "",
        "claimsSummaryFilePath": fileResponses["ClaimsSummary"] ?? "",
        "templateFilePath": fileResponses["EmpData"] ?? "",
        "policyCopyFilePath": fileResponses["PolicyCopy"] ?? "",
        "familyDefication13": isfamilyDefication13,
        "familyDefication15": isfamilyDefication15,
        "familyDeficationParents": isfamilyDeficationParents,
        "familyDefication13Amount": OneThree,
        "familyDefication15Amount": OneFive,
        "familyDeficationParentsAmount": ParentOnly,
        "empData": hasEmpData
      };
    }
  }

  Future<void> createCoverageDetails(BuildContext context) async {
    addedItemsParents.removeWhere((element) => element.isEmpty);
    addedItems15.removeWhere((element) => element.isEmpty);
    addedItems13.removeWhere((element) => element.isEmpty);
    addedItems.removeWhere((element) => element.isEmpty);

    dynamic data = {};
    final prefs = await SharedPreferences.getInstance();
    final rfqId = prefs.getString('responseBody');

    if (familyDefination == 'Varied' && SumInsureded == 'Fixed') {
      if (_selectedCharacters.contains(SingingCharacter2.fixed1)) {
        if (familyDefication13.isNotEmpty) {
          OneThree =
              familyDefication13.map((value) => value.toString()).toList();
        }
      }
      if (_selectedCharacters.contains(SingingCharacter2.fixed2)) {
        if (familyDefication15.isNotEmpty) {
          OneFive =
              familyDefication15.map((value) => value.toString()).toList();
        }
      }
      if (_selectedCharacters.contains(SingingCharacter2.fixed3)) {
        if (familyDeficationParents.isNotEmpty) {
          ParentOnly =
              familyDeficationParents.map((value) => value.toString()).toList();
        }
      }
    }

// Determine which radio button is selected

    // Based on the selected option, retrieve the corresponding sum insured value
    if (familyDefination == 'Fixed' && SumInsureded == 'Fixed') {
      String selectedRadioOption = '';
      if (_character1 == SingingCharacter1.fixed1 ||
          _selectedCharacters == SingingCharacter2.fixed1) {
        selectedRadioOption = '1 + 3';
        // isfamilyDefication13 = true;
      } else if (_character1 == SingingCharacter1.fixed2 ||
          _selectedCharacters == SingingCharacter2.fixed2) {
        selectedRadioOption = '1 + 5';
        // isfamilyDefication15 = true;
      } else if (_character1 == SingingCharacter1.fixed3 ||
          _selectedCharacters == SingingCharacter2.fixed3) {
        selectedRadioOption = 'Parents Only';
        // isfamilyDeficationParents = true;
      }

      if (selectedRadioOption == '1 + 3') {
        if (familyDefication13.isNotEmpty) {
          OneThree =
              familyDefication13.map((value) => value.toString()).toList();
        }
      } else if (selectedRadioOption == '1 + 5') {
        if (familyDefication15.isNotEmpty) {
          OneFive =
              familyDefication15.map((value) => value.toString()).toList();
        }
      } else if (selectedRadioOption == 'Parents Only') {
        if (familyDeficationParents.isNotEmpty) {
          ParentOnly =
              familyDeficationParents.map((value) => value.toString()).toList();
        }
      }
    }

    if (familyDefination == 'Fixed' && SumInsureded == 'Varied') {
      data = {
        'rfqId': rfqId,
        'policyType': policyType,
        'familyDefination': familyDefination,
        'sumInsured': SumInsureded,
        'uploadedDocumentsPath': fileResponses["UploadedDocuments"] ?? "",
        "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
        "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
        "coveragesFilePath": fileResponses["CoveragesSought"] ?? "",
        "claimsMiscFilePath": fileResponses["ClaimsMis"] ?? "",
        "claimsSummaryFilePath": fileResponses["ClaimsSummary"] ?? "",
        "templateFilePath": fileResponses["EmpData"] ?? "",
        "policyCopyFilePath": fileResponses["PolicyCopy"] ?? "",
        "familyDefication13": isfamilyDefication13,
        "familyDefication15": isfamilyDefication15,
        "familyDeficationParents": isfamilyDeficationParents,
        "familyDefication13Amount": isfamilyDefication13! ? addedItems : [],
        "familyDefication15Amount": isfamilyDefication15! ? addedItems : [],
        "familyDeficationParentsAmount":
            isfamilyDeficationParents! ? addedItems : [],
        "empData": hasEmpData
      };
    }
    if (familyDefination == 'Varied' && SumInsureded == 'Varied') {
      data = {
        'rfqId': rfqId,
        'policyType': policyType,
        'familyDefination': familyDefination,
        'sumInsured': SumInsureded,
        'uploadedDocumentsPath': fileResponses["UploadedDocuments"] ?? "",
        "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
        "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
        "coveragesFilePath": fileResponses["CoveragesSought"] ?? "",
        "claimsMiscFilePath": fileResponses["ClaimsMis"] ?? "",
        "claimsSummaryFilePath": fileResponses["ClaimsSummary"] ?? "",
        "templateFilePath": fileResponses["EmpData"] ?? "",
        "policyCopyFilePath": fileResponses["PolicyCopy"] ?? "",
        "familyDefication13": isfamilyDefication13,
        "familyDefication15": isfamilyDefication15,
        "familyDeficationParents": isfamilyDeficationParents,
        "familyDefication13Amount": isfamilyDefication13! ? addedItems13 : [],
        "familyDefication15Amount": isfamilyDefication15! ? addedItems15 : [],
        "familyDeficationParentsAmount":
            isfamilyDeficationParents! ? addedItemsParents : [],
        "empData": hasEmpData
      };
    }
    if (familyDefination == 'Fixed' && SumInsureded == 'Fixed' ||
        familyDefination == 'Varied' && SumInsureded == 'Fixed') {
      data = {
        'rfqId': rfqId,
        'policyType': policyType,
        'familyDefination': familyDefination,
        'sumInsured': SumInsureded,
        'uploadedDocumentsPath': fileResponses["UploadedDocuments"] ?? "",
        "empDepDataFilePath": fileResponses["EmpDepData"] ?? "",
        "mandateLetterFilePath": fileResponses["MandateLetter"] ?? "",
        "coveragesFilePath": fileResponses["CoveragesSought"] ?? "",
        "claimsMiscFilePath": fileResponses["ClaimsMis"] ?? "",
        "claimsSummaryFilePath": fileResponses["ClaimsSummary"] ?? "",
        "templateFilePath": fileResponses["EmpData"] ?? "",
        "policyCopyFilePath": fileResponses["PolicyCopy"] ?? "",
        "familyDefication13": isfamilyDefication13,
        "familyDefication15": isfamilyDefication15,
        "familyDeficationParents": isfamilyDeficationParents,
        "familyDefication13Amount": OneThree,
        "familyDefication15Amount": OneFive,
        "familyDeficationParentsAmount": ParentOnly,
        "empData": hasEmpData
      };
    }
    final headers = await ApiServices.getHeaders();

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
        title: 'CoverageDetails  failed to save.....!',
      );
    }
    OneThree.clear();
    OneFive.clear();
    ParentOnly.clear();
  }
}

http.MultipartRequest jsonToFormData(
    http.MultipartRequest request, Map<String, dynamic> data) {
  for (var key in data.keys) {
    request.fields[key] = data[key].toString();
  }
  return request;
}

class CoverageDetailsState extends State<CoverageDetails> {
  late EmpData empData;
  List<String> missingColumnDropdown = [];

  Future<void> fetchFieldMappings() async {
    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
          Uri.parse(ApiServices.baseUrl + ApiServices.GetAllEmployeeHeaders),
          headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        missingColumnDropdown =
            List<String>.from(data.where((element) => element != null));
      } else {
        throw Exception('Failed to fetch field mappings');
      }
    } catch (e) {
      throw Exception('Error fetching field mappings: $e');
    }
    empData = EmpData(
        coverageDetailsKey: widget.coverageDetailsKey,
        empheaders: missingColumnDropdown);
  }

  @override
  void initState() {
    super.initState();
    (widget.coverageDetailsKey?.currentContext);
    fetchFieldMappings();
    OneThree.clear();
    OneFive.clear();
    ParentOnly.clear();
    familyDefication15 = [];
    familyDefication15 = [];
    familyDeficationParents = [];
  }

  TextEditingController familyDefinationSumInsureded = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _formSubmitted = false;
  bool nextClicked = false;
  bool uploadMandateText = false;
  bool uploadMandateLettererror = false;

  bool validateCoverageDetails() {
    _formKey.currentState!.validate();
    nextClicked = true;
    if (policyType == null) {
      setState(() {
        policyTypeError = 'Please select a policy type';
      });
    } else {
      setState(() {
        policyTypeError = null;
      });
    }

    if (familyDefination == null) {
      setState(() {
        familyDefinationError = 'Please select a family defination';
      });
    } else {
      setState(() {
        familyDefinationError = null;
      });
    }

    if (SumInsureded == null) {
      setState(() {
        sumInsurededError = 'Please select a Sum Insureded';
      });
    } else {
      setState(() {
        sumInsurededError = null;
      });
    }
    if (_character != null) {
      setState(() {
        _characterError = 'Field is mandatory';
      });
    } else {
      setState(() {
        _characterError = null;
      });
    }
    if (_character1 != null) {
      setState(() {
        _characterError1 = 'Field is mandatory';
      });
    } else {
      setState(() {
        _characterError1 = null;
      });
    }

    setState(() {
      _formSubmitted = true;
    });

    if (showEmpDataCard == false && nextClicked == true) {
      setState(() {
        uploadMandateText = true;
      });
    }

    // if (uploadSuccessMap["MandateLetter"] == false) {
    //   if (nextClicked == true) {
    //     setState(() {
    //       uploadMandateLettererror = true;
    //     });
    //   }
    // }
    bool radioOrCheckboxIsSelected = false;
    if (_selectedCharacters.isNotEmpty || _character1 != null) {
      radioOrCheckboxIsSelected = true;
    }

    if (policyType != null &&
        familyDefination != null &&
        SumInsureded != null &&
        _character != null &&
        radioOrCheckboxIsSelected == true &&
        uploadMandateText == false) {
      return true;
    }
    return false;
  }

  bool showEmpDataCard = false;
  bool isEmpDataUploadSuccessful = false;

  downloadFile() async {
    final urlString = ApiServices.baseUrl + ApiServices.Download_Template;

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Extract filename from Content-Disposition header

        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = "RfqTemplate.xlsx";

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

  Map<String, bool> uploadSuccessMap = {
    "MandateLetter": false,
    "CoveragesSought": false,
    // Add more file types as needed
  };

  Future<void> uploadEmpdataFile(
      Uint8List? fileBytes, String fileType, String fileName) async {
    final prefs = await SharedPreferences.getInstance();

    final rfqId = prefs.getString('responseBody');

    try {
      // var headers=await ApiServices.getHeaders();
      final headers = await ApiServices.getHeaders();
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.Coverage_Upload_Endpoint);
      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);
      ("$uploadApiUrl");

      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes!,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );
      request.files.add(multipartFile);
      request.fields['fileType'] = 'EmpDepData';
      request.fields['rfqId'] = rfqId!;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        fileResponses[fileType] = responseBody; // Store the response
        ("Response for $fileType: $responseBody"); //  the response

        Loader.hideLoader();
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: '$fileType uploaded successfully.....!',
        );

        setState(() {
          isEmpDataUploadSuccessful = true;
          showEmpDataCard = true;
          uploadMandateText = false; // Set the flag to show the empdata card
        });
      } else {
        Loader.hideLoader();
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File upload failed.....!',
        );
      }
    } catch (e) {
      Loader.hideLoader();
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File upload failed.....!',
      );
    }
  }

  Future<void> _uploadFile(String fileType) async {
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
        var fileName = result.files.first.name; // Get the filename
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
            title: '$fileType uploaded successfully.....!',
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
        title: 'File upload failed.....!',
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
          title: '$fileType uploaded successfully.....!',
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

  Future<bool> sendEmail(String recipientEmail) async {
    var headers = await ApiServices.getHeaders();
    final apiUrl = Uri.parse(
        ApiServices.baseUrl + ApiServices.Send_Email_Downloaded_Template);

    final jsonBody = {
      "email": recipientEmail,
    };

    final response = await http.post(
      (apiUrl),
      headers: headers,
      body: json.encode(jsonBody),
    );

    if (response.statusCode == 200) {
      ('Email sent successfully');
      return true;
    } else {
      ('Failed to send email: ${response.statusCode}');
      return true;
    }
  }

  void _emailSenderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController emailController = TextEditingController();

        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          contentPadding: EdgeInsets.zero,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                width: 440,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: SecureRiskColours.Table_Heading_Color,
                ),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Send Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.white,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 180, // Increased the height to accommodate the note
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8), // Add a small space
                    Text(
                      'Note: If sending to multiple emails, separate them with commas.',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(
                              199, 55, 125, 1.0), // Hovered color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                          bool success = await sendEmail(emailController.text);
                          if (success) {
                            Navigator.pop(context); // Close the dialog
                            Fluttertoast.showToast(
                              msg: 'Email sent! Check your mailbox.',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                            );
                          }
                        },
                        child: Text(
                          'Send Email',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Row(
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
                            child:
                                AppBarBuilder.buildAppBar('Coverage Details'),
                            // child: AppBar(
                            //   toolbarHeight: SecureRiskColours.AppbarHeight,
                            //   backgroundColor:
                            //       SecureRiskColours.Table_Heading_Color,
                            //   title: Text(
                            //     "Details",
                            //     style: GoogleFonts.poppins(
                            //       color: Colors.white,
                            //       fontSize: 14,
                            //       // fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            //   elevation: 5,
                            // ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: CustomDropdown(
                                  value: policyType,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      policyType = newValue;
                                      _formSubmitted = false;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text(
                                        '------Policy Type------',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                        ),
                                      ), // default label
                                    ),
                                    ...productCategories.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(
                                          option,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              if (policyTypeError != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    policyTypeError!,
                                    style:
                                        GoogleFonts.poppins(color: Colors.red),
                                  ),
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: CustomDropdown(
                                  value: familyDefination,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      familyDefination = newValue;
                                      _formSubmitted = false;
                                      addedItems = [''];
                                      addedItems13 = [''];
                                      addedItems15 = [''];
                                      addedItemsParents = [''];
                                      familyDefication15 = [];
                                      familyDefication13 = [];
                                      familyDeficationParents = [];
                                      isfamilyDefication13 = false;
                                      isfamilyDefication15 = false;
                                      isfamilyDeficationParents = false;
                                      OneThree.clear();
                                      OneFive.clear();
                                      ParentOnly.clear();
                                      familyDefication13Controller.clear();
                                      familyDefication15Controller.clear();
                                      familyDeficationParentsController.clear();
                                      _selectedCharacters.clear();
                                      _character1 = null;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text(
                                        '------Family Defination------',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    ...Definations.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(
                                          option,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              if (familyDefinationError != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    familyDefinationError!,
                                    style:
                                        GoogleFonts.poppins(color: Colors.red),
                                  ),
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: CustomDropdown(
                                  value: SumInsureded,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      SumInsureded = newValue;
                                      _formSubmitted = false;
                                      addedItems = [''];
                                      addedItems13 = [''];
                                      addedItems15 = [''];
                                      addedItemsParents = [''];
                                      familyDefication15 = [];
                                      familyDefication13 = [];
                                      familyDeficationParents = [];
                                      isfamilyDefication13 = false;
                                      isfamilyDefication15 = false;
                                      isfamilyDeficationParents = false;
                                      OneThree.clear();
                                      OneFive.clear();
                                      ParentOnly.clear();
                                      familyDefication13Controller.clear();
                                      familyDefication15Controller.clear();
                                      familyDeficationParentsController.clear();
                                      _selectedCharacters.clear();
                                      _character1 = null;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text(
                                        '------Sum Insured------',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                        ),
                                      ), // default label
                                    ),
                                    ...insured.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(
                                          option,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              if (sumInsurededError != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    sumInsurededError!,
                                    style:
                                        GoogleFonts.poppins(color: Colors.red),
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
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: ListTile(
                                      title: Text(
                                        'I have employee data',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          // color: SecureRiskColours.Button_Color
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
                                            isEmpDataUploadSuccessful = false;
                                            showEmpDataCard = false;
                                            uploadSuccessMap["MandateLetter"] =
                                                false;
                                            uploadSuccessMap[
                                                "CoveragesSought"] = false;
                                            fileResponses["EmpDepData"] = "";
                                            fileResponses["MandateLetter"] = "";
                                            fileResponses["CoveragesSought"] =
                                                "";
                                            fileResponses["ClaimsMis"] = "";
                                            fileResponses["ClaimsSummary"] = "";
                                            fileResponses["PolicyCopy"] = "";

                                            _formKey.currentState!
                                                .validate(); // Trigger validation when radio changes
                                            _formSubmitted = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'I dont have data',
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
                                          hasEmpData = false;
                                          _character = value;
                                          isEmpDataUploadSuccessful = false;
                                          showEmpDataCard = false;
                                          uploadSuccessMap["CoveragesSought"] =
                                              false;
                                          fileResponses["EmpDepData"] = "";
                                          fileResponses["MandateLetter"] = "";
                                          fileResponses["CoveragesSought"] = "";
                                          fileResponses["ClaimsMis"] = "";
                                          fileResponses["ClaimsSummary"] = "";
                                          fileResponses["PolicyCopy"] = "";
                                          _formKey.currentState!
                                              .validate(); // Trigger validation when radio changes
                                          _formSubmitted = false;
                                        });
                                      },
                                    ),
                                  ),
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
                          ),
                          if (_character == SingingCharacter.lafayette) ...[
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 300),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Employee & Dependent Data ",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            // Loader.hideLoader();
                                            if (!isEmpDataUploadSuccessful) {
                                              empData.handleUpload(
                                                  context, "EmpDepData");
                                            }
                                          },
                                          icon: isEmpDataUploadSuccessful
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
                                ],
                              ),
                            ),
                            if (showEmpDataCard)
                              Row(
                                children: [
                                  CardExample(onClose: () {
                                    setState(() {
                                      isEmpDataUploadSuccessful = false;
                                      showEmpDataCard = false;
                                      fileResponses["EmpDepData"] = "";
                                      // Hide the card
                                    });
                                  }),
                                ],
                              ),
                            if (uploadMandateText)
                              Row(
                                children: [
                                  Text(
                                    "Please Upload a file..!",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                            SizedBox(
                                height: 10), // Add spacing between sections
                            Container(
                              constraints: BoxConstraints(maxWidth: 300),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Mandate Letter",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (uploadSuccessMap
                                              .containsKey("MandateLetter") &&
                                          !uploadSuccessMap["MandateLetter"]!) {
                                        uploadMandateLetter("MandateLetter");
                                      }
                                    },
                                    icon: uploadSuccessMap
                                                .containsKey("MandateLetter") &&
                                            uploadSuccessMap["MandateLetter"]!
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Color.fromARGB(
                                                255, 62, 233, 105),
                                            size: 40,
                                          )
                                        : Icon(
                                            Icons.drive_folder_upload_rounded,
                                            color:
                                                SecureRiskColours.Button_Color,
                                            size: 40,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            if (uploadSuccessMap["MandateLetter"] == true)
                              UploadedFileCard(
                                fileType: "Mandate Letter",
                                onClose: () {
                                  // Handle card's cross mark action
                                  setState(() {
                                    uploadSuccessMap["MandateLetter"] = false;
                                    fileResponses["MandateLetter"] = "";
                                  });
                                },
                              ),

                            SizedBox(height: 10),
                            // Add spacing between sections
                            Container(
                              constraints: BoxConstraints(maxWidth: 300),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Coverage Sought",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (uploadSuccessMap
                                              .containsKey("CoveragesSought") &&
                                          !uploadSuccessMap[
                                              "CoveragesSought"]!) {
                                        _uploadFile("CoveragesSought");
                                      }
                                    },
                                    icon: uploadSuccessMap.containsKey(
                                                "CoveragesSought") &&
                                            uploadSuccessMap["CoveragesSought"]!
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Color.fromARGB(
                                                255, 62, 233, 105),
                                            size: 40,
                                          )
                                        : Icon(
                                            Icons.drive_folder_upload_rounded,
                                            color:
                                                SecureRiskColours.Button_Color,
                                            size: 40,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            if (uploadSuccessMap["CoveragesSought"] == true)
                              UploadedFileCard(
                                fileType: "Coverage Sought",
                                onClose: () {
                                  // Handle card's cross mark action
                                  setState(() {
                                    uploadSuccessMap["CoveragesSought"] = false;
                                    fileResponses["CoveragesSought"] = "";
                                  });
                                },
                              ),
                            SizedBox(height: 10)
                          ],
                          if (_character == SingingCharacter.jefferson) ...[
                            Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // Align children to the left
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start, // Align children to the left
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Please download the template",
                                        style:
                                            GoogleFonts.poppins(fontSize: 14),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10.0,
                                            left: 15.0,
                                            right: 10.0),
                                        child: IconButton(
                                          style: style,
                                          onPressed: () {
                                            // Handle the upload button action
                                            downloadFile();
                                          },
                                          icon: Icon(
                                            Icons.download_for_offline_rounded,
                                            size:
                                                35, // Increase the size of the icon
                                            color:
                                                SecureRiskColours.Button_Color,
                                          ), // Use the f icon
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _emailSenderDialog();
                                          },
                                          style: SecureRiskColours
                                              .customButtonStyle(),
                                          child: Text(
                                            'Send Email',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: str.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: ListTile(
                                            title: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Text(
                                                str[index],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 300),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Upload your Filled Employee Data ",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (!isEmpDataUploadSuccessful) {
                                                  empData.handleUpload(
                                                      context, "EmpDepData");
                                                }
                                              },
                                              icon: isEmpDataUploadSuccessful
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
                                      if (showEmpDataCard)
                                        Row(
                                          children: [
                                            CardExample(onClose: () {
                                              setState(() {
                                                isEmpDataUploadSuccessful =
                                                    false;
                                                showEmpDataCard = false;
                                                fileResponses["EmpDepData"] =
                                                    "";
                                                // Hide the card
                                              });
                                            }),
                                          ],
                                        ),
                                      if (uploadMandateText)
                                        Row(
                                          children: [
                                            Text(
                                              "Please Upload a file..!",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red),
                                            )
                                          ],
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
                                              "Coverage Sought",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (uploadSuccessMap.containsKey(
                                                        "CoveragesSought") &&
                                                    !uploadSuccessMap[
                                                        "CoveragesSought"]!) {
                                                  _uploadFile(
                                                      "CoveragesSought");
                                                }
                                              },
                                              icon: uploadSuccessMap.containsKey(
                                                          "CoveragesSought") &&
                                                      uploadSuccessMap[
                                                          "CoveragesSought"]!
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
                                      if (uploadSuccessMap["CoveragesSought"] ==
                                          true)
                                        UploadedFileCard(
                                          fileType: "Coverage Sought",
                                          onClose: () {
                                            // Handle card's cross mark action
                                            setState(() {
                                              uploadSuccessMap[
                                                  "CoveragesSought"] = false;
                                              fileResponses["CoveragesSought"] =
                                                  "";
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 40),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: screenHeight * 0.8,
          child: VerticalDivider(
            color: Color.fromARGB(255, 82, 81, 81),
            thickness: 1,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (familyDefination == 'Fixed' && SumInsureded == 'Fixed')
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth * 0.4,
                              child: AppBarBuilder.buildAppBar(
                                  'Select Family Defination'),
                              // child: AppBar(
                              //   toolbarHeight: SecureRiskColours.AppbarHeight,
                              //   backgroundColor:
                              //       SecureRiskColours.Table_Heading_Color,
                              //   title: Text(
                              //     "Select Family Defination",
                              //     style: GoogleFonts.poppins(
                              //       color: Colors.white,
                              //       fontSize: 14,
                              //       // ,
                              //     ),
                              //   ),
                              //   elevation: 5,
                              // ),
                            ),
                            Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    '1 + 3',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  leading: Radio<SingingCharacter1>(
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) =>
                                            SecureRiskColours.Button_Color),
                                    value: SingingCharacter1.fixed1,
                                    groupValue: _character1,
                                    onChanged: (SingingCharacter1? value) {
                                      setState(() {
                                        _character1 = value;
                                        familyDeficationParents = [];
                                        familyDefication13 = [];
                                        familyDefication15 = [];

                                        familyDeficationParentsController
                                            .clear();
                                        familyDefication13Controller.clear();
                                        familyDefication15Controller.clear();
                                        isfamilyDefication13 = true;
                                        isfamilyDefication15 = false;
                                        isfamilyDeficationParents = false;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    '1+5',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  leading: Radio<SingingCharacter1>(
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) =>
                                            SecureRiskColours.Button_Color),
                                    value: SingingCharacter1.fixed2,
                                    groupValue: _character1,
                                    onChanged: (SingingCharacter1? value) {
                                      setState(() {
                                        _character1 = value;
                                        familyDeficationParents = [];
                                        familyDefication13 = [];
                                        familyDefication15 = [];

                                        familyDeficationParentsController
                                            .clear();
                                        familyDefication13Controller.clear();
                                        familyDefication15Controller.clear();
                                        isfamilyDefication13 = false;
                                        isfamilyDefication15 = true;
                                        isfamilyDeficationParents = false;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Parents Only',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  leading: Radio<SingingCharacter1>(
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) =>
                                            SecureRiskColours.Button_Color),
                                    value: SingingCharacter1.fixed3,
                                    groupValue: _character1,
                                    onChanged: (SingingCharacter1? value) {
                                      setState(() {
                                        _character1 = value;
                                        familyDeficationParents = [];
                                        familyDefication13 = [];
                                        familyDefication15 = [];

                                        familyDeficationParentsController
                                            .clear();
                                        familyDefication13Controller.clear();
                                        familyDefication15Controller.clear();
                                        isfamilyDefication13 = false;
                                        isfamilyDefication15 = false;
                                        isfamilyDeficationParents = true;
                                      });
                                    },
                                  ),
                                ),
                                if (_formSubmitted &&
                                    _character1 == null &&
                                    policyType != null)
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
                            Container(
                              width: screenWidth * 0.4,
                              child: AppBarBuilder.buildAppBar('Sum Insured'),
                              // child: Padding(
                              //   padding: EdgeInsets.only(left: 10.0),

                              //   // child: AppBar(
                              //   //   toolbarHeight: SecureRiskColours.AppbarHeight,
                              //   //   backgroundColor:
                              //   //       SecureRiskColours.Table_Heading_Color,
                              //   //   title: Text(
                              //   //     "Sum Insured",
                              //   //     style: GoogleFonts.poppins(
                              //   //       color: Colors.white,
                              //   //       fontSize: 14,
                              //   //     ),
                              //   //   ),
                              //   //   elevation: 5,
                              //   // ),
                              // ),
                            ),
                            if (_character1 == SingingCharacter1.fixed1) ...[
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 5, left: 5),
                                      child: Text(
                                        "1+3",
                                        style:
                                            GoogleFonts.poppins(fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(),
                                      child: SizedBox(
                                        height: 60.0,
                                        width: 245.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 14),
                                          child: Material(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: TextField(
                                              controller:
                                                  familyDefication13Controller,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  familyDefication13.clear();
                                                  familyDefication13.add(
                                                      double.tryParse(
                                                          familyDefication13Controller
                                                              .text)!);
                                                });
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Sum Insured',
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        188, 188, 188, 220), //
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        188, 188, 188, 220), //
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                            if (_character1 == SingingCharacter1.fixed2) ...[
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 5.0, bottom: 5),
                                      child: Text(
                                        "1+5",
                                        style:
                                            GoogleFonts.poppins(fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(),
                                      child: SizedBox(
                                        height: 60.0,
                                        width: 245.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 14),
                                          child: Material(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: TextField(
                                              controller:
                                                  familyDefication15Controller,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  familyDefication15.clear();
                                                  familyDefication15.add(
                                                      double.tryParse(
                                                          familyDefication15Controller
                                                              .text)!);
                                                });
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Sum Insured',
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        188, 188, 188, 220), //
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        188, 188, 188, 220), //
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (_character1 == SingingCharacter1.fixed3) ...[
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Parents only",
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(),
                                      child: SizedBox(
                                        height: 60.0,
                                        width: 245.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 14),
                                          child: Material(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: TextField(
                                              controller:
                                                  familyDeficationParentsController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    familyDeficationParents
                                                        .clear();
                                                    familyDeficationParents.add(
                                                        double.tryParse(
                                                            familyDeficationParentsController
                                                                .text)!);
                                                  },
                                                );
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Sum Insured',
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        188, 188, 188, 220), //
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        188, 188, 188, 220), //
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ],
                        )),
                      ),
                    if (familyDefination == 'Fixed' && SumInsureded == 'Varied')
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBarBuilder.buildAppBar(
                                    'Select Family Defination'),
                                // child: AppBar(
                                //   toolbarHeight: SecureRiskColours.AppbarHeight,
                                //   backgroundColor:
                                //       SecureRiskColours.Table_Heading_Color,
                                //   title: Text(
                                //     "Select Family Defination",
                                //     style: GoogleFonts.poppins(
                                //       color: Colors.white,
                                //       fontSize: 14,
                                //     ),
                                //   ),
                                //   elevation: 5,
                                // ),
                              ),
                              Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      '1 + 3',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Radio<SingingCharacter1>(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              SecureRiskColours.Button_Color),
                                      value: SingingCharacter1.fixed1,
                                      groupValue: _character1,
                                      onChanged: (SingingCharacter1? value) {
                                        setState(() {
                                          addedItems = [''];
                                          _character1 = value;
                                          familyDeficationParents = [];
                                          familyDefication13 = [];
                                          familyDefication15 = [];

                                          familyDeficationParentsController
                                              .clear();
                                          familyDefication13Controller.clear();
                                          familyDefication15Controller.clear();
                                          isfamilyDefication13 = true;
                                          isfamilyDefication15 = false;
                                          isfamilyDeficationParents = false;
                                          default1.clear();
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      '1+5',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Radio<SingingCharacter1>(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              SecureRiskColours.Button_Color),
                                      value: SingingCharacter1.fixed2,
                                      groupValue: _character1,
                                      onChanged: (SingingCharacter1? value) {
                                        setState(() {
                                          addedItems = [''];
                                          _character1 = value;
                                          familyDeficationParents = [];
                                          familyDefication13 = [];
                                          familyDefication15 = [];

                                          familyDeficationParentsController
                                              .clear();
                                          familyDefication13Controller.clear();
                                          familyDefication15Controller.clear();
                                          isfamilyDefication13 = false;
                                          isfamilyDefication15 = true;
                                          isfamilyDeficationParents = false;
                                          default2.clear();
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Parents Only',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Radio<SingingCharacter1>(
                                      fillColor: MaterialStateColor.resolveWith(
                                          (states) =>
                                              SecureRiskColours.Button_Color),
                                      value: SingingCharacter1.fixed3,
                                      groupValue: _character1,
                                      onChanged: (SingingCharacter1? value) {
                                        setState(() {
                                          addedItems = [''];
                                          _character1 = value;
                                          familyDeficationParents = [];
                                          familyDefication13 = [];
                                          familyDefication15 = [];

                                          familyDeficationParentsController
                                              .clear();
                                          familyDefication13Controller.clear();
                                          familyDefication15Controller.clear();
                                          isfamilyDefication13 = false;
                                          isfamilyDefication15 = false;
                                          isfamilyDeficationParents = true;
                                          default3.clear();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (_formSubmitted &&
                                  _character1 == null &&
                                  policyType != null)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Please select an option.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBarBuilder.buildAppBar('Sum Insured'),
                                // child: Padding(
                                //   padding: EdgeInsets.only(left: 10.0),
                                //   child: AppBar(
                                //     toolbarHeight:
                                //         SecureRiskColours.AppbarHeight,
                                //     backgroundColor:
                                //         SecureRiskColours.Table_Heading_Color,
                                //     title: Text(
                                //       "Sum Insured",
                                //       style: GoogleFonts.poppins(
                                //         color: Colors.white,
                                //         fontSize: 14,
                                //       ),
                                //     ),
                                //     elevation: 5,
                                //   ),
                                // ),
                              ),
                              if (_character1 == SingingCharacter1.fixed1) ...[
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          "1+3",
                                          style: GoogleFonts.poppins(
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 60.0,
                                              width: 245.0,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 14),
                                                child: Material(
                                                  elevation: 5,
                                                  shadowColor: Color.fromRGBO(
                                                      113, 114, 111, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: TextField(
                                                    controller: default1,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        addedItems[0] =
                                                            value; // Update item value
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Sum Insured',
                                                      hintStyle: TextStyle(
                                                          fontSize: 14),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 25),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  addedItems.add(
                                                      ''); // Add a new empty item
                                                });
                                                (addedItems);
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: addedItems.length - 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                SizedBox(
                                                  height: 60.0,
                                                  width: 245.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 14),
                                                    child: Material(
                                                      elevation: 5,
                                                      shadowColor:
                                                          Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          setState(() {
                                                            addedItems[
                                                                    index + 1] =
                                                                value; // Update item value
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Sum Insured',
                                                          hintStyle: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  4),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      113,
                                                                      114,
                                                                      111,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems.add(
                                                          ''); // Add a new empty item
                                                    });
                                                    (addedItems);
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems.removeAt(index +
                                                          1); // Remove the item at the current index
                                                    });
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              if (_character1 == SingingCharacter1.fixed2) ...[
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          "1+5",
                                          style: GoogleFonts.poppins(
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 60.0,
                                              width: 245.0,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 14),
                                                child: Material(
                                                  elevation: 5,
                                                  shadowColor: Color.fromRGBO(
                                                      113, 114, 111, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: TextField(
                                                    controller: default2,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        addedItems[0] =
                                                            value; // Update item value
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Sum Insured',
                                                      hintStyle: TextStyle(
                                                          fontSize: 14),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 25),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  addedItems.add(
                                                      ''); // Add a new empty item
                                                });
                                                (addedItems);
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: addedItems.length - 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                SizedBox(
                                                  height: 60.0,
                                                  width: 245.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 14),
                                                    child: Material(
                                                      elevation: 5,
                                                      shadowColor:
                                                          Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          setState(() {
                                                            addedItems[
                                                                    index + 1] =
                                                                value; // Update item value
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Sum Insured',
                                                          hintStyle: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  4),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      113,
                                                                      114,
                                                                      111,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems.add(
                                                          ''); // Add a new empty item
                                                    });
                                                    (addedItems);
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems.removeAt(index +
                                                          1); // Remove the item at the current index
                                                    });
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              if (_character1 == SingingCharacter1.fixed3) ...[
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          "Parents only",
                                          style: GoogleFonts.poppins(
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 60.0,
                                              width: 245.0,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 14),
                                                child: Material(
                                                  elevation: 5,
                                                  shadowColor: Color.fromRGBO(
                                                      113, 114, 111, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: TextField(
                                                    controller: default3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        addedItems[0] =
                                                            value; // Update item value
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Sum Insured',
                                                      hintStyle: TextStyle(
                                                          fontSize: 14),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 25),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  addedItems.add(
                                                      ''); // Add a new empty item
                                                });
                                                (addedItems);
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: addedItems.length - 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                SizedBox(
                                                  height: 60.0,
                                                  width: 245.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 14),
                                                    child: Material(
                                                      elevation: 5,
                                                      shadowColor:
                                                          Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: TextField(
                                                        // controller: familyDefication13Controller,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            addedItems[
                                                                    index + 1] =
                                                                value; // Update item value
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Sum Insured',
                                                          hintStyle: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  4),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      113,
                                                                      114,
                                                                      111,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems.add(
                                                          ''); // Add a new empty item
                                                    });
                                                    (addedItems);
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems.removeAt(index +
                                                          1); // Remove the item at the current index
                                                    });
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    if (familyDefination == 'Varied' && SumInsureded == 'Fixed')
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBarBuilder.buildAppBar(
                                    'Select Family Defination'),
                                // child: AppBar(
                                //   toolbarHeight: SecureRiskColours.AppbarHeight,
                                //   backgroundColor:
                                //       SecureRiskColours.Table_Heading_Color,
                                //   title: Text(
                                //     "Select Family Defination",
                                //     style: GoogleFonts.poppins(
                                //       color: Colors.white,
                                //       fontSize: 14,
                                //     ),
                                //   ),
                                //   elevation: 5,
                                // ),
                              ),
                              Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      '1 + 3',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Checkbox(
                                      fillColor: MaterialStateColor.resolveWith(
                                        (states) {
                                          // Change this to your desired color
                                          return _selectedCharacters.contains(
                                                  SingingCharacter2.fixed1)
                                              ? SecureRiskColours.Button_Color
                                              : Colors.transparent;
                                        },
                                      ),
                                      // (states) =>
                                      //     SecureRiskColours.Button_Color),
                                      value: _selectedCharacters
                                          .contains(SingingCharacter2.fixed1),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCharacters
                                                .add(SingingCharacter2.fixed1);
                                            isfamilyDefication13 = true;
                                          } else {
                                            _selectedCharacters.remove(
                                                SingingCharacter2.fixed1);
                                            isfamilyDefication13 = false;
                                            familyDefication13Controller
                                                .clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      '1 + 5',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Checkbox(
                                      fillColor: MaterialStateColor.resolveWith(
                                        (states) {
                                          // Change this to your desired color
                                          return _selectedCharacters.contains(
                                                  SingingCharacter2.fixed2)
                                              ? SecureRiskColours.Button_Color
                                              : Colors.transparent;
                                        },
                                      ),
                                      value: _selectedCharacters
                                          .contains(SingingCharacter2.fixed2),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCharacters
                                                .add(SingingCharacter2.fixed2);
                                            isfamilyDefication15 = true;
                                          } else {
                                            _selectedCharacters.remove(
                                                SingingCharacter2.fixed2);
                                            isfamilyDefication15 = false;
                                            familyDefication15Controller
                                                .clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Parents Only',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Checkbox(
                                      fillColor: MaterialStateColor.resolveWith(
                                        (states) {
                                          // Change this to your desired color
                                          return _selectedCharacters.contains(
                                                  SingingCharacter2.fixed3)
                                              ? SecureRiskColours.Button_Color
                                              : Colors.transparent;
                                        },
                                      ),
                                      value: _selectedCharacters
                                          .contains(SingingCharacter2.fixed3),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCharacters
                                                .add(SingingCharacter2.fixed3);
                                            isfamilyDeficationParents = true;
                                          } else {
                                            _selectedCharacters.remove(
                                                SingingCharacter2.fixed3);
                                            isfamilyDeficationParents = false;
                                            familyDeficationParentsController
                                                .clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (_formSubmitted &&
                                  _selectedCharacters.isEmpty &&
                                  policyType != null)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Please select an option.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth * 0.4,
                                    child: AppBarBuilder.buildAppBar(
                                        'Sum Insured'),
                                    // child: Padding(
                                    //   padding:
                                    //       const EdgeInsets.only(left: 10.0),
                                    //   child: AppBar(
                                    //     toolbarHeight:
                                    //         SecureRiskColours.AppbarHeight,
                                    //     backgroundColor: SecureRiskColours
                                    //         .Table_Heading_Color,
                                    //     title: Text(
                                    //       "Sum Insured",
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //         fontSize: 17,
                                    //         // fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     elevation: 5,
                                    //   ),
                                    // ),
                                  ),
                                  if (_selectedCharacters
                                      .contains(SingingCharacter2.fixed1)) ...[
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, left: 5),
                                            child: Text(
                                              "1+3",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(),
                                            child: SizedBox(
                                              height: 60.0,
                                              width: 245.0,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 14),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: TextField(
                                                    controller:
                                                        familyDefication13Controller,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          familyDefication13
                                                              .clear();
                                                          familyDefication13.add(
                                                              double.tryParse(
                                                                  familyDefication13Controller
                                                                      .text)!);
                                                        },
                                                      );
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Sum Insured',
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: const Color
                                                              .fromARGB(188,
                                                              188, 188, 220), //
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              188,
                                                              188,
                                                              188,
                                                              220), //
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                  if (_selectedCharacters
                                      .contains(SingingCharacter2.fixed2)) ...[
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 5.0, bottom: 5),
                                            child: Text(
                                              "1+5",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(),
                                            child: SizedBox(
                                              height: 60.0,
                                              width: 245.0,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 14),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: TextField(
                                                    controller:
                                                        familyDefication15Controller,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          familyDefication15
                                                              .clear();
                                                          familyDefication15.add(
                                                              double.tryParse(
                                                                  familyDefication15Controller
                                                                      .text)!);
                                                        },
                                                      );
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Sum Insured',
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: const Color
                                                              .fromARGB(188,
                                                              188, 188, 220), //
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              188,
                                                              188,
                                                              188,
                                                              220), //
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (_selectedCharacters
                                      .contains(SingingCharacter2.fixed3)) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Parents only",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(),
                                            child: SizedBox(
                                              height: 60.0,
                                              width: 245.0,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 14),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: TextField(
                                                    controller:
                                                        familyDeficationParentsController,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          familyDeficationParents
                                                              .clear();
                                                          familyDeficationParents
                                                              .add(double.tryParse(
                                                                  familyDeficationParentsController
                                                                      .text)!);
                                                        },
                                                      );
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Sum Insured',
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: const Color
                                                              .fromARGB(188,
                                                              188, 188, 220), //
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(4),
                                                        ),
                                                        borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              188,
                                                              188,
                                                              188,
                                                              220), //
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (familyDefination == 'Varied' &&
                        SumInsureded == 'Varied')
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBarBuilder.buildAppBar(
                                    'Select Family Defination'),
                                // child: AppBar(
                                //   toolbarHeight: SecureRiskColours.AppbarHeight,
                                //   backgroundColor:
                                //       SecureRiskColours.Table_Heading_Color,
                                //   title: Text(
                                //     "Select Family Defination",
                                //     style: GoogleFonts.poppins(
                                //       color: Colors.white,
                                //       fontSize: 14,
                                //     ),
                                //   ),
                                //   elevation: 5,
                                // ),
                              ),
                              Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      '1 + 3',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Checkbox(
                                      fillColor: MaterialStateColor.resolveWith(
                                        (states) {
                                          // Change this to your desired color
                                          return _selectedCharacters.contains(
                                                  SingingCharacter2.fixed1)
                                              ? SecureRiskColours.Button_Color
                                              : Colors.transparent;
                                        },
                                      ),
                                      value: _selectedCharacters
                                          .contains(SingingCharacter2.fixed1),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCharacters
                                                .add(SingingCharacter2.fixed1);
                                            isfamilyDefication13 = true;
                                          } else {
                                            _selectedCharacters.remove(
                                                SingingCharacter2.fixed1);
                                            isfamilyDefication13 = false;
                                            addedItems13 = [''];
                                            default1.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      '1 + 5',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Checkbox(
                                      fillColor: MaterialStateColor.resolveWith(
                                        (states) {
                                          // Change this to your desired color
                                          return _selectedCharacters.contains(
                                                  SingingCharacter2.fixed2)
                                              ? SecureRiskColours.Button_Color
                                              : Colors.transparent;
                                        },
                                      ),
                                      value: _selectedCharacters
                                          .contains(SingingCharacter2.fixed2),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCharacters
                                                .add(SingingCharacter2.fixed2);
                                            isfamilyDefication15 = true;
                                          } else {
                                            _selectedCharacters.remove(
                                                SingingCharacter2.fixed2);
                                            isfamilyDefication15 = false;
                                            addedItems15 = [''];
                                            default2.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Parents Only',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: Checkbox(
                                      fillColor: MaterialStateColor.resolveWith(
                                        (states) {
                                          // Change this to your desired color
                                          return _selectedCharacters.contains(
                                                  SingingCharacter2.fixed3)
                                              ? SecureRiskColours.Button_Color
                                              : Colors.transparent;
                                        },
                                      ),
                                      value: _selectedCharacters
                                          .contains(SingingCharacter2.fixed3),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCharacters
                                                .add(SingingCharacter2.fixed3);
                                            isfamilyDeficationParents = true;
                                          } else {
                                            _selectedCharacters.remove(
                                                SingingCharacter2.fixed3);
                                            isfamilyDeficationParents = false;
                                            addedItemsParents = [''];
                                            default3.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (_formSubmitted &&
                                  _selectedCharacters.isEmpty &&
                                  policyType != null)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Please select an option.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth * 0.4,
                                    child: AppBarBuilder.buildAppBar(
                                        'Sum Insured'),
                                    // child: Padding(
                                    //   padding: EdgeInsets.only(left: 10.0),
                                    //   child: AppBar(
                                    //     toolbarHeight:
                                    //         SecureRiskColours.AppbarHeight,
                                    //     backgroundColor: SecureRiskColours
                                    //         .Table_Heading_Color,
                                    //     title: Text(
                                    //       "Sum Insured",
                                    //       style: GoogleFonts.poppins(
                                    //         color: Colors.white,
                                    //         fontSize: 14,
                                    //       ),
                                    //     ),
                                    //     elevation: 5,
                                    //   ),
                                    // ),
                                  ),
                                  if (_selectedCharacters
                                      .contains(SingingCharacter2.fixed1)) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Text(
                                              "1+3",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    113, 114, 111, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 60.0,
                                                  width: 245.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 14),
                                                    child: Material(
                                                      elevation: 5,
                                                      shadowColor:
                                                          Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: TextField(
                                                        controller: default1,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            addedItems13[0] =
                                                                value; // Update item value
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Sum Insured',
                                                          hintStyle: TextStyle(
                                                              fontSize: 14),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  4),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      113,
                                                                      114,
                                                                      111,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems13.add(
                                                          ''); // Add a new empty item
                                                    });
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  addedItems13.length - 1,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 60.0,
                                                      width: 245.0,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 14),
                                                        child: Material(
                                                          elevation: 5,
                                                          shadowColor:
                                                              Color.fromRGBO(
                                                                  113,
                                                                  114,
                                                                  111,
                                                                  1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child: TextField(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                addedItems13[
                                                                        index +
                                                                            1] =
                                                                    value;
                                                              });
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Sum Insured',
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          4),
                                                                ),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          113,
                                                                          114,
                                                                          111,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 25),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          addedItems13.add(
                                                              ''); // Add a new empty item
                                                        });
                                                        (addedItems13);
                                                      },
                                                      child: Text(
                                                        'Add',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          addedItems13.removeAt(
                                                              index +
                                                                  1); // Remove the item at the current index
                                                        });
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                  if (_selectedCharacters
                                      .contains(SingingCharacter2.fixed2)) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Text(
                                              "1+5",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    113, 114, 111, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 60.0,
                                                  width: 245.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 14),
                                                    child: Material(
                                                      elevation: 5,
                                                      shadowColor:
                                                          Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: TextField(
                                                        controller: default2,
                                                        onChanged: (value) {
                                                          setState(
                                                            () {
                                                              addedItems15[0] =
                                                                  value; // Update item value
                                                            },
                                                          );
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Sum Insured',
                                                          hintStyle: TextStyle(
                                                              fontSize: 14),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  4),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      113,
                                                                      114,
                                                                      111,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItems15.add(
                                                          ''); // Add a new empty item
                                                    });
                                                    (addedItems15);
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  addedItems15.length - 1,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 60.0,
                                                      width: 245.0,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 14),
                                                        child: Material(
                                                          elevation: 5,
                                                          shadowColor:
                                                              Color.fromRGBO(
                                                                  113,
                                                                  114,
                                                                  111,
                                                                  1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child: TextField(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                addedItems15[
                                                                        index +
                                                                            1] =
                                                                    value; // Update item value
                                                              });
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Sum Insured',
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          4),
                                                                ),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          113,
                                                                          114,
                                                                          111,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 25),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          addedItems15.add(
                                                              ''); // Add a new empty item
                                                        });
                                                        (addedItems15);
                                                      },
                                                      child: Text(
                                                        'Add',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          addedItems15.removeAt(
                                                              index +
                                                                  1); // Remove the item at the current index
                                                        });
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                  if (_selectedCharacters
                                      .contains(SingingCharacter2.fixed3)) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Text(
                                              "Parents only",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    113, 114, 111, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 60.0,
                                                  width: 245.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 14),
                                                    child: Material(
                                                      elevation: 5,
                                                      shadowColor:
                                                          Color.fromRGBO(
                                                              113, 114, 111, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: TextField(
                                                        controller: default3,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            addedItemsParents[
                                                                    0] =
                                                                value; // Update item value
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Sum Insured',
                                                          hintStyle: TextStyle(
                                                              fontSize: 14),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  4),
                                                            ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      113,
                                                                      114,
                                                                      111,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 25),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addedItemsParents.add(
                                                          ''); // Add a new empty item
                                                    });
                                                    (addedItemsParents);
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  addedItemsParents.length - 1,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 60.0,
                                                      width: 245.0,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 14),
                                                        child: Material(
                                                          elevation: 5,
                                                          shadowColor:
                                                              Color.fromRGBO(
                                                                  113,
                                                                  114,
                                                                  111,
                                                                  1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child: TextField(
                                                            // controller: familyDefication13Controller,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                addedItemsParents[
                                                                        index +
                                                                            1] =
                                                                    value; // Update item value
                                                              });
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Sum Insured',
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          4),
                                                                ),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          113,
                                                                          114,
                                                                          111,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 25),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          addedItemsParents.add(
                                                              ''); // Add a new empty item
                                                        });
                                                      },
                                                      child: Text(
                                                        'Add',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          addedItemsParents
                                                              .removeAt(index +
                                                                  1); // Remove the item at the current index
                                                        });
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 150.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
