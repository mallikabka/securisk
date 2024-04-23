// import 'package:flutter/material.dart';
// import 'package:loading_animations/loading_animations.dart';
// import 'package:loginapp/Colours.dart';

// class Loader {
//   static OverlayEntry? _overlayEntry;

//   static void showLoader(BuildContext context) {
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).size.height / 2 - 30,
//         left: MediaQuery.of(context).size.width / 2 - 30,
//         child: LoadingBouncingLine.circle(
//           backgroundColor: SecureRiskColours.Button_Color, // Set the background color as needed
//         ),
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//   }

//   static void hideLoader() {
//     _overlayEntry?.remove();
//   }
// }

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loginapp/Colours.dart';

class Loader {
  static OverlayEntry? _overlayEntry;
  static bool _isLoading = false;

  static void showLoader(BuildContext context) {
    // Check if a loader is already visible
    if (_isLoading) {
      hideLoader(); // Close the existing loader
    }

    _isLoading = true;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 30,
        left: MediaQuery.of(context).size.width / 2 - 30,
        child: LoadingBouncingLine.circle(
          backgroundColor: SecureRiskColours.Button_Color,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hideLoader() {
    if (_isLoading) {
      _isLoading = false;
      _overlayEntry?.remove();
    }
  }
}
