import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Service.dart';

class ChartData {
  final String x;
  final int y;
  Color color;

  ChartData(this.x, this.y, this.color);
}

Future<List<ChartData>> fetchData() async {
  var headers = await ApiServices.getHeaders();
  var response = await http.get(
    Uri.parse(ApiServices.baseUrl + ApiServices.dashboard_api),
    headers: headers,
  );
  // final response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    final List<Color> colors = [
      Colors.grey,
      Colors.green,
      Colors.red,
      Color.fromARGB(255, 35, 193, 241),
      SecureRiskColours.Button_Color
    ];

    return data
        .where((entry) => entry[0] != "Total") // Filter out "Total"
        .toList()
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final color = colors[index % colors.length];
      return ChartData(
        entry.value[0] ?? "Unknown",
        entry.value[1] as int,
        color,
      );
    }).toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}

class Donutgraph extends StatelessWidget {
  late int _totalCount;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: FutureBuilder<List<ChartData>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final chartData = snapshot.data;
              num maxDataValue = chartData?.fold<num>(
                      0, (max, data) => data.y > max ? data.y : max) ??
                  0;
              _totalCount =
                  chartData?.fold<int>(0, (total, data) => total + data.y) ?? 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 35, // Set a fixed height for the header
                    color: SecureRiskColours.Table_Heading_Color,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.pie_chart_rounded),
                          color: SecureRiskColours.Button_Color,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add your onTap logic here
                            print('Text tapped!');
                          },
                          child: Text(
                            "Total RFQ",
                            style: TextStyle(
                              color: SecureRiskColours.table_Text_Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 5), // Add some spacing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                // Adjust the size of the chart container as needed
                                width: 250,
                                height: 200,
                                child: SfCircularChart(
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: chartData,
                                      name: 'Total RFQ',
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      pointColorMapper: (ChartData data, _) =>
                                          data.color,
                                      explode: true,
                                      explodeIndex: 1,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                child: Text(
                                  'Total: $_totalCount',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      // color: SecureRiskColours.Button_Color
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Add spacing between chart and data
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: chartData!.map((data) {
                            double progress = (data.y / maxDataValue);
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 2),
                                  Text(
                                    data.x,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  SizedBox(
                                    height: 16,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: progress * 100,
                                          height: 16,
                                          color: data.color,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          "${data.y}",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
