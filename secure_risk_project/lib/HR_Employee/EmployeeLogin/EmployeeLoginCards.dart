import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loginapp/ClientList/ActiveClientList.dart';
import 'dart:math' as math;

import 'package:loginapp/Colours.dart';
import 'package:loginapp/HR_Employee/EmployeeLogin/PolicyDetails.dart';
import 'package:loginapp/LandingPage.dart';

class EmployeeLoginCardsPage extends StatelessWidget {
  final List<String> items = [
    "Policy Details",
    "Member Details",
    "E-Cards",
    "Network Hospital",
    "Downloads",
    "Coverages",
    "E-Cashless",
    "Claims",
    "Claim Intimation",
    "Claim Tracker",
    "Submit Claim",
  ]; // List of items for each card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Card(
            margin: EdgeInsets.only(
                top: 48, left: 68.0, right: 68), // Margin around the card
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Claims\nSettled', style: TextStyle(fontSize: 15)),
                  Spacer(), // This widget will create space between the text widgets
                  Text('Claims\nPending', style: TextStyle(fontSize: 15)),
                  Spacer(), // Another spacer for even space distribution
                  Text('Claims\nRejected', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Increase to 4 for smaller width per card
                childAspectRatio:
                    1 / 1, // Adjusted for slightly taller than wide cards
                crossAxisSpacing:
                    0, // Spacing between items along the cross axis
                mainAxisSpacing: 0, // Spacing between items along the main axis
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CardWidget(item: items[index], index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final String item;
  final int index;

  CardWidget({required this.item, required this.index});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMouseEnter(bool isHovering) {
    if (isHovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onMouseEnter(true),
      onExit: (_) => _onMouseEnter(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final bool isHovering = _controller.value > 0.5;
          final double rotationValue = math.pi * _flipAnimation.value;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(rotationValue)
              ..setEntry(3, 2, 0.001), // perspective tweak
            child: rotationValue > math.pi / 2
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: _buildBackSide(context, widget.item, widget.index),
                  )
                : buildFrontSide(context, widget.item, widget.index),
          );
        },
      ),
    );
  }

  Widget buildFrontSide(BuildContext context, String item, int index) {
    return Center(
      child: SizedBox(
        width: 350, // Explicit width of the Card
        height: 300, // Explicit height of the Card
        child: Card(
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.only(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: IconButton(
                      icon: const Icon(FontAwesomeIcons.users, size: 100),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: ActiveClientList(),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    item,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(height: 15),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => ActiveClientList()),
                  //     );
                  //   },
                  //   child: Text('Button'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildBackSide(BuildContext context, String item, int index) {
  return Center(
    child: SizedBox(
      width: 350, // Explicit width of the Card
      height: 300, // Explicit height of the Card
      child: Card(
        //color: Colors.blueGrey, // Differentiate back side
        margin: EdgeInsets.all(0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                item,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              uniqueButton(context, item, index)
              // OutlinedButton(
              //   onPressed: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //       builder: (context) => EmployeePolicyDetails()),
              //     // );
              //     //  onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return Dialog(
              //           child: Container(
              //             padding: EdgeInsets.all(20),
              //             constraints: BoxConstraints(
              //                 maxWidth: 400,
              //                 maxHeight: 450), // Limit dialog size
              //             child: EmployeePolicyDetails(),
              //           ),
              //         );
              //       },
              //     );
              //     // },
              //   },
              //   child: Text(
              //     'Button',
              //     style: TextStyle(color: SecureRiskColours.Button_Color),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget uniqueButton(BuildContext context, String item, int index) {
  switch (item) {
    case "Policy Details":
      return OutlinedButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => EmployeePolicyDetails()),
          // );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  padding: EdgeInsets.all(20),
                  constraints: BoxConstraints(
                      maxWidth: 400, maxHeight: 420), // Limit dialog size
                  child: EmployeePolicyDetails(),
                ),
              );
            },
          );
        },
        child: Text(
          'Policy Details',
          style: TextStyle(color: SecureRiskColours.Button_Color),
        ),
      );
    case "Member Details":
      return OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        },
        child: Text('Member Details',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "E-Cards":
      return OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        },
        child: Text('E-Cards',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "Network Hospital":
      return OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        },
        child: Text("Network Hospital",
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "Downloads":
      return OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        },
        child: Text('Downloads',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "Coverages":
      return OutlinedButton(
        onPressed: () {
          // Navigate to the Submit Claim page
        },
        child: Text('Coverages',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "E-Cashless":
      return OutlinedButton(
        onPressed: () {
          // Navigate to the Submit Claim page
        },
        child: Text('E-Cashless',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "Claims":
      return OutlinedButton(
        onPressed: () {
          // Navigate to the Submit Claim page
        },
        child: Text('Claims',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "Claim Intimation":
      return OutlinedButton(
        onPressed: () {
          // Navigate to the Submit Claim page
        },
        child: Text('Claim Intimation',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "Claim Tracker":
      return OutlinedButton(
        onPressed: () {
          // Navigate to the Submit Claim page
        },
        child: Text('Claim Tracker',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    case "Submit Claim":
      return OutlinedButton(
        onPressed: () {
          // Navigate to the Submit Claim page
        },
        child: Text('Submit Claim',
            style: TextStyle(color: SecureRiskColours.Button_Color)),
      );
    default:
      return SizedBox(); // Return an empty widget for unspecified cases
  }
}
