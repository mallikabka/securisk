import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/RenewalPolicy/RenewalClaimsDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalCorporateDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalCoverageDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalExpiryDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalPolicyTerms.dart';
import 'package:loginapp/Service.dart';
import 'dart:convert';
import 'package:toastification/toastification.dart';
import '../FreshPolicyFields/SendRFQ.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FreshPolicyFields/NonEbCoverage.dart';

enum SingingCharacter { fixed1, fixed2, fixed3, lafayette, jefferson }

class RenewalStepper extends StatefulWidget {
  final dynamic productId;
  RenewalStepper({super.key, required this.productId});
  @override
  _RenewalStepperState createState() => _RenewalStepperState();
}

class _RenewalStepperState extends State<RenewalStepper> {
  GlobalKey<CoverageDetailsState1> step2_2Key =
      GlobalKey<CoverageDetailsState1>();

  GlobalKey<RenewalCorporateDetailsState> step1Key =
      GlobalKey<RenewalCorporateDetailsState>();
  GlobalKey<RenewalCoverageDetailsState> step2Key =
      GlobalKey<RenewalCoverageDetailsState>();
  GlobalKey<RenewalExpiryDetailsState> step3Key =
      GlobalKey<RenewalExpiryDetailsState>();
  GlobalKey<RenewalClaimsDetailsState> step4Key =
      GlobalKey<RenewalClaimsDetailsState>();
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;
  int? productId;
  String? policyType;

  String? SumInsureded;

  List<List<TextEditingController>> tableData = [];
  int rowCounter = 1;
  bool validateCorporateDetails() {
    (step1Key.currentState);
    bool isValid = step1Key.currentState?.validateDetails() ?? false;
    return isValid;
  }

  bool validateCoverageDetails() {
    bool isValid =
        step2Key.currentState?.validateRenewalCoverageDetails() ?? false;

    ('Hi $isValid');
    return isValid;
  }

  bool validateDemoCoverageDetails() {
    bool isValid =
        step2_2Key.currentState?.validateDemoCoverageDetails() ?? false;

    return isValid;
  }

  bool validateExpiryDetails() {
    bool isValid = step3Key.currentState?.validateExpiryDetails() ?? false;

    ("hi $isValid");
    return isValid;
  }

  bool validateClaimsDetails() {
    bool isValid = step4Key.currentState?.validateClaimsDetails() ?? false;
    ("hi $isValid");
    return isValid;
  }

  void removeRow(int index) {
    setState(() {
      tableData[index][0].clear();
      tableData[index][1].clear();
      tableData.removeAt(index);
      rowCounter--;
    });
  }

