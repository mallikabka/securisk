import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

final TextEditingController Reimbursment1 = TextEditingController();
final TextEditingController Cashless1 = TextEditingController();
final TextEditingController Reimbursment2 = TextEditingController();
final TextEditingController Cashless2 = TextEditingController();
final TextEditingController Reimbursment3 = TextEditingController();
final TextEditingController Cashless3 = TextEditingController();
final TextEditingController Reimbursment4 = TextEditingController();
final TextEditingController Cashless4 = TextEditingController();
final TextEditingController Reimbursment5 = TextEditingController();
final TextEditingController Cashless5 = TextEditingController();
final TextEditingController Reimbursment6 = TextEditingController();
final TextEditingController Cashless6 = TextEditingController();
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

  ApiPayload({
    required this.rfqId,
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
  });
}

class RenewalClaimsDetails extends StatefulWidget {
  RenewalClaimsDetails({super.key});

  @override
  State<RenewalClaimsDetails> createState() => RenewalClaimsDetailsState();
  Future<void> fetchClaimsFeildsData() async {
    final prefs = await SharedPreferences.getInstance();
    var headers = await ApiServices.getHeaders();
    String? rfqId = prefs.getString('responseBody');

    Response response = await http.get(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.claims_Feilds_data_EndPoint +
          rfqId!),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      Map<String, dynamic> data = json.decode(response.body);

      Reimbursment1.text = data['claimPaidReimbursement'].toString();
      Cashless1.text = data['claimsPaidCashless'].toString();
      Reimbursment2.text = data['claimsOutStandingReimbursement'].toString();
      Cashless2.text = data['claimsOutStandingCashless'].toString();
      ('EditCorporateDetails saved successfully');
    } else {}
  }

  Future<void> fetchApiData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var headers = await ApiServices.getHeaders();
    final rfqId = prefs.getString('responseBody');
    var body = {
      "rfqId": rfqId,
      "claimPaidReimbursement":
          Reimbursment1.text.isNotEmpty ? Reimbursment1.text : "N/A",
      "claimPaidCashless": Cashless1.text.isNotEmpty ? Cashless1.text : "N/A",
      "claimOutstandingReimbursement":
          Reimbursment2.text.isNotEmpty ? Reimbursment2.text : "N/A",
      "claimOutstandingCashless":
          Cashless2.text.isNotEmpty ? Cashless2.text : "N/A",
      "opdClaimPaidReimbursement":
          Reimbursment3.text.isNotEmpty ? Reimbursment3.text : "N/A",
      "opdClaimPaidCashless": Cashless3.text.isNotEmpty ? Cashless3.text : "N/A",
      "opdClaimOutstandingReimbursement":
          Reimbursment4.text.isNotEmpty ? Reimbursment4.text : "N/A",
      "opdClaimOutstandingCashless":
          Cashless4.text.isNotEmpty ? Cashless4.text : "N/A",
      "corporateBufferClaimPaidReimbursement":
          Reimbursment5.text.isNotEmpty ? Reimbursment5.text : "N/A",
      "corporateBufferClaimPaidCashless":
          Cashless5.text.isNotEmpty ? Cashless5.text : "N/A",
      "corporateBufferClaimOutstandingReimbursement":
          Reimbursment6.text.isNotEmpty ? Reimbursment6.text : "N/A",
      "corporateBufferClaimOutstandingCashless":
          Cashless6.text.isNotEmpty ? Cashless6.text : "N/A",
      "corporateBufferAmount": CorporateBufferAmount.text.isNotEmpty
          ? CorporateBufferAmount.text
          : "N/A",
      "perFamilyLimit":
          perfamilylimit.text.isNotEmpty ? perfamilylimit.text : "N/A",
      "maxCasesNo": maxNoOfCases.text.isNotEmpty ? maxNoOfCases.text : "N/A",
      "maxSumInsured":
          perFamilyMaximumSI.text.isNotEmpty ? perFamilyMaximumSI.text : "N/A",
      "policyPeriod": PolicyPeriod.text.isNotEmpty?PolicyPeriod.text:"N/A",
      "premiumPaid": Premiumperiod.text.isNotEmpty?Premiumperiod.text:"N/A",
      "totalSumInsured":
          TotalSumInsured.text.isNotEmpty ? TotalSumInsured.text : "N/A",
      "claimsNo": NumberOfClaims.text.isNotEmpty ? NumberOfClaims.text : "N/A",
      "claimedAmount": ClaimedAmont.text.isNotEmpty ? ClaimedAmont.text : "N/A",
      "settledAmount": SettledAmont.text.isNotEmpty ? SettledAmont.text : "N/A",
      "pendingAmount": PendingAmont.text.isNotEmpty
          ? PendingAmont.text
          : "N/A",
    };

    Response response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.renewal_Claims_Details),
        headers: headers,
        body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'RenewalClaimsDetails saved successfully',
      );
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'RenewalClaimsDetails failed to save...!',
      );
    }
  }

  static void renewalClaimsDetailsclearFileds() {
    Reimbursment1.text = "";
    Cashless1.text = "";
    Reimbursment2.text = "";
    Cashless2.text = "";
    Reimbursment3.text = "";
    Cashless3.text = "";
    Reimbursment4.text = "";
    Cashless4.text = "";
    Reimbursment5.text = "";
    Cashless5.text = "";
    Reimbursment6.text = "";
    Cashless6.text = "";
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

class RenewalClaimsDetailsState extends State<RenewalClaimsDetails> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validateClaimsDetails() {
    ("validating");
    if (formKey.currentState == null) {
      return false; // Handle the case when formKey or currentState is null
    }
    (formKey.currentState);
    bool status = formKey.currentState!.validate();

    return status;
  }

  late final localstorageProductId;
  late final storageProductCategoryId;

  Future<void> getProdCategoryId() async {
    final prefs = await SharedPreferences.getInstance();
    localstorageProductId = prefs.getInt('productId') ?? 0;
    storageProductCategoryId = prefs.getInt('prodCategoryId') ?? 0;
  }

  void initState() {
    super.initState();
    getProdCategoryId();
  }

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
            if (storageProductCategoryId == 100 &&
                localstorageProductId == 1001) ...[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Align children to the left
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align children to the start of the cross axis (left)
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBar(
                                  toolbarHeight: SecureRiskColours.AppbarHeight,
                                  backgroundColor:
                                      SecureRiskColours.Table_Heading_Color,
                                  title: Text(
                                    "Claim Details",
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: Reimbursment1,
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: Cashless1,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: Reimbursment2,
                                        decoration: InputDecoration(
                                          hintText: "N/A",
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
                                  height: _claimsOutStandingCashlessHasError ==
                                              null ||
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],

                                        controller: Cashless2,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
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
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Container(
                                  width: screenWidth * 0.4,
                                  child: AppBar(
                                    toolbarHeight:
                                        SecureRiskColours.AppbarHeight,
                                    backgroundColor:
                                        SecureRiskColours.Table_Heading_Color,
                                    title: Text(
                                      "OPD Details",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    elevation: 5,
                                  ),
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: Reimbursment3,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
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
                                  height: _ClaimsPaidAsOnDateCashlessHasError ==
                                              null ||
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: Cashless3,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: Reimbursment4,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
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
                                          _ClaimsPaidAsOnDateCashlessError!
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: Cashless4,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.99,
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
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: AppBar(
                                toolbarHeight: SecureRiskColours.AppbarHeight,
                                backgroundColor:
                                    SecureRiskColours.Table_Heading_Color,
                                title: Text(
                                  "Corporate Buffer Details",
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: Reimbursment5,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: Cashless5,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: Reimbursment6,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: Cashless6,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                            AppBar(
                              toolbarHeight: SecureRiskColours.AppbarHeight,
                              backgroundColor:
                                  SecureRiskColours.Table_Heading_Color,
                              title: Text(
                                "Corporate Buffer Details-Renewal",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              elevation: 5,
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: CorporateBufferAmount,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: perfamilylimit,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: maxNoOfCases,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: perFamilyMaximumSI,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
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
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only numeric input
                              ],
                              controller: PolicyPeriod,
                              decoration: InputDecoration(
                                hintText: 'N/A ',
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

                              validator: (value) {
                                // Convert the input string to an integer
                                int? parsedValue = int.tryParse(value ?? '');

                                if (parsedValue == null) {
                                  // Return an error message if parsing fails
                                  setState(() {
                                    _PolicyPeriodError =
                                        'Please enter a policy period in  digit ';
                                  });
                                } else {
                                  // Reset the error message if parsing succeeds
                                  setState(() {
                                    _PolicyPeriodError = null;
                                  });
                                }
                                return _PolicyPeriodError;
                              },
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
                          "Premium Paid",
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
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only numeric input
                              ],
                              controller: Premiumperiod,
                              decoration: InputDecoration(
                                hintText: 'N/A',
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
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only numeric input
                              ],
                              controller: TotalSumInsured,
                              decoration: InputDecoration(
                                hintText: 'N/A',
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
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only numeric input
                              ],
                              controller: NumberOfClaims,
                              decoration: InputDecoration(
                                hintText: 'N/A',
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
                        "Claimed Amount",
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
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only numeric input
                              ],
                              controller: ClaimedAmont,
                              decoration: InputDecoration(
                                hintText: 'N/A',
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
                        "Settled Amount",
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
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only numeric input
                              ],
                              controller: SettledAmont,
                              decoration: InputDecoration(
                                hintText: 'N/A',
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
                        "Pending Amount",
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
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only numeric input
                              ],
                              controller: PendingAmont,
                              decoration: InputDecoration(
                                hintText: 'N/A',
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
                              // validator: (value) {
                              //   _PendingAmontHasError = validateString(value);
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
            ]
          ],
        ),
      ),
    );
  }
}
