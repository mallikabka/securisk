import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class PolicyTerms extends StatefulWidget {
  PolicyTerms({super.key});

  @override
  PolicyTermsState createState() => PolicyTermsState();

  Future<void> sendDataToApi(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final rfqId = prefs.getString('responseBody');
    var headers = await ApiServices.getHeaders();
    try {
      Map<String, dynamic> requestData = {
        'rfqId': rfqId,
        'policyDetails': [],
      };

      for (var data in tableData) {
        String coverageName = data[0].text;
        String remark = data[1].text;

        Map<String, String> policyDetails = {
          'coverageName': coverageName,
          'remark': remark,
        };
        requestData['policyDetails'].add(policyDetails);
      }

      String requestBody = json.encode(requestData);

      final response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.createPloicyTerms_Endpoint),
        body: requestBody,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Policyterms saved successfully.....!',
        );
        ('Data sent successfully......!');
      } else {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Policyterms failed.....!',
        );
        ('API error: ${response.statusCode}');
      }
    } catch (e) {
      ('Error: $e');
    }
    tableData.clear();
  }
}

List<List<TextEditingController>> tableData = [];
int rowCounter = 1;

class PolicyTermsState extends State<PolicyTerms> {
  List<bool> rowEnabledStates = [];
  TextEditingController coverageNameController = TextEditingController();
  TextEditingController limitsREmarksController = TextEditingController();
  Future<void> getCoveragesByProductId() async {
    final prefs = await SharedPreferences.getInstance();

    final localStorageProdId = prefs.getInt('productId');
    var headers = await ApiServices.getHeaders();
    if (localStorageProdId == null) {
      ('Product ID not found in SharedPreferences.');
      return;
    }

    try {
      final res = await http.get(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.getPloicyTermsByProductId_Endpoint +
            '$localStorageProdId'),
        headers: headers,
      );

      (res.body);
      final List<dynamic> responseData = json.decode(res.body);

      for (var coverageName in responseData) {
        tableData.add([
          TextEditingController(text: coverageName['coverage']),
          TextEditingController(text: ""),
        ]);
      }
      rowEnabledStates = List.generate(tableData.length, (index) => false);
    } catch (e) {
      ('Error: $e');
    }
  }

  void initState() {
    super.initState();
    getCoveragesByProductId();
  }

  void toggleRowEnabledState(int rowIndex) {
    setState(() {
      rowEnabledStates[rowIndex] = !rowEnabledStates[rowIndex];
    });
  }

  @override
  void dispose() {
    for (var i = 0; i < tableData.length; i++) {
      tableData[i][0].dispose();
      tableData[i][1].dispose();
    }
    super.dispose();
  }

  void removeRow(int index) {
    setState(() {
      tableData[index][0].clear();
      tableData[index][1].clear();
      tableData.removeAt(index);
      rowCounter--;
      coverageNameController.text = "";
      limitsREmarksController.text = "";
    });
  }

  void showDeleteConfirmationDialog(BuildContext context, int rowIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete this coverage?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No button pressed
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                removeRow(rowIndex); // Yes button pressed
                Navigator.of(context).pop(true);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Proposed Scope of Cover",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: SecureRiskColours.Table_Heading_Color),
            ),
          ),
        ),
        Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.06,
          color: SecureRiskColours.Table_Heading_Color,
          // padding: EdgeInsets.all(5),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  'Coverage',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.35,
                ),
                Text(
                  'Limits/Remarks',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.32,
                ),
                Text(
                  'Actions',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        for (var i = 0; i < tableData.length; i++)
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 0, top: 10),
                width: screenWidth * 0.365,
                height: 35,
                child: TextField(
                  enabled: rowEnabledStates[i],
                  controller: tableData[i][0],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    border: OutlineInputBorder(),
                    hintText: 'Enter a coverage name',
                    hintStyle: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Container(
                margin: EdgeInsets.only(right: 0, top: 10),
                width: screenWidth * 0.365,
                height: 35,
                child: TextField(
                  enabled: rowEnabledStates[i],
                  controller: tableData[i][1],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    border: OutlineInputBorder(),
                    hintText: 'Limits/Remarks',
                    hintStyle: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              IconButton(
                onPressed: () {
                  toggleRowEnabledState(i);
                },
                icon: Icon(Icons.edit_note),
              ),
              IconButton(
                onPressed: () {
                  // removeRow(i);
                  showDeleteConfirmationDialog(context, i);
                },
                icon: Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 252, 0, 0),
                ),
              ),
            ],
          ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 0, top: 10),
              width: screenWidth * 0.365,
              height: 35,
              child: TextField(
                controller: coverageNameController,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(),
                  hintText: 'Enter a coverage name',
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(right: 0, top: 10),
              width: screenWidth * 0.365,
              height: 35,
              child: TextField(
                controller: limitsREmarksController,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(),
                  hintText: 'Limits/Remarks',
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.05,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  tableData.add([
                    TextEditingController(),
                    TextEditingController(),
                  ]);
                  rowEnabledStates.add(true);
                  rowCounter++;
                });
              },
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}
