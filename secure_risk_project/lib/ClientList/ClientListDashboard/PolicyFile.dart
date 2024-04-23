import 'dart:convert';
import 'dart:html';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/RenewalPolicy/RenewalCorporateDetails.dart';
import 'package:loginapp/Service.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';

import 'package:toastification/toastification.dart';

String? NatureofBusiness;
int? selectedLocationId;
List<Location> locations = [];

// ignore: must_be_immutable
class PolicyForm extends StatefulWidget {
  final String productNameVar;

  int clientId;

  String productIdvar;
  String tpaNameVar;
  String insuranceComp;

  PolicyForm(
      {Key? key,
      required this.clientId,
      required this.productIdvar,
      required this.productNameVar,
      required this.tpaNameVar,
      required this.insuranceComp})
      : super(key: key);

  @override
  State<PolicyForm> createState() => PolicyFormState();
  String nameOfTheBusinessError = "";
  static void clearFields() {
    ("clearing fields");

    selectedLocationId = null;
  }
}

List<Map<String, dynamic>> apiResponse = [];

class PolicyFormState extends State<PolicyForm> {
  final TextEditingController familyDefinitioncontroller =
      TextEditingController();
  final TextEditingController policyNamecontroller = TextEditingController();

  final TextEditingController policyNumbercontroller = TextEditingController();

  final TextEditingController policystartDate = TextEditingController();

  final TextEditingController policyEndDate = TextEditingController();

  // final TextEditingController policyCopy = TextEditingController();

  final TextEditingController pptcontroller = TextEditingController();

  final TextEditingController insuranceBrokerController =
      TextEditingController();

  final TextEditingController insuranceCompany = TextEditingController();

  final TextEditingController inceptionPremiumController =
      TextEditingController();

  final TextEditingController tillDatePremium = TextEditingController();
  final TextEditingController nameOfTPAcontroller = TextEditingController();
  final TextEditingController sumInsuredcontroller = TextEditingController();
  String? policyCopy;
  String? pptCopyPath;
  String buttonText = "Edit"; // Initial button text
  bool textfeildStatus = false;
  List<RowData> rows = [RowData()];

  String? selectedValue;
  final List<String> _options = ['1+3', '1+5', 'Self', 'Parents Only'];
  bool isGHI = false;

  double bottomMargin = 120;

  int fieldCount = 1;

  bool isFileUploaded1 = false;
  bool isFileUploaded2 = false;
  bool isHovered = false;
  bool isIgnoredropDown = true;
  final FocusNode inceptionPremiumFocusNode = FocusNode();
  // Later, when you're ready to send the request

// Convert your map to a JSON string
//String familyDefinitionJson = jsonEncode([familyDefinition]); // Enclosed in [] to form a list

  void initState() {
    super.initState();

    findProductId();
    fetchPolicyData(widget.clientId, int.tryParse(widget.productIdvar));
    inceptionPremiumFocusNode.addListener(() {
      if (!inceptionPremiumFocusNode.hasFocus) {
        // When inceptionPremium loses focus, transfer its value to tillDatePremium
        tillDatePremium.text = inceptionPremiumController.text;
      }
    });
    setState(() {
       policyNamecontroller.text=widget.productNameVar;
        nameOfTPAcontroller.text=widget.tpaNameVar;
        insuranceCompany.text=widget.insuranceComp;
        insuranceBrokerController.text="Securisk Insurance Brokers(P) Ltd.";
    });
    
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void findProductId() {
    if (widget.productIdvar == "1001") {
      setState(() {
        isGHI = true;
       
      });
    }
  }

  @override
  void dispose() {
    inceptionPremiumFocusNode.dispose();
    super.dispose();
  }

  bool nameOfTheBusinessHasError = false;

  bool showNameError = false;
  bool showAddressError = false;

  String? policyNameHasError = "";
  String? policyNumberHasError = "";
  String? policystartDateError = "";
  String? policyEndDateError = "";
  String? insuranceBrockerError = "";
  String? insuranceCompanyError = "";
  String? inceptionPremiumError = "";
  String? tillDatePremiumError = "";
  String? nameOfTPAError = "";
  String? sumInsuredError = "";
  String? policyfileName;
  String? pptFileName;

  void clearValidationErrors() {
    setState(() {
      //tillDatePremium.text = inceptionPremiumController.text;
    });
  }

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  String? pickedFileName;
  PlatformFile? file;
  PlatformFile? file1;
  Future<void> pickFile() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) {
        return; // File picker was canceled or failed
      }

