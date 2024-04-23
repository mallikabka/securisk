import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:toastification/toastification.dart';

// ignore: must_be_immutable
class EditPolicyTerms extends StatefulWidget {
  late String rfid;
  EditPolicyTerms({super.key, required this.rfid});
  @override
  EditPolicyTermsState createState() => EditPolicyTermsState();

  Future<void> sendDataToApi(BuildContext context) async {
    try {
      Map<String, dynamic> requestData = {
        'rfqId': rfid,
        // Assuming `rfid` is defined somewhere in your class
        'policyDetails': [],
      };
      int index = 0;
      for (var data in tableData) {
        String coverageName = data[0].text;
        String remark = data[1].text;

        Map<String, String> policyDetails = {
          'coverageName': coverageName,
          'remark': remark,
          'policyTermId': policyIds[index] ?? ""
        };
        requestData['policyDetails'].add(policyDetails);
        index++;
      }

      String requestBody = json.encode(requestData);
      var headers = await ApiServices.getHeaders();

      final response = await http.put(
        Uri.parse(ApiServices.baseUrl + ApiServices.updatePloicyTerms_Endpoint),
        body: requestBody,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'PolicyTerms saved successfully.....!',
        );
      } else {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'PolicyTerms failed.....!',
        );
        print('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    tableData.clear();
  }
}

List<List<TextEditingController>> tableData = [];
List<dynamic> policyIds = [];
int rowCounter = 1;

class EditPolicyTermsState extends State<EditPolicyTerms> {
  List<bool> rowEnabledStates = [];
  TextEditingController coverageNameController = TextEditingController();
  TextEditingController limitsREmarksController = TextEditingController();
  Future<void> editDataApi() async {
    final rfqId = widget.rfid;
    var headers = await ApiServices.getHeaders();
    try {
      final res = await http.get(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.EditPolicyTerms_Details_EndPoint +
            rfqId),
        headers: headers,
      );

      (res.body);
      final List<dynamic> responseData = json.decode(res.body);

      tableData.clear();
      rowEnabledStates
          .clear(); // Clear rowEnabledStates when clearing tableData

      for (var item in responseData) {
        tableData.add([
          TextEditingController(text: item['coverageName']),
          TextEditingController(text: item['remark']),
        ]);

        rowEnabledStates.add(false); // Add a corresponding boolean value
        policyIds.add(item['id']);
      }
    } catch (e) {
      ('Error: $e');
    }
  }

  void initState() {
    editDataApi();
    super.initState();

    tableData.add([
      TextEditingController(),
      TextEditingController(),
    ]);
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
                  fontSize: 20,
                  color: SecureRiskColours.Table_Heading_Color),
            ),
          ),
        ),
        Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.06,
          color: SecureRiskColours.Table_Heading_Color,
          padding: EdgeInsets.all(5),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text(
                  'Coverage',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.35,
                ),
                Text(
                  'Limits/Remarks',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.30,
                ),
                Text(
                  'Actions',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                width: screenWidth * 0.355,
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
                width: screenWidth * 0.355,
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
                  removeRow(i);
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
              width: screenWidth * 0.355,
              height: 35,
              child: TextField(
                controller: coverageNameController,
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
              width: screenWidth * 0.355,
              height: 35,
              child: TextField(
                controller: limitsREmarksController,
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
              width: screenWidth * 0.04,
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
