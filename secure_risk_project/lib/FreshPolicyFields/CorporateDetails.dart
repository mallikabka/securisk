import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/FreshPolicyFields/CustonDropdown.dart';
import 'package:loginapp/Service.dart';
import 'package:loginapp/Utilities/CustomAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

final TextEditingController NameOftheInsurer = TextEditingController();

final TextEditingController NameOfTheBusiness = TextEditingController();

final TextEditingController Address = TextEditingController();

final TextEditingController EmailId = TextEditingController();

final TextEditingController PhoneNumber = TextEditingController();

final TextEditingController NameOfTheIntermediary = TextEditingController();

final TextEditingController IntermediateEmailId = TextEditingController();

final TextEditingController IntermediateContactName = TextEditingController();

final TextEditingController ContactName = TextEditingController();

final TextEditingController IntermediatePhoneNumber = TextEditingController();

final TextEditingController customdropdownfield = TextEditingController();

String? NatureofBusiness;
int? selectedLocationId;
List<Location> locations = [];

List<String> productCategories = [];
// 'IT/ITES',
// 'Manufacturing',
// 'Pharma',
// 'Government',
// 'Infrastructure',
// 'Shipping',
// 'Processing',
// 'Agriculture',
// 'Custom'

// ignore: must_be_immutable
class CorporateDetails extends StatefulWidget {
  CorporateDetails({Key? key}) : super(key: key);

  @override
  State<CorporateDetails> createState() => CorporateDetailsState();
  String nameOfTheBusinessError = "";
  static void clearFields() {
    ("clearing fields");
    NameOftheInsurer.text = "";
    NameOfTheBusiness.text = "";
    Address.text = "";
    EmailId.text = "";
    PhoneNumber.text = "";
    NameOfTheIntermediary.text = "";
    IntermediateEmailId.text = "";
    IntermediateContactName.text = "";
    ContactName.text = "";
    IntermediatePhoneNumber.text = "";
    customdropdownfield.text = "";
    NatureofBusiness = null;
    selectedLocationId = null;
  }

  Future<void> saveCorporateDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final LocalStoragePolicyType = prefs.getString('policyType');

    final LocalStorageProdCategoryId = prefs.getInt('prodCategoryId');

    final LocalStorageProdId = prefs.getInt('productId');

    // ignore: unused_local_variable
    List<Location> locations = [];

    var headers = await ApiServices.getHeaders();
    var body = {
      "prodCategoryId": LocalStorageProdCategoryId,
      "productId": LocalStorageProdId,
      "policyType": LocalStoragePolicyType,
      "recordStatus": null,
      "appStatus": "Pending",
      "insuredName": NameOftheInsurer.text,
      "address": Address.text,
      "nob": NatureofBusiness,
      "nobCustom": customdropdownfield.text,
      "contactName": ContactName.text,
      "email": EmailId.text,
      //"customdropdown": customdropdownfield.text,
      "phNo": PhoneNumber.text,
      "intermediaryName": NameOfTheIntermediary.text,
      "intermediaryContactName": IntermediateContactName.text,
      "intermediaryEmail": IntermediateEmailId.text,
      "intermediaryPhNo": IntermediatePhoneNumber.text,
      "tpaName": "",
      "tpaContactName": "",
      "tpaEmail": "",
      "tpaPhNo": "",
      "location": "$selectedLocationId",
    };

    Response response = await http.post(
      Uri.parse(
          ApiServices.baseUrl + ApiServices.createCorporateDetails_Endpoint),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CorporateDetails saved successfully',
      );

      var responseBody = response.body;
      final LocalStorageResponseBody =
          prefs.setString('responseBody', responseBody);
      (LocalStorageResponseBody);
      ('CorporateDetails saved successfully' + responseBody);
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'CorporateDetails failed to save...!',
      );
      ('Failed to save CorporateDetails');
    }
  }
}

class CorporateDetailsState extends State<CorporateDetails> {
  // Widget buildAppBar(String title) {
  //   return AppBar(
  //     toolbarHeight: 35, // Change this to your desired app bar height
  //     backgroundColor: SecureRiskColours
  //         .Table_Heading_Color, // Change this to your desired color
  //     title: Text(
  //       title,
  //       style: GoogleFonts.poppins(
  //         color: Colors.white,
  //         fontSize: 14,
  //         // fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     elevation: 5,
  //   );
  //}

