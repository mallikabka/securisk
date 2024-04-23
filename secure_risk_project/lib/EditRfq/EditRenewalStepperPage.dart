import 'dart:convert';
import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/EditCover.dart';
import 'package:loginapp/EditRfq/RenewalEditCover.dart';
import 'package:loginapp/EditRfq/RenewalEditRestCoverages.dart';
import 'package:loginapp/SideBarComponents/AppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service.dart';
import 'EditSendRfq.dart';
import 'RenewalEditClaimsDetails.dart';
import 'RenewalEditCorporate.dart';
import 'RenewalEditCoverage.dart';
import 'RenewalEditExpiryDetails.dart';
import 'RenewalEditPolicyTerms.dart';

final TextEditingController NameOftheInsurer = TextEditingController();

final TextEditingController Address = TextEditingController();

final TextEditingController EmailId = TextEditingController();
final TextEditingController policyType = TextEditingController();

final TextEditingController PhoneNumber = TextEditingController();

final TextEditingController NameOfTheIntermediary = TextEditingController();

final TextEditingController IntermediateEmailId = TextEditingController();

final TextEditingController IntermediateContactName = TextEditingController();

final TextEditingController ContactName = TextEditingController();

final TextEditingController IntermediatePhoneNumber = TextEditingController();

// final TextEditingController nameOfTheTpa = TextEditingController();

final TextEditingController TpaContactName = TextEditingController();

final TextEditingController TpaEmail = TextEditingController();

final TextEditingController TpaPhoneNumber = TextEditingController();
final TextEditingController EditNatureofBussiness = TextEditingController();

final TextEditingController membersNoInceptionForDependents =
    TextEditingController();
final TextEditingController additionsForDependents = TextEditingController();
final TextEditingController deletionsForDependents = TextEditingController();
final TextEditingController totalMembersForDependents = TextEditingController();

class EditRenewalStepperPage extends StatefulWidget {
  final String rfid;
  final dynamic productId;
  final dynamic policyType;
  final dynamic responseProdCategoryId;
  EditRenewalStepperPage(
      {super.key,
      required this.rfid,
      required this.productId,
      required this.policyType,
      required this.responseProdCategoryId});

  @override
  State<EditRenewalStepperPage> createState() => _EditRenewalStepperPageState();
}

// late int? localStorageProdCategoryId;

class _EditRenewalStepperPageState extends State<EditRenewalStepperPage> {
  int? productId;
  int currentStep = 0;
  GlobalKey<RenewalEditCoverState> step2_1Key =
      GlobalKey<RenewalEditCoverState>();
  GlobalKey<EditClaimsDetailsState> step4Key =
      GlobalKey<EditClaimsDetailsState>();
  GlobalKey<RenewalEditExpiryDetailsState> step3Key =
      GlobalKey<RenewalEditExpiryDetailsState>();
  GlobalKey<RenewalEditRestCoverageDetailsState> step2_2Key =
      GlobalKey<RenewalEditRestCoverageDetailsState>();

  bool validateClaimsDetails() {
    bool isValid = step4Key.currentState?.validateClaimsDetails() ?? false;
    return isValid;
  }

  bool validateEditExpiryDetails() {
    bool isValid = step3Key.currentState?.validateExpiryDetails() ?? false;
    return isValid;
  }

  bool validateEditCoverageDetails() {
    bool isValid =
        step2_1Key.currentState?.validateEditCoverageDetails() ?? false;
    return isValid;
  }

  bool validateRestEditCoverageDetails() {
    bool isValid =
        step2_2Key.currentState?.validateRenewalEditRestCoverageDetails() ??
            false;
    return isValid;
  }

  GlobalKey<RenewalEditCorporateDetailsState> step1_1Key =
      GlobalKey<RenewalEditCorporateDetailsState>();

  bool validateEditCorporateDetails() {
    bool isValid =
        step1_1Key.currentState?.validateEditCorporateDetails() ?? false;

    return isValid;
  }

  get rfid => widget.rfid;
  void onStepBack() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  void _loadProductId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedProductId = prefs.getInt('productId');

