import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:loginapp/SideBarComponents/AppBar.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isHovered1 = false;

  @override
  void dispose() {
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBarExample(),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        height: screenHeight * 0.9,
        width: screenWidth * 0.975,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 128, 126, 126),
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: BootstrapRow(
            children: [
              BootstrapCol(
                lg: 12,
                xl: 12,
                md: 12,
                xs: 12,
                child: BootstrapRow(
                  children: [
                    BootstrapCol(
                      lg: 4,
                      xl: 4,
                      md: 6,
                      xs: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Update Password",
                          style: GoogleFonts.poppins(
                              color: SecureRiskColours.Button_Color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BootstrapCol(
                child: BootstrapRow(
                  children: [
                    BootstrapCol(
                      lg: 4,
                      xl: 4,
                      md: 6,
                      xs: 10,
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: SecureRiskColours
                                    .Button_Color), // Change the color as needed
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Enter Your Current Password',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BootstrapCol(
                child: BootstrapRow(
                  children: [
                    BootstrapCol(
                      lg: 4,
                      xl: 4,
                      md: 6,
                      xs: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: TextField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: SecureRiskColours
                                      .Button_Color), // Change the color as needed
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter New Password',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BootstrapCol(
                child: BootstrapRow(
                  children: [
                    BootstrapCol(
                      lg: 4,
                      xl: 4,
                      md: 6,
                      xs: 10,
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: SecureRiskColours
                                    .Button_Color), // Change the color as needed
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Confirm Password',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BootstrapCol(
                lg: 4,
                xl: 4,
                md: 6,
                xs: 10,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: _isHovered1
                          ? Color.fromRGBO(199, 55, 125, 1.0) // Hovered color
                          : SecureRiskColours.Button_Color,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.poppins(
                          color: _isHovered1
                              ? Colors.white // Hovered color
                              : Colors.white,
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
    );
  }

  login(BuildContext context) async {
    try {
      String password = passwordController.text;
      String newPassword = newPasswordController.text;
      String confirmPassword = confirmPasswordController.text;

      final Map<String, String> bodyParams = {
        'password': password,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword
      };

      var headers = await ApiServices.getHeaders();
      Response response = await put(
        Uri.parse(ApiServices.baseUrl + ApiServices.reset_Password),
        headers: headers,
        body: jsonEncode(bodyParams),
      );
      if (response.statusCode == 200) {
        // Show success popup
        showPasswordUpdatedPopup(context);
        // Navigate to login page or any other page as per your requirement
        Navigator.pushNamed(
          context,
          '/login_page',
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void showPasswordUpdatedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Updated Successfully'),
          content: Text('Your password has been updated successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