  void initState() {
    super.initState();
    getAllnatureOfBusiness();
    fetchData();
    // Set the default value to Hyderabad
    // selectedLocationId = 254;
    //  fetchData1();
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

  // Future<void> addNatureOfBusiness(String? natureofBusiness) async {
  //   ("api call made");

  //   final Map<String, dynamic> requestBody = {
  //     "nameofNatureofBusiness": natureofBusiness
  //   };
  //   (requestBody);
  //   try {
  //     var headers = await ApiServices.getHeaders();

  //     final response = await http.post(
  //       Uri.parse(ApiServices.baseUrl + ApiServices.saveNatureofBusiness),
  //       body: jsonEncode(requestBody),
  //       headers: headers,
  //     );
  //     print(response.body);
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       (response.body);
  //       productCategories.toSet().add(natureofBusiness!);
  //       await getAllnatureOfBusiness();
  //     } else {
  //       ('Error: ${response.statusCode}');
  //     }
  //   } catch (exception) {
  //     ('Exception: $exception');
  //   }
  // }

  Future<void> addNatureOfBusiness(String? natureofBusiness) async {
    print("api call made");

    final Map<String, dynamic> requestBody = {
      "nameofNatureofBusiness": natureofBusiness
    };
    print(requestBody);
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.saveNatureofBusiness),
        body: jsonEncode(requestBody),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.body);

        // Check if natureOfBusiness already exists in productCategories
        if (!productCategories.contains(natureofBusiness)) {
          productCategories.add(natureofBusiness!);
          await getAllnatureOfBusiness();
        } else {
          // Show error message if natureOfBusiness already exists
          print('Error: Nature of business already exists');
          // Here you can handle how you want to show the error message below the text field
          // For example, you can set a flag and display an error message in the UI
          // or use a Flutter SnackBar to show a temporary message.
        }
      } else {
        print('Error: ${response.statusCode}');
        // Here you can handle how you want to show the error message below the text field
      }
    } catch (exception) {
      print('Exception: $exception');
      // Here you can handle how you want to show the exception message below the text field
    }
  }

  final alphabetsAndSpace = RegExp(r'[a-zA-Z ]');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateDetails() {
    bool status = formKey.currentState!.validate();

   if (_customNatureofBussiness == null ||_customNatureofBussiness!.isEmpty == true)
       setState(() {
           _customNatureHasError = 'Field is mandatory';                                     
  
       });
        else {
      setState(() {
        _customNatureHasError = '';
      });
    }
      
    ("validating");
    if (NatureofBusiness == null || NatureofBusiness!.isEmpty == true) {
      setState(() {
        _nameOfTheBusinessHasError = 'Field is mandatory';
       
      });
    } 
    
    else {
      setState(() {
        _nameOfTheBusinessHasError = '';
      });
    }
    if (selectedLocationId == null) {
      setState(() {
        _locationError = 'Field is mandatory';
      });
    } else {
      setState(() {
        _locationError = '';
      });
    }
    if (formKey.currentState == null ||
        status == false ||
        NatureofBusiness == null ||
        NatureofBusiness!.isEmpty == true ||
        selectedLocationId == null) {
      return false;
    }

    return status;
  }

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }
  // String? validateInt(int? value) {
  //   if (value?. ?? true) {
  //     return 'Field is mandatory';
  //   }
  //   return null;
  // }

  String? validateEmail(String? value) {
    final RegExp emailRegex =
        RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    } else if (!emailRegex.hasMatch(value!)) {
      return "Invalid email address";
    } else if (value.substring(value.indexOf('@') + 1).split('.').length != 2) {
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
  String? _nameOfTheBusinessHasError = "";
  String? _customNatureHasError = "";
  String? _phoneNumberHasError = "";
  String? _addressControllerHasError = "";
  String? _emailIdHasError = "";
  String? _nameOfTheIntermediaryHasError = "";
  String? _intermediateEmailIdHasError = "";
  String? _intermediateContactNameHasError = "";
  String? _contactNameHasError = "";
  String? _customNatureofBussiness = "";
  String? _intermediatePhoneNumberError = "";
  String? _locationError = "";

  void clearValidationErrors() {
    setState(() {});
  }

  final RegExp alphabetsOnly = RegExp(r'^[a-zA-Z]+$');
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
    } catch (e) {
      print('Error fetching location data: $e');
      // Handle error state if necessary
      setState(() {
        _locationError = 'Error fetching location data';
      });
    }
  }

