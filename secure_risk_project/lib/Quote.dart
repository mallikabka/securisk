import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:toastification/toastification.dart';

enum Fruit { apple, banana }

class Quote extends StatefulWidget {
  Quote({super.key});

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  Fruit? _fruit = Fruit.apple;
  bool isButtonEnabled = false;

  // late TextEditingController _controller;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void _checkButtonStatus(String value) {
    setState(() {
      isButtonEnabled = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          messageController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Center(
        child: Text(
          'GET A FREE QUOTE',
          style: GoogleFonts.poppins(
              color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width * 0.55,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 10, // Adjust the elevation value as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      shadowColor: Color.fromARGB(
                          255, 250, 245, 245), // Set the shadow color

                      child: TextFormField(
                        controller: nameController,
                        onChanged: _checkButtonStatus,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Name',
                          hintStyle: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 10, // Adjust the elevation value as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.white, // Set the shadow color
                        child: TextField(
                          controller: emailController,
                          onChanged: _checkButtonStatus,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Email',
                            hintText: 'Email',
                            hintStyle: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 10, // Adjust the elevation value as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      shadowColor: Colors.white, // Set the shadow color
                      child: TextField(
                        controller: phoneController,
                        onChanged: _checkButtonStatus,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Phone',
                          hintText: 'Phone',
                          hintStyle: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: messageController,
                          onChanged: _checkButtonStatus,
                          maxLines: 8, // Allow multiple lines
                          keyboardType:
                              TextInputType.multiline, // Enable multiline input
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Message',
                            hintText: 'Enter your message...',
                            hintStyle: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Corporate  Insurence',
                            style: GoogleFonts.poppins()),
                        leading: Radio<Fruit>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => SecureRiskColours.Button_Color),
                          value: Fruit.banana,
                          groupValue: _fruit,
                          onChanged: (Fruit? value) {
                            setState(() {
                              _fruit = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Retail  Insurence',
                            style: GoogleFonts.poppins()),
                        leading: Radio<Fruit>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => SecureRiskColours.Button_Color),
                          value: Fruit.apple,
                          groupValue: _fruit,
                          onChanged: (Fruit? value) {
                            setState(() {
                              _fruit = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: SizedBox(
                            width: 80,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isButtonEnabled
                                  ? () {
                                      toastification.show(
                                        context: context,
                                        autoCloseDuration: Duration(seconds: 2),
                                        title: 'Quote is send successfully',
                                      );
                                      Timer(Duration(seconds: 2), () {
                                        Navigator.pushReplacementNamed(
                                            context, '/landing_Page');
                                      });
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 27, 170, 231),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get a quote',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_circle_right,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
