import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/FreshPolicyFields/CorporateDetails.dart';
import 'package:loginapp/Utilities/CustomAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../FreshPolicyFields/CustonDropdown.dart';
import '../Service.dart';
import 'RenewalCoverageDetails.dart';

final TextEditingController NameOftheInsurer = TextEditingController();
// final TextEditingController NameOfTheBussiness = TextEditingController();
// final TextEditingController NatureOfTheBusiness = TextEditingController();
final TextEditingController Address = TextEditingController();
final TextEditingController EmailId = TextEditingController();
final TextEditingController PhoneNumber = TextEditingController();
final TextEditingController NameOfTheIntermediary = TextEditingController();
final TextEditingController IntermediateEmailId = TextEditingController();
final TextEditingController IntermediateContactName = TextEditingController();
final TextEditingController ContactName = TextEditingController();
final TextEditingController IntermediatePhoneNumber = TextEditingController();
final TextEditingController tpaName = TextEditingController();
final TextEditingController tpaContactName = TextEditingController();
final TextEditingController tpaEmail = TextEditingController();
final TextEditingController tpaPhNo = TextEditingController();
String? RenewalNatureofBussiness;
String? tpaDetails;

class RenewalCorporateDetails extends StatefulWidget {
  final GlobalKey<RenewalCoverageDetailsState>? renewalcoverageDetals;

  RenewalCorporateDetails({Key? key, this.renewalcoverageDetals})
      : super(key: key);
  @override
  State<RenewalCorporateDetails> createState() =>
      RenewalCorporateDetailsState();

  Future<void> renewalsaveCorporateDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var headers = await ApiServices.getHeaders();

    final LocalStoragePolicyType = prefs.getString('policyType');

    final LocalStorageProdCategoryId = prefs.getInt('prodCategoryId');

    final LocalStorageProdId = prefs.getInt('productId');

    var body = {
      "prodCategoryId": LocalStorageProdCategoryId,
      "productId": LocalStorageProdId,
      "policyType": LocalStoragePolicyType,
      "appStatus": "Pending",
      "insuredName": NameOftheInsurer.text,
      "address": Address.text,
      "nob": RenewalNatureofBussiness,
      "nobCustom": customdropdownfield.text,
      "contactName": ContactName.text,
      "email": EmailId.text,
      "phNo": PhoneNumber.text,
      "intermediaryName": NameOfTheIntermediary.text,
      "intermediaryContactName": IntermediateContactName.text,
      "intermediaryEmail": IntermediateEmailId.text,
      "intermediaryPhNo": IntermediatePhoneNumber.text,
      "tpaName": tpaDetails ?? "",
      "tpaContactName": tpaContactName.text,
      "tpaEmail": tpaEmail.text,
      "tpaPhNo": tpaPhNo.text
    };

    Response response = await post(
        Uri.parse(ApiServices.baseUrl + ApiServices.renewal_Corporate_Details),
        headers: headers,
        body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = response.body;

      // ignore: unused_local_variable
      final LocalStorageResponseBody =
          prefs.setString('responseBody', responseBody);
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CorporateDetails saved successfully',
      );
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CorporateDetails failed to save...!',
      );
    }
  }

  static void clearFields() {
    NameOftheInsurer.text = "";
    Address.text = "";
    EmailId.text = "";
    PhoneNumber.text = "";
    NameOfTheIntermediary.text = "";
    IntermediateEmailId.text = "";
    IntermediateContactName.text = "";
    ContactName.text = "";
    IntermediatePhoneNumber.text = "";
    tpaContactName.text = "";
    tpaEmail.text = "";
    tpaPhNo.text = "";
    tpaDetails = null;
    RenewalNatureofBussiness = null;
    customdropdownfield.text = '';
  }
}

class RenewalCorporateDetailsState extends State<RenewalCorporateDetails> {
  final alphabetsAndSpace = RegExp(r'[a-zA-Z ]');
  late int localStorageProdCategoryId;
  late int localStorageproductId;
  List<Map<String, dynamic>> tpalist = [];
  bool isVisible = false;
  Future<void> getProdCategoryId() async {
    final prefs = await SharedPreferences.getInstance();
    localStorageProdCategoryId = prefs.getInt('prodCategoryId') ?? 0;
    localStorageproductId = prefs.getInt('productId') ?? 0;
    isVisible = true;
  }

  List<String> tpaList = [];

