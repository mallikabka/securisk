import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/LandingPage.dart';

class DialogUtils {
  static void showSessionExpiredDialog(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth = screenWidth * 0.33;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: true,
      title: 'Error',
      desc: 'Your Session has been Expired........!',
      descTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      btnOkOnPress: () {
        // Navigator.of(context).pop(); // Close the dialog
        _navigateToLandingPage(context);
      },
      btnOkIcon: Icons.cancel,
      btnCancelOnPress: () {
        _navigateToLandingPage(context);
      },
      onDismissCallback: (type) {
        _navigateToLandingPage(context);
      },
      btnOkColor: Colors.red,
      width: dialogWidth,
    ).show();
  }
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: Text('Session Expired'),
  //       content: Text(
  //           'Your session has expired. Click OK to go to the landing page.'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop(); // Close the dialog
  //             _navigateToLandingPage(context);
  //           },
  //           child: Text('OK'),
  //         ),
  //       ],
  //     );
  //   },
  // ).then((value) {
  // Navigate to the landing page even if the user clicks outside the dialog
  // _navigateToLandingPage(context);
  // });

  static void _navigateToLandingPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>  LandingPage(),
      ),
    );
  }
}