      file = result.files.first;

      setState(() {
        // pickedFileName = "uploaded";
        // print(pickedFileName);
        pickedFileName = file!.name;
      });

      if (file != null) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File  $pickedFileName Successfully!!',
        );

        setState(() {
          isFileUploaded1 = true;
        });
      }
    } catch (e) {
      // Handle exceptions or show an error message
    }
  }

  String? pickedFileName2;
  Future<void> pickFile2() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) {
        return; // File picker was canceled or failed
      }

      file1 = result.files.first;

      setState(() {
        pickedFileName2 = file1!.name;
        // pickedFileName = "uploaded";
        // print(pickedFileName);
      });

      if (file != null) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File  $pickedFileName Successfully!!',
        );
      }

      setState(() {
        isFileUploaded2 = true;
      });
    } catch (e) {
      // Handle exceptions or show an error message
    }
  }

  Future<void> createClientPolicy(String fileType) async {
    String? clientId = widget.clientId.toString();
    print("********************");
    print(clientId);
    String? productId = widget.productIdvar.toString();
    if (file == null || file1 == null) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Please pick both files first.',
      );
      return;
    }

    var headers = await ApiServices.getHeaders();

// Modified to include query parameters
    var uriWithParams =
        Uri.parse(ApiServices.baseUrl + ApiServices.client_addPolicy)
            .replace(queryParameters: {
      'clientId': clientId,
      'productId': productId,
    });
    var request = http.MultipartRequest('POST', uriWithParams)
      ..headers.addAll(headers);

    // Map<String?, String?> familyDefination = {
    //   'familyDefination': selectedValue,
    //   'sumInsured': int.tryParse(sumInsuredcontroller.text)?.toString(),
    // };
    // String jsonString = jsonEncode(familyDefination);
    List<Map<String, dynamic>> familyDefinationMap = rows.map((rowData) {
      return {
        'familyDefination': rowData.selectedDropdownValue,
        'sumInsured': rowData.sumInsuredController.text,
      };
    }).toList();

    String familyDefinationJson = jsonEncode(familyDefinationMap);

    request.files.add(http.MultipartFile.fromBytes(
      'policyCopyPath',
      file!.bytes!,
      filename: file!.name,
      contentType: MediaType('application', 'pdf'),
    ));

    // Add the second file
    request.files.add(http.MultipartFile.fromBytes(
      'PPTPath',
      file1!.bytes!,
      filename: file1!.name,
      contentType: MediaType('application', 'pdf'),
    ));

    // Add other fields
    request.fields['policyName'] = policyNamecontroller.text;
    request.fields['policyNumber'] = policyNumbercontroller.text;
    request.fields['policyStartDate'] = policystartDate.text;
    request.fields['policyEndDate'] = policyEndDate.text;
    request.fields['insuranceBroker'] = insuranceBrokerController.text;
    request.fields['insuranceCompany'] = insuranceCompany.text;
    request.fields['nameOfTheTPA'] =
        nameOfTPAcontroller.text; // Ensure this variable exists
    request.fields['inception_Premium'] = inceptionPremiumController.text;

    request.fields['familyDefination'] = familyDefinationJson;

    request.fields['tillDatePremium'] = tillDatePremium.text;
    // request.fields['rfqId'] = "123";

    try {
      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Policy Created Successfully!',
        );
        print("policy created");
      } else {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File upload failed!',
        );
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Exception during file upload: $e',
      );
    }
  }

  Future<void> fetchPolicyData(int clientId, int? productId) async {
    var headers = await ApiServices.getHeaders();
    
    String urlString =
        "${ApiServices.baseUrl}${ApiServices.getPolicyById}clientId=$clientId&productId=$productId";
    try {
      final response = await http.get(Uri.parse(urlString), headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, then parse the JSON.

        final data = json.decode(response.body);
        print("Raw policyCopyPath: ${data['policyCopyPath']}");

        setState(() {
          policyNamecontroller.text = widget.productNameVar;
          //policyNamecontroller.text = data['policyName'] ?? ' ';
          policyNumbercontroller.text = data['policyNumber'] ?? ' ';
          policystartDate.text = data['policyStartDate'] ?? ' ';
          policyEndDate.text = data['policyEndDate'] ?? ' ';
          insuranceBrokerController.text = data['insuranceBroker'] ?? ' ';
          insuranceCompany.text = data['insuranceCompany'] ?? ' ';
          nameOfTPAcontroller.text = data['nameOfTheTPA'] ?? ' ';
          inceptionPremiumController.text =
              data['inception_Premium'].toString() ?? ' ';
          tillDatePremium.text = data['tillDatePremium'].toString() ?? ' ';
          policyCopy = data['policyCopyPath'] ?? ' ';
          policyfileName = policyCopy?.split('_').last;
          pptCopyPath = data['pptpath'] ?? ' ';
          pptFileName = pptCopyPath?.split('_').last;
        });
        print(data);
        //    print("))))))))))))))))))))))))))))))))))");
        print(policyCopy);
        // Use the data as needed
        print(policyfileName);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load policy data');
      }
    } catch (e) {
      print(e); // Handle the exception
    }
  }