  Future<void> fetchTpaList() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.Tpa_List_EndPoint),
        headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List<dynamic>) {
        setState(() {
          tpaList = data.map((item) => item.toString()).toList();
        });
      }
    } else {
      throw Exception('Failed to load TPA list');
    }
  }

  Future<void> getAllnatureOfBusiness() async {
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.get(
          Uri.parse(ApiServices.baseUrl + ApiServices.getAllnatureOfBusiness),
          headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        List<String> nameofNatureofBusiness = data
            .map((map) => map['nameofNatureofBusiness'].toString())
            .toList();
        setState(() {
          // productCategories.addAll(nameofNatureofBusiness);
          productCategories = nameofNatureofBusiness;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (exception) {
      print('Exception: $exception');
    }
  }

  Future<void> addNatureOfBusiness(String? natureofBusiness) async {
    ("api call made");

    final Map<String, dynamic> requestBody = {
      "nameofNatureofBusiness": natureofBusiness
    };
    (requestBody);
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.saveNatureofBusiness),
        body: jsonEncode(requestBody),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        (response.body);
        productCategories.toSet().add(natureofBusiness!);
        await getAllnatureOfBusiness();
      } else {
        ('Error: ${response.statusCode}');
      }
    } catch (exception) {
      ('Exception: $exception');
    }
  }

