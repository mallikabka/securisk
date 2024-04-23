import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/IntermediaryDetails/intermediary_products.dart';
import 'package:loginapp/LandingPage.dart';
import 'package:loginapp/MainDashboard.dart';
import 'package:loginapp/ChangePassword.dart';
import 'package:loginapp/Roles/roles.dart';
import 'package:loginapp/SideBarComponents/AllRFQEx.dart';
import 'package:loginapp/Templates/TemplatesTabar.dart';
import 'package:loginapp/Utilities/CircularLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../ClientList/ActiveClientList.dart';
import '../ClientList/ArchieveClientList.dart';
import '../ClientList/RenewalsClientList.dart';
import '../Colours.dart';
import '../CreateLocation/CreateLocation.dart';
import '../Department/CreateDepartment.dart';
import '../IntermediaryDetails/intermediary_insurer_list.dart';
import '../IntermediaryDetails/intermediary_tpa_list.dart';
import 'package:universal_html/html.dart' as html;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarExample extends StatefulWidget {
  AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRfqId();
  }

  String? username;
  bool Templates = false;
  bool HomeVisibilityValue = false;
  bool ClientListVisibilityValue = false;
  bool ActiveClientListVisibilityValue = false;
  bool RenewalClientListVisibilityValue = false;
  bool ArchiveClientListVisibilityValue = false;
  bool IntermediaryVisibilityValue = false;
  bool IntermediaryProductsVisibilityValue = false;
  bool IntermediaryTPAListVisibilityValue = false;
  bool IntermediaryInsurerListVisibilityValue = false;
  bool EmailVisibilityValue = false;
  bool RfqVisibilityValue = false;
  bool CreateLocationVisibilityValue = false;
  bool RolesVisibilityValue = false;
  bool DepartmentVisibilityValue = false;

  Future<void> fetchRfqId() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('email');

    final templatesValue = prefs.getString('Templates');
    final homeValue = prefs.getString('Home');
    final clientListValue = prefs.getString('ClientList');
    final ActiveclientListValue = prefs.getString('ActiveClientList');
    final RenewalclientListValue = prefs.getString('RenewalsClientList');
    final ArchivesclientListValue = prefs.getString('ArchivesClientList');
    final IntermediaryValue = prefs.getString('IntermediaryDetails');
    final IntermediaryProductsValue = prefs.getString('Products');
    final IntermediaryTPAListValue = prefs.getString('TPA List');
    final IntermediaryInsurerListValue = prefs.getString('Insurer List');
    final EmailValue = prefs.getString('email');
    final RfqValue = prefs.getString('RFQ');
    final CreateLocationValue = prefs.getString('Create Location');
    final RolesValue = prefs.getString('Roles');
    final DepartmentValue = prefs.getString('Department');

    // Convert the string values to booleans

    final templatesBoolValue = templatesValue?.toLowerCase() == 'true';
    final homeBoolValue = homeValue?.toLowerCase() == 'true';
    final clientListBoolValue = clientListValue?.toLowerCase() == 'true';
    final ActiveclientListBoolValue =
        ActiveclientListValue?.toLowerCase() == 'true';
    final RenewalclientListBoolValue =
        RenewalclientListValue?.toLowerCase() == 'true';
    final ArchivesclientListBoolValue =
        ArchivesclientListValue?.toLowerCase() == 'true';
    final IntermediaryBoolValue = IntermediaryValue?.toLowerCase() == 'true';
    final IntermediaryProductBoolValue =
        IntermediaryProductsValue?.toLowerCase() == 'true';
    final IntermediaryTPAListBoolValue =
        IntermediaryTPAListValue?.toLowerCase() == 'true';
    final IntermediaryInsurerListBoolValue =
        IntermediaryInsurerListValue?.toLowerCase() == 'true';
    final EmailBoolValue = EmailValue?.toLowerCase() == 'true';
    final RfqBoolValue = RfqValue?.toLowerCase() == 'true';
    final CreateLocationBoolValue =
        CreateLocationValue?.toLowerCase() == 'true';
    final RolesBoolValue = RolesValue?.toLowerCase() == 'true';
    final DepartmentBoolValue = DepartmentValue?.toLowerCase() == 'true';

    if (templatesValue != null) {
      setState(() {
        Templates = templatesBoolValue;
      });
    }

    if (homeValue != null) {
      setState(() {
        HomeVisibilityValue = homeBoolValue;
      });
    }

    if (clientListValue != null) {
      setState(() {
        ClientListVisibilityValue = clientListBoolValue;
      });
    }

    if (ActiveclientListValue != null) {
      setState(() {
        ActiveClientListVisibilityValue = ActiveclientListBoolValue;
      });
    }
    if (RenewalclientListValue != null) {
      setState(() {
        RenewalClientListVisibilityValue = RenewalclientListBoolValue;
      });
    }
    if (ArchivesclientListValue != null) {
      setState(() {
        ArchiveClientListVisibilityValue = ArchivesclientListBoolValue;
      });
    }

    if (IntermediaryValue != null) {
      setState(() {
        IntermediaryVisibilityValue = IntermediaryBoolValue;
      });
    }

    if (IntermediaryProductsValue != null) {
      setState(() {
        IntermediaryProductsVisibilityValue = IntermediaryProductBoolValue;
      });
    }
    if (IntermediaryTPAListValue != null) {
      setState(() {
        IntermediaryTPAListVisibilityValue = IntermediaryTPAListBoolValue;
      });
    }
    if (IntermediaryInsurerListValue != null) {
      setState(() {
        IntermediaryInsurerListVisibilityValue =
            IntermediaryInsurerListBoolValue;
      });
    }

    if (EmailValue != null) {
      setState(() {
        EmailVisibilityValue = EmailBoolValue;
      });
    }

    if (RfqValue != null) {
      setState(() {
        RfqVisibilityValue = RfqBoolValue;
      });
    }

    if (CreateLocationValue != null) {
      setState(() {
        CreateLocationVisibilityValue = CreateLocationBoolValue;
      });
    }

    if (RolesValue != null) {
      setState(() {
        RolesVisibilityValue = RolesBoolValue;
      });
    }

    if (DepartmentValue != null) {
      setState(() {
        DepartmentVisibilityValue = DepartmentBoolValue;
      });
    }
  }

  Future<void> clearLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('isLocationInfoPermitted');
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // You can set the shadow color here
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes the position of the shadow
              ),
            ],
          ),
        ),
        toolbarHeight: screenHeight * 0.07,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Container(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainDashboard(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/images/Template2.png",
                      width: screenWidth * 0.12,
                      height: screenHeight * 0.05,
                    )),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainDashboard(),
                        ),
                      );
                    },
                    child: Text(
                      'HOME',
                      style: GoogleFonts.poppins(
                          //color: Color.fromRGBO(150, 51, 138, 1.0),
                          color: SecureRiskColours.Table_Heading_Color,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: RfqVisibilityValue,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 1,
                    height: 20,
                    color: Color.fromRGBO(150, 51, 138, 1.0),
                  ),
                ),
              ),
              Visibility(
                visible: RfqVisibilityValue,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: TextButton(
                      onPressed: () {
                        Loader.showLoader(context);
                        // RenewalEditExpiryDetails
                        //     .renewalEditExpiryDetailsclearFields();
                        // RenewalEditClaimsDetails
                        //     .renewalEditClaimsDetailsclearFileds();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllRFQEx(
                              onCreateRFQ: () {},
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'RFQ',
                            style: GoogleFonts.poppins(
                                //color: Color.fromRGBO(150, 51, 138, 1.0),
                                color: SecureRiskColours.Table_Heading_Color,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          // Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: ClientListVisibilityValue,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 1,
                    height: 20,
                    color: Color.fromRGBO(150, 51, 138, 1.0),
                  ),
                ),
              ),
              Visibility(
                visible: ClientListVisibilityValue,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: TextButton(
                      onPressed: () {},
                      child: PopupMenuButton<String>(
                        offset: Offset(0, 50),
                        onSelected: (String value) {
                          // Handle submenu item selection
                          if (value == 'Active' &&
                              ActiveClientListVisibilityValue) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActiveClientList(),
                              ),
                            );
                          } else if (value == 'Renewals' &&
                              RenewalClientListVisibilityValue) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RenewalsClientList(), // Replace with your actual widget
                              ),
                            );
                            // Handle other submenu item selections
                          } else if (value == 'Archives' &&
                              ArchiveClientListVisibilityValue) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArchieveClientList(), // Replace with your actual widget
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          final items = <PopupMenuEntry<String>>[];
                          if (ActiveClientListVisibilityValue) {
                            items.add(PopupMenuItem<String>(
                              value: 'Active',
                              child: Container(
                                width: 200,
                                child: Text(
                                  'Active',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ));
                          }
                          if (RenewalClientListVisibilityValue) {
                            items.add(PopupMenuItem<String>(
                              value: 'Renewals',
                              child: Text(
                                'Renewals',
                                style: GoogleFonts.poppins(),
                              ),
                            ));
                          }
                          if (ArchiveClientListVisibilityValue) {
                            items.add(PopupMenuItem<String>(
                              value: 'Archives',
                              child: Text(
                                'Archives',
                                style: GoogleFonts.poppins(),
                              ),
                            ));
                          }
                          return items;
                        },
                        child: Row(
                          children: [
                            Text(
                              'Client List',
                              style: GoogleFonts.poppins(
                                  // fontFamily: 'Open Sans',
                                  // color: Color.fromRGBO(150, 51, 138, 1.0),
                                  color: SecureRiskColours.Table_Heading_Color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                            // Icon(Icons.arrow_drop_down, color: Color.fromRGBO(150, 51, 138, 1.0)),
                            Icon(
                              Icons.arrow_drop_down,
                              //color: Color.fromRGBO(150, 51, 138, 1.0)
                              color: SecureRiskColours.Table_Heading_Color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: IntermediaryVisibilityValue,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 1,
                    height: 15,
                    color: Color.fromRGBO(150, 51, 138, 1.0),
                  ),
                ),
              ),
              Visibility(
                visible: IntermediaryVisibilityValue,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: TextButton(
                      onPressed: () {},
                      child: PopupMenuButton<String>(
                        offset: Offset(0, 50),
                        onSelected: (String value) {
                          // Handle submenu item selection
                          if (value == 'Products' &&
                              IntermediaryProductsVisibilityValue) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IntermediaryProducts(),
                              ),
                            );
                          } else if (value == 'TPA List' &&
                              IntermediaryTPAListVisibilityValue) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IntermediaryTpaList(),
                              ),
                            );
                          } else if (value == 'Insurer List' &&
                              IntermediaryInsurerListVisibilityValue) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IntermediaryInsurerList(),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          final items = <PopupMenuEntry<String>>[];
                          if (IntermediaryProductsVisibilityValue) {
                            items.add(PopupMenuItem<String>(
                              value: 'Products',
                              child: Container(
                                width: 200,
                                child: Text(
                                  'Products',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ));
                          }
                          if (IntermediaryTPAListVisibilityValue) {
                            items.add(
                              PopupMenuItem<String>(
                                value: 'TPA List',
                                child: Text(
                                  'TPA List',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            );
                          }
                          if (IntermediaryInsurerListVisibilityValue) {
                            items.add(
                              PopupMenuItem<String>(
                                value: 'Insurer List',
                                child: Text(
                                  'Insurer List',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            );
                          }
                          return items;
                        },
                        child: Row(
                          children: [
                            Text(
                              'Intermediary Details',
                              style: GoogleFonts.poppins(
                                  //color: Color.fromRGBO(150, 51, 138, 1.0),
                                  color: SecureRiskColours.Table_Heading_Color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              //color: Color.fromRGBO(150, 51, 138, 1.0)
                              color: SecureRiskColours.Table_Heading_Color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: CreateLocationVisibilityValue,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 1,
                    height: 15,
                    color: Color.fromRGBO(150, 51, 138, 1.0),
                  ),
                ),
              ),
              Visibility(
                visible: CreateLocationVisibilityValue,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateLocation(),
                          ),
                        );
                      },
                      child: Text(
                        'Create Location',
                        style: GoogleFonts.poppins(
                            //color: Color.fromRGBO(150, 51, 138, 1.0),
                            color: SecureRiskColours.Table_Heading_Color,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: RolesVisibilityValue,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 1,
                    height: 20,
                    color: Color.fromRGBO(150, 51, 138, 1.0),
                  ),
                ),
              ),
              Visibility(
                visible: RolesVisibilityValue,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Roles(),
                          ),
                        );
                        // Navigator.pushNamed(context, '/roles');
                      },
                      child: Text(
                        'Roles',
                        style: GoogleFonts.poppins(
                            //color: Color.fromRGBO(150, 51, 138, 1.0),
                            color: SecureRiskColours.Table_Heading_Color,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: DepartmentVisibilityValue,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 1,
                    height: 20,
                    color: Color.fromRGBO(150, 51, 138, 1.0),
                  ),
                ),
              ),
              Visibility(
                visible: DepartmentVisibilityValue,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateDepartment(),
                          ),
                        );
                      },
                      child: Text(
                        'Department',
                        style: GoogleFonts.poppins(
                            //color: Color.fromRGBO(150, 51, 138, 1.0),
                            color: SecureRiskColours.Table_Heading_Color,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),

              // Visibility(
              //   visible: Templates,
              //   child: Container(
              //     child: Padding(
              //       padding: EdgeInsets.only(left: screenWidth * 0.01),
              //       child: TextButton(
              //         onPressed: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => TemplateTabar(),
              //             ),
              //           );
              //         },
              //         child: Text(
              //           'Templates',
              //           style: GoogleFonts.poppins(
              //             color: Color.fromRGBO(255, 255, 255, 1),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // Handle the action when the notification icon is clicked
              },
              icon: Icon(Icons.notifications), // Add the notification icon
              tooltip: 'Notifications',
              color: SecureRiskColours.Table_Heading_Color),
          IconButton(
            onPressed: () {
              // Handle the action when the chatbot icon is clicked
            },
            icon: Icon(
              Icons.chat_bubble,
              color: SecureRiskColours.Table_Heading_Color,
            ), // Add the chatbot icon
            tooltip: 'Chatbot',
          ),
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(
                color: Colors.blue, // Set the color of the icon
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    onSurface:
                        Colors.white, // Set the text color of the menu items
                  ),
            ),
            child: PopupMenuButton<String>(
              offset: Offset(0, 65),
              icon: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.person,
                  color: SecureRiskColours.Table_Heading_Color,
                ),
              ),
              onSelected: (value) {
                // Handle the selected value
                if (value == "logout") {
                  toastification.show(
                    context: context,
                    autoCloseDuration: Duration(seconds: 2),
                    title: 'Account logout successfully',
                  );
                  clearLocalStorage();
                  Timer(Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => LandingPage(),
                      ),
                    );
                  });
                  html.window.location.reload();
                } else if (value == "forgot_password") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ResetPassword(),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "EshwarMerugu",
                    // child: Text('Ac:$_storedData'),
                    child: Text(
                      "$username",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "forgot_password",
                    child: Text(
                      "Change Password",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "logout",
                    child: Text(
                      "Logout",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
