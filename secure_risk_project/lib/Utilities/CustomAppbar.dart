import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';

class AppBarBuilder {
  static AppBar buildAppBar(String title) {
    return AppBar(
      toolbarHeight: 35, // Change this to your desired app bar height
      backgroundColor: SecureRiskColours
          .Table_Heading_Color, // Change this to your desired color
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 5,
    );
  }
}
