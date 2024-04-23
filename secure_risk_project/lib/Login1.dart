import 'dart:async';
import 'dart:convert';
import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:loginapp/HR_Employee/hr_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool obscureText = true;
  bool passToggle = true;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // ignore: unused_local_variable
    bool _isObsecure = true;
    // ignore: unused_local_variable
    bool isButtonEnabled = false;

    return Scaffold(
      body: BootstrapRow(
        children: [
          BootstrapCol(
            lg: 8,
            xl: 8,
            md: 8,
            xs: 12,
            child: Container(
              height: MediaQuery.of(context).size.width >= 600
                  ? screenHeight * 1.00
                  : screenHeight * 0.42,
              child: Image.asset(
                "assets/images/MaskGroup4.png",
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
          BootstrapCol(
            lg: 4,
            xl: 4,
            md: 4,
            xs: 12,
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenWidth <= 600 ? 1.0 : screenHeight * 0.08,
                  left: screenWidth <= 600 ? 1.0 : 20.0),
              child: BootstrapRow(
                children: [
                  BootstrapCol(
                    lg: 10,
                    xl: 10,
                    md: 12,
                    xs: 12,
                    child: Image.asset(
                      "assets/images/Template2.png",
                      height: 50,
                    ),
                  ),
                  BootstrapCol(
                    lg: 10,
                    xl: 10,
                    md: 12,
                    xs: 12,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenWidth <= 600 ? 0.1 : 30.0,
                        ),
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.poppins(
                              color: SecureRiskColours.Button_Color,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  BootstrapCol(
                    lg: 10,
                    xl: 10,
                    md: 12,
                    xs: 12,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenWidth <= 600 ? 0.1 : 30.0,
                        left: 14.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Id',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: SecureRiskColours.Button_Color),
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Enter Email Id',
                            ),
                          ),
                          _emailError != null
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: height * 0.05,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        top: 4.0,
                                      ),
                                      child: Text(
                                        _emailError!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(height: height * 0.02),
                        ],
                      ),
                    ),
                  ),
                  BootstrapCol(
                    lg: 10,
                    xl: 10,
                    md: 12,
                    xs: 12,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenWidth <= 600 ? 0.5 : 10.0,
                        left: 14.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          TextFormField(
                            controller: passwordController,
                            obscureText: passToggle,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: SecureRiskColours.Button_Color),
                              ),
                              border: OutlineInputBorder(),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passToggle = !passToggle;
                                    
                                  });
                                },
                                child: Icon(
                                  passToggle
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              hintText: "Enter Password",
                            ),
                             onFieldSubmitted: (value) {
          // Call the login method when the user submits the password
          login(emailController.text.toString(), value);
        },
                          ),
                          _passwordError != null
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: height * 0.07,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        top: 4.0,
                                      ),
                                      child: Text(
                                        _passwordError!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(height: height * 0.05),
                        ],
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
                        top: screenWidth <= 600 ? 6.0 : 20.0,
                        left: 16.0,
                      ),
                      child: BootstrapRow(
                        children: [
                          BootstrapCol(
                            lg: 4,
                            xl: 4,
                            md: 12,
                            xs: 5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SecureRiskColours.Button_Color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: () {
                                login(emailController.text.toString(),
                                    passwordController.text.toString());
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          BootstrapCol(
                            lg: 7,
                            xl: 7,
                            md: 12,
                            xs: 5,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: screenWidth <= 600 ? 1 : 5.0,
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/forgot_page',
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: GoogleFonts.poppins(
                                        color: SecureRiskColours.Button_Color),
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
            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is mandatory';
    } else if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9_-]+\.[a-zA-Z]+$')
        .hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is mandatory';
    }
    return null;
  }

  void login(String email, password) async {
    setState(() {
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
    });

    try {
      if (_emailError == null && _passwordError == null) {
        final Map<String, String> bodyParams = {
          'username': email,
          'password': password,
        };

        final prefs = await SharedPreferences.getInstance();

        Response response = await post(
          Uri.parse(ApiServices.baseUrl + ApiServices.user_login_EndPoint),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(bodyParams),
        );

        if (response.statusCode == 200) {
          await prefs.setString('email', email);

          Map<String, dynamic> jsonData = jsonDecode(response.body);
          List<dynamic> operationMapped =
              jsonData['designationBasedOperation']['operationMapped'];
          String accessToken = jsonData['accessToken'];
          await prefs.setString("accessToken", accessToken);
          for (var operation in operationMapped) {
            if ('${operation['operationType']}' == 'Home') {
              await prefs.setString(
                  'Home', "${operation['isOperationMapped']}");
            } else if ('${operation['operationType']}' == 'ClientList') {
              await prefs.setString(
                  'ClientList', "${operation['isOperationMapped']}");
              List<dynamic>? subOperation = operation['subOperation'];
              if (subOperation != null) {
                for (var subOp in subOperation) {
                  if ('${subOp['operationName']}' == 'Active') {
                    await prefs.setString(
                        'ActiveClientList', "${subOp['operationFlag']}");
                  } else if ('${subOp['operationName']}' == 'Renewals') {
                    await prefs.setString(
                        'RenewalsClientList', "${subOp['operationFlag']}");
                  } else if ('${subOp['operationName']}' == 'Archives') {
                    await prefs.setString(
                        'ArchivesClientList', "${subOp['operationFlag']}");
                  }
                }
              }
            } else if ('${operation['operationType']}' == 'RFQ') {
              await prefs.setString('RFQ', "${operation['isOperationMapped']}");
            } else if ('${operation['operationType']}' == 'Create Location') {
              await prefs.setString(
                  'Create Location', "${operation['isOperationMapped']}");
            } else if ('${operation['operationType']}' ==
                'IntermediaryDetails') {
              await prefs.setString(
                  'IntermediaryDetails', "${operation['isOperationMapped']}");
              List<dynamic>? subOperation = operation['subOperation'];
              if (subOperation != null) {
                for (var subOp in subOperation) {
                  if ('${subOp['operationName']}' == 'Products') {
                    await prefs.setString(
                        'Products', "${subOp['operationFlag']}");
                  } else if ('${subOp['operationName']}' == 'TPA List') {
                    await prefs.setString(
                        'TPA List', "${subOp['operationFlag']}");
                  } else if ('${subOp['operationName']}' == 'Insurer List') {
                    await prefs.setString(
                        'Insurer List', "${subOp['operationFlag']}");
                  }
                }
              }
            } else if ('${operation['operationType']}' == 'Templates') {
              await prefs.setString(
                  'Templates', "${operation['isOperationMapped']}");
            } else if ('${operation['operationType']}' == 'Roles') {
              await prefs.setString(
                  'Roles', "${operation['isOperationMapped']}");
            } else if ('${operation['operationType']}' == 'Department') {
              await prefs.setString(
                  'Department', "${operation['isOperationMapped']}");
            }
          }

          toastification.showSuccess(
            context: context,
            autoCloseDuration: const Duration(seconds: 2),
            title: 'Login Successfully',
          );

          //Timer(const Duration(seconds: 2), () {
               if (email == "hr@gmail.com") {
            // Navigator.pushReplacementNamed(
            //   context,
            //   '/hr_page',
            // );
            Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                          HRPage()),                                                
                                        );
          } else {
            Navigator.pushNamed(
              context,
              '/dashboard_page',
            );}
          // }
          // );
        } else {
          toastification.showError(
            context: context,
            autoCloseDuration: const Duration(seconds: 2),
            title: 'Invalid Credentials',
          );
        }
      }
    } catch (e) {
      // ignore: avoid_print
      (e.toString());
    }
  }
}
