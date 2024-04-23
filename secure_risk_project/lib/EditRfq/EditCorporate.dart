import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/FreshPolicyFields/CorporateDetails.dart';
import 'package:loginapp/FreshPolicyFields/CustonDropdown.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

late String? prodCategoryId;

late String productId;

final TextEditingController NameOftheInsurer = TextEditingController();

final TextEditingController Address = TextEditingController();

final TextEditingController EmailId = TextEditingController();
final TextEditingController policyType = TextEditingController();

final TextEditingController PhoneNumber = TextEditingController();

final TextEditingController NameOfTheIntermediary = TextEditingController();

// final TextEditingController Customdropdown = TextEditingController();

final TextEditingController IntermediateEmailId = TextEditingController();

final TextEditingController IntermediateContactName = TextEditingController();

final TextEditingController ContactName = TextEditingController();

final TextEditingController IntermediatePhoneNumber = TextEditingController();

final TextEditingController nameOfTheTpa = TextEditingController();

final TextEditingController TpaContactName = TextEditingController();

final TextEditingController TpaEmail = TextEditingController();

final TextEditingController TpaPhoneNumber = TextEditingController();

final TextEditingController appStatus = TextEditingController();

final TextEditingController createDate = TextEditingController();

String? EditFreshCropNatureofBusiness;

List<Location> locations = [];
int? selectedLocationId = 253;
String selectedLocation = "Mumbai";

// ignore: must_be_immutable
class EditCorporateDetails extends StatefulWidget {
  late String rfid;

  EditCorporateDetails({super.key, required this.rfid});

  @override
  EditCorporateDetailsState createState() => EditCorporateDetailsState();

  Future<void> updateCorporateDetails(BuildContext context) async {
    var body = {
      "productId": productId,
      "productCategoryId": prodCategoryId,
      "policyType": policyType.text,
      "insuredName": NameOftheInsurer.text,
      "address": Address.text,
      "nob": EditFreshCropNatureofBusiness,
      "nobCustom": customdropdownfield.text,
      "contactName": ContactName.text,
      "email": EmailId.text,
      "phNo": PhoneNumber.text,
      "intermediaryName": NameOfTheIntermediary.text,
      "intermediaryContactName": IntermediateContactName.text,
      "intermediaryEmail": IntermediateEmailId.text,
      "intermediaryPhNo": IntermediatePhoneNumber.text,
      "tpaName": nameOfTheTpa.text,
      "tpaContactName": TpaContactName.text,
      "tpaEmail": TpaEmail.text,
      "tpaPhNo": TpaPhoneNumber.text,
      "location": selectedLocationId
    };

    var headers = await ApiServices.getHeaders();
    Response response = await http.patch(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.Update_Corporate_Details_EndPoint +
          rfid),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CorporateDetails saved successfully',
      );
      await http.get(Uri.parse(ApiServices.all_Rfq_Endpoint));
    } else if (response.statusCode == 403) {
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CorporateDetails failed to save...!',
      );
    }
  }
}

