import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => DashboardState();

  void changePassword(BuildContext context) {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) =>
// //ResetPassword()
//         ));
    print("ResetPassword......");
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => LandingPage()),
    // );
  }
}

class DashboardState extends State<Dashboard> {
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
  //Widget _selectedDashboard = UpdatedDashboard();
  final TextEditingController iconController = TextEditingController();
  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _openRFQPage() {
    setState(() {
      // _selectedDashboard = TabBarexample();
    });
  }

  void _selectDashboard(Widget dashboard) {
    setState(() {
      _isSidebarOpen = false;
      // if (dashboard is RfqTable) {
      //   _selectedDashboard = RfqTable(onCreateRFQ: _openRFQPage);
      // } else {
      //   _selectedDashboard = dashboard;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(
            child: Row(
              children: [
                Image(
                  image: AssetImage("images/Template.png"),
                  width: 150,
                ),
                SizedBox(width: 6),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: _toggleSidebar,
            icon: Icon(_isSidebarOpen ? Icons.close : Icons.menu),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
              //  color: AppColor.blackColor,
              tooltip: 'Notifications',
            ),
            Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(
                  color: Colors.blue,
                ),
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      onSurface: Colors.blue,
                    ),
              ),
              child: PopupMenuButton<String>(
                //color: AppColor.whiteColor,
                offset: Offset(0, 65),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.person,
                    // color: AppColor.blackColor,
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
        body: Row(
          children: [
            if (_isSidebarOpen)
              Sidebar(
                onSelectDashboard: _selectDashboard,
                onCreateRFQ: _openRFQPage,
              ),
            Expanded(
              child: Container(
                color: Colors.white,
                // child: _selectedDashboard,
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

  const Sidebar({
    required this.onSelectDashboard,
    required this.onCreateRFQ,
  });

  @override
  Widget build(BuildContext context) {
    Color fieldTextColor = Color(0xFFFFFFFF);

    return Container(
      width: 250,
      height: 1061,
      color: const Color(0xFF71726F),
      child: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.home,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Dashboard',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {
              //   onSelectDashboard(UpdatedDashboard());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.graphic_eq_outlined,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'App Access',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {
              // onSelectDashboard(RfqTable(onCreateRFQ: onCreateRFQ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.charging_station,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Policy',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {
              //onSelectDashboard(ClientListTabpane());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Member Details', //if EB exist
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {
              // onSelectDashboard(ProductApiFetching());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.charging_station,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Endorsments',
              style: TextStyle(color: fieldTextColor),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'CD Balance',
              style: TextStyle(color: fieldTextColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.details,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Claims MIS',
              style: TextStyle(color: fieldTextColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.message,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'E Carts', //For GHI product only
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.format_shapes,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Network Hospitals', //For GHI product only
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Coverages',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.campaign_outlined,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Premium Calculator',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.contact_phone_rounded,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Insurer Bank Details',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.density_large_sharp,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Client Details',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.perm_data_setting,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Wellness',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.call_sharp,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Contacts',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.unsubscribe,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Sum Insured',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: Color.fromARGB(251, 255, 255, 255),
            ),
            title: Text(
              'Downloads',
              style: TextStyle(color: fieldTextColor),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
