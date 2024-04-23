import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import '../FreshPolicyFields/CustonDropdown.dart';
import 'package:intl/intl.dart';

final TextEditingController policyNumber = TextEditingController();
final TextEditingController startPeriod = TextEditingController();
final TextEditingController endPeriod = TextEditingController();
final TextEditingController premiumPaidInception = TextEditingController();
final TextEditingController premium = TextEditingController();
final TextEditingController additionPremium = TextEditingController();
final TextEditingController deletionPremium = TextEditingController();
final TextEditingController policyType = TextEditingController();
final TextEditingController activeYears = TextEditingController();
final TextEditingController membersNoInception = TextEditingController();
final TextEditingController additions = TextEditingController();
final TextEditingController deletions = TextEditingController();
final TextEditingController totalMembers = TextEditingController();
final TextEditingController membersNum = TextEditingController();
final TextEditingController familyDefination = TextEditingController();
final TextEditingController dependentMember = TextEditingController();
final TextEditingController familiesNum = TextEditingController();

final TextEditingController membersNoInceptionForDependents =
    TextEditingController();
final TextEditingController additionsForDependents = TextEditingController();
final TextEditingController deletionsForDependents = TextEditingController();
final TextEditingController totalMembersForDependents = TextEditingController();

String? policyCoverage = "NO";
String? familydefinationvalue;
String? policyTypeValue;
String? anyCoverage;

DateTime selectedStartDate = DateTime.now();
DateTime selectedEndDate = DateTime.now();

class RenewalExpiryDetails extends StatefulWidget {
  RenewalExpiryDetails({super.key});

  @override
  State<RenewalExpiryDetails> createState() => RenewalExpiryDetailsState();

  Future<void> expiryDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    print("*********Expiring Details*******");
    print(startPeriod.text);
    print(endPeriod.text);

    final rfqId = prefs.getString('responseBody');
    var body = {
      "rfqId": rfqId,
      "policyNumber": policyNumber.text,
      "startPeriod": startPeriod.text,
      "endPeriod": endPeriod.text,
      "premiumPaidInception":
          premiumPaidInception.text.isEmpty ? "N/A" : premiumPaidInception.text,
      "premium": premium.text.isEmpty ? "N/A" : premium.text,
      "additionPremium":
          additionPremium.text.isEmpty ? "N/A" : additionPremium.text,
      "deletionPremium":
          deletionPremium.text.isEmpty ? "N/A" : deletionPremium.text,
      "policyType": policyTypeValue,
      "activeYears": activeYears.text.isEmpty ? "N/A" : activeYears.text,
      "membersNoInception":
          membersNoInception.text.isEmpty ? "N/A" : membersNoInception.text,
      "additions": additions.text.isEmpty ? "N/A" : additions.text,
      "deletions": deletions.text.isEmpty ? "N/A" : deletions.text,
      "totalMembers": totalMembers.text.isEmpty ? "N/A" : totalMembers.text,
      "membersNoInceptionForDependents":
          membersNoInceptionForDependents.text.isEmpty
              ? "N/A"
              : membersNoInceptionForDependents.text,
      "additionsForDependents": additionsForDependents.text.isEmpty
          ? "N/A"
          : additionsForDependents.text,
      "deletionsForDependents": deletionsForDependents.text.isEmpty
          ? "N/A"
          : deletionsForDependents.text,
      "totalMembersForDependents": totalMembersForDependents.text.isEmpty
          ? "N/A"
          : totalMembersForDependents.text,
      "membersNum": membersNum.text.isEmpty ? "N/A" : membersNum.text,
      "dependentMember":
          dependentMember.text.isEmpty ? "N/A" : dependentMember.text,
      "familyDefination": familydefinationvalue,
      "familiesNum": familiesNum.text.isEmpty ? "N/A" : familiesNum.text,
      "additionalRelationShip": policyCoverage,
      "familyDefinationRevision": anyCoverage
    };
    (body);
    var headers = await ApiServices.getHeaders();
    Response response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.renewal_Expiry_Details),
        headers: headers,
        body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'RenewalExpiryDetails saved successfully',
      );
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'RenewalExpiryDetails failed to save...!',
      );
    }
  }

  static void renewalExpiryDetailsclearFields() {
    policyNumber.text = "";
    startPeriod.text = "";
    endPeriod.text = "";
    premiumPaidInception.text = "";
    premium.text = "";
    additionPremium.text = "";
    deletionPremium.text = "";
    policyType.text = "";
    activeYears.text = "";
    membersNoInception.text = "";
    additions.text = "";
    deletions.text = "";
    totalMembers.text = "";
    membersNoInceptionForDependents.text = "";

    membersNum.text = "";
    familyDefination.text = "";
    dependentMember.text = "";
    familiesNum.text = "";
  }
}

