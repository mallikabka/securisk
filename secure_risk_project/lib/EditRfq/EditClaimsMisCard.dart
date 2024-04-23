import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'dart:convert';

class EditClaimsMisCard extends StatefulWidget {
  final VoidCallback onClose;
  final String rfqId; // Add rfqId parameter here

  EditClaimsMisCard({required this.onClose, required this.rfqId});
  @override
  _ClaimsMisCardState createState() => _ClaimsMisCardState();
}

List<Map<String, dynamic>> apiResponse = [];

Color evenRowColor = Color.fromARGB(255, 239, 241, 242); // Your desired color
Color oddRowColor = Colors.white; // Your desired color

class _ClaimsMisCardState extends State<EditClaimsMisCard> {
  @override
  void initState() {
    super.initState();
    fetchApiData().then((data) {
      setState(() {
        apiResponse = data;
      });
    }).catchError((error) {
      ('Error fetching API data: $error');
    });
  }

  Future<List<Map<String, dynamic>>> fetchApiData() async {
    var headers = await ApiServices.getHeaders();
    final apiUrl = Uri.parse(ApiServices.baseUrl +
        ApiServices.Coverage_ClaimsMis +
        '${widget.rfqId}');
    final response = await http.get(apiUrl, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> apiResponse =
          decodedData.cast<Map<String, dynamic>>();
      return apiResponse;
    } else {
      throw Exception('Failed to load API data');
    }
  }

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.20;

    return Center(
      child: Container(
        width: cardWidth,
        child: Card(
          elevation: isHovered ? 8 : 4, // Add elevation based on hover state
          color: isHovered
              ? Color.fromARGB(255, 239, 241, 242)
              : Colors.white, // Change color based on hover state
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (event) {
              setState(() {
                isHovered = false;
              });
            },
            child: ListTile(
              title: Text(
                'Claims Mis Data',
                style: GoogleFonts.poppins(
                    // fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () =>
                        EditShowClaimsMisCard(context, apiResponse),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Icon(Icons.close, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void EditShowClaimsMisCard(
    BuildContext context, List<Map<String, dynamic>> apiResponse) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('Claims Data '),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: ScrollableTableView(
          headerBackgroundColor: SecureRiskColours.Button_Color,
          headers: [
            'Policy Number',
            'Claim Number',
            'Employee Id',
            'Employee Name',
            'Relation Ship',
            'Gender',
            'Age',
            'Beneficiary Name',
            'SumInsured',
            'Claimed Amount',
            'Paid Amount',
            'Date Of Claim',
            'Type',
            'Status',
            'Network Type',
            'Hospital Name',
            'Location',
            'Billed Amount',
            'Admission Date',
            'Disease',
            'Treatment',
            'Category',
            // "Status",
            // ... (add your header labels)
          ].map((label) {
            return TableViewHeader(
              label: label,
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
              minWidth: double.parse("190"),
            );
          }).toList(),
          rows: apiResponse.asMap().entries.map(
            (entry) {
              Map<String, dynamic> data = entry.value;
              return TableViewRow(
                height: 60,
                cells: [
                  data['policyNumber'] ?? '',
                  data['claimsNumber'] ?? '',
                  data['employeeId'] ?? '',
                  data['employeeName'] ?? '',
                  data['relationship'] ?? '',
                  data['gender'] ?? '',
                  data['age']?.toString() ?? '',
                  data['beneficiaryName'] ?? '',
                  data['sumInsured']?.toString() ?? '',
                  data['claimedAmount']?.toString() ?? '',
                  data['paidAmount']?.toString() ?? '',
                  data['dateOfClaim']?.toString() ?? '',
                  data['type'] ?? '',
                  data['status'] ?? '',
                  data['networkType'] ?? '',
                  data['hospitalName'] ?? '',
                  data['location'] ?? '',
                  data['billedAmount']?.toString() ?? '',
                  data['admissionDate']?.toString() ?? '',
                  data['disease'] ?? '',
                  data['treatment'] ?? '',
                  data['category'] ?? '',
                  // ... (add other cell values)
                ].map((value) {
                  return TableViewCell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(value.toString()),
                    ),
                  );
                }).toList(),
                // color: rowColor,
              );
            },
          ).toList(),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(199, 55, 125, 1.0), // Hovered color

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
