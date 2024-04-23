import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/SideBarComponents/AppBar.dart';
import 'package:loginapp/Templates/InsurerTemplate.dart';
import 'package:loginapp/Templates/RFQTemplate.dart';
import 'package:loginapp/Templates/TPATemplate.dart';

class TemplateTabar extends StatefulWidget {
  TemplateTabar({super.key});

  @override
  State<TemplateTabar> createState() => _TemplateTabarState();
}

class _TemplateTabarState extends State<TemplateTabar> {
  @override
  Widget build(BuildContext context) {
    Size w = MediaQuery.of(context).size;
    double screenHeight = w.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.1),
            child: AppBarExample(),
          ),
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          "Insurer",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "TPA",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "RFQ",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Accounts",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Client",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        InsurerTemplate(),
                        TPATemplate(),
                        RFQTemplate(),
                        Icon(Icons.directions_transit),
                        Icon(Icons.directions_bike),
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
