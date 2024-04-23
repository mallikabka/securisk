import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../FreshPolicyFields/CustonDropdown.dart';
import '../Service.dart';

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String? selectedMonthIndex;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedMonthIndex = getCurrentMonth();
    selectedYear = DateTime.now().year;
  }

  String getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              color: SecureRiskColours.Table_Heading_Color,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.bar_chart_outlined),
                          color: SecureRiskColours.rolesblue),
                      Text(
                        "RFQ Count",
                        style: TextStyle(
                            color: SecureRiskColours.table_Text_Color),
                      )
                    ]),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 200.0, right: 20),
                  // ),
                  // SizedBox(width: 1),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                      width: 120,
                      height: 25,
                      child: CustomDropdown(
                        value: selectedYear.toString(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedYear = int.parse(newValue!);
                            selectedMonthIndex =
                                (selectedYear == DateTime.now().year)
                                    ? getCurrentMonth()
                                    : 'December';
                          });
                        },
                        items: List.generate(100, (index) {
                          int year = DateTime.now().year - index;
                          return DropdownMenuItem<String>(
                            value: year.toString(),
                            child: Text(
                              year.toString(),
                              style: TextStyle(
                                  color: SecureRiskColours
                                      .Table_Heading_Color), // Dropdown item text color
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: 120,
                        height: 25,
                        child: CustomDropdown(
                          value: selectedMonthIndex,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMonthIndex = newValue;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Select month',
                                style: TextStyle(
                                  color: SecureRiskColours
                                      .Table_Heading_Color, // Dropdown item text color
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            for (var option in months)
                              DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: TextStyle(
                                      color: SecureRiskColours
                                          .Table_Heading_Color), // Dropdown item text color
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: FutureBuilder<List<List<dynamic>>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      try {
                        return VerticalColumnChart(data: snapshot.data!);
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
      ),
    );
  }

  Future<List<List<dynamic>>> fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      var response = await http.get(
        Uri.parse(
          ApiServices.baseUrl +
              ApiServices.dashboard_api_monthyear +
              '$selectedMonthIndex' +
              '&year=' +
              '$selectedYear',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        if (decodedData is Map<String, dynamic>) {
          if (decodedData.containsKey('getCooperateDetailsGraphDtos')) {
            final chartDataList = decodedData['getCooperateDetailsGraphDtos'];

            if (chartDataList is List<dynamic>) {
              final processedChartData = chartDataList.map((data) {
                return [
                  data['status'].toString(),
                  data['count'],
                ];
              }).toList();

              return processedChartData;
            } else {
              throw Exception('Invalid response format');
            }
          } else {
            throw Exception(
                'Key "getCooperateDetailsGraphDtos" not found in response');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data');
    }
  }
}

class VerticalColumnChart extends StatelessWidget {
  final List<List<dynamic>> data;

  VerticalColumnChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: VerticalColumn(data: data),
    );
  }
}

class VerticalColumn extends StatefulWidget {
  final List<List<dynamic>> data;

  VerticalColumn({Key? key, required this.data}) : super(key: key);

  @override
  _VerticalColumn createState() => _VerticalColumn();
}

class _VerticalColumn extends State<VerticalColumn> {
  late List<ChartSeries> _chartSeries;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartSeries = _getChartSeries(widget.data);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: _chartSeries,
          primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
          primaryYAxis: NumericAxis(labelFormat: '{value}'),
        ),
      ),
    );
  }

  List<ChartSeries> _getChartSeries(List<List<dynamic>> apiData) {
    List<ChartSeries> chartSeries = [];

    List<String> desiredStatusOrder = [
      'processing',
      'pending',
      'submitted',
      'closed',
      'lost'
    ];
    double barWidth = 5;

    for (String status in desiredStatusOrder) {
      var dataForStatus = apiData.firstWhere(
        (data) => data[0].toString().toLowerCase() == status,
        orElse: () => [status, 0],
      );

      int count = dataForStatus[1];

      // if (count == 0) {
      //   count = 1;
      // } else {
      //   count = count - (count % 1) + 1; // Round up to the nearest integer
      // }
      Color color = _getColorForStatus(status);

      chartSeries.add(ColumnSeries<ChartSampleData, String>(
        dataSource: [ChartSampleData(status, count, color: color)],
        name: status,
        xValueMapper: (ChartSampleData data, _) => data.status,
        yValueMapper: (ChartSampleData data, _) => data.count.toDouble(),
        dataLabelSettings: DataLabelSettings(isVisible: true),
        width: 0.3,
        color: color,
      ));
    }

    return chartSeries;
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'processing':
        return SecureRiskColours.rolesblue;
      case 'pending':
        return Color.fromARGB(255, 100, 235, 105);
      case 'submitted':
        return Colors.blueAccent;
      case 'closed':
        return Colors.red;
      case 'lost':
        return Colors.orange;
      default:
        return Colors.grey; // Default color if status is not recognized
    }
  }
}

class ChartSampleData {
  ChartSampleData(this.status, this.count, {required this.color});
  final String status;
  final int count;
  final Color color;
}