class RenewalExpiryDetailsState extends State<RenewalExpiryDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final localstorageProductId;
  late final localstorageProdCategoryId;
  late final localstorageRfqId;

  Future<void> getProdCategoryId() async {
    final prefs = await SharedPreferences.getInstance();
    localstorageProductId = prefs.getInt('productId');
    localstorageProdCategoryId = prefs.getInt('prodCategoryId');
  }

  Future<void> getRfqId() async {
    final prefs = await SharedPreferences.getInstance();
    localstorageRfqId = prefs.getString('responseBody');
    fetchClaimsDetails();
  }

  Future<void> fetchClaimsDetails() async {
    var headers = await ApiServices.getHeaders();

    var url = Uri.parse(ApiServices.baseUrl +
        ApiServices.Claims_policy_details +
        "=$localstorageRfqId");
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        policyNumber.text = data['policyNumber'];
        startPeriod.text = data['startDate'];
        endPeriod.text = data['endDate'];
      } else {
        // Handle the case when the response is empty
      }
    } else {
      // Handle the case when the API call fails
    }
  }

  void initState() {
    super.initState();
    getProdCategoryId();
  }

  bool validateExpiryDetails() {
    ("validating");
    if (formKey.currentState == null) {
      return false; // Handle the case when formKey or currentState is null
    }
    (formKey.currentState);
    bool status = formKey.currentState!.validate();

    return status;
  }

  List<String> productCategories = [
    'YES',
    'NO',
  ];

  List<String> familyDefinationdropdown = ['1 + 3', '1 + 5', 'Parents only'];
  List<String> policyTypedroDown = ['Floater', 'Non-Floater'];

  List<String> AnyCategory = [
    'YES',
    'NO',
  ];

  String? policyError = "";

  String? startPeriodError = "";

  String? endPeriodError = "";

  String? premiumPaidInceptionError = "";

  String? premiumError = "";

  String? additionPremiumError = "";

  String? deletionPremiumError = "";

  String? policyTypeError = "";

  String? activeYearsError = "";

  String? membersNoInceptionError = "";

  String? additionsError = "";

  String? deletionsError = "";

  String? totalMembersError = "";

  String? membersNumError = "";

  String? familyDefinationError = "";

  String? dependentMemberError = "";

  String? familiesNumError = "";

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != selectedStartDate) {
      bool isLeapYear = ((picked.year % 4 == 0 && picked.year % 100 != 0) ||
          (picked.year % 400 == 0));

      setState(() {
        selectedStartDate = picked;
        selectedEndDate = picked.add(Duration(days: isLeapYear ? 365 : 364));
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Align children to the left
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Align children to the start of the cross axis (left)
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBar(
                                  toolbarHeight: SecureRiskColours.AppbarHeight,
                                  backgroundColor:
                                      SecureRiskColours.Table_Heading_Color,
                                  title: Text(
                                    "Expiry Policy Details",
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
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Policy Number",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: policyError == null ||
                                          policyError!.isEmpty
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
                                        controller: policyNumber,
                                        decoration: InputDecoration(
                                          // hintText: 'Policy Number',
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
                                        validator: (value) {
                                          setState(() {
                                            policyError = validateString(value);
                                          });
                                          return policyError;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Start Date",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Container(
                                // height: 40,
                                height: selectedStartDate ==
                                        "Start date must be before or equal to end date"
                                    ? 40.0
                                    : 60.0,
                                width: screenWidth * 0.23,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: startPeriod,
                                  //  TextEditingController(
                                  //   text: formatDate(selectedStartDate),
                                  // ),
                                  onTap: () async {
                                    DateTime? selectedStartDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime
                                          .now(), // Initial date for the picker
                                      firstDate: DateTime(
                                          2000), // Earliest selectable date
                                      lastDate: DateTime(
                                          2101), // Latest selectable date
                                    );

                                    if (selectedStartDate != null) {
                                      // Format and set the start date
                                      startPeriod.text =
                                          // DateFormat('dd-MM-yyyy')
                                          //     .format(selectedStartDate);
                                          DateFormat('yyyy-MM-dd')
                                              .format(selectedStartDate);

                                      // Calculate the end date (one year later, minus one day)
                                      DateTime endDate = DateTime(
                                              selectedStartDate.year + 1,
                                              selectedStartDate.month,
                                              selectedStartDate.day)
                                          .subtract(Duration(days: 1));

                                      // Format and set the end date
                                      // endPeriod.text = DateFormat('dd-MM-yyyy')
                                      //     .format(endDate);
                                      endPeriod.text = DateFormat('yyyy-MM-dd')
                                          .format(endDate);
                                    }
                                  },
                                  // () => _selectStartDate(context),
                                  decoration: InputDecoration(
                                    hintText: 'Start Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 12.0, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (selectedStartDate
                                        .isAfter(selectedEndDate)) {
                                      return 'Start date must be before or equal to end date';
                                    }
                                    return null; // Return null to indicate no error
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("End Date",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Container(
                                height: selectedStartDate ==
                                        "End date must be after or equal to start date"
                                    ? 40.0
                                    : 60.0,
                                width: screenWidth * 0.23,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: endPeriod,
                                  // TextEditingController(
                                  //   text: formatDate(selectedEndDate),
                                  // ),
                                  //onTap: () => _selectEndDate(context),
                                  decoration: InputDecoration(
                                    hintText: 'End Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 12.0, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (selectedEndDate
                                        .isBefore(selectedStartDate)) {
                                      return 'End date must be after or equal to start date';
                                    }
                                    return null; // Return null to indicate no error
                                  },
                                ),
                              ),
                              Container(
                                width: screenWidth * 0.40,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: AppBar(
                                    toolbarHeight:
                                        SecureRiskColours.AppbarHeight,
                                    backgroundColor:
                                        SecureRiskColours.Table_Heading_Color,
                                    title: Text(
                                      "Premium Details",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    elevation: 5,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Premium Paid at Inception",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: premiumPaidInceptionError == null ||
                                          premiumPaidInceptionError!.isEmpty
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
                                        controller: premiumPaidInception,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          // 'Premium Paid at Inception',
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
                                        //     premiumPaidInceptionError =
                                        //         validateString(value);
                                        //   });
                                        //   return premiumPaidInceptionError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("As on Date Premium",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: premiumError == null ||
                                          premiumError!.isEmpty
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
                                        controller: premium,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          //'As on Date Premium',
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
                                        //     premiumError =
                                        //         validateString(value);
                                        //   });
                                        //   return premiumError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Addition Premium",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: additionPremiumError == null ||
                                          additionPremiumError!.isEmpty
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
                                        controller: additionPremium,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          // 'Addition Premium',
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
                                        //     additionPremiumError =
                                        //         validateString(value);
                                        //   });
                                        //   return additionPremiumError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Deletion Premium",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: deletionPremiumError == null ||
                                          deletionPremiumError!.isEmpty
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
                                        controller: deletionPremium,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          // 'Deletion Premium',
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
                                        //     deletionPremiumError =
                                        //         validateString(value);
                                        //   });
                                        //   return deletionPremiumError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Policy Type",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              SizedBox(
                                width: screenWidth * 0.23,
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: CustomDropdown(
                                    value: policyTypeValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        policyTypeValue = newValue;
                                        // showCustomTextField = newValue == 'Custom';
                                        // _formSubmitted = false;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          'Policy Type',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                          ),
                                        ), // default label
                                      ),
                                      ...policyTypedroDown.map((String option) {
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Active Years",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: activeYearsError == null ||
                                          activeYearsError!.isEmpty
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
                                        onChanged: (value) {
                                          activeYears.text =
                                              value; // Update the value of the TextFormField
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          // 'Active Years',
                                          hintStyle:
                                              GoogleFonts.poppins(fontSize: 13),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        // Set the initial value to "N/A" if the field is empty
                                        // initialValue: !.isEmpty
                                        //     ? 'N/A'
                                        //     : _textFieldValue,
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
                height: screenHeight * 1.4,
                child: VerticalDivider(
                  color: Color.fromARGB(255, 82, 81, 81),
                  thickness: 1,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    AppBar(
                      toolbarHeight: SecureRiskColours.AppbarHeight,
                      backgroundColor: SecureRiskColours
                          .Table_Heading_Color, // Change as per your requirements
                      title: Text(
                        "Member Details Expiring Year",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      elevation: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Align children to the left
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Align children to the start of the cross axis (left)
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("No.of Members at Inception",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: membersNoInceptionError == null ||
                                          membersNoInceptionError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.20,
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
                                        controller: membersNoInception,
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
                                        //     membersNoInceptionError =
                                        //         validateString(value);
                                        //   });
                                        //   return membersNoInceptionError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Additions During the year",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: additionsError == null ||
                                          additionsError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.20,
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
                                        controller: additions,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          //'Additions During the year',
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
                                        //     additionsError =
                                        //         validateString(value);
                                        //   });
                                        //   return additionsError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Deletion During the year",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: deletionsError == null ||
                                          deletionsError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.20,
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
                                        controller: deletions,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          // 'Deletion During the year',
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
                                        //     deletionsError =
                                        //         validateString(value);
                                        //   });
                                        //   return deletionsError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Total Members as on Date",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: SizedBox(
                                  height: totalMembersError == null ||
                                          totalMembersError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.20,
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
                                        controller: totalMembers,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          //'Total Members as on Date',
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
                                        //     totalMembersError =
                                        //         validateString(value);
                                        //   });
                                        //   return totalMembersError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // Align children to the left
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align children to the start of the cross axis (left)
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("No.of Members at Inception",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: membersNoInceptionError == null ||
                                        membersNoInceptionError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.20,
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
                                      controller:
                                          membersNoInceptionForDependents,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
                                        // 'No.of Members at Inception',
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Additions During the year",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: additionsError == null ||
                                        additionsError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.20,
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
                                      controller: additionsForDependents,
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Deletion During the year",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: deletionsError == null ||
                                        deletionsError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.20,
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
                                      controller: deletionsForDependents,
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Total Members as on Date",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: SizedBox(
                                height: totalMembersError == null ||
                                        totalMembersError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.20,
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
                                      controller: totalMembersForDependents,
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // Align children to the left
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align children to the start of the cross axis (left)
                          children: [
                            Container(
                              width: screenWidth * 0.4,
                              child: AppBar(
                                toolbarHeight: SecureRiskColours.AppbarHeight,
                                backgroundColor:
                                    SecureRiskColours.Table_Heading_Color,
                                title: Text(
                                  "Renewal Details",
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
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("No.of Members to be Covered",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: membersNumError == null ||
                                        membersNumError!.isEmpty
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
                                      controller: membersNum,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
                                        //'No.of Members to be Covered',
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Dependent",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: dependentMemberError == null ||
                                        dependentMemberError!.isEmpty
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
                                      controller: dependentMember,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
                                        // 'Dependent',
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Family Defination",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.23,
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: CustomDropdown(
                                  value: familydefinationvalue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      familydefinationvalue = newValue;
                                      // showCustomTextField = newValue == 'Custom';
                                      // _formSubmitted = false;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text(
                                        'Family Details',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                        ),
                                      ), // default label
                                    ),
                                    ...familyDefinationdropdown
                                        .map((String option) {
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
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("No.of Families",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: familiesNumError == null ||
                                        familiesNumError!.isEmpty
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
                                      controller: familiesNum,
                                      decoration: InputDecoration(
                                        hintText: 'N/A',
                                        //'No.of Families',
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
                                      //     familiesNumError =
                                      //         validateString(value);
                                      //   });
                                      //   return familiesNumError;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (localstorageProductId == 1001)
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Container(
                                  width: screenWidth * 0.4,
                                  child: AppBar(
                                    toolbarHeight:
                                        SecureRiskColours.AppbarHeight,
                                    backgroundColor:
                                        SecureRiskColours.Table_Heading_Color,
                                    title: Text(
                                      "Family Details",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    elevation: 5,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                '''Family Defination whether additional children covered whether 
      additional relationships covered (like brother/sister etc.)''',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color.fromRGBO(25, 26, 25, 1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.23,
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: CustomDropdown(
                                  value: policyCoverage,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      policyCoverage = newValue;
                                      // showCustomTextField = newValue == 'Custom';
                                      // _formSubmitted = false;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text(
                                        'Family Details',
                                        //" ",
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
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                  '''Any revision required in family defination under renewal policy 
        (please specify if Yes)''',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            SizedBox(
                              width: screenWidth * 0.23,
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: CustomDropdown(
                                  value: anyCoverage,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      anyCoverage = newValue;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text(
                                        'Family Details',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                        ),
                                      ), // default label
                                    ),
                                    ...AnyCategory.map((String option) {
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
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Align children to the left
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Align children to the start of the cross axis (left)
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBar(
                                  toolbarHeight: SecureRiskColours.AppbarHeight,
                                  backgroundColor:
                                      SecureRiskColours.Table_Heading_Color,
                                  title: Text(
                                    "Expiry Details",
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
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Policy Number",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: policyError == null ||
                                          policyError!.isEmpty
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
                                        controller: policyNumber,
                                        decoration: InputDecoration(
                                          hintText: 'Policy Number',
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
                                        validator: (value) {
                                          setState(() {
                                            policyError = validateString(value);
                                          });
                                          return policyError;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Start Date",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Container(
                                height: 30,
                                width: screenWidth * 0.23,
                                child: TextFormField(
                                  // readOnly: true,
                                  controller: startPeriod,
                                  onTap:
                                      // () => _selectStartDate(context),
                                      () async {
                                    DateTime? selectedStartDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime
                                          .now(), // Initial date for the picker
                                      firstDate: DateTime(
                                          2000), // Earliest selectable date
                                      lastDate: DateTime(
                                          2101), // Latest selectable date
                                    );

                                    if (selectedStartDate != null) {
                                      // Format and set the start date
                                      startPeriod.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(selectedStartDate);

                                      // Calculate the end date (one year later, minus one day)
                                      DateTime endDate = DateTime(
                                              selectedStartDate.year + 1,
                                              selectedStartDate.month,
                                              selectedStartDate.day)
                                          .subtract(Duration(days: 1));

                                      // Format and set the end date
                                      endPeriod.text = DateFormat('yyyy-MM-dd')
                                          .format(endDate);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Start Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 12.0, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("End Date",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),

                              Container(
                                height: 35.0,
                                width: screenWidth * 0.23,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: endPeriod,
                                  // TextEditingController(
                                  //   text: formatDate(selectedEndDate),
                                  // ),
                                  // onTap: () => _selectEndDate(context),
                                  decoration: InputDecoration(
                                    hintText: 'End Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 12.0, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: screenWidth * 0.4,
                                  child: AppBar(
                                    toolbarHeight:
                                        SecureRiskColours.AppbarHeight,
                                    backgroundColor:
                                        SecureRiskColours.Table_Heading_Color,
                                    title: Text(
                                      "Premium Details",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    elevation: 5,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Premium Paid at Inception",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: premiumPaidInceptionError == null ||
                                          premiumPaidInceptionError!.isEmpty
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
                                        controller: premiumPaidInception,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          //'Premium Paid at Inception',
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
                                        //     premiumPaidInceptionError =
                                        //         validateString(value);
                                        //   });
                                        //   return premiumPaidInceptionError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("As on Date Premium",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: premiumError == null ||
                                          premiumError!.isEmpty
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
                                        controller: premium,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          //'As on Date Premium',
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
                                        //     premiumError =
                                        //         validateString(value);
                                        //   });
                                        //   return premiumError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Addition Premium",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: additionPremiumError == null ||
                                          additionPremiumError!.isEmpty
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
                                        controller: additionPremium,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          // 'Addition Premium',
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
                                        //     additionPremiumError =
                                        //         validateString(value);
                                        //   });
                                        //   return additionPremiumError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Deletion Premium",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: deletionPremiumError == null ||
                                          deletionPremiumError!.isEmpty
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
                                        controller: deletionPremium,
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          //'Deletion Premium',
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
                                        //     deletionPremiumError =
                                        //         validateString(value);
                                        //   });
                                        //   return deletionPremiumError;
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Policy Type",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              SizedBox(
                                width: screenWidth * 0.23,
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: CustomDropdown(
                                    value: policyTypeValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        policyTypeValue = newValue;
                                        // showCustomTextField = newValue == 'Custom';
                                        // _formSubmitted = false;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          'Policy Type',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                          ),
                                        ), // default label
                                      ),
                                      ...policyTypedroDown.map((String option) {
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
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 8.0),
                              //   child: SizedBox(
                              //     height: policyTypeError == null ||
                              //             policyTypeError!.isEmpty
                              //         ? 40.0
                              //         : 65.0,
                              //     width: screenWidth * 0.23,
                              //     child: Padding(
                              //       padding: EdgeInsets.only(bottom: 2),
                              //       child: Material(
                              //         shadowColor: Colors.white,
                              //         borderRadius:
                              //             BorderRadius.all(Radius.circular(3)),
                              //         child: TextFormField(
                              //           controller: policyType,
                              //           decoration: InputDecoration(
                              //             hintText: 'Policy Type',
                              //             hintStyle:
                              //                 GoogleFonts.poppins(fontSize: 13),
                              //             border: OutlineInputBorder(
                              //               borderRadius: BorderRadius.all(
                              //                 Radius.circular(3),
                              //               ),
                              //               borderSide: BorderSide(
                              //                 color: Colors.white,
                              //               ),
                              //             ),
                              //           ),
                              //           validator: (value) {
                              //             setState(() {
                              //               policyTypeError =
                              //                   validateString(value);
                              //             });
                              //             return policyTypeError;
                              //           },
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Active Years",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: activeYearsError == null ||
                                          activeYearsError!.isEmpty
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
                                        onChanged: (value) {
                                          activeYears.text =
                                              value; // Update the value of the TextFormField
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'N/A',
                                          //'Active Years',
                                          hintStyle:
                                              GoogleFonts.poppins(fontSize: 13),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        // Set the initial value to "N/A" if the field is empty
                                        // initialValue: !.isEmpty
                                        //     ? 'N/A'
                                        //     : _textFieldValue,
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
            ]
          ],
        ),
      ),
    );
  }
}