//   // class CorporateDetailsState extends State<CorporateDetails> {
//   Widget buildAppBar(String title) {
//     return AppBar(
//       toolbarHeight: 35, // Change this to your desired app bar height
//       backgroundColor: SecureRiskColours
//           .Table_Heading_Color, // Change this to your desired color
//       title: Text(
//         title,
//         style: GoogleFonts.poppins(
//           color: Colors.white,
//           fontSize: 14,
//           // fontWeight: FontWeight.bold,
//         ),
//       ),
//       elevation: 5,
//     );
//   }
// }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProdCategoryId();
    getAllnatureOfBusiness();
    fetchTpaList();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateDetails() {
    if (RenewalNatureofBussiness == null ||
        RenewalNatureofBussiness!.isEmpty == true) {
      setState(() {
        _natureOfTheBusinessHasError = 'Please select an option';
      });
    } else {
      setState(() {
        _natureOfTheBusinessHasError = null;
      });
    }

    if (tpaDetails == null) {
      setState(() {
        _tpaNameError = 'Please select an option';
      });
    } else {
      setState(() {
        _tpaNameError = null;
      });
    }

    if (formKey.currentState == null) {
      return false; // Handle the case when formKey or currentState is null
    }

    bool status = formKey.currentState!.validate();
    if (isVisible) {
      if (localStorageProdCategoryId == 100 && localStorageproductId == 1001) {
        if (tpaDetails == null || RenewalNatureofBussiness == null) {
          return false;
        }
      }
    }

    return status;
  }

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final RegExp emailRegex =
        RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    } else if (!emailRegex.hasMatch(value!)) {
      return "Invalid email address";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    } else if (!phoneRegex.hasMatch(value!)) {
      return "Invalid Phone number";
    }
    return null;
  }

  bool nameOfTheBusinessHasError = false;

  bool showNameError = false;
  bool showAddressError = false;

  String? _nameOftheInsurerHasError = "";
  String? _natureOfTheBusinessHasError = "";
  String? _phoneNumberHasError = "";
  String? _addressControllerHasError = "";
  String? _emailIdHasError = "";
  String? _nameOfTheIntermediaryHasError = "";
  String? _intermediateEmailIdHasError = "";
  String? _intermediateContactNameHasError = "";
  String? _contactNameHasError = "";
  String? _intermediatePhoneNumberError = "";
  String? _tpaContactNameError = "";
  String? _tpaPhoneNumberError = "";
  String? _tpaEmailError = "";
  String? _tpaNameError = "";
  String? _customNatureofBussiness = "";
  String? policyTypeErrorMessage;

  void clearValidationErrors() {
    setState(() {});
  }

  List<String> productCategories = [];

  final RegExp alphabetsOnly = RegExp(r'^[a-zA-Z]+$');

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isCustomNatureAdded = false;

    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                  "Details",
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
                              child: Text("Name of Insured/Proposer",
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
                                      // inputFormatters: [
                                      //   // FilteringTextInputFormatter.allow(alphabetsOnly)
                                      //   FilteringTextInputFormatter.allow(
                                      //       alphabetsAndSpace),
                                      // ],
                                      controller: NameOftheInsurer,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        hintText: 'Name of Insured/Proposer',
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
                                          _nameOftheInsurerHasError =
                                              validateString(value);
                                        });
                                        return _nameOftheInsurerHasError;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Address",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _addressControllerHasError == null ||
                                        _addressControllerHasError!.isEmpty
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
                                      controller: Address,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        hintText: 'Address',
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
                                          _addressControllerHasError =
                                              validateString(value);
                                        });
                                        return _addressControllerHasError;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Nature of Business",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            SizedBox(
                              width: screenWidth * 0.23,
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: CustomDropdown(
                                  value: RenewalNatureofBussiness,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      RenewalNatureofBussiness = newValue;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text(
                                        'Nature of The Business',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          color: Color.fromARGB(
                                              255, 146, 146, 146),
                                        ),
                                      ), // default label
                                    ),
                                    ...productCategories
                                        .toSet()
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
                            if (_natureOfTheBusinessHasError != null)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  _natureOfTheBusinessHasError!,
                                  style: GoogleFonts.poppins(color: Colors.red),
                                ),
                              ),
                            if (RenewalNatureofBussiness == 'Custom') ...[
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(" Custom Nature of Business",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              SizedBox(
                                height: _customNatureofBussiness == null ||
                                        _customNatureofBussiness!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    onChanged: (_) => clearValidationErrors(),
                                    controller: customdropdownfield,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      hintText: 'Custom Nature Of Business',
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
                                    //     _customNatureofBussiness =
                                    //         validateString(value);
                                    //   });
                                    //   return _customNatureofBussiness;
                                    // },

                                    validator: (value) {
                                      setState(() {
                                        _customNatureofBussiness =
                                            validateCustomNature(value);
                                        if (_customNatureofBussiness == null &&
                                            !isCustomNatureAdded) {
                                          // Add the custom nature of business to the list if it's valid
                                          addNatureOfBusiness(
                                              customdropdownfield.text);
                                          isCustomNatureAdded =
                                              true; // Set flag to true
                                        }
                                        getAllnatureOfBusiness();
                                      });
                                      return _customNatureofBussiness;
                                    },
                                  ),
                                ),
                              ),
                            ],
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Contact Name",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _contactNameHasError == null ||
                                        _contactNameHasError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    inputFormatters: [
                                      // FilteringTextInputFormatter.allow(alphabetsAndSpace)
                                      FilteringTextInputFormatter.allow(
                                          alphabetsAndSpace),
                                    ],
                                    controller: ContactName,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      hintText: 'Contact Name',
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
                                        _contactNameHasError =
                                            validateString(value);
                                      });
                                      return _contactNameHasError;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Email Id",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _emailIdHasError == null ||
                                        _emailIdHasError!.isEmpty
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
                                      controller: EmailId,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        hintText: 'Email Id',
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
                                          _emailIdHasError =
                                              validateEmail(value);
                                        });
                                        return _emailIdHasError;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Phone Number",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: _phoneNumberHasError == null ||
                                        _phoneNumberHasError!.isEmpty
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
                                      onChanged: (_) => clearValidationErrors(),
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: PhoneNumber,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        hintText: 'Phone Number',
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
                                          _phoneNumberHasError =
                                              validatePhoneNumber(value);
                                        });
                                        return _phoneNumberHasError;
                                      },
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
              height: screenHeight * 1.1,
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
                      padding: EdgeInsets.only(left: 10.0),
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
                                  "Intermediary Details",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                elevation: 5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text("Name of the Intermediary",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: SizedBox(
                                height: _nameOfTheIntermediaryHasError ==
                                            null ||
                                        _nameOfTheIntermediaryHasError!.isEmpty
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
                                        FilteringTextInputFormatter.allow(
                                            alphabetsAndSpace)
                                      ],
                                      controller: NameOfTheIntermediary,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        hintText: 'Name of the Intermediary',
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
                                          _nameOfTheIntermediaryHasError =
                                              validateString(value);
                                        });
                                        return _nameOfTheIntermediaryHasError;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text("Contact Name",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: SizedBox(
                                height:
                                    _intermediateContactNameHasError == null ||
                                            _intermediateContactNameHasError!
                                                .isEmpty
                                        ? 40.0
                                        : 65.0,
                                width: screenWidth * 0.23,
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          alphabetsAndSpace)
                                    ],
                                    controller: IntermediateContactName,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      hintText: 'Contact Name',
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
                                        _intermediateContactNameHasError =
                                            validateString(value);
                                      });
                                      return _intermediateContactNameHasError;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text("Email Id",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: SizedBox(
                                height: _intermediateEmailIdHasError == null ||
                                        _intermediateEmailIdHasError!.isEmpty
                                    ? 40.0
                                    : 65.0,
                                width: screenWidth * 0.23,
                                child: Material(
                                  shadowColor: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: TextFormField(
                                    controller: IntermediateEmailId,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      hintText: 'Email Id',
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
                                        _intermediateEmailIdHasError =
                                            validateEmail(value);
                                      });
                                      return _intermediateEmailIdHasError;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: Text("Phone Number",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: _tpaPhoneNumberError == null ||
                                          _tpaPhoneNumberError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.23,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        onChanged: (_) =>
                                            clearValidationErrors(),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: IntermediatePhoneNumber,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          hintText: 'Phone Number',
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
                                            _tpaPhoneNumberError =
                                                validatePhoneNumber(value);
                                          });
                                          return _tpaPhoneNumberError;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (isVisible)
                              if (localStorageProdCategoryId == 100 &&
                                  localStorageproductId == 1001)
                                Container(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment
                                    //     .start, // Align children to the left
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align children to the start of the cross axis (left)
                                    children: [
                                      Container(
                                        width: screenWidth * 0.4,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: AppBar(
                                              toolbarHeight: SecureRiskColours
                                                  .AppbarHeight,
                                              backgroundColor: SecureRiskColours
                                                  .Table_Heading_Color,
                                              title: Text(
                                                "TPA Details",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              elevation: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Name of TPA",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      25, 26, 25, 1))),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: CustomDropdown<String>(
                                                value: tpaDetails,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    tpaDetails = newValue;
                                                    saveTpaNameToLocalStorage();
                                                    widget
                                                        .renewalcoverageDetals!
                                                        .currentState!
                                                        .getTpaNameFromLocalStorage();
                                                  });
                                                  saveTpaNameToLocalStorage();
                                                },
                                                validator: (value) {
                                                  if (value?.isEmpty ?? true) {
                                                    return 'Field is mandatory';
                                                  }
                                                  return null;
                                                },
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    child: Text(
                                                      '----TPA DETAILS----',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12.0,
                                                        color: Color.fromARGB(
                                                            255, 146, 146, 146),
                                                      ),
                                                    ), // default label
                                                  ),
                                                  ...tpaList
                                                      .map((String option) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: option,
                                                      child: Text(
                                                        option,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (_tpaNameError != null)
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                child: Text(
                                                  _tpaNameError!,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Contact Name",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      25, 26, 25, 1))),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            height:
                                                _tpaContactNameError == null ||
                                                        _tpaContactNameError!
                                                            .isEmpty
                                                    ? 40.0
                                                    : 65.0,
                                            width: screenWidth * 0.23,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Material(
                                                shadowColor: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            alphabetsAndSpace)
                                                  ],
                                                  controller: tpaContactName,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    hintText: 'Contact Name',
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
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(3),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .red, // Set the color to red
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    setState(() {
                                                      _tpaContactNameError =
                                                          validateString(value);
                                                    });
                                                    return _tpaContactNameError;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Email Id",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      25, 26, 25, 1))),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            height: _tpaEmailError == null ||
                                                    _tpaEmailError!.isEmpty
                                                ? 40.0
                                                : 65.0,
                                            width: screenWidth * 0.23,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Material(
                                                shadowColor: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                child: TextFormField(
                                                  controller: tpaEmail,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    hintText: 'Email Id',
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
                                                      _tpaEmailError =
                                                          validateEmail(value);
                                                    });
                                                    return _tpaEmailError;
                                                  },
                                                ),
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
                                            "Phone Number",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  Color.fromRGBO(25, 26, 25, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            height:
                                                _tpaPhoneNumberError == null ||
                                                        _tpaPhoneNumberError!
                                                            .isEmpty
                                                    ? 40.0
                                                    : 65.0,
                                            width: screenWidth * 0.23,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Material(
                                                shadowColor: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                child: TextFormField(
                                                  onChanged: (_) =>
                                                      clearValidationErrors(),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly // Allow only numeric input
                                                  ],
                                                  controller: tpaPhNo,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    hintText: 'Phone Number',
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
                                                      _tpaPhoneNumberError =
                                                          validatePhoneNumber(
                                                              value);
                                                    });
                                                    return _tpaPhoneNumberError;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//   String? validateCustomNature(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Custom Nature Of Business is required';
//     }
//     // Regular expression to match only alphabets and characters
//     RegExp regex = RegExp(r'^[a-zA-Z ]+$');
//     if (!regex.hasMatch(value)) {
//       return 'Please enter only alphabets and characters';
//     }
//     return null;
//   }
// }
  String? validateCustomNature(String? value) {
    if (value == null || value.isEmpty) {
      return 'Custom Nature Of Business is required';
    }
    // Regular expression to match only alphabets and spaces
    RegExp regex = RegExp(r'^[a-zA-Z ]+$');
    if (!regex.hasMatch(value)) {
      return 'Please enter only alphabets and spaces';
    }
    return null;
  }

  Future<void> saveTpaNameToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tpaName', tpaDetails!);
  }
}
