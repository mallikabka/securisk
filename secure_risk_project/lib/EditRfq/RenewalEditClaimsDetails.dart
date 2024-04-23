import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:toastification/toastification.dart';

final _formKey = GlobalKey<FormState>();

final TextEditingController claimPaidReimbursement = TextEditingController();
final TextEditingController claimPaidCashless = TextEditingController();
final TextEditingController claimOutstandingReimbursement =
    TextEditingController();
final TextEditingController claimOutstandingCashless = TextEditingController();
final TextEditingController opdClaimPaidReimbursement = TextEditingController();
final TextEditingController opdClaimPaidCashless = TextEditingController();
final TextEditingController opdClaimOutstandingReimbursement =
    TextEditingController();
final TextEditingController opdClaimOutstandingCashless =
    TextEditingController();
final TextEditingController corporateBufferClaimPaidReimbursement =
    TextEditingController();
final TextEditingController corporateBufferClaimPaidCashless =
    TextEditingController();
final TextEditingController corporateBufferClaimOutstandingReimbursement =
    TextEditingController();
final TextEditingController corporateBufferClaimOutstandingCashless =
    TextEditingController();
final TextEditingController CorporateBufferAmount = TextEditingController();
final TextEditingController perfamilylimit = TextEditingController();
final TextEditingController maxNoOfCases = TextEditingController();
final TextEditingController perFamilyMaximumSI = TextEditingController();
final TextEditingController PolicyPeriod = TextEditingController();
final TextEditingController Premiumperiod = TextEditingController();
final TextEditingController TotalSumInsured = TextEditingController();
final TextEditingController NumberOfClaims = TextEditingController();
final TextEditingController ClaimedAmont = TextEditingController();
final TextEditingController SettledAmont = TextEditingController();
final TextEditingController PendingAmont = TextEditingController();
ApiPayload? apiPayload;

class ApiPayload {
  final String rfqId;
  final String claimPaidReimbursement;
  final String claimPaidCashless;
  final String claimOutstandingReimbursement;
  final String claimOutstandingCashless;
  final String opdClaimPaidReimbursement;
  final String opdClaimPaidCashless;
  final String opdClaimOutstandingReimbursement;
  final String opdClaimOutstandingCashless;
  final String corporateBufferClaimPaidReimbursement;
  final String corporateBufferClaimPaidCashless;
  final String corporateBufferClaimOutstandingReimbursement;
  final String corporateBufferClaimOutstandingCashless;
  final String corporateBufferAmount;
  final String perFamilyLimit;
  final String maxCasesNo;
  final String maxSumInsured;
  final String policyPeriod;
  final String premiumperiod;
  final String totalSumInsured;
  final String numberOfClaims;
  final String claimedAmont;
  final String settledAmont;
  final String pendingAmont;

  ApiPayload(
      {required this.rfqId,
      required this.claimPaidReimbursement,
      required this.claimPaidCashless,
      required this.claimOutstandingReimbursement,
      required this.claimOutstandingCashless,
      required this.opdClaimPaidReimbursement,
      required this.opdClaimPaidCashless,
      required this.opdClaimOutstandingReimbursement,
      required this.opdClaimOutstandingCashless,
      required this.corporateBufferClaimPaidReimbursement,
      required this.corporateBufferClaimPaidCashless,
      required this.corporateBufferClaimOutstandingReimbursement,
      required this.corporateBufferClaimOutstandingCashless,
      required this.corporateBufferAmount,
      required this.perFamilyLimit,
      required this.maxCasesNo,
      required this.maxSumInsured,
      required this.policyPeriod,
      required this.premiumperiod,
      required this.numberOfClaims,
      required this.claimedAmont,
      required this.totalSumInsured,
      required this.settledAmont,
      required this.pendingAmont});
}

// ignore: must_be_immutable
class RenewalEditClaimsDetails extends StatefulWidget {
  late String rfid;
  RenewalEditClaimsDetails({super.key, required this.rfid});

  @override
  State<RenewalEditClaimsDetails> createState() => EditClaimsDetailsState();