    setState(() {
      productId = storedProductId;
    });
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: Text(
          "Corporate Details",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: RenewalEditCorporateDetails(
            rfid: rfid,
            key: step1_1Key,
            productId: widget.productId,
            responseProdCategoryId: widget.responseProdCategoryId),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: Text(
          "Coverage Details",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: widget.productId == 1001
            ? RenewalEditCover(
                rfId: rfid,
                key: step2_1Key,
                renewalcoverageDetailsKey: step2_1Key,
              )
            // RenewalEditRestCoverageDetails(
            //     rfid: rfid,
            //     coverageDetails1Key: step2_2Key,
            //     key: step2_2Key,
            //   ):RenewalEditRestCoverageDetails
            : RenewalEditRestCoverageDetails(
                rfid: rfid,
                coverageDetails1Key: step2_2Key,
                key: step2_2Key,
              ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text(
          "Expiry Details",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: RenewalEditExpiryDetails(
            rfid: rfid,
            key: step3Key,
            productId: widget.productId,
            responseProdCategoryId: widget.responseProdCategoryId),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: Text(
          "Claims Details",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: RenewalEditClaimsDetails(
          rfid: rfid,
          key: step4Key,
        ),
      ),
      Step(
        state: currentStep > 4 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 4,
        title: Text(
          "Policy Terms",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: RenewalEditPolicyTermsDetails(rfid: rfid),
      ),
      Step(
        state: currentStep > 5 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 5,
        title: Text(
          "Send Rfq",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        // content: EditSendForm(rfid: rfid),
        content: EditSendForm(
          rfid: rfid,
          productId: widget.productId,
          policyType: widget.policyType,
          responseProdCategoryId: widget.responseProdCategoryId,
        ),
      ),
    ];
  }

  Future<void> getByIdCorporateDetails() async {
    String rfid = widget.rfid;
    var headers = await ApiServices.getHeaders();
    Response response = await http.get(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.EditCorporate_Details_EndPoint +
          rfid),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);

      setState(() {
        // localStorageProdCategoryId =
        //     jsonData["corporateDetails"]['prodCategoryId'];
        NameOftheInsurer.text = jsonData["corporateDetails"]['insuredName'];
        Address.text = jsonData["corporateDetails"]['address'];
        ContactName.text = jsonData["corporateDetails"]['contactName'];
        EmailId.text = jsonData["corporateDetails"]['email'];
        policyType.text = jsonData["corporateDetails"]['policyType'];
        PhoneNumber.text = jsonData["corporateDetails"]['phNo'];
        EditNatureofBussiness.text = jsonData["corporateDetails"]['nob'];

        IntermediateEmailId.text =
            jsonData["corporateDetails"]['intermediaryEmail'];
        IntermediateContactName.text =
            jsonData["corporateDetails"]['intermediaryContactName'];
        NameOfTheIntermediary.text =
            jsonData["corporateDetails"]['intermediaryName'];
        IntermediatePhoneNumber.text =
            jsonData["corporateDetails"]['intermediaryPhNo'];
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getByIdCorporateDetails();
    _loadProductId();
  }

  final List<Item> _data = [
    Item(
        headerValue: 'Employee Dependent Details',
        expandedValue: 'This is item number 0')
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context as BuildContext).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBarExample(),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Container(
              // color: Colors.white,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                border: Border.all(
                  color: SecureRiskColours
                      .Table_Heading_Color, // Set your desired border color
                  width: 1.0, // Set your desired border width
                ),
              ),
              child: ExpansionPanelList(
                elevation: 4,
                expandedHeaderPadding: EdgeInsets.all(5.0),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        height: 60.0, // Set the height as needed
                        child: ListTile(
                          title: Text(
                            _data[0].headerValue,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    body: Column(
                      children: [
                        BootstrapRow(children: [
                          BootstrapCol(
                            lg: 6,
                            xl: 6,
                            md: 6,
                            xs: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(2), // Column for labels
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(2),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          "Insured Name:",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(":"),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          NameOftheInsurer.text,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Text(
                                        "Address:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(":"),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          Address.text,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                          "Nature Of Bussiness:",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(":"),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                          EditNatureofBussiness.text,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Text(
                                        "Contact Name:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(":"),
                                      Text(
                                        ContactName.text,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                          "Email Id:",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(":"),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                          EmailId.text,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Text(
                                        "Mobile Number:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(":"),
                                      Text(
                                        PhoneNumber.text,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BootstrapCol(
                            lg: 1,
                            xl: 1,
                            md: 1,
                            xs: 0,
                            child: Container(
                              height: screenHeight * 0.22,
                              child: VerticalDivider(
                                color: Color.fromARGB(255, 82, 81, 81),
                                thickness: 1,
                              ),
                            ),
                          ),
                          BootstrapCol(
                            lg: 5,
                            xl: 5,
                            md: 5,
                            xs: 0,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 20),
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(2), // Column for labels
                                  1: FlexColumnWidth(0.5),
                                  2: FlexColumnWidth(1), // Column for values
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          "Intermediary Name:",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(":"),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          NameOfTheIntermediary.text,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Text(
                                        "Contact Name:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(":"),
                                      Text(
                                        IntermediateContactName.text,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                          "Email Id:",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(":"),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                          IntermediateEmailId.text,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Text(
                                        "Mobile Number:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(":"),
                                      Text(
                                        IntermediatePhoneNumber.text,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                      ],
                    ),
                    isExpanded: _data[0].isExpanded,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                color: Colors.white,
                width: screenWidth * 0.9,
                child: Material(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: SecureRiskColours.Table_Heading_Color,
                      width: 1,
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor:
                          Colors.white, // Set the canvas color to transparent
                    ),
                    child: Scaffold(
                      body: Container(
                        color: Colors.white,
                        child: Stepper(
                            type: StepperType
                                .horizontal, // Set the type to horizontal
                            currentStep: currentStep,
                            onStepTapped: (step) {
                              setState(() {
                                currentStep = step;
                              });
                            },
                            onStepContinue: () async {
                              bool isLastStep =
                                  (currentStep == getSteps().length - 1);
                              if (currentStep == 1 &&
                                  widget.productId == 1001) {
                                if (!validateEditCoverageDetails()) {
                                  return;
                                }
                              } else if (currentStep == 1 &&
                                  widget.productId != 1001) {
                                if (!validateRestEditCoverageDetails()) {
                                  return;
                                }
                              }
                              if (currentStep == 2) {
                                if (!validateEditExpiryDetails()) {
                                  return;
                                }
                              } else if (currentStep == 3) {
                                if (!validateClaimsDetails()) {
                                  return;
                                }
                              }
                              if (currentStep == 0) {
                                if (!validateEditCorporateDetails()) {
                                  return;
                                }
                              }

                              if (isLastStep) {
                                return;
                              } else {
                                setState(() {
                                  if (currentStep == 0) {
                                    RenewalEditCorporateDetails
                                        renewalCorporateDetails =
                                        new RenewalEditCorporateDetails(
                                            rfid: rfid,
                                            productId: widget.productId,
                                            responseProdCategoryId:
                                                widget.responseProdCategoryId);
                                    renewalCorporateDetails
                                        .updateRenewalCorporateDetails();
                                  } else if (currentStep == 1) {
                                    if (widget.productId == 1001) {
                                      RenewalEditCover editCoverageDetails =
                                          new RenewalEditCover(
                                        rfId: rfid,
                                      );
                                      editCoverageDetails
                                          .updateCoverageDetails(context);
                                    } else {
                                      RenewalEditRestCoverageDetails
                                          editRestCoverageDetails =
                                          new RenewalEditRestCoverageDetails(
                                              rfid: rfid);
                                      editRestCoverageDetails
                                          .updateCoverageDetails(context);
                                    }
                                  } else if (currentStep == 2) {
                                    ('eshwar2222');
                                    RenewalEditExpiryDetails
                                        renewalEditExpiryDetails =
                                        new RenewalEditExpiryDetails(
                                      rfid: rfid,
                                      productId: widget.productId,
                                      responseProdCategoryId:
                                          widget.responseProdCategoryId,
                                    );
                                    renewalEditExpiryDetails
                                        .updateRenewalExpiryeDetails(context);
                                  } else if (currentStep == 3) {
                                    RenewalEditClaimsDetails
                                        renewalEditClaimsDetails =
                                        new RenewalEditClaimsDetails(
                                            rfid: rfid);
                                    renewalEditClaimsDetails
                                        .updateRenewalClaimsDetails(context);
                                  } else if (currentStep == 4) {
                                    RenewalEditPolicyTermsDetails
                                        editPolicyTerms =
                                        RenewalEditPolicyTermsDetails(
                                            rfid: rfid);
                                    editPolicyTerms.sendDataToApi(context);
                                  }

                                  currentStep += 1;
                                });
                              }
                            },
                            onStepCancel: () {
                              setState(() {
                                if (currentStep > 0) {
                                  currentStep--;
                                }
                              });
                            },
                            steps: getSteps(),
                            controlsBuilder: (BuildContext context,
                                ControlsDetails details) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  if (currentStep != 0 &&
                                      currentStep !=
                                          5) // Skip on the first step
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        color: SecureRiskColours
                                            .Back_Button_Color, // Set your desired background color for "BACK" button
                                        child: TextButton(
                                          onPressed: details.onStepCancel,
                                          child: Text(
                                            'BACK',
                                            style: GoogleFonts.poppins(
                                                color: Colors
                                                    .white), // Set the text color for "BACK" button
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (currentStep != 5) // Skip on the last step
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        color: SecureRiskColours
                                            .Button_Color, // Set your desired background color for "NEXT" button
                                        child: TextButton(
                                          onPressed: details.onStepContinue,
                                          child: Text(
                                            'NEXT',
                                            style: GoogleFonts.poppins(
                                                color: Colors
                                                    .white), // Set the text color for "NEXT" button
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }),
                      ),
                    ),
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

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