class EditCorporateDetailsState extends State<EditCorporateDetails> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _nameOfTheBusinessHasError = "";

  bool isCustomNatureAdded = false;

  bool validateDetails() {
    if (NatureofBusiness == null || NatureofBusiness!.isEmpty == true) {
      setState(() {
        _nameOfTheBusinessHasError = 'Please select an option';
      });
    } else {
      setState(() {
        _nameOfTheBusinessHasError = 'Please select an option';
      });
    }
    if (formKey.currentState == null) {
      return false; // Handle the case when formKey or currentState is null
    }

    bool status = formKey.currentState!.validate();

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

  Map<String, dynamic> apiData = {};
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
        NameOftheInsurer.text = jsonData["corporateDetails"]['insuredName'];
        Address.text = jsonData["corporateDetails"]['address'];
        appStatus.text = jsonData["corporateDetails"]['appStatus'];
        createDate.text = jsonData["corporateDetails"]['createDate'];
        ContactName.text = jsonData["corporateDetails"]['contactName'];
        EmailId.text = jsonData["corporateDetails"]['email'];
        policyType.text = jsonData["corporateDetails"]['policyType'];
        prodCategoryId =
            jsonData["corporateDetails"]['prodCategoryId'].toString();
        PhoneNumber.text = jsonData["corporateDetails"]['phNo'];
        EditFreshCropNatureofBusiness = jsonData["corporateDetails"]['nob'];
        customdropdownfield.text = jsonData['corporateDetails']['nobCustom'];
        productId = jsonData["corporateDetails"]['productId'].toString();
        IntermediateEmailId.text =
            jsonData["corporateDetails"]['intermediaryEmail'];
        IntermediateContactName.text =
            jsonData["corporateDetails"]['intermediaryContactName'];
        NameOfTheIntermediary.text =
            jsonData["corporateDetails"]['intermediaryName'];
        IntermediatePhoneNumber.text =
            jsonData["corporateDetails"]['intermediaryPhNo'];

        setEditprodCategoryId();
      });
    } else {}
  }

  void setEditprodCategoryId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('EditprodCategoryId', productId);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getCorporateDetails();
    getAllnatureOfBusiness();
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

  String? _nameOftheInsurerHasError = ""; // Track validation error
  // ignore: unused_field
  String? _EditCropNameOfTheBusinessHasError = ""; // Track validation error
  String? _phoneNumberHasError = ""; // Track validation error
  String? _addressControllerHasError = ""; // Track validation error
  String? _emailIdHasError = ""; // Track validation error
  String? _nameOfTheIntermediaryHasError = ""; // Track validation error
  String? _intermediateEmailIdHasError = ""; // Track validation error
  String? _intermediateContactNameHasError = ""; // Track validation error
  String? _contactNameHasError = ""; // Track validation error
  String? _intermediatePhoneNumberError = ""; // Track validation error
  String? _locationError = "";
  String? _customNatureofBussiness = "";

  List<String> productCategories = [];
  void clearValidationErrors() {
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context as BuildContext).size.height;
    double screenWidth = MediaQuery.of(context as BuildContext).size.width;

    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: IntrinsicHeight(
          child: Row(
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
                              AppBar(
                                toolbarHeight: SecureRiskColours.AppbarHeight,
                                backgroundColor:
                                    SecureRiskColours.Table_Heading_Color,
                                title: Text(
                                  "Details",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                elevation: 5,
                                automaticallyImplyLeading: false,
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
                                        controller: NameOftheInsurer,
                                        onChanged: (_) =>
                                            clearValidationErrors(),
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
                                                Radius.circular(3)),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          _nameOftheInsurerHasError =
                                              validateString(value);
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
                                padding: EdgeInsets.only(top: 10.0),
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
                                        onChanged: (_) =>
                                            clearValidationErrors(),
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
                                                Radius.circular(3)),
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
                                      value: EditFreshCropNatureofBusiness,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          EditFreshCropNatureofBusiness =
                                              newValue;
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
                                        ...productCategories.toSet()
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
                              ),
                              if (EditFreshCropNatureofBusiness == 'Custom')
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        child: TextFormField(
                                          onChanged: (_) =>
                                              clearValidationErrors(),
                                          controller: customdropdownfield,
                                          decoration: InputDecoration(
                                            hintText: 'Custom Business',
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: 13),
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
                                padding: EdgeInsets.only(top: 8.0),
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
                                        onChanged: (_) =>
                                            clearValidationErrors(),
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
                                        onChanged: (_) =>
                                            clearValidationErrors(),
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
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Phone Number",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        child: TextFormField(
                                          onChanged: (_) =>
                                              clearValidationErrors(),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly // Allow only numeric input
                                          ],
                                          controller: PhoneNumber,
                                          decoration: InputDecoration(
                                             contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                            hintText: 'Phone Number',
                                            hintStyle: GoogleFonts.poppins(
                                                fontSize: 13),
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
                height: screenHeight * 0.98,
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
                        padding: EdgeInsets.only(top: 02),
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
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
                                      onChanged: (_) => clearValidationErrors(),
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
                                            color: Color.fromARGB(
                                                255, 151, 16, 16),
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
                                      onChanged: (_) => clearValidationErrors(),
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
                              child: Text("Emaill Id",
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
                                      onChanged: (_) => clearValidationErrors(),
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
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: _intermediatePhoneNumberError ==
                                              null ||
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly // Allow only numeric input
                                        ],
                                        controller: IntermediatePhoneNumber,
                                        onChanged: (_) =>
                                            clearValidationErrors(),
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
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: 70.0,
                                width: 300.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: 70.0,
                                width: screenWidth * 0.23,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
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
