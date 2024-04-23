import 'dart:ui';

import 'package:flutter/material.dart';

class SecureRiskColours {
  static Color Table_Heading_Color = Color(0xff414141);

  static Color Button_Color = Color(0xff96338A);

  static Color Back_Button_Color = Color.fromRGBO(52, 58, 48, 1.0);
  static Color Text_Color = Color(0xff96338A);
  static Color table_Text_Color = Color(0xffFFFFFF);
  //  static  Color Button_Color = Color.fromRGBO(199, 55, 125, 1.0);

  static Color Button_shadow_Color = Color.fromARGB(199, 231, 8, 38);
  static String rolesHeaderBlue = "";
  static Color blue = Color.fromRGBO(62, 69, 87, 1);
  static Color toggleOn = Color.fromRGBO(62, 69, 87, 1);
  static Color toggleOff = Color.fromRGBO(241, 241, 241, 1);
  static Color rolesblue = Color.fromRGBO(9, 104, 160, 1);

  static Color appBarColor = Color.fromRGBO(246, 233, 242, 1.0);
  static Color graphbar = Color.fromARGB(198, 238, 97, 32);

  static const AppbarHeight = 28.0;

  static ButtonStyle customButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Adjust the border radius here
        ),
      ),
      backgroundColor:
          MaterialStateProperty.all<Color>(SecureRiskColours.Button_Color),
      shadowColor: MaterialStateProperty.all<Color>(
          SecureRiskColours.Button_shadow_Color),
    );
  }
}
