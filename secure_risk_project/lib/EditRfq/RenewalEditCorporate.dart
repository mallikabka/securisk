import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/FreshPolicyFields/CustonDropdown.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
final TextEditingController customdropdownfield = TextEditingController();
late int ProducId;

late int? ProductCategoryId;

final TextEditingController appStatus = TextEditingController();

final TextEditingController createDate = TextEditingController();

String? EditNatureofBussiness;
String? editTpaDetails;
List<Location> locations = [];
int? selectedLocationId = 252;
String selectedLocation = "Pune";

// ignore: must_be_immutable
class RenewalEditCorporateDetails extends StatefulWidget {
  late String rfid;
  final dynamic productId;
  final dynamic responseProdCategoryId;
  RenewalEditCorporateDetails(
      {super.key,
      required this.rfid,
      required this.productId,
      required this.responseProdCategoryId});

  @override
  RenewalEditCorporateDetailsState createState() =>
      RenewalEditCorporateDetailsState();
  String nameOfTheBusinessError = "";

  Future<void> updateRenewalCorporateDetails() async {
    var body = {
      "productId": productId,
      "productCategoryId": responseProdCategoryId,
      "policyType": policyType.text,
      "insuredName": NameOftheInsurer.text,
      "address": Address.text,
      "nob": EditNatureofBussiness,
      "nobCustom": customdropdownfield.text,
      "contactName": ContactName.text,
      "email": EmailId.text,
      "phNo": PhoneNumber.text,
      "intermediaryName": NameOfTheIntermediary.text,
      "intermediaryContactName": IntermediateContactName.text,
      "intermediaryEmail": IntermediateEmailId.text,
      "intermediaryPhNo": IntermediatePhoneNumber.text,
      "appStatus": appStatus.text,
      "createDate": createDate.text,
      "tpaName": editTpaDetails,
      "tpaContactName": TpaContactName.text,
      "tpaEmail": TpaEmail.text,
      "tpaPhNo": TpaPhoneNumber.text,
      "location": selectedLocationId
    };

    var headers = await ApiServices.getHeaders();

    Response response = await http.patch(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.update_Renewal_CorporateDetails_EndPoint +
          rfid),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {}
  }
}

