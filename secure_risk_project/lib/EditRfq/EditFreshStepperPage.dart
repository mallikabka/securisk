import 'dart:convert';
import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/EditCorporate.dart';
import 'package:loginapp/EditRfq/EditCover.dart';
import 'package:loginapp/EditRfq/EditPolicy.dart';
import 'package:loginapp/EditRfq/EditRestCoverages.dart';
import 'package:loginapp/SideBarComponents/AppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Service.dart';
import 'EditSendRfq.dart';

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

final TextEditingController TpaContactName = TextEditingController();

final TextEditingController TpaEmail = TextEditingController();

final TextEditingController TpaPhoneNumber = TextEditingController();
final TextEditingController EditFreshNatureofBussiness =
    TextEditingController();

class EditFreshStepperPage extends StatefulWidget {
  final String rfid;
  final dynamic productId;
  final dynamic responseProdCategoryId;
  final dynamic policyType;

  EditFreshStepperPage(
      {Key? key,
      required this.rfid,
      required this.productId,
      required this.policyType,
      required this.responseProdCategoryId})
      : super(key: key);

  @override
  State<EditFreshStepperPage> createState() => _RenewalPageState();
}

class _RenewalPageState extends State<EditFreshStepperPage> {
  bool isCardVisible = true;
  bool active = false;
  String exTitle = "User Details";
  int currentStep = 0;
  late int? localStorageProdCategoryId;

  // late int? localStorageproductId;
  String? productCategoryId;
  GlobalKey<EditCorporateDetailsState> step1Key =
      GlobalKey<EditCorporateDetailsState>();

  GlobalKey<EditCoverState> step2_1Key = GlobalKey<EditCoverState>();
  GlobalKey<EditRestCoverageDetailsState> step2_2Key =
      GlobalKey<EditRestCoverageDetailsState>();

  get rfid => widget.rfid;

  void onStepBack() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  Future<void> getCorporateDetails() async {
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
        localStorageProdCategoryId =
            jsonData["corporateDetails"]['prodCategoryId'];
        // localStorageproductId = jsonData["corporateDetails"]['productId'];
        NameOftheInsurer.text = jsonData["corporateDetails"]['insuredName'];
        Address.text = jsonData["corporateDetails"]['address'];
        ContactName.text = jsonData["corporateDetails"]['contactName'];
        EmailId.text = jsonData["corporateDetails"]['email'];
        PhoneNumber.text = jsonData["corporateDetails"]['phNo'];
        EditFreshNatureofBussiness.text = jsonData["corporateDetails"]['nob'];
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

  void _loadProductId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedProductId = prefs.getString('EditprodCategoryId');
    setState(() {
      productCategoryId = storedProductId;
    });
  }

  @override
  void initState() {
    super.initState();
    getCorporateDetails();
    _loadProductId();
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
        content: EditCorporateDetails(rfid: rfid, key: step1Key),
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
            ? EditCover(
                rfId: rfid, key: step2_1Key, coverageDetailsKey: step2_1Key)
            : EditRestCoverageDetails(
                rfid: rfid, key: step2_2Key, coverageDetails1Key: step2_2Key),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text(
          "Policy Terms",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: EditPolicyTerms(rfid: rfid),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: Text(
          "Send RFQ",
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
            responseProdCategoryId: widget.responseProdCategoryId),
      ),
    ];
  }

  bool validateCorporateDetails() {
    bool isValid = step1Key.currentState?.validateDetails() ?? false;
    return isValid;
  }

  bool validateCoverageDetails() {
    bool isValid =
        step2_1Key.currentState?.validateEditCoverageDetails() ?? false;

    return isValid;
  }

  bool validateEditRestCoverageDetails() {
    bool isValid =
        step2_2Key.currentState?.validateEditRestCoverageDetails() ?? false;

    return isValid;
  }

  final List<Item> _data = [
    Item(
        headerValue: 'Employee Dependent Details',
        expandedValue: 'This is item number 0')
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
                                          EditFreshNatureofBussiness.text,
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
                      canvasColor: Colors.white,
                    ),
                    child: Scaffold(
                      body: Container(
                        color: Colors.white,
                        child: Stepper(
                          type: StepperType.horizontal,
                          currentStep: currentStep,
                          // onStepTapped: (step) {
                          //   setState(() {
                          //     currentStep = step;
                          //   });
                          // },
                          onStepContinue: () async {
                            bool isLastStep =
                                (currentStep == getSteps().length - 1);
                            if (currentStep == 0) {
                              if (!validateCorporateDetails()) {
                                return;
                              }
                            } else if (currentStep == 1 &&
                                widget.productId == 1001) {
                              if (!validateCoverageDetails()) {
                                return;
                              }
                            } else if (currentStep == 1 &&
                                widget.productId != 1001) {
                              if (!validateEditRestCoverageDetails()) {
                                return;
                              }
                            }
                            if (isLastStep) {
                              return;
                            } else {
                              setState(() {
                                if (currentStep == 0) {
                                  EditCorporateDetails editCorporateDetails =
                                      new EditCorporateDetails(rfid: rfid);
                                  editCorporateDetails
                                      .updateCorporateDetails(context);
                                } else if (currentStep == 1) {
                                  if (widget.productId == 1001) {
                                    EditCover editCover =
                                        new EditCover(rfId: rfid);
                                    editCover.updateCoverageDetails(context);
                                  } else {
                                    EditRestCoverageDetails
                                        editRestCoverageDetails =
                                        new EditRestCoverageDetails(rfid: rfid);
                                    editRestCoverageDetails
                                        .updateCoverge(context);
                                  }
                                } else if (currentStep == 2) {
                                  EditPolicyTerms editPolicyTerms =
                                      EditPolicyTerms(rfid: rfid);
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
                          controlsBuilder:
                              (BuildContext context, ControlsDetails details) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                if (currentStep != 0 && currentStep != 3)
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      color:
                                          SecureRiskColours.Back_Button_Color,
                                      child: TextButton(
                                        onPressed: details.onStepCancel,
                                        child: Text(
                                          'BACK',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (currentStep != 3)
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      color: SecureRiskColours.Button_Color,
                                      child: TextButton(
                                        onPressed: details.onStepContinue,
                                        child: Text(
                                          'NEXT',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
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
