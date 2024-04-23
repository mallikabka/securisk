import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Validations {
  static String test = "sds";

  static Widget stringValidations(
      String field, void Function(bool status) isValid) {
    if (field.isEmpty) {
      isValid(false);
      return  Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          "Field is mandatory",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    }
    isValid(true);
    return SizedBox.shrink();
  }

  static Widget stringValidation(String field) {
    if (field.isEmpty) {
      return  Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          "Field is mandatory",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    }

    return SizedBox();
  }


  static Widget emailValidations(
      String email, void Function(bool status) isValid) {
    final RegExp emailRegex =
        RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
    if (email.isEmpty) {
      isValid(false);
      return  Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          "Field is mandatory",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    } else if (!emailRegex.hasMatch(email)) {
      isValid(false);
      return  Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          "Invalid email address",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    }
    isValid(true);
    return SizedBox.shrink(); // Empty widget to signify no error
  }

  static Widget phoneNumberValidations(
      String phoneNumber, void Function(bool status) isValid) {
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    if (phoneNumber.isEmpty) {
      isValid(false);
      return  Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          "Field is mandatory",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    } else if (!phoneRegex.hasMatch(phoneNumber)) {
      isValid(false);
      return  Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          "Invalid phone number",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    }
    isValid(true);
    return SizedBox.shrink(); // Empty widget to signify no error
  }

  static Widget emailValidation(String value) {
    if (value.isEmpty) {
      return  SizedBox.shrink();
    } else if (!_isValidEmail(value)) {
      return Padding(
        padding:  EdgeInsets.only(top: 5.0),
        child: Text(
          "Invalid email format",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  static Widget phoneNumberValidation(String value) {
    if (value.isEmpty) {
      return  SizedBox.shrink();
    } else if (!_isValidPhoneNumber(value)) {
      return Padding(
        padding:  EdgeInsets.only(top: 5.0),
        child: Text(
          "Invalid phone number format",
          style: GoogleFonts.poppins(fontSize: 14, color: Color.fromRGBO(240, 46, 20, 1)),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  static bool _isValidEmail(String value) {
    // Implement your email format validation logic here
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  static bool _isValidPhoneNumber(String value) {
    // Implement your phone number format validation logic here
    return RegExp(r'^\d{10}$').hasMatch(value);
  }
}