  //Policy Terms
  Future<void> sendDataToApi() async {
    try {
      Map<String, dynamic> requestData = {
        'rfqId': '9537705c-cced-4ea1-b113-ae90563e1a11',
        'policyDetails': [],
      };

      for (var data in tableData) {
        String coverageName = data[0].text;
        String remark = data[1].text;

        Map<String, String> policyDetails = {
          'coverageName': coverageName,
          'remark': remark,
        };
        requestData['policyDetails'].add(policyDetails);
      }

      String requestBody = json.encode(requestData);
      var headers = await ApiServices.getHeaders();
      final response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.createPloicyTerms_Endpoint),
        body: requestBody,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Policy Details sent successfully..',
        );
      } else {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Something went wrong..',
        );
      }
    } catch (e) {
      ('Error: $e');
    }
  }

  Future<Widget> getCoverageContent() async {
    final prefs = await SharedPreferences.getInstance();
    final LocalStorageProdId = prefs.getInt('productId');

    if (LocalStorageProdId == 1001) {
      return RenewalCoverageDetails(
        key: step2Key,
        renewalcoverageDetailsKey: step2Key,
      );
    } else {
      return CoverageDetails1(
        coverageDetails1Key: step2_2Key,
        key: step2_2Key,
      );
    }
  }

  void _loadProductId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedProductId = prefs.getInt('productId');

    setState(() {
      productId = storedProductId;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProductId();
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: FittedBox(
          child: Text(
            "Corporate Details",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        content: RenewalCorporateDetails(
            key: step1Key, renewalcoverageDetals: step2Key),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        // title:  Text("Coverage Details"),
        title: FittedBox(
          child: Text(
            "Coverage Details",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        content: FutureBuilder(
          future: getCoverageContent(),
          builder: (context, snapshot) {
            return snapshot.data ??
                SizedBox
                    .shrink(); // Use the retrieved widget or an empty SizedBox
          },
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        // title:  Text("Expiring Details"),
        title: FittedBox(
          child: Text(
            "Expiring Details",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        content: RenewalExpiryDetails(key: step3Key),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        // title:  Text("Claims Details"),
        title: FittedBox(
          child: Text(
            "Claims Details",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        content: RenewalClaimsDetails(key: step4Key),
      ),
      Step(
        state: currentStep > 4 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 4,
        // title:  Text("Policy Terms"),
        title: FittedBox(
          child: Text(
            "Policy Terms",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        content: RenewalPolicyTermsDetails(),
      ),
      Step(
        state: currentStep > 5 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 5,
        // title:  Text("Send RFQ"),
        title: FittedBox(
          child: Text(
            "Send RFQ",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        content: SendForm(
          productId: widget.productId,
        ),
      ),
    ];
  }

  void onStepBack() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Material(
          color: Colors.transparent, // Set the Material color to transparent
          elevation: 0,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white, // Set the canvas color to transparent
            ),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              onStepCancel: onStepBack,
              onStepContinue: () async {
                bool isLastStep = (currentStep == getSteps().length - 1);
                final prefs = await SharedPreferences.getInstance();
                final LocalStorageProdId = prefs.getInt('productId');
                if (currentStep == 0) {
                  if (!validateCorporateDetails()) {
                    return;
                  }
                } else if (currentStep == 1 && LocalStorageProdId == 1001) {
                  if (!validateCoverageDetails()) {
                    return;
                  }
                } else if (currentStep == 1 && LocalStorageProdId != 1001) {
                  if (!validateDemoCoverageDetails()) {
                    return;
                  }
                } else if (currentStep == 2) {
                  if (!validateExpiryDetails()) {
                    return;
                  }
                } else if (currentStep == 3) {
                  if (!validateClaimsDetails()) {
                    return;
                  }
                }
                if (isLastStep) {
                  return;
                } else {
                  setState(() {
                    currentStep += 1;
                  });

                  Future<void> asyncWork() async {
                    if (currentStep == 0) {
                      ("0");
                    } else if (currentStep == 1) {
                      RenewalCorporateDetails corporatedetails =
                          new RenewalCorporateDetails();
                      await corporatedetails.renewalsaveCorporateDetails(context);
                    } else if (currentStep == 2) {
                      final prefs = await SharedPreferences.getInstance();
                      final LocalStorageProdId = prefs.getInt('productId');
                      if (LocalStorageProdId == 1001) {
                        RenewalCoverageDetails coverageDetails =
                            RenewalCoverageDetails(
                          key: step2Key,
                        );
                        await coverageDetails
                            .createRenewalCoverageDetails(context);
                        step3Key.currentState?.getRfqId();
                      } else {
                        // Call a different method for a different product
                        CoverageDetails1 coverageDetails1 = CoverageDetails1(
                          key: step2_2Key,
                        );
                        await coverageDetails1.createCoverageDetails1(
                            context); // Call a different method here
                      }
                    } else if (currentStep == 3) {
                      RenewalExpiryDetails renewalExpiryDetails =
                          new RenewalExpiryDetails();
                      await renewalExpiryDetails.expiryDetails(context);
                      RenewalClaimsDetails renewalClaimsDetails1 =
                          new RenewalClaimsDetails();
                      await renewalClaimsDetails1.fetchClaimsFeildsData();
                    } else if (currentStep == 4) {
                      RenewalClaimsDetails renewalClaimsDetails =
                          new RenewalClaimsDetails();
                      await renewalClaimsDetails.fetchApiData(context);
                    } else if (currentStep == 5) {
                      RenewalPolicyTermsDetails renewalPolicyTermsDetails =
                          new RenewalPolicyTermsDetails();
                      await renewalPolicyTermsDetails.sendDataToApi(context);
                    }
                  }

                  asyncWork(); // Call the asynchronous work function
                }
              },
              // onStepTapped: (step) => setState(() {
              //   currentStep = step;
              // }),
              steps: getSteps(),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (currentStep != 0 &&
                       // currentStep != 4 &&
                        currentStep != 5) // Skip on the first step
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromRGBO(52, 58, 48,
                              1.0), // Set your desired background color for "BACK" button
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
