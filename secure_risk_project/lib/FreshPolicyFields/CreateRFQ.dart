import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:breadcrumbs/breadcrumbs.dart';
import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginapp/RenewalPolicy/RenewalClaimsDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalCorporateDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalCoverageDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalExpiryDetails.dart';
import 'package:loginapp/RenewalPolicy/RenewalStepper.dart';
import 'package:loginapp/Service.dart';
import 'package:loginapp/FreshPolicyFields/CorporateDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colours.dart';
import '../SideBarComponents/AppBar.dart';
import '../SideBarComponents/Stepper.dart';
import 'package:loginapp/FreshPolicyFields/CoverageDetails.dart';
import 'package:loginapp/FreshPolicyFields/PolicyTerms.dart';
import 'NonEbCoverage.dart';

class CreateRFQ extends StatefulWidget {
  @override
  State<CreateRFQ> createState() => _CreateRFQState();
}

class _CreateRFQState extends State<CreateRFQ>
    with SingleTickerProviderStateMixin {
  HashMap<int, String> productData = new HashMap<int, String>();

  int? selectedProductId;
  String? selectedProductCategory;
  List<Map<String, dynamic>> productCategories = [];
  String? selectedProductType;
  List<String> productTypes = [];
  int? selectedCategoryId;
  String? selectedPolicyType;
  List<String> policyTypes = ['Fresh', 'Renewal'];
  bool isVisible = false;
  bool isDropdownEmpty = false;
  String? categoryErrorMessage;
  String? productTypeErrorMessage;
  String? policyTypeErrorMessage;

  Future<void> fetchDropdownOptionsProductCategories() async {
    try {
      var headers = await ApiServices.getHeaders();
      var response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.product_Category_Endpoint),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);

        setState(() {
          productCategories = List<Map<String, dynamic>>.from(data);
        });
      } else {
        ('Failed to fetch dropdown options');
      }
    } catch (error) {
      ('Error: $error');
    }
  }

  Future<void> fetchDropdownOptionsProductList() async {
    try {
      var selectedCategory = productCategories.firstWhere(
          (category) => category['categoryName'] == selectedProductCategory);
      var categoryId = int.parse(selectedCategory['categoryId'].toString());
      var headers = await ApiServices.getHeaders();
      var response = await http.get(
          Uri.parse(ApiServices.baseUrl +
              ApiServices.product_List_Endpoint +
              '$categoryId'),
          headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);

        List<String> productIds = []; // Initialize a list to store product IDs

        // Iterate through the data and extract the product IDs
        for (var item in data) {
          productData[item['productId']] = item['productName'].toString();
          String productId = item['productId'].toString();
          productIds.add(productId);
          ('obj:$productId');
        }
        setState(() {
          productTypes = List<String>.from(
              data.map((item) => item['productName'].toString()));
        });
      } else {
        ('Failed to fetch dropdown options');
      }
    } catch (error) {
      ('Error: $error');
    }
  }

  void _toggleVisibility() {
    if (selectedProductCategory == null) {
      setState(() {
        categoryErrorMessage = 'Please select a product category';
      });
    } else {
      setState(() {
        categoryErrorMessage = null;
      });
    }

    if (selectedProductType == null) {
      setState(() {
        productTypeErrorMessage = 'Please select a product type';
      });
    } else {
      setState(() {
        productTypeErrorMessage = null;
      });
    }

    if (selectedPolicyType == null) {
      setState(() {
        policyTypeErrorMessage = 'Please select a policy type';
      });
    } else {
      setState(() {
        policyTypeErrorMessage = null;
      });
    }

    if (selectedProductCategory != null &&
        selectedProductType != null &&
        selectedPolicyType != null) {
      CorporateDetails.clearFields();
      CoverageDetails1.nonEbClearFields();
      RenewalCorporateDetails.clearFields();
      CoverageDetails.coverageClearFields();
      RenewalCoverageDetails.coverageClearFields();
      RenewalExpiryDetails.renewalExpiryDetailsclearFields();
      RenewalClaimsDetails.renewalClaimsDetailsclearFileds();
      isVisible = true;
      isDropdownEmpty = false;
      _createRFQ();
    }
  }

  void _createRFQ() async {
    // int? selectedProductId;
    for (var entry in productData.entries) {
      if (entry.value == selectedProductType) {
        selectedProductId = entry.key;
        break; // Found the matching productId, exit the loop
      }
    }

    for (var category in productCategories) {
      if (category['categoryName'] == selectedProductCategory) {
        selectedCategoryId = category['categoryId'];
        break; // Found the matching categoryId, exit the loop
      }
    }

    if (selectedProductId != null && selectedCategoryId != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        // Save the individual values of the requestBody in local storage
        await prefs.setInt('prodCategoryId', selectedCategoryId!);
        await prefs.setInt('productId', selectedProductId!);
        await prefs.setString('policyType', selectedPolicyType!);
        await prefs.setString('ProductType', selectedProductType!);
      } catch (error) {
        ('Error storing data in local storage: $error');
      }
    } else {
      ('Please select both a product category and a product type.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDropdownOptionsProductCategories();
  }

  GlobalKey<CorporateDetailsState> step1Key =
      GlobalKey<CorporateDetailsState>();
  GlobalKey<CoverageDetailsState> step2Key = GlobalKey<CoverageDetailsState>();
  GlobalKey<PolicyTermsState> step3Key = GlobalKey<PolicyTermsState>();
  GlobalKey<CoverageDetailsState1> step2_2Key =
      GlobalKey<CoverageDetailsState1>();

  List<String> list = <String>['One', 'Two', 'Three', 'Four'];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    bool _isHovered1 = false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: AppBarExample(),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: screenHeight * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 3), // Offset
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if (!isVisible)
                        BootstrapRow(
                          children: [
                            BootstrapCol(
                              lg: 12,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, bottom: 10.0),
                                // child: Breadcrumbs(
                                //   crumbs: [
                                //     TextSpan(
                                //       text: 'Home',
                                //       style: GoogleFonts.poppins(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     TextSpan(
                                //       text: 'Add RFQ',
                                //       style: GoogleFonts.poppins(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //   ],
                                //   separator: ' > ',
                                //   style:
                                //       GoogleFonts.poppins(color: Colors.black),
                                // ),
                              ),
                            ),
                            BootstrapCol(
                              xs: 12,
                              md: 4,
                              xl: 3,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Product Category',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16.0, color: Colors.black),
                                      textAlign: TextAlign.start,
                                    ),
                                    Container(
                                      width: screenWidth > 1024
                                          ? screenWidth * 0.23
                                          : screenWidth * 0.7,
                                      height: screenHeight > 600
                                          ? screenHeight * 0.05
                                          : screenHeight * 0.03,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(113, 114, 111, 1),
                                        ),
                                      ),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedProductCategory,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedProductCategory = newValue;
                                            selectedProductType = null;
                                            selectedPolicyType = null;
                                            fetchDropdownOptionsProductList();
                                          });
                                        },
                                        underline: Container(),
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: null,

                                            //child: Center(
                                            child: Text(
                                              '------Select Product Category------',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14.0,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            //  ),
                                          ),
                                          ...productCategories.map((category) {
                                            return DropdownMenuItem<String>(
                                              value: category['categoryName'],
                                              child: Text(
                                                category['categoryName'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    if (categoryErrorMessage != null)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          categoryErrorMessage!,
                                          style: GoogleFonts.poppins(
                                              color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            BootstrapCol(
                              xs: 12,
                              md: 4,
                              xl: 3,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Product Type',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth > 1024
                                          ? screenWidth * 0.23
                                          : screenWidth * 0.7,
                                      height: screenHeight > 600
                                          ? screenHeight * 0.05
                                          : screenHeight * 0.03,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(113, 114, 111, 1),
                                        ),
                                      ),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedProductType,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedProductType = newValue;
                                            selectedPolicyType = null;
                                          });
                                        },
                                        underline: Container(),
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: null,
                                            child: Text(
                                              '------Select Product type------',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                          ...productTypes
                                              .toSet()
                                              .map((product) {
                                            return DropdownMenuItem<String>(
                                              value: product,
                                              child: Text(product),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    if (productTypeErrorMessage != null)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          productTypeErrorMessage!,
                                          style: GoogleFonts.poppins(
                                              color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            BootstrapCol(
                              xs: 12,
                              md: 4,
                              xl: 3,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Policy Type',
                                      // Replace with your desired label
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth > 1024
                                          ? screenWidth * 0.23
                                          : screenWidth * 0.7,
                                      height: screenHeight > 600
                                          ? screenHeight * 0.05
                                          : screenHeight * 0.03,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(113, 114, 111, 1),
                                        ),
                                      ),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedPolicyType,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedPolicyType = newValue;
                                          });
                                        },
                                        underline: Container(),
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: null,
                                            child: Text(
                                              '------Select Policy Type------',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                          ...policyTypes.map((option) {
                                            return DropdownMenuItem<String>(
                                              value: option,
                                              child: Text(option),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    if (policyTypeErrorMessage != null)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          policyTypeErrorMessage!,
                                          style: GoogleFonts.poppins(
                                              color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            BootstrapCol(
                              xs: 7,
                              md: 3,
                              xl: 2,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 32.0, left: 10, right: 10),
                                child: MouseRegion(
                                  onEnter: (_) {
                                    setState(() {
                                      _isHovered1 = true;
                                    });
                                  },
                                  onExit: (_) {
                                    setState(() {
                                      _isHovered1 = false;
                                    });
                                  },
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _toggleVisibility();
                                    },
                                    child: Text(
                                      'Submit',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                    style:
                                        SecureRiskColours.customButtonStyle(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (selectedPolicyType == "Fresh" && isVisible)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, top: 0),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: HorizontalStepperExampleApp(
                                  step1Key: step1Key,
                                  productId: selectedProductId),
                            ),
                          ),
                        ),
                      if (selectedPolicyType == "Renewal" && isVisible)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, top: 10),
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child:
                                  RenewalStepper(productId: selectedProductId),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
