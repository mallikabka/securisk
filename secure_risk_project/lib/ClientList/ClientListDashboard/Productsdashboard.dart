import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loginapp/ClientList/ClientListDashboard/CDBalance.dart';
import 'package:loginapp/ClientList/ClientListDashboard/ClaimsMis/ClaimsApprovedList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/ClaimsMis/Claims_Pending.dart';
import 'package:loginapp/ClientList/ClientListDashboard/ClaimsMis/Claims_RejectedList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/Contact/EmployeeList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/Coverages.dart';
import 'package:loginapp/ClientList/ClientListDashboard/Ecards.dart';
import 'package:loginapp/ClientList/ClientListDashboard/Endorsements.dart';
import 'package:loginapp/ClientList/ClientListDashboard/Contact/ManagementList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/InsurerBankDetails.dart';
import 'package:loginapp/ClientList/ClientListDashboard/ClaimsMis/Claims_MasterList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/MemberDetails/EnrollementDetail.dart';
import 'package:loginapp/ClientList/ClientListDashboard/MemberDetails/MasterList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/MemberDetails/MemberCorrection.dart';
import 'package:loginapp/ClientList/ClientListDashboard/MemberDetails/MemberDeletion.dart';
import 'package:loginapp/ClientList/ClientListDashboard/MemberDetails/MemberDetailsActiveList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/MemberDetails/MemberDetailsAdditions.dart';
import 'package:loginapp/ClientList/ClientListDashboard/DashboardPage.dart';
import 'package:loginapp/ClientList/ClientListDashboard/MemberDetails/MemberDetailsPending.dart';
import 'package:loginapp/ClientList/ClientListDashboard/ClientDetails.dart';

import 'package:loginapp/ClientList/ClientListDashboard/PremiumCaculator/PerFamilyCard.dart';
import 'package:loginapp/ClientList/ClientListDashboard/PremiumCaculator/PerLifeCard.dart';

import 'package:loginapp/ClientList/NetworkHospital.dart';
import 'package:loginapp/RenewalPolicy/RenewalCoverageDetails.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:loginapp/ClientList/ClientListDashboard/PolicyFile.dart';

class Dashboard extends StatefulWidget {
  final String productNameVar;
  int clientId;
  final String clientNameVar;
  String productIdvar;
  String tpaNameVar;
  String insuranceCompanyVar;

  Dashboard(
      {Key? key,
      required this.productNameVar,
      required this.productIdvar,
      required this.clientId,
      required this.clientNameVar,
      required this.tpaNameVar,
      required this.insuranceCompanyVar})
      : super(key: key);

  @override
  State<Dashboard> createState() => DashboardState();

  void changePassword(BuildContext context) {}
  // static void navigateToPremiumCalculator(BuildContext context) {
  //   final _dashboardKey =
  //       context.findAncestorStateOfType<DashboardState>()!.dashboardKey;
  //   _dashboardKey.currentState!.navigateToPremiumCalculator(context);
  // }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
  }
}

class DashboardState extends State<Dashboard> {
  final GlobalKey<DashboardState> dashboardKey = GlobalKey<DashboardState>();
  String? username = "";