  Future<void> updateRenewalClaimsDetails(BuildContext context) async {
    var body = {
      "claimPaidReimbursement": claimPaidReimbursement.text.isNotEmpty
          ? claimPaidReimbursement.text
          : "N/A",
      "claimPaidCashless":
          claimPaidCashless.text.isNotEmpty ? claimPaidCashless.text : "N/A",
      "claimOutstandingReimbursement":
          claimOutstandingReimbursement.text.isNotEmpty
              ? claimOutstandingReimbursement.text
              : "N/A",
      "claimOutstandingCashless": claimOutstandingCashless.text.isNotEmpty
          ? claimOutstandingCashless.text
          : "N/A",
      "opdClaimPaidReimbursement": opdClaimPaidReimbursement.text.isNotEmpty
          ? opdClaimPaidReimbursement.text
          : "N/A",
      "opdClaimPaidCashless": opdClaimPaidCashless.text.isNotEmpty
          ? opdClaimPaidCashless.text
          : "N/A",
      "opdClaimOutstandingReimbursement":
          opdClaimOutstandingReimbursement.text.isNotEmpty
              ? opdClaimOutstandingReimbursement.text
              : "N/A",
      "opdClaimOutstandingCashless": opdClaimOutstandingCashless.text.isNotEmpty
          ? opdClaimOutstandingCashless.text
          : "N/A",
      "corporateBufferClaimPaidReimbursement":
          corporateBufferClaimPaidReimbursement.text.isNotEmpty
              ? corporateBufferClaimPaidReimbursement.text
              : "N/A",
      "corporateBufferClaimPaidCashless":
          corporateBufferClaimPaidCashless.text.isNotEmpty
              ? corporateBufferClaimPaidCashless.text
              : "N/A",
      "corporateBufferClaimOutstandingReimbursement":
          corporateBufferClaimOutstandingReimbursement.text.isNotEmpty
              ? corporateBufferClaimOutstandingReimbursement.text
              : "N/A",
      "corporateBufferClaimOutstandingCashless":
          corporateBufferClaimOutstandingCashless.text.isNotEmpty
              ? corporateBufferClaimOutstandingCashless.text
              : "N/A",
      "corporateBufferAmount": CorporateBufferAmount.text.isNotEmpty
          ? CorporateBufferAmount.text
          : "N/A",
      "perFamilyLimit":
          perfamilylimit.text.isNotEmpty ? perfamilylimit.text : "N/A",
      "maxCasesNo": maxNoOfCases.text.isNotEmpty ? maxNoOfCases.text : "N/A",
      "maxSumInsured":
          perFamilyMaximumSI.text.isNotEmpty ? perFamilyMaximumSI.text : "N/A",
      "policyperiod": PolicyPeriod.text.isNotEmpty ? PolicyPeriod.text : "N/A",
      "premiumPaid": Premiumperiod.text.isNotEmpty ? Premiumperiod.text : "N/A",
      "claimsNo": NumberOfClaims.text.isNotEmpty ? NumberOfClaims.text : "N/A",
      "claimedAmount": ClaimedAmont.text.isNotEmpty ? ClaimedAmont.text : "N/A",
      "totalSumInsured": TotalSumInsured.text.isNotEmpty?TotalSumInsured.text:"N/A",
      "settledAmount": SettledAmont.text.isNotEmpty? SettledAmont.text:"N/A",
      "pendingAmount": PendingAmont.text.isNotEmpty?PendingAmont.text:"N/A"
    };
    var headers = await ApiServices.getHeaders();
    Response response = await http.put(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.renewal_Ghi_ClaimDetails_update +
          rfid),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ('EditClaims Details saved successfully');
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: ' update Claims Details saved successfully...!',
      );
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: ' update Claims Details failed to save...!',
      );
    }
  }

  static void renewalEditClaimsDetailsclearFileds() {
    claimPaidReimbursement.text = "";
    claimPaidCashless.text = "";
    claimOutstandingReimbursement.text = "";
    claimOutstandingCashless.text = "";
    opdClaimPaidReimbursement.text = "";
    opdClaimPaidCashless.text = "";
    opdClaimOutstandingReimbursement.text = "";
    opdClaimOutstandingCashless.text = "";
    corporateBufferClaimPaidReimbursement.text = "";
    corporateBufferClaimPaidCashless.text = "";
    corporateBufferClaimOutstandingReimbursement.text = "";
    corporateBufferClaimOutstandingCashless.text = "";
    CorporateBufferAmount.text = "";
    perfamilylimit.text = "";
    maxNoOfCases.text = "";
    perFamilyMaximumSI.text = "";
    PolicyPeriod.text = "";
    Premiumperiod.text = "";
    TotalSumInsured.text = "";
    NumberOfClaims.text = "";
    ClaimedAmont.text = "";
    SettledAmont.text = "";
    PendingAmont.text = "";
  }
}

