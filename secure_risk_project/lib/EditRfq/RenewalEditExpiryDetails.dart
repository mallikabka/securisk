import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/EditCorporate.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
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
final TextEditingController additionalRelationShip = TextEditingController();
final TextEditingController familyDefinationRevision = TextEditingController();
final TextEditingController createDate = TextEditingController();
final TextEditingController updateDate = TextEditingController();
final TextEditingController recordStatus = TextEditingController();

final TextEditingController membersNoInceptionForDependents =
    TextEditingController();
final TextEditingController additionsForDependents = TextEditingController();
final TextEditingController deletionsForDependents = TextEditingController();
final TextEditingController totalMembersForDependents = TextEditingController();

String? policyCoverage = "NO";
String? anyCoverage;
List<String> policyTypedroDown = ['Floater', 'Non-Floater'];
String? policyTypeValue;

// ignore: must_be_immutable
class RenewalEditExpiryDetails extends StatefulWidget {
  late String rfid;
  late int productId;
  late int responseProdCategoryId;
  RenewalEditExpiryDetails(
      {super.key,
      required this.rfid,
      required this.productId,
      required this.responseProdCategoryId});

  @override
  State<RenewalEditExpiryDetails> createState() =>
      RenewalEditExpiryDetailsState();

  Future<void> updateRenewalExpiryeDetails(BuildContext context) async {
    var body = {
      "policyNumber": policyNumber.text,
      "startPeriod": startPeriod.text,
      "endPeriod": endPeriod.text,
      "premiumPaidInception":
          premiumPaidInception.text.isEmpty ? "N/A" : premiumPaidInception.text,
      // premiumPaidInception.text,
      "premium": premium.text.isEmpty ? "N/A" : premium.text,
      // premium.text,
      "additionPremium":
          additionPremium.text.isEmpty ? "N/A" : additionPremium.text,
      //additionPremium.text,
      "deletionPremium":
          deletionPremium.text.isEmpty ? "N/A" : deletionPremium.text,
      //deletionPremium.text,
      "policyType": policyTypeValue,
      "activeYears": activeYears.text.isEmpty ? "N/A" : activeYears.text,
      "membersNoInception":
          membersNoInception.text.isEmpty ? "N/A" : membersNoInception.text,
      //membersNoInception.text,
      "additions": additions.text.isEmpty ? "N/A" : additions.text,
      //additions.text,
      "deletions": deletions.text.isEmpty ? "N/A" : deletions.text,
      //deletions.text,
      "totalMembers": totalMembers.text.isEmpty ? "N/A" : totalMembers.text,
      // totalMembers.text,
      "membersNum": membersNum.text.isEmpty ? "N/A" : membersNum.text,
      //membersNum.text,
      "dependentMember":
          dependentMember.text.isEmpty ? "N/A" : dependentMember.text,

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

      // dependentMember.text,
      "familyDefination": familyDefination.text,
      "familiesNum":
          dependentMember.text.isEmpty ? "N/A" : dependentMember.text,
      //familiesNum.text,
      "additionalRelationShip": policyCoverage,
      //additionalRelationShip.text,
      "familyDefinationRevision": anyCoverage,
      // familyDefinationRevision.text,
      "createDate": createDate.text,
      "updateDate": updateDate.text,
      "recordStatus": recordStatus.text
    };
    var headers = await ApiServices.getHeaders();
    Response response = await http.put(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.update_Renewal_ExpiryDetails_EndPoint +
          rfid),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ('EditCorporateDetails saved successfully');
    } else {}
  }

  static void renewalEditExpiryDetailsclearFields() {
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
    membersNum.text = "";
    familyDefination.text = "";
    dependentMember.text = "";
    familiesNum.text = "";
    // membersNoInceptionForDependents.text="";
  }
}