  Future<void> fetchEmail() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('email');
    print("usermail is:$username");
  }

  @override
  void initState() {
    fetchEmail();

    super.initState();
  }

  bool _isSidebarOpen = true;

  Widget _selectedDashboard = DashboardPage();

  final TextEditingController iconController = TextEditingController();
  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _openRFQPage() {
    setState(() {});
  }

  void _selectDashboard(Widget dashboard) {
    setState(() {
      _isSidebarOpen = true;
      _selectedDashboard = dashboard;
    });
  }

  // void navigateToPremiumCalculator(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PremiumCards(
  //         clientId: widget.clientId,
  //         productIdvar: widget.productIdvar,
  //       ),
  //     ),
  //   );
  // }
  // void navigateToPremiumCalculator(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MyWidget(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // print('tpa name :$tpaNameVar');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Color.fromARGB(255, 233, 229, 229),
            child: AppBar(
              title: SingleChildScrollView(
                child: Row(
                  children: [
                    Image(
                      image: AssetImage("assets/images/Template2.png"),
                      width: 150,
                    ),
                    // SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text(
                        widget.productNameVar,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 700.0),
                      child: Text(
                        widget.clientNameVar,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications),
                  tooltip: 'Notifications',
                  color: Colors.black,
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          onSurface: Colors.black,
                        ),
                  ),
                  child: PopupMenuButton<String>(
                    offset: Offset(0, 65),
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                    onSelected: (value) {
                      if (value == "logout") {
                        widget.logout(context);
                      } else if (value == "forgot_password") {
                        widget.changePassword(context);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: ("$username"),
                          child: Text("$username"),
                        ),
                        const PopupMenuItem<String>(
                          value: "forgot_password",
                          child: Text("ChangePassword"),
                        ),
                        const PopupMenuItem<String>(
                          value: "logout",
                          child: Text("Logout"),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Row(
          children: [
            if (_isSidebarOpen)
              Sidebar(
                  onSelectDashboard: _selectDashboard,
                  onCreateRFQ: _openRFQPage,
                  productIdvar: widget.productIdvar,
                  clientId: widget.clientId,
                  productNameVar: widget.productNameVar,
                  tpaName: widget.tpaNameVar,
                  insuranceCompanyVar: widget.insuranceCompanyVar,),
            Expanded(
              child: Container(
                color: Colors.white,
                child: _selectedDashboard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final void Function(Widget) onSelectDashboard;
  final VoidCallback onCreateRFQ;
  final String productIdvar;
  final int clientId;
  final String productNameVar;
  final String tpaName;
   final String insuranceCompanyVar;

  const Sidebar({
    required this.onSelectDashboard,
    required this.onCreateRFQ,
    required this.productIdvar,
    required this.clientId,
    required this.productNameVar,
    required this.tpaName,
    required this.insuranceCompanyVar,
  });

  @override
  Widget build(BuildContext context) {
    Color fieldTextColor = Colors.black;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 10.0,
        ),
      ),
      child: Container(
        width: 250,
        height: 800,
        color: Color.fromARGB(255, 233, 229, 229),
        child: ListView(
            children: _buildListTiles(fieldTextColor, productIdvar, clientId,
                productNameVar,tpaName,insuranceCompanyVar, context)),
      ),
    );
  }

  List<Widget> _buildListTiles(Color fieldTextColor, String productId,
      int clientId, String productNameVar, String tpaNameVar,String insuranceCompanyVar,BuildContext context) {
    List<Map<String, dynamic>> items = [
      {"icon": Icons.home, "title": "Dashboard", "onTap": () {}},
      //  {"icon": Icons.person, "title": "App Access", "onTap": () {}},
      {
        "icon": Icons.person,
        "title": "Policy",
        "onTap": () {
          onSelectDashboard(PolicyForm(
              clientId: clientId,
              productIdvar: productId,
              productNameVar: productNameVar,
              tpaNameVar:tpaNameVar,
              insuranceComp:insuranceCompanyVar));
        }
      },
      if (productId == "1001")
        {
          "icon": Icons.person,
          "title": "Member Details",
          "onTap": () {},
          "dropdownItems": [
            "Master List",
            "Active List",
            "Additions",
            "Deletion",
            "Correction",
            "Pending",
            "Enrollment"
          ]
        },
      {
        "icon": Icons.person,
        "title": "Endorsements",
        "onTap": () {
          onSelectDashboard(Endorsements(
            clientId: clientId,
            productIdvar: productId,
          ));
        }
      },
      {
        "icon": Icons.person,
        "title": "CD Balance",
        "onTap": () {
          onSelectDashboard(
              CdBalanceDetatis(clientId: clientId, productId: productId));
        }
      },
      {
        "icon": Icons.person,
        "title": "Claims MIS",
        "onTap": () {
          // onSelectDashboard(Claims_MasterList(clientId: clientId, productId: productId));
        },
        "claims_dropdownItems": [
          "Master List",
          "Approved",
          "Rejected",
          "Pending"
        ]
      },
      {
        "icon": Icons.person,
        "title": "Ecards",
        "onTap": () {
          onSelectDashboard(Ecards(clientId: clientId, productId: productId));
        }
      },
      if (productId == "1001")
        {
          "icon": Icons.person,
          "title": "Network Hospital",
          "onTap": () {
            onSelectDashboard(NetworkHospitalForm(
                clientId: clientId, productIdvar: productIdvar,tpaName: tpaNameVar,));
          },
        },
      {
        "icon": Icons.person,
        "title": "Coverages",
        "onTap": () {
          onSelectDashboard(
              PolicyType(clientId: clientId, productIdvar: productId));
        }
      },
      {
        "icon": Icons.person,
        "title": "Premium Calculator",
        "onTap": () {},
        // onSelectDashboard(
        //    // PremiumCards(clientId: clientId, productIdvar: productId));
        "premiumDropdownItems": [
          "Per Life Premium Calculator",
          "Per Family Premium Calculator",
        ]
      },
      {
        "icon": Icons.person,
        "title": "Insurer Bank Details",
        "onTap": () {
          onSelectDashboard(InsurerBankDetatis(
            clientId: clientId,
            productId: productId,
          ));
        }
      },
      {
        "icon": Icons.person,
        "title": "Client Details",
        "onTap": () {
          onSelectDashboard(CLientDetailsForm(
            clientId: clientId,
            productIdvar: productId,
          ));
        }
      },
      // {"icon": Icons.person, "title": "Wellness", "onTap": () {}},
      {
        "icon": Icons.contacts,
        "title": "Contact",
        "onTap": () {},
        "contactDropdownItems": [
          "Management List",
          "Employee List",
        ]
      },
      // {"icon": Icons.mail, "title": "Email", "onTap": () {}},
      // {"icon": Icons.file_download, "title": "Downloads", "onTap": () {}},
    ];
    int index = items.indexWhere((item) => item["title"] == "Member Details");

    if (index != -1) {
      Map<String, dynamic> memberDetailsItem = items.removeAt(index);

      List<String>? dropdownItems =
          memberDetailsItem["dropdownItems"] as List<String>?;

      if (dropdownItems != null && dropdownItems.isNotEmpty) {
        ExpansionTile expansionTile = ExpansionTile(
          leading: Icon(Icons.person, color: Colors.black),
          title: Text(
            "Member Details",
            style: TextStyle(color: fieldTextColor, fontSize: 15),
          ),
          children: dropdownItems.map((dropdownItem) {
            return ListTile(
              title: Text(
                dropdownItem,
                style: TextStyle(
                  color: fieldTextColor,
                ),
              ),
              onTap: () {
                // Navigate to Master List or Active List based on the selection
                if (dropdownItem == "Master List") {
                  onSelectDashboard(
                      MasterList(clientId: clientId, productId: productId));
                } else if (dropdownItem == "Active List") {
                  onSelectDashboard(
                      ActiveList(clientId: clientId, productId: productId));
                } else if (dropdownItem == "Additions") {
                  onSelectDashboard(
                      AdditionsList(clientId: clientId, productId: productId));
                } else if (dropdownItem == "Deletion") {
                  onSelectDashboard(
                      MemberDeletion(clientId: clientId, productId: productId));
                } else if (dropdownItem == "Correction") {
                  onSelectDashboard(MemberCorrection(
                      clientId: clientId, productId: productId));
                } else if (dropdownItem == "Pending") {
                  onSelectDashboard(
                      PendingList(clientId: clientId, productId: productId));
                } else if (dropdownItem == "Enrollment") {
                  onSelectDashboard(EntrollementDetail(
                    clientId: clientId,
                    productIdvar: productId,
                    tpaName: tpaName,
                  ));
                 }
                // else if (dropdownItem == "Pending") {
                //   onSelectDashboard(
                //       PendingList(clientId: clientId, productId: productId));
                // }
              },
            );
          }).toList(),
        );

        items.insert(index, {"widget": expansionTile});
      }
    }
    int claimsindex = items.indexWhere((item) => item["title"] == "Claims MIS");

    if (claimsindex != -1) {
      Map<String, dynamic> claimsDetailsItem = items.removeAt(claimsindex);
      List<String>? claims_dropdownItems =
          claimsDetailsItem["claims_dropdownItems"] as List<String>?;

      if (claims_dropdownItems != null && claims_dropdownItems.isNotEmpty) {
        ExpansionTile expansionTile = ExpansionTile(
          leading: Icon(Icons.person, color: Colors.black),
          title: Text(
            "Claims MIS",
            style: TextStyle(color: fieldTextColor, fontSize: 15),
          ),
          children: claims_dropdownItems.map((dropdownItems) {
            return ListTile(
              title: Text(
                dropdownItems,
                style: TextStyle(
                  color: fieldTextColor,
                ),
              ),
              onTap: () {
                // Navigate to Master List or Active List based on the selection

                if (dropdownItems == "Master List") {
                  onSelectDashboard(Claims_MasterList(
                      clientId: clientId, productId: productId,tpaNameVar:tpaNameVar));
                } else if (dropdownItems == "Approved") {
                  onSelectDashboard(Claims_ApprovedList(
                      clientId: clientId, productId: productId,tpaNameVar:tpaNameVar));
                } else if (dropdownItems == "Rejected") {
                  onSelectDashboard(Claims_RejectedList(
                      clientId: clientId, productId: productId,tpaNameVar:tpaNameVar));
                } else if (dropdownItems == "Pending") {
                  onSelectDashboard(Claims_PendingList(
                      clientId: clientId, productId: productId,tpaNameVar:tpaNameVar));
                }
                
              },
            );
          }).toList(),
        );

        items.insert(claimsindex, {"widget": expansionTile});
      }
    }
    int contactindex = items.indexWhere((item) => item["title"] == "Contact");

    if (contactindex != -1) {
      Map<String, dynamic> contactDetailsItem = items.removeAt(contactindex);
      List<String>? contactdropdownItems =
          contactDetailsItem["contactDropdownItems"] as List<String>?;

      if (contactdropdownItems != null && contactdropdownItems.isNotEmpty) {
        ExpansionTile expansionTile = ExpansionTile(
          leading: Icon(Icons.person, color: Colors.black),
          title: Text(
            "Contact",
            style: TextStyle(color: fieldTextColor, fontSize: 15),
          ),
          children: contactdropdownItems.map((dropdownItems) {
            return ListTile(
              title: Text(
                dropdownItems,
                style: TextStyle(
                  color: fieldTextColor,
                ),
              ),
              onTap: () {
                // Navigate to Master List or Active List based on the selection

                if (dropdownItems == "Management List") {
                  onSelectDashboard(
                      ManagementList(clientId: clientId, productId: productId));
                } else if (dropdownItems == "Employee List") {
                  onSelectDashboard(
                      EmployeeList(clientId: clientId, productId: productId));
                }
              },
            );
          }).toList(),
        );

        items.insert(contactindex, {"widget": expansionTile});
      }
    }
    int premiumindex =
        items.indexWhere((item) => item["title"] == "Premium Calculator");

    if (premiumindex != -1) {
      Map<String, dynamic> contactDetailsItem = items.removeAt(premiumindex);
      List<String>? premiumdropdownItems =
          contactDetailsItem["premiumDropdownItems"] as List<String>?;

      if (premiumdropdownItems != null && premiumdropdownItems.isNotEmpty) {
        ExpansionTile expansionTile = ExpansionTile(
          leading: Icon(Icons.person, color: Colors.black),
          title: Text(
            "Premium Calculator",
            style: TextStyle(color: fieldTextColor, fontSize: 15),
          ),
          children: premiumdropdownItems.map((dropdownItems) {
            return ListTile(
              title: Text(
                dropdownItems,
                style: TextStyle(
                  color: fieldTextColor,
                ),
              ),
              onTap: () {
                // Navigate to Master List or Active List based on the selection

                if (dropdownItems == "Per Life Premium Calculator") {
                  onSelectDashboard(
                      PerLifeCard(clientId: clientId, productIdvar: productId));
                } else if (dropdownItems == "Per Family Premium Calculator") {
                  onSelectDashboard(PerFamilyCard(
                      clientId: clientId, productIdvar: productId));
                }
              },
            );
          }).toList(),
        );

        items.insert(premiumindex, {"widget": expansionTile});
      }
    }
    return items.map<Widget>((item) {
      if (item.containsKey("widget")) {
        return item["widget"];
      } else {
        return ListTile(
          leading: Icon(
            item["icon"],
            color: Colors.black,
          ),
          title: Text(
            item["title"],
            style: TextStyle(color: fieldTextColor, fontSize: 15),
          ),
          onTap: item["onTap"],
        );
      }
    }).toList();
  }
}
