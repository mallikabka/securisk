// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyMapPage(),
//     );
//   }
// }

// class MyMapPage extends StatefulWidget {
//   @override
//   _MyMapPageState createState() => _MyMapPageState();
// }

// class _MyMapPageState extends State<MyMapPage> {
//   List<Location> locations = [
//     Location("Location A", Offset(100, 200)),
//     Location("Location B", Offset(300, 400)),
//     // Add more locations as needed
//   ];

//   Location selectedLocation;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map with Pins and Graphs'),
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                       'assets/map_image.png'), // Replace with your map image
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(
//                 children: locations
//                     .map(
//                       (location) => Positioned(
//                         top: location.position.dy,
//                         left: location.position.dx,
//                         child: PinWidget(
//                           label: location.label,
//                           onTap: () {
//                             setState(() {
//                               selectedLocation = location;
//                             });
//                           },
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               color: Colors.grey[200],
//               child: selectedLocation != null
//                   ? Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: LineChart(
//                         LineChartData(
//                           titlesData: FlTitlesData(
//                             leftTitles: SideTitles(showTitles: true),
//                             bottomTitles: SideTitles(showTitles: true),
//                           ),
//                           borderData: FlBorderData(
//                             show: false,
//                           ),
//                           gridData: FlGridData(
//                             show: true,
//                           ),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: selectedLocation.data
//                                   .asMap()
//                                   .entries
//                                   .map(
//                                     (entry) => FlSpot(
//                                       entry.key.toDouble(),
//                                       entry.value.toDouble(),
//                                     ),
//                                   )
//                                   .toList(),
//                               isCurved: true,
//                               belowBarData: BarAreaData(show: false),
//                               colors: [Colors.blue],
//                               dotData: FlDotData(show: false),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Center(
//                       child: Text('Tap on a location to view graphs'),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PinWidget extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;

//   PinWidget({required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           Icons.location_on,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// class Location {
//   final String label;
//   final List<double> data;
//   final Offset position;

//   Location(this.label, this.position, {this.data = const [2, 4, 3, 1, 2, 5]});
// }
