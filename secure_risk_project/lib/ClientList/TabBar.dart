
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/ClientList/ActiveClientList.dart';
import 'ArchieveClientList.dart';
import 'RenewalsClientList.dart';
import '../SideBarComponents/AppBar.dart';

// ignore: must_be_immutable
class ClientListTabBar extends StatelessWidget {
  ClientListTabBar({super.key});
  double screenWidth = MediaQuery.of(context as BuildContext).size.width;
  double screenHeight = MediaQuery.of(context as BuildContext).size.height;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight * 0.1),
              child: AppBarExample(),
            ),
            body: DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxHeight: 150.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.blue,
                            Colors.yellow,
                          ],
                        ),
                      ),
                      child: Material(
                        // color: Color.fromARGB(255, 173, 215, 248),
                        child: TabBar(
                          tabs: [
                            Tab(
                              child: Text(
                                'Active',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Renewals',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Tab(
                                child: Text(
                              'Archieves',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        //ActiveClient(),
                        ActiveClientList(),
                        RenewalsClientList(),
                        ArchieveClientList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
