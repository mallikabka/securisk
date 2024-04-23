import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/FreshPolicyFields/CorporateDetails.dart';
import 'package:loginapp/FreshPolicyFields/CoverageDetails.dart';
import 'package:loginapp/FreshPolicyFields/PolicyTerms.dart';
import 'package:loginapp/FreshPolicyFields/SendRFQ.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FreshPolicyFields/NonEbCoverage.dart';

class HorizontalStepperExampleApp extends StatefulWidget {
  final GlobalKey<CorporateDetailsState> step1Key;
  final dynamic productId;
  const HorizontalStepperExampleApp(
      {super.key, required this.step1Key, required this.productId});
  @override
  HorizontalStepperExampleAppState createState() =>
      HorizontalStepperExampleAppState();
}

class HorizontalStepperExampleAppState
    extends State<HorizontalStepperExampleApp> {
  GlobalKey<CoverageDetailsState> step2Key = GlobalKey<CoverageDetailsState>();
  GlobalKey<PolicyTermsState> step3Key = GlobalKey<PolicyTermsState>();
  GlobalKey<CoverageDetailsState1> step2_2Key =
      GlobalKey<CoverageDetailsState1>();
  String corporateDetailsErrorMessage = '';
  String coverageDetailsErrorMessage = '';
  String policyTermsErrorMessage = '';
  int? productId;

  bool validateCorporateDetails() {
    bool isValid = widget.step1Key.currentState?.validateDetails() ?? false;
    return isValid;
  }

  bool validateCoverageDetails() {
    bool isValid = step2Key.currentState?.validateCoverageDetails() ?? false;
    return isValid;
  }

  bool validateDemoCoverageDetails() {
    bool isValid =
        step2_2Key.currentState?.validateDemoCoverageDetails() ?? false;

    return isValid;
  }

  bool validatePolicyTerms() {
    return true;
  }

  int currentStep = 0;
  void onStepBack() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  Future<Widget> getCoverageContent() async {
    final prefs = await SharedPreferences.getInstance();
    final LocalStorageProdId = prefs.getInt('productId');

    if (LocalStorageProdId == 1001) {
      return CoverageDetails(
        key: step2Key,
        coverageDetailsKey: step2Key,
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
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        content: CorporateDetails(key: widget.step1Key),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: FittedBox(
          child: Text(
            "Coverage Details",
            style: GoogleFonts.poppins(
              color: Colors.black,
              // backgroundColor: SecureRiskColours.Table_Heading_Color,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        content: FutureBuilder(
          future: getCoverageContent(),
          builder: (context, snapshot) {
            return snapshot.data ?? SizedBox.shrink();
          },
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: FittedBox(
          child: Text(
            "Policy Terms",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        content: PolicyTerms(key: step3Key),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: FittedBox(
          child: Text(
            "Send RFQ",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        content: SendForm(productId: widget.productId),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        width: MediaQuery.of(context).size.width * 10.0,
        //color: Colors.black,
        child: Material(
          color: Colors.white, // Set the Material color to transparent
          elevation: 0,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              // Set the canvas color to transparent
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
                  if (!validatePolicyTerms()) {
                    return;
                  }
                }

                if (isLastStep) {
                  return;
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                  // Perform asynchronous work outside setState
                  Future<void> asyncWork() async {
                    if (currentStep == 0) {
                      ("0");
                    } else if (currentStep == 1) {
                      CorporateDetails corporateDetails = CorporateDetails(
                        key: widget.step1Key,
                      );
                      await corporateDetails.saveCorporateDetails(context);
                    } else if (currentStep == 2) {
                      final prefs = await SharedPreferences.getInstance();
                      final LocalStorageProdId = prefs.getInt('productId');
                      if (LocalStorageProdId == 1001) {
                        CoverageDetails coverageDetails = CoverageDetails(
                          key: step2Key,
                        );
                        await coverageDetails.createCoverageDetails(context);
                      } else {
                        // Call a different method for a different product
                        CoverageDetails1 coverageDetails1 = CoverageDetails1(
                          key: step2_2Key,
                        );
                        await coverageDetails1.createCoverageDetails1(
                            context); // Call a different method here
                      }
                    } else if (currentStep == 3) {
                      PolicyTerms policyTerms = PolicyTerms(
                        key: step3Key,
                      );
                      await policyTerms.sendDataToApi(context);
                    }
                  }

                  asyncWork(); // Call the asynchronous work function
                }
              },
              onStepTapped: (step) => setState(
                () {
                  currentStep = step;
                },
              ),
              steps: getSteps(),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (currentStep != 0 &&
                        // currentStep != 2 &&
                        currentStep != 3) // Skip on the first step
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          color: SecureRiskColours
                              .Back_Button_Color, // Set your desired background color for "BACK" button
                          child: TextButton(
                            onPressed: details.onStepCancel,
                            child: Text(
                              'BACK',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ), // Set the text color for "BACK" button
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 15,
                    ),
                    if (currentStep != 3) // Skip on the last step
                      Padding(
                        padding: EdgeInsets.all(0.0),
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
