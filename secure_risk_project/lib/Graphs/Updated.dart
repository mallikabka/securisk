// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'Donut.dart';
import 'monthAndYear.dart';
import 'locationbased.dart';

class Updated extends StatefulWidget {
  const Updated({super.key});

  @override
  State<Updated> createState() => _UpdatedState();
}

class _UpdatedState extends State<Updated> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: screenHeight * 0.45,
                    width: screenWidth * 0.48,
                    // decoration: BoxDecoration(
                    //    color: Colors.green,
                    //     borderRadius: BorderRadius.all(Radius.circular(30.0))),

                    child: Card(
                      elevation: 4,
                      child: ChartPage(),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: screenHeight * 0.45,
                    width: screenWidth * 0.49,
                    child: Card(
                      elevation: 4,
                      child: Donutgraph(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: screenHeight * 0.40,
                width: screenWidth * 0.98,
                // decoration: BoxDecoration(
                //    color: Colors.green,
                //     borderRadius: BorderRadius.all(Radius.circular(30.0))),

                child: Card(
                  elevation: 4,
                  child: LocationBased(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'Donut.dart';
// import 'monthAndYear.dart';
// import 'locationbased.dart';

// class Updated extends StatefulWidget {
//   const Updated({Key? key}) : super(key: key);

//   @override
//   State<Updated> createState() => _UpdatedState();
// }

// class _UpdatedState extends State<Updated> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Expanded(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 elevation: 4,
//                                 child: ChartPage(),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Expanded(
//                               child: Card(
//                                 elevation: 4,
//                                 child: Donutgraph(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Expanded(
//                         child: Card(
//                           elevation: 4,
//                           child: LocationBased(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
