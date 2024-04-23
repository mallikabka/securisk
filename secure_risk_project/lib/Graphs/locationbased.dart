import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../FreshPolicyFields/CustonDropdown.dart';
import '../Service.dart';

class Location {
  final int locationId;
  final String locationName;

  Location({required this.locationId, required this.locationName});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationId'],
      locationName: json['locationName'],
    );
  }
}

class LocationBased extends StatefulWidget {
  @override
  _LocationBasedState createState() => _LocationBasedState();
}

class _LocationBasedState extends State<LocationBased> {
  List<Location> locations = [];
  int? selectedLocationId;

  @override
  void initState() {
    super.initState();
    fetchData();
    // Set the default value to Hyderabad
    selectedLocationId = 254;
    fetchData1();
  }

  Future<void> fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      var response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.get_all_locations),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          locations = data.map((item) => Location.fromJson(item)).toList();
        });
      } else {
        throw Exception(
            'Failed to load location data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching location data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 35,
            color: SecureRiskColours.Table_Heading_Color,
            child: Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.stacked_bar_chart),
                      color: SecureRiskColours.graphbar),
                  Text(
                    "Count RFQ Location-Wise ",
                    style: TextStyle(color: SecureRiskColours.table_Text_Color),
                  ),
                  // SizedBox(
                  //   width: screenWidth * 0.59,
                  // ),
                  const Spacer(),
                  Text(
                    "Select Location : ",
                    style: TextStyle(color: SecureRiskColours.table_Text_Color),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                      height: 25,
                      width: 200,
                      child: CustomDropdown<int>(
                        value: selectedLocationId,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedLocationId = newValue;
                            fetchData1();
                          });
                        },
                        items: locations.map((Location location) {
                          return DropdownMenuItem<int>(
                            value: location.locationId,
                            child: Text(
                              location.locationName,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<List<dynamic>>>(
                future: fetchData1(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    try {
                      // Use HorizontalColumnChart instead of VerticalColumnChart
                      return StackedBarChart(data: snapshot.data!);
                    } catch (e) {
                      return Text('Error rendering chart: $e');
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<List<dynamic>>> fetchData1() async {
    try {
      var headers = await ApiServices.getHeaders();
      var response = await http.get(
        Uri.parse(
          ApiServices.baseUrl +
              ApiServices.get_dashboard_count +
              '/$selectedLocationId',
        ),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> chartDataList = json.decode(response.body);

        if (chartDataList.isEmpty) {
          throw Exception('No records found for the particular location');
        }

        final processedChartData = chartDataList.map((data) {
          return [
            data['appStatus'].toString(),
            int.parse(data['count'].toString()), // Convert to int
          ];
        }).toList();

        Set<String> allAppStatus =
            chartDataList.map((data) => data['appStatus'].toString()).toSet();
        allAppStatus.forEach((status) {
          if (!processedChartData.any((data) => data[0] == status)) {
            processedChartData.add([status, 0]);
          }
        });
        processedChartData
            .sort((a, b) => a[0].toString().compareTo(b[0].toString()));
        return processedChartData;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');

      throw Exception(
        '$e',
      );
    }
  }
}

class StackedBarChart extends StatelessWidget {
  final List<List<dynamic>> data;

  StackedBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: StackedBar(data: data),
    );
  }
}

class StackedBar extends StatefulWidget {
  final List<List<dynamic>> data;
  StackedBar({Key? key, required this.data}) : super(key: key);
  @override
  _StackedBar createState() => _StackedBar();
}

class _StackedBar extends State<StackedBar> {
  late List<ChartSampleData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData(widget.data);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxValue = _chartData
        .map((data) => data.count.toDouble())
        .reduce((a, b) => a > b ? a : b);
    double interval = calculateInterval(maxValue);
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <StackedBarSeries>[
            StackedBarSeries<ChartSampleData, String>(
              dataSource: _chartData,
              name: 'RFQ Count Location Based',
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.count.toInt(),
              color: SecureRiskColours.graphbar, // Default color
              dataLabelSettings: DataLabelSettings(isVisible: true),
              width: 0.3, // Adjust the width as needed
            ),
          ],
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
            labelRotation: -45, // Rotate labels for better visibility
          ),
          primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            axisLine: AxisLine(width: 0),
            interval: interval, // Hide Y-axis line for better appearance
          ),
        ),
      ),
    );
  }

  List<ChartSampleData> getChartData(List<List<dynamic>> apiData) {
    return apiData.map((data) {
      String status = data[0].toString();
      int count = data[1];
      Color color = _getStatusColor(status);
      return ChartSampleData(status, count, color: color);
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Processing':
        return Colors.red;
      case 'Submitted':
        return Colors.green;
      case 'Closed':
        return Colors.blue;
      case 'Lost':
        return Colors.blue;
      case 'Pending':
        return Colors.blue;
      default:
        return Colors.grey; // Default color
    }
  }

  double calculateInterval(double maxValue) {
    if (maxValue <= 5) {
      return 1;
    } else if (maxValue <= 10) {
      return 2;
    } else {
      return 5;
    }
  }
}

class ChartSampleData {
  ChartSampleData(this.x, this.count, {required this.color});
  final String x;
  final int count;
  final Color color;
}
