import 'dart:convert';
import 'dart:io';
import 'dart:js';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:toastification/toastification.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  late TextEditingController _controller;
  final TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;

  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _checkButtonStatus(String value) {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  // "assets/images/MaskGroup4.png",
                  "assets/images/MaskGroup4.png",
                  fit: BoxFit.cover,
                  height: 790,
                  width: 749,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 168),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    width: 581,
                    height: 62,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 120, bottom: 10),
                      child: Image.asset("assets/images/Template2.png"),
                    ),
                  ),
                  SizedBox(
                    width: 301,
                    height: 57,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 10),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Forgot Password ',
                          style: TextStyle(
                            fontSize: 27,
                            color: Color.fromRGBO(38, 38, 38, 0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 323,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        'Enter your email and we will send you a link to reset your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(38, 38, 38, 0.4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 65.0,
                    width: 354.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 14),
                      child: Material(
                        elevation: 5,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: TextField(
                          controller: emailController,
                          onChanged: _checkButtonStatus,
                          decoration: const InputDecoration(
                            labelText: 'Enter Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    height: 75,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, left: 25),
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                                login(emailController.text.toString(), context);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      margin: const EdgeInsets.only(left: 230, top: 5),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/login_page',
                          );
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Back to Login?',
                            style: TextStyle(
                              color: SecureRiskColours.Button_Color,
                              decoration: TextDecoration.none,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login(String email, BuildContext context) async {
    try {
      final Map<String, String> bodyParams = {
        'email': email,
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      Response response = await post(
        Uri.parse(ApiServices.baseUrl + ApiServices.Forgot_EndPoint),
        headers: headers,
        body: jsonEncode(bodyParams),
      );

      if (response.statusCode == 200) {
        // Login successful
        print("forgot successful");

        // Extract message from the response body
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody['message'] ?? 'Email sent successfully';

        toastification.showSuccess(
          context: context,
          autoCloseDuration: const Duration(seconds: 2),
          title: 'email send succcessfully',
        );

        Timer(
          const Duration(seconds: 2),
          () {
            Navigator.pushNamed(
              context,
              '/change_password_page',
            );
          },
        );
      } else {
        // Login failed
        print("Login failed with status code: ${response.statusCode}");

        // Extract error message from the response body
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['error'] ?? 'Failed to send email';
      }
    } catch (e) {
      // Handle exceptions (e.g., network error)
      print("Exception during login: $e");
      Fluttertoast.showToast(
        msg: 'Error occurred: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
