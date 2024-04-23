import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:toastification/toastification.dart';

void main() => runApp(const ClientDashboardAppbar());

class ClientDashboardAppbar extends StatelessWidget {
  const ClientDashboardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClientAppbar(),
    );
  }
}

class ClientAppbar extends StatelessWidget {
  const ClientAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        //  title: const Text('AppBar Demo'),
        backgroundColor: SecureRiskColours.appBarColor,
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
              // Container(
              //   child: TextButton(
              //       onPressed: () {
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (context) => MainDashboard(),
              //         //   ),
              //         // );
              //       },
              //       child: Image.asset(
              //         "assets/images/Template2.png",
              //         width: screenWidth * 0.12,
              //         height: screenHeight * 0.05,
              //       )),
              // ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'GtL',
                      style: GoogleFonts.poppins(
                          color: SecureRiskColours.Table_Heading_Color,
                          fontSize: 22,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),

              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 1000.0),
                  child: Text("Alacrity Infosys System"),
                ),
              )
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
                  //clearLocalStorage();
                  Timer(Duration(seconds: 1), () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) => LandingPage(),
                    //   ),
                    // );
                  });
                  // html.window.location.reload();
                } else if (value == "forgot_password") {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute<void>(
                  //     builder: (BuildContext context) => ResetPassword(),
                  //   ),
                  // );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "EshwarMerugu",
                    // child: Text('Ac:$_storedData'),
                    child: Text(
                      "username",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "forgot_password",
                    child: Text(
                      "ChangePassword",
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
      body: const Center(
        child: Text(
          'body',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
