import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:flutter/material.dart';
import 'Quote.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isHovered = false;
  bool _isHovered1 = false;
  bool _isHovered2 = false;
  bool _isHovered3 = false;
  bool _isHovered4 = false;
  bool _isHovered5 = false;
  bool _isHovered6 = false;
  bool _isHovered7 = false;
  bool _isHovered8 = false;
  bool _isHovered9 = false;
  bool _isHovered10 = false;
  bool _isHovered11 = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: screenHeight * 0.125,
        title: PreferredSize(
          preferredSize: Size(screenWidth, screenHeight * 0.125),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                      ),
                      child: Image.asset(
                        "assets/images/Template2.png",
                        width: screenWidth * 0.12,
                      )),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.22),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered4 = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered4 = false;
                        });
                      },
                      child: TextButton(
                        onPressed: () {
                          // Add your button press logic here
                        },
                        child: Text(
                          'HOME',
                          style: GoogleFonts.poppins(
                            color: _isHovered4
                                ? Colors.blue // Hovered color
                                : Color.fromRGBO(113, 114, 111, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered5 = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered5 = false;
                        });
                      },
                      child: TextButton(
                        onPressed: () {
                          // Add your button press logic here
                        },
                        child: Text('PRODUCT',
                            style: GoogleFonts.poppins(
                              color: _isHovered5
                                  ? Colors.blue // Hovered color
                                  : Color.fromRGBO(113, 114, 111, 1),
                            )),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered6 = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered6 = false;
                        });
                      },
                      child: TextButton(
                        onPressed: () {
                          // Add your button press logic here
                        },
                        child: Text(
                          'ABOUT',
                          style: GoogleFonts.poppins(
                            color: _isHovered6
                                ? Colors.blue // Hovered color
                                : Color.fromRGBO(113, 114, 111, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
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
                      child: SizedBox(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Quote();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: _isHovered1
                                ? Color.fromRGBO(
                                    199, 55, 125, 1.0) // Hovered color
                                : Colors.white,
                          ),
                          child: Text(
                            'GET QUOTE',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _isHovered1
                                  ? Colors.white // Hovered color
                                  : Color.fromRGBO(113, 114, 111, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered = false;
                        });
                      },
                      child: SizedBox(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login_page');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isHovered
                                ? Color.fromRGBO(
                                    199, 55, 125, 1.0) // Hovered color
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'LOGIN',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _isHovered
                                      ? Colors.white // Hovered color
                                      : Color.fromRGBO(113, 114, 111, 1),
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_circle_right_rounded,
                                size: 40,
                                color: _isHovered
                                    ? Colors.white // Hovered color
                                    : Color.fromRGBO(113, 114, 111, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered2 = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered2 = false;
                        });
                      },
                      child: SizedBox(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your button press logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isHovered2
                                ? Color.fromRGBO(
                                    199, 55, 125, 1.0) // Hovered color
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '900000',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _isHovered2
                                      ? Colors.white // Hovered color
                                      : Color.fromRGBO(113, 114, 111, 1),
                                ),
                              ),
                              //SizedBox(width: 8),
                              Icon(
                                Icons.phone_in_talk_rounded,
                                color: _isHovered2
                                    ? Colors.white // Hovered color
                                    : Color.fromRGBO(113, 114, 111, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(246, 233, 242, 1.0),
          child: BootstrapRow(
            children: [
              BootstrapCol(
                lg: 6,
                xl: 6,
                md: 6,
                xs: 12,
                child: BootstrapRow(
                  children: [
                    if (screenWidth <= 500) ...[
                      BootstrapCol(
                        lg: 12,
                        xl: 12,
                        md: 12,
                        xs: 12,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Get Insurance Policy and Save 20%!',
                              style: GoogleFonts.poppins(
                                color: Color.fromRGBO(73, 80, 87, 1.0),
                                height: 1.3,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      BootstrapCol(
                        lg: 12,
                        xl: 12,
                        md: 12,
                        xs: 12,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Text(
                            'Lorem Ipsum is simply dummy text of the printing and type setting industry and uses Latin words combined with a handful of model words.',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Color.fromRGBO(73, 80, 87, 1.0),
                              height: 1.5,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      BootstrapCol(
                        lg: 5,
                        xl: 5,
                        md: 6,
                        xs: 6,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _isHovered3 = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _isHovered3 = false;
                                });
                              },
                              child: SizedBox(
                                height: 50.0,
                                width: 200.0,
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Quote();
                                      },
                                    );
                                  },
                                  backgroundColor: _isHovered3
                                      ? Colors.white // Hovered color
                                      : Color.fromRGBO(199, 55, 125, 1.0),
                                  label: Row(
                                    children: [
                                      Text(
                                        'Get a quote',
                                        style: GoogleFonts.poppins(
                                          color: _isHovered3
                                              ? Color.fromRGBO(113, 114, 111,
                                                  1) // Hovered color
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.02),
                                        child: Icon(
                                          Icons.arrow_circle_right_rounded,
                                          color: _isHovered3
                                              ? Color.fromRGBO(113, 114, 111,
                                                  1) // Hovered color
                                              : Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      BootstrapCol(
                        lg: 11,
                        xl: 11,
                        md: 12,
                        xs: 12,
                        child: Padding(
                          padding: EdgeInsets.only(top: 100.0, left: 40.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Get Insurance Policy and Save 20%!',
                              style: GoogleFonts.poppins(
                                color: Color.fromRGBO(73, 80, 87, 1.0),
                                height: 1.3,
                                fontSize: 54,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      BootstrapCol(
                        lg: 11,
                        xl: 11,
                        md: 12,
                        xs: 12,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 50),
                          child: Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry and uses Latin words combined with a handful of model words.',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Color.fromRGBO(73, 80, 87, 1.0),
                              height: 1.5,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      BootstrapCol(
                        lg: 5,
                        xl: 5,
                        md: 6,
                        xs: 6,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0,left: 40.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _isHovered3 = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _isHovered3 = false;
                                });
                              },
                              child: SizedBox(
                                height: 50.0,
                                width: 200.0,
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Quote();
                                      },
                                    );
                                  },
                                  backgroundColor: _isHovered3
                                      ? Colors.white // Hovered color
                                      : Color.fromRGBO(199, 55, 125, 1.0),
                                  label: Row(
                                    children: [
                                      Text(
                                        'Get a quote',
                                        style: GoogleFonts.poppins(
                                          color: _isHovered3
                                              ? Color.fromRGBO(113, 114, 111,
                                                  1) // Hovered color
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.02),
                                        child: Icon(
                                          Icons.arrow_circle_right_rounded,
                                          color: _isHovered3
                                              ? Color.fromRGBO(113, 114, 111,
                                                  1) // Hovered color
                                              : Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              BootstrapCol(
                lg: 6,
                xl: 6,
                md: 6,
                xs: 12,
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: 1),
                  child: Image.asset(
                    'assets/images/Caspture.png',
                    height: screenHeight * 0.7,
                    width: screenWidth * 0.5,
                  ),
                ),
              ),

              //second row
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Container(
                  color: Colors.white,
                  child: BootstrapRow(
                    children: [
                      BootstrapCol(
                        lg: 4,
                        xl: 4,
                        md: 4,
                        xs: 12,
                        child: BootstrapRow(children: [
                          BootstrapCol(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 72,
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.white,
                                foregroundImage:
                                    AssetImage("assets/images/healthcare.png"),
                              ),
                            ),
                          ),
                          BootstrapCol(
                            child: Text(
                              "Reliable Partner",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromRGBO(113, 114, 111, 1),
                              ),
                            ),
                          ),
                          BootstrapCol(
                            child: Text(
                              "Lorem Ipsum is simply dummy text \n of the printing and typesetting\n  industry",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  height: 1.5,
                                  color: Color.fromRGBO(113, 114, 111, 1),
                                  fontSize: 18),
                            ),
                          ),
                        ]),
                      ),
                      BootstrapCol(
                        lg: 4,
                        xl: 4,
                        md: 4,
                        xs: 12,
                        child: BootstrapRow(
                          children: [
                            BootstrapCol(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 72,
                                child: CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.white,
                                  foregroundImage: AssetImage(
                                      "assets/images/healthcare.png"),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              child: Text(
                                "Tailored Plans",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromRGBO(113, 114, 111, 1),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              child: Text(
                                "Lorem Ipsum is simply dummy text \n of the printing and typesetting\n  industry",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    height: 1.5,
                                    color: Color.fromRGBO(113, 114, 111, 1),
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BootstrapCol(
                        lg: 4,
                        xl: 4,
                        md: 4,
                        xs: 12,
                        child: BootstrapRow(
                          children: [
                            BootstrapCol(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 72,
                                child: CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.white,
                                  foregroundImage: AssetImage(
                                      "assets/images/healthcare.png"),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              child: Text(
                                "Services",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromRGBO(113, 114, 111, 1),
                                ),
                              ),
                            ),
                            BootstrapCol(
                              child: Text(
                                "Lorem Ipsum is simply dummy text \n of the printing and typesetting\n  industry",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    height: 1.5,
                                    color: Color.fromRGBO(113, 114, 111, 1),
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //third row
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20),
                    child: BootstrapRow(
                      children: [
                        BootstrapCol(
                          lg: 2,
                          xl: 2,
                          md: 4,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 3,
                              xl: 3,
                              md: 2,
                              xs: 3,
                              child: Image.asset(
                                "assets/images/plane.png",
                                height: 40.0,
                                width: 40.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 9,
                              xl: 9,
                              md: 8,
                              xs: 9,
                              child: Padding(
                                padding: EdgeInsets.only(top: 7.0),
                                child: Text(
                                  "TRAVEL INSURANCE",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromRGBO(113, 114, 111, 1)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        BootstrapCol(
                          lg: 3,
                          xl: 3,
                          md: 4,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 3,
                              xl: 3,
                              md: 2,
                              xs: 3,
                              child: Image.asset(
                                "assets/images/healthcare.png",
                                height: 40.0,
                                width: 40.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 9,
                              xl: 9,
                              md: 8,
                              xs: 9,
                              child: Padding(
                                padding: EdgeInsets.only(top: 7.0),
                                child: Text(
                                  "HEALTH INSURANCE",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromRGBO(113, 114, 111, 1)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        BootstrapCol(
                          lg: 3,
                          xl: 3,
                          md: 4,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 2,
                              xl: 2,
                              md: 2,
                              xs: 3,
                              child: Image.asset(
                                "assets/images/employees.png",
                                height: 40.0,
                                width: 40.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 9,
                              xl: 9,
                              md: 8,
                              xs: 9,
                              child: Padding(
                                padding: EdgeInsets.only(top: 7.0),
                                child: Text(
                                  "EMPLOYEE INSURANCE",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromRGBO(113, 114, 111, 1)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        BootstrapCol(
                          lg: 2,
                          xl: 2,
                          md: 4,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 3,
                              xl: 3,
                              md: 2,
                              xs: 3,
                              child: Image.asset(
                                "assets/images/sedan.png",
                                height: 40.0,
                                width: 40.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 9,
                              xl: 9,
                              md: 8,
                              xs: 9,
                              child: Padding(
                                padding: EdgeInsets.only(top: 7.0),
                                child: Text(
                                  "CAR INSURANCE",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromRGBO(113, 114, 111, 1)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        BootstrapCol(
                          lg: 2,
                          xl: 2,
                          md: 4,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 3,
                              xl: 3,
                              md: 2,
                              xs: 3,
                              child: Image.asset(
                                "assets/images/home.png",
                                height: 40.0,
                                width: 40.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 9,
                              xl: 9,
                              md: 8,
                              xs: 9,
                              child: Padding(
                                padding: EdgeInsets.only(top: 7.0),
                                child: Text(
                                  "HOME INSURANCE",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromRGBO(113, 114, 111, 1)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //fourth row
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: BootstrapRow(
                      children: [
                        BootstrapCol(
                          lg: 12,
                          xl: 12,
                          md: 12,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: Image.asset(
                                "assets/images/Group.png",
                                height: 400.0,
                                width: 600.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: BootstrapRow(
                                children: [
                                  BootstrapCol(
                                    lg: 6,
                                    xl: 6,
                                    md: 9,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/plane.png",
                                          height: 60.0,
                                          width: 60.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 7,
                                    xl: 7,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "TRAVEL INSURANCE",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(113, 114, 111, 1),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, left: 20.0),
                                      child: Text(
                                        'Lorem Ipsum is simply dummy text of the printing and type setting industry and uses Latin words combined with a handful a model words',
                                        style: GoogleFonts.poppins(
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1),
                                            fontSize: 16,
                                            height: 1.6),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 7,
                                    xl: 7,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            _isHovered7 = true;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            _isHovered7 = false;
                                          });
                                        },
                                        child: Center(
                                          child: SizedBox(
                                            height: 50.0,
                                            width: 200.0,
                                            child:
                                                FloatingActionButton.extended(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Quote();
                                                  },
                                                );
                                              },
                                              backgroundColor: _isHovered7
                                                  ? Colors
                                                      .white // Hovered color
                                                  : Color.fromRGBO(
                                                      199, 55, 125, 1.0),
                                              label: Row(
                                                children: [
                                                  Text(
                                                    'Get a quote',
                                                    style: GoogleFonts.poppins(
                                                      color: _isHovered7
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color: _isHovered7
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //fifth row
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Container(
                  color: Color.fromRGBO(246, 233, 242, 1.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: BootstrapRow(
                      children: [
                        BootstrapCol(
                          lg: 12,
                          xl: 12,
                          md: 12,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: BootstrapRow(
                                children: [
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 8,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/healthcare@2x.png",
                                          height: 60.0,
                                          width: 60.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 8,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "HEALTH INSURANCE",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1)),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 20.0, left: 20),
                                      child: Center(
                                        child: Text(
                                          'Lorem Ipsum is simply dummy text of the printing and type setting industry and uses Latin words combined with a handful a model words',
                                          // textAlign: TextAlign.right,
                                          style: GoogleFonts.poppins(
                                              color: Color.fromRGBO(
                                                  113, 114, 111, 1),
                                              fontSize: 16,
                                              height: 1.6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 8,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            _isHovered8 = true;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            _isHovered8 = false;
                                          });
                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 50.0,
                                            width: 200.0,
                                            child:
                                                FloatingActionButton.extended(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Quote();
                                                  },
                                                );
                                              },
                                              backgroundColor: _isHovered8
                                                  ? Colors
                                                      .white // Hovered color
                                                  : Color.fromRGBO(
                                                      199, 55, 125, 1.0),
                                              label: Row(
                                                children: [
                                                  Text(
                                                    'Get a quote',
                                                    style: GoogleFonts.poppins(
                                                      color: _isHovered8
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color: _isHovered8
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: Image.asset(
                                "assets/images/Group.png",
                                height: 400.0,
                                width: 600.0,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //Sixth row
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: BootstrapRow(
                      children: [
                        BootstrapCol(
                          lg: 12,
                          xl: 12,
                          md: 12,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: Image.asset(
                                "assets/images/Group.png",
                                height: 400.0,
                                width: 600.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: BootstrapRow(
                                children: [
                                  BootstrapCol(
                                    lg: 6,
                                    xl: 6,
                                    md: 8,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/employees@2x.png",
                                          height: 60.0,
                                          width: 60.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 7,
                                    xl: 7,
                                    md: 8,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Text(
                                          "EMPLOYEE INSURANCE",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  113, 114, 111, 1)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 20.0, left: 10),
                                      child: Text(
                                        'Lorem Ipsum is simply dummy text of the printing and type setting industry and uses Latin words combined with a handful a model words',
                                        style: GoogleFonts.poppins(
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1),
                                            fontSize: 16,
                                            height: 1.6),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 7,
                                    xl: 7,
                                    md: 7,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            _isHovered11 = true;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            _isHovered11 = false;
                                          });
                                        },
                                        child: Center(
                                          child: SizedBox(
                                            height: 50.0,
                                            width: 200.0,
                                            child:
                                                FloatingActionButton.extended(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Quote();
                                                  },
                                                );
                                              },
                                              backgroundColor: _isHovered11
                                                  ? Colors
                                                      .white // Hovered color
                                                  : Color.fromRGBO(
                                                      199, 55, 125, 1.0),
                                              label: Row(
                                                children: [
                                                  Text(
                                                    'Get a quote',
                                                    style: GoogleFonts.poppins(
                                                      color: _isHovered11
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color: _isHovered11
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //Seventh row
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Container(
                  color: Color.fromRGBO(246, 233, 242, 1.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: BootstrapRow(
                      children: [
                        BootstrapCol(
                          lg: 12,
                          xl: 12,
                          md: 12,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: BootstrapRow(
                                children: [
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 8,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/sedan@2x.png",
                                          height: 60.0,
                                          width: 60.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 8,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "CAR INSURANCE",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1)),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 20.0, left: 20),
                                      child: Text(
                                        'Lorem Ipsum is simply dummy text of the printing and type setting industry and uses Latin words combined with a handful a model words',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1),
                                            fontSize: 16,
                                            height: 1.6),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 8,
                                    xl: 8,
                                    md: 9,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            _isHovered9 = true;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            _isHovered9 = false;
                                          });
                                        },
                                        child: Center(
                                          child: SizedBox(
                                            height: 50.0,
                                            width: 200.0,
                                            child:
                                                FloatingActionButton.extended(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Quote();
                                                  },
                                                );
                                              },
                                              backgroundColor: _isHovered9
                                                  ? Colors
                                                      .white // Hovered color
                                                  : Color.fromRGBO(
                                                      199, 55, 125, 1.0),
                                              label: Row(
                                                children: [
                                                  Text(
                                                    'Get a quote',
                                                    style: GoogleFonts.poppins(
                                                      color: _isHovered9
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color: _isHovered9
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: Image.asset(
                                "assets/images/Group.png",
                                height: 400.0,
                                width: 600.0,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //eighth row
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: BootstrapRow(
                      children: [
                        BootstrapCol(
                          lg: 12,
                          xl: 12,
                          md: 12,
                          xs: 12,
                          child: BootstrapRow(children: [
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: Image.asset(
                                "assets/images/Group.png",
                                height: 400.0,
                                width: 600.0,
                              ),
                            ),
                            BootstrapCol(
                              lg: 6,
                              xl: 6,
                              md: 6,
                              xs: 12,
                              child: BootstrapRow(
                                children: [
                                  BootstrapCol(
                                    lg: 7,
                                    xl: 7,
                                    md: 9,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/home@2x.png",
                                          height: 60.0,
                                          width: 60.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 7,
                                    xl: 7,
                                    md: 9,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Text(
                                          "HOME INSURANCE",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  113, 114, 111, 1)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 9,
                                    xl: 9,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, left: 10.0),
                                      child: Text(
                                        'Lorem Ipsum is simply dummy text of the printing and type setting industry and uses Latin words combined with a handful a model words',
                                        style: GoogleFonts.poppins(
                                            color: Color.fromRGBO(
                                                113, 114, 111, 1),
                                            fontSize: 16,
                                            height: 1.6),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  BootstrapCol(
                                    lg: 7,
                                    xl: 7,
                                    md: 10,
                                    xs: 12,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            _isHovered10 = true;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            _isHovered10 = false;
                                          });
                                        },
                                        child: Center(
                                          child: SizedBox(
                                            height: 50.0,
                                            width: 200.0,
                                            child:
                                                FloatingActionButton.extended(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Quote();
                                                  },
                                                );
                                              },
                                              backgroundColor: _isHovered10
                                                  ? Colors
                                                      .white // Hovered color
                                                  : Color.fromRGBO(
                                                      199, 55, 125, 1.0),
                                              label: Row(
                                                children: [
                                                  Text(
                                                    'Get a quote',
                                                    style: GoogleFonts.poppins(
                                                      color: _isHovered10
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color: _isHovered10
                                                          ? Color.fromRGBO(
                                                              113,
                                                              114,
                                                              111,
                                                              1) // Hovered color
                                                          : Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //Cards
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    child: BootstrapRow(
                      children: [
                        BootstrapCol(
                          lg: 4,
                          xl: 4,
                          md: 6,
                          xs: 12,
                          child: Card(
                            surfaceTintColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Better Coverage',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Know More',
                                            style: GoogleFonts.poppins(
                                              color: Color.fromRGBO(
                                                  199, 55, 125, 1.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {/* ... */},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          lg: 4,
                          xl: 4,
                          md: 6,
                          xs: 12,
                          child: Card(
                            elevation: 4,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Cost Effective',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Know More',
                                            style: GoogleFonts.poppins(
                                              color: Color.fromRGBO(
                                                  199, 55, 125, 1.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {/* ... */},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          lg: 4,
                          xl: 4,
                          md: 6,
                          xs: 12,
                          child: Card(
                            surfaceTintColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Best Practises',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Know More',
                                            style: GoogleFonts.poppins(
                                              color: Color.fromRGBO(
                                                  199, 55, 125, 1.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {/* ... */},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          lg: 4,
                          xl: 4,
                          md: 6,
                          xs: 12,
                          child: Card(
                            elevation: 4,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Customer first',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Know More',
                                            style: GoogleFonts.poppins(
                                              color: Color.fromRGBO(
                                                  199, 55, 125, 1.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {/* ... */},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          lg: 4,
                          xl: 4,
                          md: 6,
                          xs: 12,
                          child: Card(
                            elevation: 4,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Flexible Plans',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Know More',
                                            style: GoogleFonts.poppins(
                                              color: Color.fromRGBO(
                                                  199, 55, 125, 1.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {/* ... */},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BootstrapCol(
                          lg: 4,
                          xl: 4,
                          md: 6,
                          xs: 12,
                          child: Card(
                            surfaceTintColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Premium Service',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Color.fromRGBO(121, 122, 119, 1),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Know More',
                                            style: GoogleFonts.poppins(
                                              color: Color.fromRGBO(
                                                  199, 55, 125, 1.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {/* ... */},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