class RenewalEditCorporateDetailsState
    extends State<RenewalEditCorporateDetails> {
  // bool isVisible = false;
  Map<String, dynamic> apiData = {};

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
        // ProductCategoryId = jsonData["corporateDetails"]['prodCategoryId'];
        // ProducId = jsonData["corporateDetails"]['productId'];
        NameOftheInsurer.text = jsonData["corporateDetails"]['insuredName'];
        Address.text = jsonData["corporateDetails"]['address'];
        ContactName.text = jsonData["corporateDetails"]['contactName'];
        EmailId.text = jsonData["corporateDetails"]['email'];
        policyType.text = jsonData["corporateDetails"]['policyType'];
        PhoneNumber.text = jsonData["corporateDetails"]['phNo'];
        EditNatureofBussiness = jsonData["corporateDetails"]['nob'];
        customdropdownfield.text = jsonData['corporateDetails']['nobCustom'];
        IntermediateEmailId.text =
            jsonData["corporateDetails"]['intermediaryEmail'];
        IntermediateContactName.text =
            jsonData["corporateDetails"]['intermediaryContactName'];
        NameOfTheIntermediary.text =
            jsonData["corporateDetails"]['intermediaryName'];
        IntermediatePhoneNumber.text =
            jsonData["corporateDetails"]['intermediaryPhNo'];

        appStatus.text = jsonData["corporateDetails"]['appStatus'];

        createDate.text = jsonData["corporateDetails"]['createDate'];

        editTpaDetails = jsonData["corporateDetails"]['tpaName'];
        TpaContactName.text =
            jsonData["corporateDetails"]['tpaContactName'] ?? "";
        TpaEmail.text = jsonData["corporateDetails"]['tpaEmail'] ?? "";
        TpaPhoneNumber.text = jsonData["corporateDetails"]['tpaPhNo'] ?? "";
        //selectedLocationId=jsonData["corporateDetails"]['location']??"";
        saveTpaNameToLocalStorage();
      });
    } else {}
  }

  List<String> tpaList = [];

  Future<void> fetchTpaList() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.Tpa_List_EndPoint),
        headers: headers);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      final data = json.decode(response.body);
      if (data is List<dynamic>) {
        setState(() {
          tpaList = data.map((item) => item.toString()).toList();
        });
      }
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load TPA list');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getAllnatureOfBusiness();
    fetchTpaList();
    getByIdCorporateDetails();
  }

  void clearValidationErrors() {
    setState(() {});
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateEditCorporateDetails() {
    if (EditNatureofBussiness == null ||
        EditNatureofBussiness!.isEmpty == true) {
      setState(() {
        _natureOfTheBusinessHasError = 'Please select an option';
      });
    } else {
      setState(() {
        _natureOfTheBusinessHasError = null;
      });
    }

    if (editTpaDetails == null) {
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

    setState(() {});

    if (widget.responseProdCategoryId == 100 && widget.productId == 1001) {
      if (editTpaDetails == null || EditNatureofBussiness == null) {
        return false;
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

  String? _locationError = "";
  String? _nameOftheInsurerHasError = ""; // Track validation error
  String? _natureOfTheBusinessHasError = ""; // Track validation error
  String? _phoneNumberHasError = ""; // Track validation error
  String? _addressControllerHasError = ""; // Track validation error
  String? _emailIdHasError = ""; // Track validation error
  String? _nameOfTheIntermediaryHasError = ""; // Track validation error
  String? _intermediateEmailIdHasError = ""; // Track validation error
  String? _intermediateContactNameHasError = ""; // Track validation error
  String? _contactNameHasError = ""; // Track validation error
  String? _intermediatePhoneNumberError = ""; // Track validation error
  String? _tpaContactNameError = ""; // Track validation error
  String? _tpaPhoneNumberError = ""; // Track validation error
  String? _tpaEmailError = ""; // Track validation error
  String? _tpaNameError = "";
  String? policyTypeErrorMessage;
  String? _customNatureofBussiness = "";

  List<String> productCategories = [
    
  ];
  Future<void> fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      var response = await http.get(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.dashboard_api_locationbased),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          locations = data.map((item) => Location.fromJson(item)).toList();
        });
      } else {
        throw Exception(
            'Failed to load location data. Status code: ${response.statusCode}');
      }
    } catch (e) {}
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

  bool isCustomNatureAdded = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;

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
                              child: AppBar(
                                toolbarHeight: SecureRiskColours.AppbarHeight,
                                backgroundColor:
                                    SecureRiskColours.Table_Heading_Color,
                                title: Text(
                                  "Details",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                elevation: 5,
                                automaticallyImplyLeading: false,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Name of Insurer/Proposer",
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
                                      controller: NameOftheInsurer,
                                      decoration: InputDecoration(
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                        hintText: 'Name of Insurer/Proposer',
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
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                              child: Text("Nature Of Business",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            SizedBox(
                              width: screenWidth * 0.23,
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      // Set the border properties
                                      color: Color.fromARGB(9, 214, 15,
                                          15), // Set the desired border color here
                                      width: 2.0, // Set the border width
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optionally, add border radius
                                  ),
                                  child: CustomDropdown(
                                    value: EditNatureofBussiness,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        EditNatureofBussiness = newValue;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          'Nature of the Business',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12.0,
                                            color: Color.fromARGB(
                                                255, 146, 146, 146),
                                          ),
                                        ), // default label
                                      ),
                                      ...productCategories.toSet().map((String option) {
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
                            ),
                            if (EditNatureofBussiness == 'Custom')
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: _customNatureofBussiness == null ||
                                          _customNatureofBussiness!.isEmpty
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
                                        onChanged: (_) =>
                                            clearValidationErrors(),
                                        controller: customdropdownfield,
                                        decoration: InputDecoration(
                                          hintText: 'Custom Business',
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
                                            if (_customNatureofBussiness ==
                                                    null &&
                                                !isCustomNatureAdded) {
                                              // Add the custom nature of business to the list if it's valid
                                              addNatureOfBusiness(
                                                  customdropdownfield.text);
                                              isCustomNatureAdded =
                                                  true; // Set flag to true
                                            }
                                            getAllnatureOfBusiness();
                                          });
                                          return _contactNameHasError;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Contact Name",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: _contactNameHasError == null ||
                                        _contactNameHasError!.isEmpty
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
                                      controller: ContactName,
                                      decoration: InputDecoration(
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Phone Number",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                            ),
                            Container(
                              child: Padding(
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
                                        controller: PhoneNumber,
                                        decoration: InputDecoration(
                                           contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.0, bottom: 80),
                                    child: CustomDropdown<int>(
                                      value: selectedLocationId,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedLocationId = newValue;
                                        });
                                      },
                                      items: [
                                        // Default item
                                        DropdownMenuItem<int>(
                                          value: null,
                                          child: Text(
                                            selectedLocation,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        // Other items
                                        ...locations.map((Location location) {
                                          return DropdownMenuItem<int>(
                                            value: location.locationId,
                                            child: Text(
                                              location.locationName,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_locationError != null)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  _locationError!,
                                  style: GoogleFonts.poppins(
                                      color: Color.fromARGB(
                                        255,
                                        138,
                                        29,
                                        29,
                                      ),
                                      fontSize: 13),
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
              height: screenHeight * 0.5,
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
                            AppBar(
                              toolbarHeight: SecureRiskColours.AppbarHeight,
                              backgroundColor:
                                  SecureRiskColours.Table_Heading_Color,
                              title: Text(
                                "Intermediary Details",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              elevation: 5,
                              automaticallyImplyLeading: false,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Name of the Intermediary",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
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
                                      controller: NameOfTheIntermediary,
                                      decoration: InputDecoration(
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Contact Name",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height:
                                    _intermediateContactNameHasError == null ||
                                            _intermediateContactNameHasError!
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
                                      controller: IntermediateContactName,
                                      decoration: InputDecoration(
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                                height: _intermediateEmailIdHasError == null ||
                                        _intermediateEmailIdHasError!.isEmpty
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
                                      controller: IntermediateEmailId,
                                      decoration: InputDecoration(
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                                height: _intermediatePhoneNumberError == null ||
                                        _intermediatePhoneNumberError!.isEmpty
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
                                      controller: IntermediatePhoneNumber,
                                      decoration: InputDecoration(
                                         contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
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
                                          _intermediatePhoneNumberError =
                                              validatePhoneNumber(value);
                                        });
                                        return _intermediatePhoneNumberError;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // if (isVisible)
                            SizedBox(
                              height: 10,
                            ),
                            if (widget.responseProdCategoryId == 100 &&
                                widget.productId == 1001)
                              Container(
                                width: screenWidth * 0.55,
                                child: Column(
                                  children: [
                                    AppBar(
                                      toolbarHeight:
                                          SecureRiskColours.AppbarHeight,
                                      backgroundColor:
                                          SecureRiskColours.Table_Heading_Color,
                                      title: Text(
                                        "TPA Details",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      elevation: 5,
                                      automaticallyImplyLeading: false,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Name Of TPA",
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
                                              value: editTpaDetails,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  editTpaDetails = newValue;

                                                  saveTpaNameToLocalStorage();
                                                });
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
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.0,
                                                    ),
                                                  ), // default label
                                                ),
                                                ...tpaList.map((String option) {
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
                                      padding: EdgeInsets.only(top: 5.0),
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
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          height: _tpaContactNameError ==
                                                      null ||
                                                  _tpaContactNameError!.isEmpty
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
                                                controller: TpaContactName,
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
                                            padding: EdgeInsets.only(bottom: 2),
                                            child: Material(
                                              shadowColor: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3)),
                                              child: TextFormField(
                                                controller: TpaEmail,
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
                                          height: _tpaPhoneNumberError ==
                                                      null ||
                                                  _tpaPhoneNumberError!.isEmpty
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
                                                controller: TpaPhoneNumber,
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
                                    // Rest of your UI code for TPA details
                                    // ...
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
}

class Location {
  final int locationId;
  final String locationName;

  Location({required this.locationId, required this.locationName});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationId'],
      locationName: json['locationName'],
    );
  }
}

Future<void> saveTpaNameToLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  if (editTpaDetails != null) {
    await prefs.setString('tpaName', editTpaDetails!);
  }
}