class EditClaimsDetailsState extends State<RenewalEditClaimsDetails> {
  String? _nameOftheInsurerHasError = "";
  String? _cashLessHasError = "";
  String? _claimsOutStandingReimbursementmaHasError = "";
  String? _claimsOutStandingCashlessHasError = "";
  String? _ClaimsPaidAsOnDateHasError = "";
  String? _ClaimsPaidAsOnDateCashlessHasError = "";
  String? _ClaimsPaidAsOnDateReimbursementError = "";
  String? _ClaimsPaidAsOnDateCashlessError = "";
  String? _CorporateBufferClaimsPaidReimbursementError = "";
  String? _CorporateBufferClaimsPaidClaimsError = "";
  String? _CorporateBufferClaimsOutstandingReimbursementError = "";
  String? _CorporateBufferClaimsOutstandingCashlessError = "";
  String? _CorporateBufferAmontCashlessError = "";
  String? _PerFamilyLimitError = "";
  String? _PerFamilyMaximumLimitError = "";
  String? _MaximumNumberOfCases = "";
  String? _PolicyPeriodError = "";
  String? _PremiumPaidError = "";
  String? _TotalSumInsuredHasError = "";
  String? _NumberOfCasesHasError = "";
  String? _NumberOfClaimedHasError = "";
  String? _SettledAmontHasError = "";
  String? _PendingAmontHasError = "";

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  Future<void> fetch() async {
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
      localstorageProductId = jsonData["corporateDetails"]['productId'];
      localstorageProdCategoryId =
          jsonData["corporateDetails"]['prodCategoryId'];
    }
  }

  Future<void> fetchApiData() async {
    print("CLAIMS DETAILS GET BY ID ********************");
    String rfid = widget.rfid;
    var headers = await ApiServices.getHeaders();
    Response response = await http.get(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.Renewal_EditClaims_Details_EndPoint +
          rfid),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      ('object:$jsonData');
      setState(() {
        String claimPaidReimbursementValue = jsonData['claimPaidReimbursement'];
        claimPaidReimbursement.text = claimPaidReimbursementValue;

        String claimPaidCashlessValue = jsonData['claimPaidCashless'];
        claimPaidCashless.text = claimPaidCashlessValue;

        String claimOutstandingReimbursementValue =
            jsonData['claimOutstandingReimbursement'];
        claimOutstandingReimbursement.text =
            claimOutstandingReimbursementValue;

        String claimOutstandingCashlessValue =
            jsonData['claimOutstandingCashless'];
        claimOutstandingCashless.text =
            claimOutstandingCashlessValue;

        String opdClaimPaidReimbursementValue =
            jsonData['opdClaimPaidReimbursement'];
        opdClaimPaidReimbursement.text =
            opdClaimPaidReimbursementValue;

        String opdClaimPaidCashlessValue =
            jsonData['opdClaimOutstandingCashless'];
        opdClaimPaidCashless.text = opdClaimPaidCashlessValue;

        String opdClaimOutstandingReimbursementValue =
            jsonData['opdClaimOutstandingReimbursement'];
        opdClaimOutstandingReimbursement.text =
            opdClaimOutstandingReimbursementValue;

        // opdClaimOutstandingCashless.text = jsonData["opdClaimPaidCashless"];
        String opdClaimOutstandingCashlessValue =
            jsonData['claimOutstandingCashless'];
        opdClaimOutstandingCashless.text =
            opdClaimOutstandingCashlessValue;

        String corporateBufferClaimPaidReimbursementValue =
            jsonData['corporateBufferClaimOutstandingReimbursement'];
        corporateBufferClaimPaidReimbursement.text =
            corporateBufferClaimPaidReimbursementValue;

        String corporateBufferClaimPaidCashlessValue =
            jsonData['corporateBufferClaimPaidCashless'];
        corporateBufferClaimPaidCashless.text =
            corporateBufferClaimPaidCashlessValue;

        String corporateBufferClaimOutstandingReimbursementValue =
            jsonData['corporateBufferClaimPaidReimbursement'];
        corporateBufferClaimOutstandingReimbursement.text =
            corporateBufferClaimOutstandingReimbursementValue;

        String corporateBufferClaimOutstandingCashlessValue =
            jsonData['corporateBufferClaimOutstandingCashless'];
        corporateBufferClaimOutstandingCashless.text =
            corporateBufferClaimOutstandingCashlessValue;

        CorporateBufferAmount.text =
            jsonData["corporateBufferAmount"];

        perfamilylimit.text = jsonData["perFamilyLimit"];

        maxNoOfCases.text = jsonData["maxCasesNo"];

        perFamilyMaximumSI.text = jsonData["perFamilyLimit"];
        ('family:$jsonData["perFamilyLimit"]');
        PolicyPeriod.text = jsonData["policyperiod"];
        Premiumperiod.text = jsonData["premiumPaid"];
        TotalSumInsured.text = jsonData["totalSumInsured"];
        NumberOfClaims.text = jsonData["claimsNo"];
        ClaimedAmont.text = jsonData["claimedAmount"];
        SettledAmont.text = jsonData["settledAmount"];
        PendingAmont.text = jsonData["pendingAmount"];
        // "policyperiod": "hdgfjdf",
//   "premiumPaid": 0,
//   "totalSumInsured": 0,
//   "claimsNo": 0,
//   "claimedAmount": 0,totalSumInsured
//   "settledAmount": 0,
//   "pendingAmount": 0,
      });

      ('EditCorporateDetails saved successfully');
    } else {}
  }

  late final localstorageProductId;
  late final localstorageProdCategoryId;

  @override
  void initState() {
    super.initState();
    fetchApiData();
    fetch();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validateClaimsDetails() {
    if (formKey.currentState == null) {
      return false;
    }

    bool status = formKey.currentState!.validate();

    return status;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (localstorageProdCategoryId == 100 &&
                localstorageProductId == 1001) ...[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Align children to the left
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align children to the start of the cross axis (left)
                        children: [
                          AppBar(
                            toolbarHeight: SecureRiskColours.AppbarHeight,
                            backgroundColor:
                                SecureRiskColours.Table_Heading_Color,
                            title: Text(
                              "Claim Details",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            elevation: 5,
                            automaticallyImplyLeading: false,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text("Claims paid as on Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color.fromRGBO(25, 26, 25, 1))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: _nameOftheInsurerHasError == null ||
                                      _nameOftheInsurerHasError!.isEmpty
                                  ? 40.0
                                  : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: claimPaidReimbursement,
                                    decoration: InputDecoration(
                                      hintText: 'Reimbursement',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   _nameOftheInsurerHasError =
                                    //       validateString(value);
                                    //   return _nameOftheInsurerHasError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: _cashLessHasError == null ||
                                      _cashLessHasError!.isEmpty
                                  ? 40.0
                                  : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: claimPaidCashless,
                                    decoration: InputDecoration(
                                      hintText: 'Cashless',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   setState(() {
                                    //     _cashLessHasError =
                                    //         validateString(value);
                                    //   });
                                    //   return _cashLessHasError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text("Claims outstanding as on Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color.fromRGBO(25, 26, 25, 1))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: _claimsOutStandingReimbursementmaHasError ==
                                          null ||
                                      _claimsOutStandingReimbursementmaHasError!
                                          .isEmpty
                                  ? 40.0
                                  : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: claimOutstandingReimbursement,
                                    decoration: InputDecoration(
                                      hintText: 'Reimbursement',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   _claimsOutStandingReimbursementmaHasError =
                                    //       validateString(value);
                                    //   return _claimsOutStandingReimbursementmaHasError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height:
                                  _claimsOutStandingCashlessHasError == null ||
                                          _claimsOutStandingCashlessHasError!
                                              .isEmpty
                                      ? 40.0
                                      : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: claimOutstandingCashless,
                                    decoration: InputDecoration(
                                      hintText: 'Cashless',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   _claimsOutStandingCashlessHasError =
                                    //       validateString(value);
                                    //   return _claimsOutStandingCashlessHasError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //  Padding(
                          //   padding: EdgeInsets.only(top: 15),
                          //   child: Text(
                          //     "OPD Details",
                          //     style: GoogleFonts.poppins(
                          //       color: Color.fromRGBO(0, 0, 0, 1),
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: AppBar(
                              toolbarHeight: SecureRiskColours.AppbarHeight,
                              backgroundColor:
                                  SecureRiskColours.Table_Heading_Color,
                              title: Text(
                                "OPD Details",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              elevation: 5,
                              automaticallyImplyLeading: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text("Claims paid as on Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color.fromRGBO(25, 26, 25, 1))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: _ClaimsPaidAsOnDateHasError == null ||
                                      _ClaimsPaidAsOnDateHasError!.isEmpty
                                  ? 40.0
                                  : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: opdClaimPaidReimbursement,
                                    decoration: InputDecoration(
                                      hintText: 'Reimbursement',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   _ClaimsPaidAsOnDateHasError =
                                    //       validateString(value);
                                    //   return _ClaimsPaidAsOnDateHasError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height:
                                  _ClaimsPaidAsOnDateCashlessHasError == null ||
                                          _ClaimsPaidAsOnDateCashlessHasError!
                                              .isEmpty
                                      ? 40.0
                                      : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: opdClaimPaidCashless,
                                    decoration: InputDecoration(
                                      hintText: 'Cashless',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   _ClaimsPaidAsOnDateCashlessHasError =
                                    //       validateString(value);
                                    //   return _ClaimsPaidAsOnDateCashlessHasError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text("Claims outstanding as on Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color.fromRGBO(25, 26, 25, 1))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: _ClaimsPaidAsOnDateReimbursementError ==
                                          null ||
                                      _ClaimsPaidAsOnDateReimbursementError!
                                          .isEmpty
                                  ? 40.0
                                  : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller:
                                        opdClaimOutstandingReimbursement,
                                    decoration: InputDecoration(
                                      hintText: 'Reimbursement',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   _ClaimsPaidAsOnDateReimbursementError =
                                    //       validateString(value);
                                    //   return _ClaimsPaidAsOnDateReimbursementError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: _ClaimsPaidAsOnDateCashlessError ==
                                          null ||
                                      _ClaimsPaidAsOnDateCashlessError!.isEmpty
                                  ? 40.0
                                  : 65.0,
                              width: screenWidth * 0.23,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: claimOutstandingCashless,
                                    decoration: InputDecoration(
                                      hintText: 'Cashless',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   _ClaimsPaidAsOnDateCashlessError =
                                    //       validateString(value);
                                    //   return _ClaimsPaidAsOnDateCashlessError;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.95,
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
                        padding: EdgeInsets.only(top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align children to the left
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align children to the start of the cross axis (left)
                          children: [
                            //  Padding(
                            //   padding: EdgeInsets.all(0),
                            //   child: Text(
                            //     "Corporate Buffer Details",
                            //     style: GoogleFonts.poppins(
                            //       color: Color.fromRGBO(0, 0, 0, 1),
                            //       fontSize: 15,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            AppBar(
                              toolbarHeight: SecureRiskColours.AppbarHeight,
                              backgroundColor:
                                  SecureRiskColours.Table_Heading_Color,
                              title: Text(
                                "Corporate Buffer Details",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              elevation: 5,
                              automaticallyImplyLeading: false,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Claims paid as on Date",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: _CorporateBufferClaimsPaidReimbursementError ==
                                            null ||
                                        _CorporateBufferClaimsPaidReimbursementError!
                                            .isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller:
                                          corporateBufferClaimPaidReimbursement,
                                      decoration: InputDecoration(
                                        hintText: 'Reimbursement',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _CorporateBufferClaimsPaidReimbursementError =
                                      //       validateString(value);
                                      //   return _CorporateBufferClaimsPaidReimbursementError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: _CorporateBufferClaimsPaidClaimsError ==
                                            null ||
                                        _CorporateBufferClaimsPaidClaimsError!
                                            .isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller:
                                          corporateBufferClaimPaidCashless,
                                      decoration: InputDecoration(
                                        hintText: 'Cashless',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _CorporateBufferClaimsPaidClaimsError =
                                      //       validateString(value);
                                      //   return _CorporateBufferClaimsPaidClaimsError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Claims outstanding as on Date",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _CorporateBufferClaimsOutstandingReimbursementError ==
                                            null ||
                                        _CorporateBufferClaimsOutstandingReimbursementError!
                                            .isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller:
                                          corporateBufferClaimOutstandingReimbursement,
                                      decoration: InputDecoration(
                                        hintText: 'Reimbursement',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _CorporateBufferClaimsOutstandingReimbursementError =
                                      //       validateString(value);
                                      //   return _CorporateBufferClaimsOutstandingReimbursementError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: SizedBox(
                                height: _CorporateBufferClaimsOutstandingCashlessError ==
                                            null ||
                                        _CorporateBufferClaimsOutstandingCashlessError!
                                            .isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller:
                                          corporateBufferClaimOutstandingCashless,
                                      decoration: InputDecoration(
                                        hintText: 'Cashless',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _CorporateBufferClaimsOutstandingCashlessError =
                                      //       validateString(value);
                                      //   return _CorporateBufferClaimsOutstandingCashlessError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: AppBar(
                                toolbarHeight: SecureRiskColours.AppbarHeight,
                                backgroundColor:
                                    SecureRiskColours.Table_Heading_Color,
                                title: Text(
                                  "Corporate Buffer Details-Renewal",
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
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Corporate Buffer Amount",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: _CorporateBufferAmontCashlessError ==
                                            null ||
                                        _CorporateBufferAmontCashlessError!
                                            .isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller: CorporateBufferAmount,
                                      decoration: InputDecoration(
                                        hintText: 'Corporate Buffer Amount',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _CorporateBufferAmontCashlessError =
                                      //       validateString(value);
                                      //   return _CorporateBufferAmontCashlessError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Per Family Limit",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _PerFamilyLimitError == null ||
                                        _PerFamilyLimitError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller: perfamilylimit,
                                      decoration: InputDecoration(
                                        hintText: 'Per Family Limit',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _PerFamilyLimitError =
                                      //       validateString(value);
                                      //   return _PerFamilyLimitError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Maximum No. of Cases",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _MaximumNumberOfCases == null ||
                                        _MaximumNumberOfCases!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller: maxNoOfCases,
                                      decoration: InputDecoration(
                                        hintText: 'Maximum No. of Cases',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _MaximumNumberOfCases =
                                      //       validateString(value);
                                      //   return _MaximumNumberOfCases;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Per Family Maximum SI",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _PerFamilyMaximumLimitError == null ||
                                        _PerFamilyMaximumLimitError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      controller: perFamilyMaximumSI,
                                      decoration: InputDecoration(
                                        hintText: 'Per Family Maximum SI',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   _PerFamilyMaximumLimitError =
                                      //       validateString(value);
                                      //   return _PerFamilyMaximumLimitError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ] else ...[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.4,
                      child: AppBar(
                        toolbarHeight: SecureRiskColours.AppbarHeight,
                        backgroundColor: SecureRiskColours.Table_Heading_Color,
                        title: Text(
                          "Claims Details",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        elevation: 5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Policy Period",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color.fromRGBO(25, 26, 25, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: _PolicyPeriodError == null ||
                                _PolicyPeriodError!.isEmpty
                            ? 40.0
                            : 65.0,
                        width: screenWidth * 0.23,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Material(
                            shadowColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: TextFormField(
                              controller: PolicyPeriod,
                              decoration: InputDecoration(
                                hintText: 'Policy Period',
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   setState(() {
                              //     _PolicyPeriodError = validateString(value);
                              //   });
                              //   return _PolicyPeriodError;
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Premium paid",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color.fromRGBO(25, 26, 25, 1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: _PremiumPaidError == null ||
                                _PremiumPaidError!.isEmpty
                            ? 40.0
                            : 65.0,
                        width: screenWidth * 0.23,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Material(
                            shadowColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: TextFormField(
                              controller: Premiumperiod,
                              decoration: InputDecoration(
                                hintText: 'Premium Paid',
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   setState(() {
                              //     _PremiumPaidError = validateString(value);
                              //   });
                              //   return _PremiumPaidError;
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Align(
                        alignment: Alignment
                            .centerLeft, // Align the child (Text) to the left
                        child: Text(
                          "Total Sum Insured",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color.fromRGBO(25, 26, 25, 1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: _TotalSumInsuredHasError == null ||
                                _TotalSumInsuredHasError!.isEmpty
                            ? 40.0
                            : 65.0,
                        width: screenWidth * 0.23,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Material(
                            shadowColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: TextFormField(
                              controller: TotalSumInsured,
                              decoration: InputDecoration(
                                hintText: 'Total Sum Insured',
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   setState(() {
                              //     _TotalSumInsuredHasError =
                              //         validateString(value);
                              //   });
                              //   return _TotalSumInsuredHasError;
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "No. of Claims",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color.fromRGBO(25, 26, 25, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: _NumberOfCasesHasError == null ||
                                _NumberOfCasesHasError!.isEmpty
                            ? 40.0
                            : 65.0,
                        width: screenWidth * 0.23,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Material(
                            shadowColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: TextFormField(
                              controller: NumberOfClaims,
                              decoration: InputDecoration(
                                hintText: 'No. of Claims',
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   setState(() {
                              //     _NumberOfCasesHasError =
                              //         validateString(value);
                              //   });
                              //   return _NumberOfCasesHasError;
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Claimed Amont",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color.fromRGBO(25, 26, 25, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: _NumberOfClaimedHasError == null ||
                                _NumberOfClaimedHasError!.isEmpty
                            ? 40.0
                            : 65.0,
                        width: screenWidth * 0.23,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Material(
                            shadowColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: TextFormField(
                              controller: ClaimedAmont,
                              decoration: InputDecoration(
                                hintText: 'Claimed Amont',
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   setState(() {
                              //     _NumberOfClaimedHasError =
                              //         validateString(value);
                              //   });
                              //   return _NumberOfClaimedHasError;
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Settled Amont",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color.fromRGBO(25, 26, 25, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: _SettledAmontHasError == null ||
                                _SettledAmontHasError!.isEmpty
                            ? 40.0
                            : 65.0,
                        width: screenWidth * 0.23,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Material(
                            shadowColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: TextFormField(
                              controller: SettledAmont,
                              decoration: InputDecoration(
                                hintText: 'Settled Amont',
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   setState(() {
                              //     _SettledAmontHasError = validateString(value);
                              //   });
                              //   return _SettledAmontHasError;
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "pending Amont",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color.fromRGBO(25, 26, 25, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: _PendingAmontHasError == null ||
                                _PendingAmontHasError!.isEmpty
                            ? 40.0
                            : 65.0,
                        width: screenWidth * 0.23,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Material(
                            shadowColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: TextFormField(
                              controller: PendingAmont,
                              decoration: InputDecoration(
                                hintText: 'Pending Amont',
                                hintStyle: GoogleFonts.poppins(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // validator: (value) {
                              //   setState(() {
                              //     _PendingAmontHasError = validateString(value);
                              //   });
                              //   return _PendingAmontHasError;
                              // },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