class RenewalEditExpiryDetailsState extends State<RenewalEditExpiryDetails> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // debugger();
    expiryDetails();
  }

  bool validateExpiryDetails() {
    if (formKey.currentState == null) {
      return false; // Handle the case when formKey or currentState is null
    }
    bool status = formKey.currentState!.validate();
    return status;
  }

  late final LocalStorageProdId = widget.productId;
  late final LocalStorageProdCategoryId = widget.responseProdCategoryId;

  Future<void> expiryDetails() async {
    String rfid = widget.rfid;

    var headers = await ApiServices.getHeaders();
    Response response = await http.get(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.Renewal_EditExpiry_Details_EndPoint +
          rfid),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);

      setState(() {
        policyNumber.text = jsonData['policyNumber'];
        startPeriod.text = jsonData['startPeriod'];
        endPeriod.text = jsonData['endPeriod'];
        //  policyType.text = jsonData['policyType'];

        String premiumPaidInceptionValue = jsonData['premiumPaidInception'];
        premiumPaidInception.text = premiumPaidInceptionValue;
        //premiumPaidInceptionValue.toString();

        // premium.text = jsonData['premium'];
        String premiumValue = jsonData['premium'];
        premium.text = premiumValue;
        //premiumValue.toString();

        String additionPremiumValue = jsonData['additionPremium'];
        additionPremium.text = additionPremiumValue;
        //additionPremiumValue.toString();

        String deletionPremiumValue = jsonData['deletionPremium'];
        deletionPremium.text = deletionPremiumValue;
        // deletionPremiumValue.toString();
        // deletionPremium.text = jsonData['deletionPremium'];

        // policyType.text = jsonData['policyType'];

        String membersNoInceptionForDependentsvalue =
            jsonData['membersNoInceptionForDependents'];
        membersNoInceptionForDependents.text =
            membersNoInceptionForDependentsvalue;

        String additionsForDependentsvalue = jsonData['additionsForDependents'];
        additionsForDependents.text = additionsForDependentsvalue;

        String deletionsForDependentsvalue = jsonData['deletionsForDependents'];
        deletionsForDependents.text = deletionsForDependentsvalue;

        String totalMembersForDependentsvalue =
            jsonData['totalMembersForDependents'];
        totalMembersForDependents.text = totalMembersForDependentsvalue;

        String activeYearsValue = jsonData['activeYears'];
        activeYears.text = activeYearsValue;
        //activeYearsValue.toString();
        // activeYears.text = jsonData['activeYears'];

        String membersNoInceptionValue = jsonData['membersNoInception'];
        membersNoInception.text = membersNoInceptionValue;
        //membersNoInceptionValue.toString();
        // membersNoInception.text = jsonData['membersNoInception'];

        String additionsValue = jsonData['additions'];
        additions.text = additionsValue;
        print("*********************addition.text************");
        print(additions.text);
        // additionsValue.toString();
        // additions.text = jsonData['additions'];

        String deletionsValue = jsonData['deletions'];
        deletions.text = deletionsValue;
        // deletionsValue.toString();
        // deletions.text = jsonData['deletions'];

        String totalMembersValue = jsonData['totalMembers'];
        totalMembers.text = totalMembersValue;
        //totalMembersValue.toString();

        String MembersValue = jsonData['membersNum'];
        membersNum.text = MembersValue;
        // MembersValue.toString();

        dependentMember.text = jsonData['dependentMember'];

        familyDefination.text = jsonData['familyDefination'];

        //double familiesNumValue = jsonData['familiesNum'];
        familiesNum.text = jsonData['familiesNum'];
        // familiesNumValue.toString();
      });
      ('Expiring Detail saved successfully premium:');
    } else {
      ('Failed to save RenwalEditExpiry Details');
    }
  }

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

  List<String> productCategories = [
    'YES',
    'NO',
  ];

  List<String> AnyCategory = [
    'YES',
    'NO',
  ];
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
            if (LocalStorageProdCategoryId == 100 &&
                LocalStorageProdId == 1001) ...[
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
                                    "Expiry Details",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  elevation: 5,
                                  automaticallyImplyLeading: false,
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
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: startPeriodError == null ||
                                          startPeriodError!.isEmpty
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
                                        controller: startPeriod,
                                        readOnly:
                                            true, // Prevents manual text input
                                        decoration: InputDecoration(
                                          hintText: 'Start Date',
                                          hintStyle:
                                              GoogleFonts.poppins(fontSize: 13),
                                          suffixIcon: GestureDetector(
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
                                                startPeriod.text = DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(selectedStartDate);

                                                // Calculate the end date (one year later, minus one day)
                                                DateTime endDate = DateTime(
                                                        selectedStartDate.year +
                                                            1,
                                                        selectedStartDate.month,
                                                        selectedStartDate.day)
                                                    .subtract(
                                                        Duration(days: 1));

                                                endPeriod.text =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(endDate);
                                              }
                                            },
                                            child: Icon(
                                              Icons.calendar_month_sharp,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
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
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: endPeriodError == null ||
                                          endPeriodError!.isEmpty
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
                                        controller: endPeriod,
                                        readOnly:
                                            true, // Prevents manual text input
                                        decoration: InputDecoration(
                                          hintText: 'End Date',
                                          hintStyle:
                                              GoogleFonts.poppins(fontSize: 13),
                                          suffixIcon: GestureDetector(
                                            child: Icon(
                                              Icons.calendar_month_sharp,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
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
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    elevation: 5,
                                    automaticallyImplyLeading: false,
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
                                        controller: premiumPaidInception,
                                        decoration: InputDecoration(
                                          hintText: 'Premium Paid at Inception',
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
                                        controller: premium,
                                        decoration: InputDecoration(
                                          hintText: 'As on Date Premium',
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
                                        controller: additionPremium,
                                        decoration: InputDecoration(
                                          hintText: 'Addition Premium',
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
                                        controller: deletionPremium,
                                        decoration: InputDecoration(
                                          hintText: 'Deletion Premium',
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
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          policyType.text,
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
                                        controller: activeYears,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        onChanged: (value) {
                                          activeYears.text =
                                              value; // Update the value of the TextFormField
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Active Years',
                                          hintStyle:
                                              GoogleFonts.poppins(fontSize: 13),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            borderSide:
                                                BorderSide(color: Colors.white),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    // Align children to the left
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        toolbarHeight: SecureRiskColours.AppbarHeight,
                        backgroundColor: SecureRiskColours.Table_Heading_Color,
                        title: Text(
                          "Member Details Expiring Year",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        elevation: 5,
                        automaticallyImplyLeading: false,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Align children to the left
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller: membersNoInception,
                                        decoration: InputDecoration(
                                          hintText:
                                              'No.of Members at Inception',
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
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller: additions,
                                        decoration: InputDecoration(
                                          hintText: 'Additions During the year',
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
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller: deletions,
                                        decoration: InputDecoration(
                                          hintText: 'Deletion During the year',
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
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: totalMembersError == null ||
                                          totalMembersError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller: totalMembers,
                                        decoration: InputDecoration(
                                          hintText: 'Total Members as on Date',
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Align children to the left
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller:
                                            membersNoInceptionForDependents,
                                        decoration: InputDecoration(
                                          hintText:
                                              'No.of Members at Inception',
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
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller: additionsForDependents,
                                        decoration: InputDecoration(
                                          hintText: 'Additions During the year',
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
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller: deletionsForDependents,
                                        decoration: InputDecoration(
                                          hintText: 'Deletion During the year',
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
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: totalMembersError == null ||
                                          totalMembersError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        controller: totalMembersForDependents,
                                        decoration: InputDecoration(
                                          hintText: 'Total Members as on Date',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: AppBar(
                          toolbarHeight: SecureRiskColours.AppbarHeight,
                          backgroundColor:
                              SecureRiskColours.Table_Heading_Color,
                          title: Text(
                            "Renewal Details",
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
                                controller: membersNum,
                                decoration: InputDecoration(
                                  hintText: 'No.of Members to be Covered',
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
                                  hintText: 'Dependent',
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
                            "Family Defination",
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
                        child: SizedBox(
                          height: familyDefinationError == null ||
                                  familyDefinationError!.isEmpty
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
                                controller: familyDefination,
                                decoration: InputDecoration(
                                  hintText: 'Family Defination',
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
                              ),
                            ),
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
                                controller: familiesNum,
                                decoration: InputDecoration(
                                  hintText: 'No.of Families',
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
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (LocalStorageProdId == 1001)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: AppBar(
                            toolbarHeight: SecureRiskColours.AppbarHeight,
                            backgroundColor:
                                SecureRiskColours.Table_Heading_Color,
                            title: Text(
                              "Family Details",
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
                        child: Text(
                          '''Family Defination whether additional children covered whether 
                      additional relationships covered (like brother/sister etc.)''',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color.fromRGBO(25, 26, 25, 1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CustomDropdown(
                          value: policyCoverage,
                          onChanged: (String? newValue) {
                            setState(() {
                              policyCoverage = newValue;
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
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                            '''Any revision required in family defination under renewal policy 
                      (please specify if Yes)''',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color.fromRGBO(25, 26, 25, 1))),
                      ),
                      Padding(
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
                      )
                    ],
                  ),
                ),
              )
            ] else ...[
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
                          Container(
                            width: screenWidth * 0.55,
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
                              automaticallyImplyLeading: false,
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
                              height:
                                  policyError == null || policyError!.isEmpty
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
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: startPeriodError == null ||
                                      startPeriodError!.isEmpty
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
                                    controller: startPeriod,
                                    readOnly:
                                        true, // Prevents manual text input
                                    decoration: InputDecoration(
                                      hintText: 'Start Date',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      suffixIcon: GestureDetector(
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
                                            endPeriod.text =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(endDate);
                                          }
                                        },
                                        child: Icon(
                                          Icons.calendar_month_sharp,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
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
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: endPeriodError == null ||
                                      endPeriodError!.isEmpty
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
                                    controller: endPeriod,
                                    readOnly:
                                        true, // Prevents manual text input
                                    decoration: InputDecoration(
                                      hintText: 'End Date',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      suffixIcon: GestureDetector(
                                        child: Icon(
                                          Icons.calendar_month_sharp,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: screenWidth * 0.55,
                            child: AppBar(
                              toolbarHeight: SecureRiskColours.AppbarHeight,
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
                              automaticallyImplyLeading: false,
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
                                    controller: premiumPaidInception,
                                    decoration: InputDecoration(
                                      hintText: 'Premium Paid at Inception',
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
                            child: Text("As on Date Premium",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color.fromRGBO(25, 26, 25, 1))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height:
                                  premiumError == null || premiumError!.isEmpty
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
                                    controller: premium,
                                    decoration: InputDecoration(
                                      hintText: 'As on Date Premium',
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
                                    controller: additionPremium,
                                    decoration: InputDecoration(
                                      hintText: 'Addition Premium',
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
                                    controller: deletionPremium,
                                    decoration: InputDecoration(
                                      hintText: 'Deletion Premium',
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
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Text(
                                      policyType.text,
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
                                    controller: activeYears,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly // Allow only numeric input
                                    ],
                                    onChanged: (value) {
                                      activeYears.text =
                                          value; // Update the value of the TextFormField
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Active Years',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 13),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
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
            ]
          ],
        ),
      ),
    );
  }
}