//changes
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = MediaQuery.of(context).size.width * 0.20;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          // shape: RoundedRectangleBorder(
          //   borderRadius:
          //       BorderRadius.circular(50.0), // Set the value of radius as needed
          // ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 15, // Spread radius
                blurRadius: 17, // Blur radius
                offset: Offset(0, 3), // Offset
              ),
            ],
          ),
          child: Container(
            // padding: EdgeInsets.all(12),
            //height: screenHeight * 0.4,
            color: Colors.white,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // Align children to the left
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Align children to the start of the cross axis (left)
                                  children: [
                                    Container(
                                      width: screenWidth * 0.4,
                                      child: AppBar(
                                        toolbarHeight: 40,
                                        backgroundColor: SecureRiskColours
                                            .Table_Heading_Color,
                                        automaticallyImplyLeading: false,
                                        title: Text(
                                          "Overview",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 14,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        elevation: 5,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          //  isAlwaysShown: true,
                                          ),
                                      child: Scrollbar(
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0, left: 20),
                                            child: Text("Policy Name",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        25, 26, 25, 1))),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 20),
                                      child: SizedBox(
                                        height: policyNameHasError == null ||
                                                policyNameHasError!.isEmpty
                                            ? 40.0
                                            : 65.0,
                                        width: screenWidth * 0.22,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Material(
                                            shadowColor: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            child: TextFormField(
                                              enabled: textfeildStatus,
                                              controller: policyNamecontroller,
                                              onChanged: (_) =>
                                                  clearValidationErrors(),
                                              decoration: InputDecoration(
                                                hintText: 'Policy Name',
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 13),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                setState(() {
                                                  policyNameHasError =
                                                      validateString(value);
                                                });
                                                return policyNameHasError;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 20),
                                      child: Text("Policy Number",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  25, 26, 25, 1))),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 20),
                                      child: SizedBox(
                                        height: policyNumberHasError == null ||
                                                policyNumberHasError!.isEmpty
                                            ? 40.0
                                            : 65.0,
                                        width: screenWidth * 0.22,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Material(
                                            shadowColor: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            child: TextFormField(
                                              enabled: textfeildStatus,
                                              controller:
                                                  policyNumbercontroller,
                                              decoration: InputDecoration(
                                                hintText: 'Policy Number',
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 13),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                setState(() {
                                                  policyNumberHasError =
                                                      validateString(value);
                                                });
                                                return policyNumberHasError;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 20),
                                      child: Text("Policy Start Date",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  25, 26, 25, 1))),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 8.0, left: 20),
                                      child: SizedBox(
                                        height: policystartDateError == null ||
                                                policystartDateError!.isEmpty
                                            ? 40.0
                                            : 65.0,
                                        width: screenWidth * 0.22,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Material(
                                            shadowColor: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            child: TextFormField(
                                              enabled: textfeildStatus,
                                              controller: policystartDate,
                                              readOnly:
                                                  true, // Prevents manual text input
                                              decoration: InputDecoration(
                                                hintText: 'Policy Start Date',
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 13),
                                                suffixIcon: GestureDetector(
                                                  onTap: () async {
                                                    DateTime?
                                                        selectedStartDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime
                                                          .now(), // Initial date for the picker
                                                      firstDate: DateTime(
                                                          2000), // Earliest selectable date
                                                      lastDate: DateTime(
                                                          2101), // Latest selectable date
                                                    );

                                                    if (selectedStartDate !=
                                                        null) {
                                                      // Format and set the start date
                                                      policystartDate
                                                          .text = DateFormat(
                                                              'dd-MM-yyyy')
                                                          .format(
                                                              selectedStartDate);

                                                      // Calculate the end date (one year later, minus one day)
                                                      DateTime endDate = DateTime(
                                                              selectedStartDate.year +
                                                                  1,
                                                              selectedStartDate
                                                                  .month,
                                                              selectedStartDate
                                                                  .day)
                                                          .subtract(Duration(
                                                              days: 1));

                                                      // Format and set the end date
                                                      policyEndDate.text =
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(endDate);
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.calendar_month_sharp,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),

                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Field is Mandatory"; // Display error message if field is empty
                                                }
                                                // Additional validation logic can go here, if necessary
                                                return null; // Return null if the data is valid
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 20),
                                      child: Text("Policy End Date",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  25, 26, 25, 1))),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 8.0, left: 20),
                                      child: SizedBox(
                                        height: policystartDateError == null ||
                                                policystartDateError!.isEmpty
                                            ? 40.0
                                            : 65.0,
                                        width: screenWidth * 0.22,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Material(
                                            shadowColor: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            child: Container(
                                              child: TextFormField(
                                                enabled: textfeildStatus,
                                                controller: policyEndDate,
                                                readOnly:
                                                    true, // Prevents manual text input
                                                decoration: InputDecoration(
                                                  hintText: 'Policy End Date',
                                                  hintStyle:
                                                      GoogleFonts.poppins(
                                                          fontSize: 13),
                                                  suffixIcon: GestureDetector(
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_sharp,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(3)),
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  setState(() {
                                                    policystartDateError =
                                                        validateString(value);
                                                  });
                                                  return policystartDateError;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 20),
                                      child: Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 300),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Policy Copy ",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: textfeildStatus
                                                  ? () {
                                                      pickFile();
                                                    }
                                                  : null, // Conditionally set the onPressed callback
                                              icon: Icon(
                                                Icons
                                                    .drive_folder_upload_rounded,
                                                // color: Colors.black38,
                                                color: textfeildStatus
                                                    ? SecureRiskColours
                                                        .Button_Color
                                                    : Colors.black38,
                                                size: 40,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (policyCopy != null)
                                      Visibility(
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Container(
                                                width: cardWidth,
                                                child: Card(
                                                  elevation: isHovered
                                                      ? 8
                                                      : 4, // Add elevation based on hover state
                                                  color: isHovered
                                                      ? const Color.fromARGB(
                                                          255, 239, 241, 242)
                                                      : Colors
                                                          .white, // Change color based on hover state
                                                  child: MouseRegion(
                                                    onEnter: (event) {
                                                      setState(() {
                                                        isHovered = true;
                                                      });
                                                    },
                                                    onExit: (event) {
                                                      setState(() {
                                                        isHovered = false;
                                                      });
                                                    },
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: ListTile(
                                                        title: policyCopy !=
                                                                null
                                                            ? Text(
                                                                policyfileName!,
                                                                //  "Mandate Letter",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              )
                                                            : Text(
                                                                'Policy Copy',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                        // child: ListTile(
                                                        //   title: Text(
                                                        //     'PPT',
                                                        //     style: GoogleFonts
                                                        //         .poppins(
                                                        //       fontSize: 14,
                                                        //       // fontWeight: FontWeight.bold
                                                        //     ),
                                                        //   ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .remove_red_eye),
                                                              onPressed: () {},
                                                            ),
                                                            SizedBox(width: 10),
                                                            IconButton(
                                                              onPressed: () {
                                                                isFileUploaded2 =
                                                                    false;
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
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
                                    if (isFileUploaded1)
                                      Visibility(
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Container(
                                                width: cardWidth,
                                                child: Card(
                                                  elevation: isHovered
                                                      ? 8
                                                      : 4, // Add elevation based on hover state
                                                  color: isHovered
                                                      ? const Color.fromARGB(
                                                          255, 239, 241, 242)
                                                      : Colors
                                                          .white, // Change color based on hover state
                                                  child: MouseRegion(
                                                    onEnter: (event) {
                                                      setState(() {
                                                        isHovered = true;
                                                      });
                                                    },
                                                    onExit: (event) {
                                                      setState(() {
                                                        isHovered = false;
                                                      });
                                                    },
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: ListTile(
                                                        title: isFileUploaded1 &&
                                                                pickedFileName !=
                                                                    null
                                                            ? Text(
                                                                pickedFileName!,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              )
                                                            : Text(
                                                                'Policy Copy',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                        // ListTile(
                                                        //   title: Text(
                                                        //     'Policy Copy',
                                                        //     style: GoogleFonts
                                                        //         .poppins(
                                                        //       fontSize: 14,
                                                        //       // fontWeight: FontWeight.bold
                                                        //     ),
                                                        //   ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .remove_red_eye),
                                                              onPressed: () {},
                                                            ),
                                                            SizedBox(width: 10),
                                                            IconButton(
                                                              onPressed: () {
                                                                isFileUploaded1 =
                                                                    false;
                                                              },
                                                              icon: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 20),
                                      child: Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 300),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "PPT",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons
                                                    .drive_folder_upload_rounded,
                                                color: textfeildStatus
                                                    ? SecureRiskColours
                                                        .Button_Color
                                                    : Colors.black38,
                                                size: 40,
                                              ),

                                              onPressed: textfeildStatus
                                                  ? () {
                                                      pickFile2();
                                                    }
                                                  : null, // Conditionally set the onPressed callback
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (pptCopyPath != null)
                                      Visibility(
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Container(
                                                width: cardWidth,
                                                child: Card(
                                                  elevation: isHovered
                                                      ? 8
                                                      : 4, // Add elevation based on hover state
                                                  color: isHovered
                                                      ? const Color.fromARGB(
                                                          255, 239, 241, 242)
                                                      : Colors
                                                          .white, // Change color based on hover state
                                                  child: MouseRegion(
                                                    onEnter: (event) {
                                                      setState(() {
                                                        isHovered = true;
                                                      });
                                                    },
                                                    onExit: (event) {
                                                      setState(() {
                                                        isHovered = false;
                                                      });
                                                    },
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: ListTile(
                                                        title: pptCopyPath !=
                                                                null
                                                            ? Text(
                                                                pptFileName!,
                                                                //  "Mandate Letter",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              )
                                                            : Text(
                                                                'PPT',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                        // child: ListTile(
                                                        //   title: Text(
                                                        //     'PPT',
                                                        //     style: GoogleFonts
                                                        //         .poppins(
                                                        //       fontSize: 14,
                                                        //       // fontWeight: FontWeight.bold
                                                        //     ),
                                                        //   ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .remove_red_eye),
                                                              onPressed: () {},
                                                            ),
                                                            SizedBox(width: 10),
                                                            IconButton(
                                                              onPressed: () {
                                                                isFileUploaded2 =
                                                                    false;
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
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
                                    if (isFileUploaded2)
                                      Visibility(
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Container(
                                                width: cardWidth,
                                                child: Card(
                                                  elevation: isHovered
                                                      ? 8
                                                      : 4, // Add elevation based on hover state
                                                  color: isHovered
                                                      ? const Color.fromARGB(
                                                          255, 239, 241, 242)
                                                      : Colors
                                                          .white, // Change color based on hover state
                                                  child: MouseRegion(
                                                    onEnter: (event) {
                                                      setState(() {
                                                        isHovered = true;
                                                      });
                                                    },
                                                    onExit: (event) {
                                                      setState(() {
                                                        isHovered = false;
                                                      });
                                                    },
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: ListTile(
                                                        title: isFileUploaded1 &&
                                                                pickedFileName2 !=
                                                                    null
                                                            ? Text(
                                                                pickedFileName2!,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              )
                                                            : Text(
                                                                'PPT',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                        // child: ListTile(
                                                        //   title: Text(
                                                        //     'PPT',
                                                        //     style: GoogleFonts
                                                        //         .poppins(
                                                        //       fontSize: 14,
                                                        //       // fontWeight: FontWeight.bold
                                                        //     ),
                                                        //   ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .remove_red_eye),
                                                              onPressed: () {},
                                                            ),
                                                            SizedBox(width: 10),
                                                            IconButton(
                                                              onPressed: () {
                                                                isFileUploaded2 =
                                                                    false;
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
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
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 400),
                                  child: ElevatedButton(
                                    // onPressed: () {
                                    //   if (formKey.currentState!.validate()) {
                                    //     // If the form is valid, proceed with your submission logic
                                    //     createClientPolicy("pdf");
                                    //   }
                                    // },
                                    onPressed: () {
                                      setState(() {
                                        // Toggle button text
                                        buttonText = buttonText == "Edit"
                                            ? "Update/Save"
                                            : "Edit";
                                        textfeildStatus = true;
                                        isIgnoredropDown = false;
                                        // Only call createClientPolicy when button text is "Update/Save"
                                        if (buttonText == "Edit") {
                                          createClientPolicy("pdf");
                                        }
                                      });
                                    },
                                    child: Text(
                                      buttonText,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      backgroundColor:
                                          SecureRiskColours.Button_Color,
                                      minimumSize: Size(140, 45),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: screenHeight * 0.9,
                          child: VerticalDivider(
                            color: Color.fromARGB(255, 82, 81, 81),
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: isGHI ? bottomMargin : 280),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppBar(
                                      toolbarHeight: 40,
                                      backgroundColor:
                                          SecureRiskColours.Table_Heading_Color,
                                      automaticallyImplyLeading: false,
                                      title: Text(
                                        "Policy Presentation",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      elevation: 5,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 10),
                                      child: Text("Insurance Broker",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  25, 26, 25, 1))),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 10),
                                      child: SizedBox(
                                        height: insuranceBrockerError == null ||
                                                insuranceBrockerError!.isEmpty
                                            ? 40.0
                                            : 65.0,
                                        width: screenWidth * 0.23,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Material(
                                            shadowColor: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            child: TextFormField(
                                              enabled: textfeildStatus,
                                              controller:
                                                  insuranceBrokerController,
                                              decoration: InputDecoration(
                                                hintText: 'Insurance Broker',
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 13),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(3),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 151, 16, 16),
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                setState(() {
                                                  insuranceBrockerError =
                                                      validateString(value);
                                                });
                                                return insuranceBrockerError;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10.0, left: 10),
                                      child: Text("Insurance Company",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  25, 26, 25, 1))),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 8.0, left: 10),
                                      child: SizedBox(
                                        height: insuranceCompanyError == null ||
                                                insuranceCompanyError!.isEmpty
                                            ? 40.0
                                            : 65.0,
                                        width: screenWidth * 0.23,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: Material(
                                            shadowColor: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            child: TextFormField(
                                              enabled: textfeildStatus,
                                              controller: insuranceCompany,
                                              decoration: InputDecoration(
                                                hintText: 'Insurance Company',
                                                hintStyle: GoogleFonts.poppins(
                                                    fontSize: 13),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(3),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                setState(() {
                                                  insuranceCompanyError =
                                                      validateString(value);
                                                });
                                                return insuranceCompanyError;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    if (widget.productIdvar == "1001")
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align children to the start of the cross axis (left)
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8.0, left: 10),
                                            child: Text("Name Of TPA",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        25, 26, 25, 1))),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, left: 10, bottom: 8),
                                            child: SizedBox(
                                              height: nameOfTPAError == null ||
                                                      nameOfTPAError!.isEmpty
                                                  ? 40.0
                                                  : 65.0, // Adjust as necessary
                                              width: screenWidth * 0.23,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 2),
                                                child: Material(
                                                  shadowColor: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  child: TextFormField(
                                                    enabled: textfeildStatus,
                                                    controller:
                                                        nameOfTPAcontroller, // Define this controller
                                                    decoration: InputDecoration(
                                                      hintText: 'Name Of TPA',
                                                      hintStyle:
                                                          GoogleFonts.poppins(
                                                              fontSize: 13),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    3)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      setState(() {
                                                        nameOfTPAError =
                                                            validateString(
                                                                value);
                                                      });
                                                      return nameOfTPAError;
                                                    },
                                                    // Add any validators or input formatters as needed
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Row(children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0, left: 10),
                                        child: Text("Inception Premium",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    25, 26, 25, 1))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0, left: 50),
                                        child: Text("Till Date Premium",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    25, 26, 25, 1))),
                                      ),
                                    ]),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: SizedBox(
                                            height:
                                                inceptionPremiumError == null ||
                                                        inceptionPremiumError!
                                                            .isEmpty
                                                    ? 40.0
                                                    : 65.0,
                                            width: screenWidth * 0.11,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 2),
                                              child: Material(
                                                shadowColor: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                child: TextFormField(
                                                  focusNode:
                                                      inceptionPremiumFocusNode,
                                                  enabled: textfeildStatus,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly // Allow only numeric input
                                                  ],
                                                  onChanged: (_) =>
                                                      clearValidationErrors(),
                                                  controller:
                                                      inceptionPremiumController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Inception Premium',
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                            fontSize: 13),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(3),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    setState(() {
                                                      inceptionPremiumError =
                                                          validateString(value);
                                                    });
                                                    return inceptionPremiumError;
                                                  },
                                                  onFieldSubmitted: (value) {
                                                    // When user finishes editing, the value is transferred to tillDatePremiumController
                                                    tillDatePremium.text =
                                                        value;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: SizedBox(
                                            height:
                                                tillDatePremiumError == null ||
                                                        tillDatePremiumError!
                                                            .isEmpty
                                                    ? 40.0
                                                    : 65.0,
                                            width: screenWidth * 0.11,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 2),
                                              child: Material(
                                                shadowColor: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                child: TextFormField(
                                                  enabled: false,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly // Allow only numeric input
                                                  ],
                                                  controller: tillDatePremium,
                                                  onChanged: (_) =>
                                                      clearValidationErrors(),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Till Date Premium',
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                            fontSize: 13),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(3),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    setState(() {
                                                      tillDatePremiumError =
                                                          validateString(value);
                                                    });
                                                    return tillDatePremiumError;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (widget.productIdvar == "1001")
                                      Scrollbar(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0, left: 10),
                                                  child: Text(
                                                      "Family Definition",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xFF191A19))),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0, left: 70),
                                                  child: Text("Sum Insured",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      25,
                                                                      26,
                                                                      25,
                                                                      1))),
                                                ),
                                              ]),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              for (int i = 0;
                                                  i < fieldCount;
                                                  i++)
                                                Column(
                                                    children: List.generate(
                                                        rows.length, (index) {
                                                  return Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        height: 40,
                                                        width:
                                                            screenWidth * 0.11,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                            color:
                                                                Color.fromRGBO(
                                                                    113,
                                                                    114,
                                                                    111,
                                                                    1),
                                                          ),
                                                          color: SecureRiskColours
                                                              .table_Text_Color,
                                                        ),
                                                        child: IgnorePointer(
                                                          ignoring:
                                                              isIgnoredropDown,
                                                          child: DropdownButton<
                                                              String>(
                                                            isExpanded: true,
                                                            underline:
                                                                Container(),
                                                            // value:
                                                            //     selectedValue,
                                                            value: rows[index]
                                                                .selectedDropdownValue,
                                                            hint: Text(
                                                                '  Select '),
                                                            items: _options.map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              // Update the state to reflect the new selected value
                                                              // setState(() {
                                                              //   selectedValue =
                                                              //       value;
                                                              // });
                                                              setState(() {
                                                                rows[index]
                                                                        .selectedDropdownValue =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8.0,
                                                                left: 10),
                                                        child: SizedBox(
                                                          height: sumInsuredError ==
                                                                      null ||
                                                                  sumInsuredError!
                                                                      .isEmpty
                                                              ? 40.0
                                                              : 65.0,
                                                          width: screenWidth *
                                                              0.11,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 2),
                                                            child: Material(
                                                              shadowColor:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              3)),
                                                              child:
                                                                  TextFormField(
                                                                enabled:
                                                                    textfeildStatus,
                                                                controller: rows[
                                                                        index]
                                                                    .sumInsuredController,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly // Allow only numeric input
                                                                ],
                                                                // controller:
                                                                //     sumInsuredcontroller,
                                                                onChanged: (_) =>
                                                                    clearValidationErrors(),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Sum Insured',
                                                                  hintStyle: GoogleFonts
                                                                      .poppins(
                                                                          fontSize:
                                                                              13),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              3),
                                                                    ),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                validator:
                                                                    (value) {
                                                                  setState(() {
                                                                    sumInsuredError =
                                                                        validateString(
                                                                            value);
                                                                  });
                                                                  return sumInsuredError;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      if (textfeildStatus)
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (rows[index]
                                                                  .isAddButton) {
                                                                // If it's an add button, add a new row and set the current row to a delete state
                                                                rows[index]
                                                                        .isAddButton =
                                                                    false;
                                                                rows.add(
                                                                    RowData());
                                                              } else {
                                                                // If it's a delete button, remove the current row
                                                                rows.removeAt(
                                                                    index);
                                                              }
                                                            });
                                                          },
                                                          child: Text(
                                                            rows[index]
                                                                    .isAddButton
                                                                ? "+"
                                                                : "-",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                SecureRiskColours
                                                                    .Button_Color,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                })),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

// class RowData {
//   String? selectedDropdownValue;
//   bool isAddButton;

//   RowData({this.selectedDropdownValue, this.isAddButton = true});
// }
class RowData {
  String? selectedDropdownValue;
  TextEditingController sumInsuredController;
  bool isAddButton;

  RowData({
    this.selectedDropdownValue,
    String? sumInsured,
    this.isAddButton = true,
  }) : sumInsuredController = TextEditingController(text: sumInsured);
}