//changes
  @override
  Widget build(BuildContext context) {
    void test() {
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Login successfully',
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isCustomNatureAdded = false;
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
                              Container(
                                width: screenWidth * 0.4,
                                child: AppBarBuilder.buildAppBar('Details'),
                                //child: buildAppBar("Details"),
                                //   child: AppBar(
                                //     toolbarHeight: SecureRiskColours.AppbarHeight,
                                //     backgroundColor:
                                //         SecureRiskColours.Table_Heading_Color,
                                //     title: Text(
                                //       "Details",
                                //       style: GoogleFonts.poppins(
                                //         color: Colors.white,
                                //         fontSize: 14,
                                //         // fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     elevation: 5,
                                //   ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("Name of the Insured/Proposer",
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
                                      : 62.0,
                                  width: screenWidth * 0.22,
                                  child: Material(
                                    shadowColor: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    child: TextFormField(
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.allow(
                                      //       alphabetsAndSpace),
                                      // ],
                                      controller: NameOftheInsurer,
                                      maxLength: 27,
                                      onChanged: (_) => clearValidationErrors(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        hintText:
                                            'Name of the Insured/Proposer',
                                        hintStyle:
                                            GoogleFonts.poppins(fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        counterText: '',
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
                                  // height: 40.0,
                                  width: screenWidth * 0.22,
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
                                        maxLength: 27,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
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
                                          counterText: '',
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
                                width: screenWidth * 0.22,
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8),
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
                                      value: NatureofBusiness,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          NatureofBusiness = newValue;
                                        });
                                      },
                                      items: [
                                        DropdownMenuItem<String>(
                                          child: Text(
                                            'Nature of The Business',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12.0,
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
                              ),
                              if (_nameOfTheBusinessHasError != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    _nameOfTheBusinessHasError!,
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
                              if (NatureofBusiness == 'Custom') ...[
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text("Custom Nature Of Business",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(25, 26, 25, 1))),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(top: 0),
                                //   child: SizedBox(
                                //     height: _customNatureofBussiness == null ||
                                //             _customNatureofBussiness!.isEmpty
                                //         ? 40.0
                                //         : 65.0,
                                //     width: screenWidth * 0.22,
                                //     child: Padding(
                                //       padding: EdgeInsets.only(bottom: 1),
                                //       child: Material(
                                //           shadowColor: Colors.white,
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(3)),
                                //           child: TextFormField(
                                //             onChanged: (_) =>
                                //                 clearValidationErrors(),
                                //             controller: customdropdownfield,
                                //             decoration: InputDecoration(
                                //                contentPadding: EdgeInsets.symmetric(
                                //             horizontal: 10, vertical: 5),
                                //               hintText:
                                //                   'Custom Nature Of Business',
                                //               hintStyle: GoogleFonts.poppins(
                                //                   fontSize: 13),
                                //               border: OutlineInputBorder(
                                //                 borderRadius: BorderRadius.all(
                                //                   Radius.circular(3),
                                //                 ),
                                //                 borderSide: BorderSide(
                                //                   color: Colors.white,
                                //                 ),
                                //               ),
                                //             ),
                                //             validator: (value) {
                                //               setState(() {
                                //                 _customNatureofBussiness =
                                //                     validateString(value);
                                //                 if (_customNatureofBussiness ==
                                //                         null &&
                                //                     !isCustomNatureAdded) {
                                //                   // Add the custom nature of business to the list if it's valid
                                //                   addNatureOfBusiness(
                                //                       customdropdownfield.text);
                                //                   isCustomNatureAdded =
                                //                       true; // Set flag to true
                                //                 }
                                //                 getAllnatureOfBusiness();
                                //               });
                                //               return _customNatureofBussiness;
                                //             },
                                //           )),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            _customNatureofBussiness == null ||
                                                    _customNatureofBussiness!
                                                        .isEmpty
                                                ? 40.0
                                                : 65.0,
                                        width: screenWidth * 0.22,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 1),
                                          child: Material(
                                            shadowColor: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            child: TextFormField(
                                              onChanged: (_) =>
                                                  clearValidationErrors(),
                                              controller: customdropdownfield,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                hintText:
                                                    'Custom Nature Of Business',
                                                hintStyle: GoogleFonts.poppins(
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
                                            _customNatureHasError =
                                                validateString(value);
                                          });
                                          return _customNatureHasError;
                                        },
                                              // validator: (value) {
                                              //   setState(() {
                                              //     _customNatureofBussiness =
                                              //         validateString(value);
                                              //     if (_customNatureofBussiness ==
                                              //             null &&
                                              //         !isCustomNatureAdded) {
                                              //       // Add the custom nature of business to the list if it's valid
                                              //       addNatureOfBusiness(
                                              //           customdropdownfield
                                              //               .text);
                                              //       isCustomNatureAdded =
                                              //           true; // Set flag to true
                                              //     }
                                              //     getAllnatureOfBusiness();
                                              //   });
                                              //   return _customNatureofBussiness;
                                              // },
                                            ),
                                          ),
                                        ),
                                      ),
                                //       if (_customNatureHasError != null)
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 15),
                                //   child: Text(
                                //     _customNatureHasError!,
                                //     style: GoogleFonts.poppins(
                                //         color: Color.fromARGB(
                                //           255,
                                //           138,
                                //           29,
                                //           29,
                                //         ),
                                //         fontSize: 13),
                                //   ),
                                // ),
                                     
                                      if (_customNatureofBussiness != null &&
                                          productCategories.contains(
                                              customdropdownfield.text) && _customNatureHasError != null)
                                        Container(
                                          padding:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: Text(
                                            'Error: Nature of business already exists',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                         
                                        ),                                        
                                        
                                    ],
                                  ),
                                ),
                              ],

                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Text("Contact Name",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color.fromRGBO(25, 26, 25, 1))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: SizedBox(
                                  height: _contactNameHasError == null ||
                                          _contactNameHasError!.isEmpty
                                      ? 40.0
                                      : 65.0,
                                  width: screenWidth * 0.22,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Material(
                                      shadowColor: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              alphabetsAndSpace),
                                        ],
                                        maxLength: 27,
                                        onChanged: (_) =>
                                            clearValidationErrors(),
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
                                          counterText: '',
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
                                  width: screenWidth * 0.22,
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
                              Container(
                                width: screenWidth * 0.22,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    height: _phoneNumberHasError == null ||
                                            _phoneNumberHasError!.isEmpty
                                        ? 40.0
                                        : 65.0,
                                    // width: screenWidth * 0.22,
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
                                    SizedBox(
                                      width: screenWidth * 0.22,
                                      height: 50,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8.0),
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
                                                'Select location',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12.0,
                                                  color: Color.fromARGB(
                                                      255, 146, 146, 146),
                                                ),
                                              ),
                                            ),
                                            // Other items
                                            ...locations
                                                .map((Location location) {
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

                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10.0),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text(
                              //         'Location',
                              //         style: GoogleFonts.poppins(
                              //           fontSize: 16.0,
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(top: 8.0),
                              //         child: CustomDropdown<int>(
                              //           value: selectedLocationId,
                              //           onChanged: (int? newValue) {
                              //             setState(() {
                              //               selectedLocationId = newValue;
                              //             });
                              //           },
                              //           items:
                              //               locations.map((Location location) {
                              //             return DropdownMenuItem<int>(
                              //               // "Select location",
                              //               value: location.locationId,
                              //               child: Text(
                              //                 location.locationName,
                              //                 style: GoogleFonts.poppins(
                              //                   fontSize: 14.0,
                              //                 ),
                              //               ),
                              //             );
                              //           }).toList(),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.9,
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
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBarBuilder.buildAppBar('Intermediary Details'),
                            // AppBar(
                            //   toolbarHeight: SecureRiskColours.AppbarHeight,
                            //   backgroundColor:
                            //       SecureRiskColours.Table_Heading_Color,
                            //   title: Text(
                            //     "Intermediary Details",
                            //     style: GoogleFonts.poppins(
                            //       color: Colors.white,
                            //       fontSize: 14,
                            //       // fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            //   elevation: 5,
                            // ),

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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            alphabetsAndSpace),
                                      ],
                                      maxLength: 27,
                                      onChanged: (_) => clearValidationErrors(),
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
                                            color: Color.fromARGB(
                                                255, 151, 16, 16),
                                          ),
                                        ),
                                        counterText: '',
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            alphabetsAndSpace),
                                      ],
                                      onChanged: (_) => clearValidationErrors(),
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
                                      onChanged: (_) => clearValidationErrors(),
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly // Allow only numeric input
                                      ],
                                      controller: IntermediatePhoneNumber,
                                      onChanged: (_) => clearValidationErrors(),
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
