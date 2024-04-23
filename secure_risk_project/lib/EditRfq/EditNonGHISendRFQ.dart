import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/EditClaimsMisCard.dart';
import 'package:loginapp/EditRfq/EditCoverageCard.dart';
import 'package:loginapp/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:universal_platform/universal_platform.dart';

// ignore: must_be_immutable
class EditNonGHISendRFQ extends StatefulWidget {
  late String rfid;
  EditNonGHISendRFQ({super.key, required this.rfid});
  @override
  @override
  _EditNonGHISendRFQState createState() => _EditNonGHISendRFQState();
}

class _EditNonGHISendRFQState extends State<EditNonGHISendRFQ> {
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> data = [];
  List<DownloadItem> downloadItems = [];
  String rfqId = '';
  late final localStorageProdId;
  late final localStoragePolicyType;
  late final localStorageprodCategoryId;

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> claimsapiResponse = [];

  Future<void> checkProductId() async {
    var headers = await ApiServices.getHeaders();
    String rfid = widget.rfid;
    http.Response response = await http.get(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.EditCorporate_Details_EndPoint +
          rfid),
      headers: headers,
    );

    (response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      setState(() {
        localStoragePolicyType = jsonData["corporateDetails"]['policyType'];
        localStorageprodCategoryId =
            jsonData["corporateDetails"]['prodCategoryId'];
        localStorageProdId = jsonData["corporateDetails"]['productId'];
      });
    }
    initializeDownloadItems();
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchRfqId function passed from parent
    checkProductId();
    rfqId = widget.rfid;

    fetchApiData().then((data) {
      setState(() {
        apiResponse = data;
      });
    }).catchError((error) {
      ('Error fetching API data: $error');
    });

    fetchApiclaimsData().then((data) {
      setState(() {
        claimsapiResponse = data;
      });
    }).catchError((error) {
      ('Error fetching API data: $error');
    });
  }

  Future<List<Map<String, dynamic>>> fetchApiclaimsData() async {
    var headers = await ApiServices.getHeaders();
    final apiUrl = Uri.parse(
        ApiServices.baseUrl + ApiServices.Coverage_ClaimsMis + "$rfqId");
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

  Future<List<Map<String, dynamic>>> fetchApiData() async {
    var headers = await ApiServices.getHeaders();
    final apiUrl = Uri.parse(
        ApiServices.baseUrl + ApiServices.Coverage_EmpDepData + "$rfqId");
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

  void initializeDownloadItems() {
    List<DownloadItem> freshItems = [
      if (localStorageProdId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Age_Binding,
          "Age Banding Analysis",
        ),
      if (localStorageProdId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.IRDA_Format,
          "IRDA Format",
        ),
      DownloadItem(
        ApiServices.baseUrl + ApiServices.RFQ_Coverage,
        "RFQ Coverage",
      ),
      DownloadItem(
        ApiServices.baseUrl + ApiServices.Mandate_Letter,
        "Mandate Letter",
      ),
      if (localStorageProdId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Employee_Dependent_Data,
          "Employee Dependent Data",
        ),

      // Add more DownloadItems as needed
    ];
    List<DownloadItem> renewalItems = [
      if (localStoragePolicyType == "Renewal" && localStorageProdId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Age_Binding,
          "Age Banding Analysis",
        ),
      if (localStoragePolicyType == "Renewal" && localStorageProdId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Claims_Analysis,
          "Claims Analysis",
        ),
      if (localStoragePolicyType == "Renewal" && localStorageProdId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Claims_Mis,
          "Claims Mis",
        ),

      // DownloadItem(
      //   ApiServices.baseUrl + ApiServices.Claims_Summary,
      //   "Claims Summary",
      // ),
      if (localStoragePolicyType == "Renewal" && localStorageProdId == 1001)
        // DownloadItem(
        //   ApiServices.baseUrl + ApiServices.Coverages_Sought,
        //   "Coverages Sought",
        // ),
        if (localStoragePolicyType == "Renewal" && localStorageProdId == 1001)
          DownloadItem(
            ApiServices.baseUrl + ApiServices.Employee_Dependent_Data,
            "Employee Data",
          ),
      if (localStoragePolicyType == "Renewal" && localStorageProdId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.IRDA_Format,
          "IRDA",
        ),

      DownloadItem(
        ApiServices.baseUrl + ApiServices.Mandate_Letter,
        "Mandate Letter",
      ),
      DownloadItem(
        ApiServices.baseUrl + ApiServices.RFQ_Coverage,
        "RFQ Coverage",
      ),
    ];

    setState(() {
      downloadItems =
          localStoragePolicyType == "Renewal" ? renewalItems : freshItems;
    });
  }

  Future<String> fetchRfqId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('responseBody') ?? '';
  }

  Future<void> fetchData() async {
    var headers = await ApiServices.getHeaders();
    final url = ApiServices.baseUrl + ApiServices.Emails;
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      setState(() {
        data = List<Map<String, dynamic>>.from(decodedData);
      });
    } else {
      ('API call failed with status code: ${response.statusCode}');
    }
  }

  SecureRiskColours secureRiskColours = SecureRiskColours();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: fetchRfqId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the value, you can display a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading RFQ ID');
          } else {
            // final rfqId = snapshot.data ?? '';
            return Container(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: Image.asset("assets/images/success.png"),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 400.0,
                              child: Center(
                                child: Text(
                                  "Thank You",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFF3EB655), fontSize: 45.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 400.0,
                              child: Center(
                                child: Text(
                                  "Successfully Registered RFQ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 30.0,
                                    color: Color(0xFF747474),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 400.0,
                              child: Center(
                                child: Text(
                                  "Policy Id:'${rfqId}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.0,
                                    color: Color.fromARGB(255, 4, 4, 4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50.0),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (localStorageProdId == 1001)
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // debugger();
                                      editshowDataTableDialog(
                                          context, apiResponse);
                                    },
                                    style:
                                        SecureRiskColours.customButtonStyle(),
                                    child: Text(
                                      'Employee Dependent Details',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              if (localStoragePolicyType == "Renewal" &&
                                  localStorageprodCategoryId == 1001)
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      EditShowClaimsMisCard(
                                          context, claimsapiResponse);
                                    },
                                    style:
                                        SecureRiskColours.customButtonStyle(),
                                    child: Text(
                                      'Claims MIS',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showDataGridDialog(context, widget.rfid);
                                  },
                                  style: SecureRiskColours.customButtonStyle(),
                                  child: Text(
                                    'Send Email',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showDownloadDialog(context, widget.rfid);
                                    },
                                    style:
                                        SecureRiskColours.customButtonStyle(),
                                    child: Text(
                                      'Download',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  void _showDownloadDialog(BuildContext context, String rfqId) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
            color: SecureRiskColours
                .Table_Heading_Color, // Set the background color for the title
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Align(alignment: Alignment.center, child: Text('Download'))),
        content: Container(
          width: screenWidth * 0.23,
          height: screenHeight * 0.38,
          child: SingleChildScrollView(
            child: Column(
              children: downloadItems.asMap().entries.map((entry) {
                final item = entry.value;
                final index = entry.key;
                final isEven = index.isEven;
                final backgroundColor =
                    isEven ? Colors.grey[200] : Colors.white;
                return Container(
                  color: backgroundColor,
                  child: ListTile(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                (item.name),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // validationResponse.containsKey(fieldKey)
                            Icon(
                              Icons.cloud_download_outlined,
                              color: Colors.blueGrey,
                            ),
                          ],
                        ),
                        // Divider(
                        //   color: Colors.grey,
                        //   height: 20,
                        //   thickness: 1,
                        // ),
                      ],
                    ),
                    onTap: () {
                      if (UniversalPlatform.isWeb) {
                        _handleWebDownload(
                            item.getCompleteUrl(rfqId), item.name);
                      } else {
                        // _handleMobileDownload(item.apiUrl);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleWebDownload(String apiUrl, String name) async {
    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Extract filename from Content-Disposition header

        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = "$name.pdf";

        anchor.click();
        html.Url.revokeObjectUrl(url);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                  SizedBox(height: 16.0),
                  Text(
                    'Failed to download...!',
                    style: GoogleFonts.poppins(fontSize: 18.0),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'close',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                SizedBox(height: 16.0),
                Text(
                  'Failed to download...!',
                  style: GoogleFonts.poppins(fontSize: 18.0),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  'close',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showDataGridDialog(BuildContext context, String rfqId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DataGridDialog(
          data: data,
          onSendEmail:
              (List<String> selectedEmails, List<String> selectedDocumnets) {
            _sendEmail(selectedEmails, selectedDocumnets, rfqId);
          },
        );
      },
    );
  }

  Future<void> _sendEmail(List<String> selectedEmails,
      List<String> selectedDocumnets, String rfqId) async {
    var headers = await ApiServices.getHeaders();
    final url = ApiServices.baseUrl + ApiServices.send_email;

    final payload = {
      "to": selectedEmails,
      "documentList": selectedDocumnets,
      "rfqId": rfqId
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success',
                  style: GoogleFonts.poppins(color: Colors.green)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check_circle, color: Colors.green, size: 48.0),
                  SizedBox(height: 16.0),
                  Text(
                    'Email sent successfully!',
                    style: GoogleFonts.poppins(fontSize: 18.0),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'OK',
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
        // Show a success message to the user if needed
      } else {
        ('Failed to send email. Status code: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                  SizedBox(height: 16.0),
                  Text(
                    'Please try again.....!!',
                    style: GoogleFonts.poppins(fontSize: 18.0),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'close',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );

        // Handle the API call failure
      }
    } catch (e) {
      ('Error occurred while sending email: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.close_rounded, color: Colors.red, size: 48.0),
                SizedBox(height: 16.0),
                Text(
                  'Please try again.....!!',
                  style: GoogleFonts.poppins(fontSize: 18.0),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  'close',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );

      // Handle any exceptions that occurred during the API call
    }
  }
}

class DataGridDialog extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function(List<String>, List<String>) onSendEmail;

  DataGridDialog({required this.data, required this.onSendEmail});

  @override
  _DataGridDialogState createState() => _DataGridDialogState();
}

class _DataGridDialogState extends State<DataGridDialog> {
  Map<int, List<String>> selectedEmailsMap = {};
  Map<String, bool> checkboxStates = {
    'IRDA Details': false,
    'rfq coverage': false,
    'Ageband Analysis': false,
    'Employee details': false,
    'Mandate Letter': false,
  };

  bool anyCheckboxSelected() {
    return checkboxStates.containsValue(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Emails Report'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith(
            (states) => Color.fromRGBO(110, 201, 241, 1),
          ),
          dataRowHeight: 50,
          headingRowHeight: 50,
          columns: [
            DataColumn(
                label: Text(
              'Insurer Name',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
            DataColumn(
                label: Text(
              'Location',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
            DataColumn(label: UserDataTableHeader()),
          ],
          rows: widget.data
              .asMap()
              .map((index, insurer) => MapEntry(
                    index,
                    DataRow(
                      cells: [
                        DataCell(Text(insurer['insurerName'])),
                        DataCell(Text(insurer['location'])),
                        DataCell(SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: UserDataTable(
                            users: insurer['listOfUsers'],
                            onChanged: (selectedRows) {
                              setState(() {
                                selectedEmailsMap[index] =
                                    selectedRows; // Update selectedEmailsMap
                              });
                            },
                          ),
                        )),
                      ],
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Checkbox(
                  value: checkboxStates['IRDA Details'] ?? false,
                  onChanged: (value) {
                    setState(() {
                      checkboxStates['IRDA Details'] = value ?? false;
                    });
                  },
                ),
                Text(
                  'IRDA Details',
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Adjust the font size as needed
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Checkbox(
                    value: checkboxStates['rfq coverage'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        checkboxStates['rfq coverage'] = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'rfq coverage',
                    style: GoogleFonts.poppins(
                      fontSize: 16, // Adjust the font size as needed
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: checkboxStates['Mandate Letter'] ?? false,
                  onChanged: (value) {
                    setState(() {
                      checkboxStates['Mandate Letter'] = value ?? false;
                    });
                  },
                ),
                Text(
                  'Mandate Letter',
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Adjust the font size as needed
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 120,
            ),
            ElevatedButton(
              onPressed: anyCheckboxSelected()
                  ? () {
                      List<String> allSelectedEmails = [];
                      selectedEmailsMap.values.forEach((emails) {
                        allSelectedEmails.addAll(emails);
                      });
                      List<String> selectedCheckboxNames = checkboxStates
                          .entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .toList();
                      widget.onSendEmail(
                          allSelectedEmails, selectedCheckboxNames);
                    }
                  : null,
              style: anyCheckboxSelected()
                  ? SecureRiskColours.customButtonStyle()
                  : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send), // Add your desired send icon here
                  SizedBox(width: 8), // Adjust the spacing as needed
                  Text('Send Email'),
                ],
              ),
            ),
            // Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 20.0, left: 2.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: SecureRiskColours.customButtonStyle(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close), // Add your desired close icon here
                    SizedBox(width: 8), // Adjust the spacing as needed
                    Text('Close'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class UserDataTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: SizedBox(
              width: 150, // Adjust the width as needed
              child: Text(
                'Manager Name',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 100, // Adjust the width as needed
              child: Text(
                'Phone Number',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 80, // Adjust the width as needed
              child: Text(
                'Select',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 220, // Adjust the width as needed
              child: Text(
                'Email',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],

        rows: [], // Leave this empty, as it's just a header
      ),
    );
  }
}

class DownloadItem {
  final String apiUrl;
  final String name;

  DownloadItem(this.apiUrl, this.name);
  String getCompleteUrl(String rfqId) {
    return '$apiUrl$rfqId';
  }
}

class UserDataTable extends StatefulWidget {
  final List<dynamic> users;
  final ValueChanged<List<String>> onChanged;

  UserDataTable({
    required this.users,
    required this.onChanged,
  });

  @override
  _UserDataTableState createState() => _UserDataTableState();
}

class _UserDataTableState extends State<UserDataTable> {
  List<bool> checkedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize the checkedList with false values for each user
    checkedList = List.generate(widget.users.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 0,
      columns: [
        DataColumn(
          label: Container(
            width: 150, // Set the desired width for this column
            child: Text('Manager Name'),
          ),
        ),
        DataColumn(
          label: Container(
            width: 100, // Set the desired width for this column
            child: Text('Phone Number'),
          ),
        ),
        DataColumn(
          label: Container(
            width: 80, // Set the desired width for this column
            child: Text('Select'),
          ),
        ),
        DataColumn(
          label: Container(
            width: 220, // Set the desired width for this column
            child: Text('Email'),
          ),
        ),
        // Add more DataColumn widgets if needed
      ],
      rows: List.generate(widget.users.length, (index) {
        var user = widget.users[index];
        return DataRow(
          cells: [
            DataCell(
              SizedBox(
                width: 150, // Adjust the width as needed
                child: Text(user['managerName']),
              ),
            ),
            DataCell(
              SizedBox(
                width: 100, // Adjust the width as needed
                child: Text(user['phoneNumber'].toString()),
              ),
            ),
            DataCell(
              SizedBox(
                width: 80, // Adjust the width as needed
                child: Checkbox(
                  value: checkedList[index],
                  onChanged: (value) {
                    setState(() {
                      checkedList[index] = value ?? false;
                      List<String> selectedEmails = [];
                      for (int i = 0; i < checkedList.length; i++) {
                        if (checkedList[i]) {
                          selectedEmails.add(widget.users[i]['email']);
                        }
                      }
                      widget.onChanged(selectedEmails);
                    });
                  },
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 220, // Adjust the width as needed
                child: Text(user['email']),
              ),
            ),
          ],

          // cells: [
          //   DataCell(Text(user['managerName'])),
          //   DataCell(Text(user['phoneNumber'].toString())),
          //   DataCell(
          //     Checkbox(
          //       value: checkedList[index],
          //       onChanged: (value) {
          //         setState(() {
          //           checkedList[index] = value ?? false;
          //           List<String> selectedEmails = [];
          //           for (int i = 0; i < checkedList.length; i++) {
          //             if (checkedList[i]) {
          //               selectedEmails.add(widget.users[i]['email']);
          //             }
          //           }
          //           widget.onChanged(selectedEmails);
          //         });
          //       },
          //     ),
          //   ),
          //   // DataCell(Text(user['location'] ?? 'N/A')),
          //   DataCell(Text(user['email'])),
          // ],
        );
      }),
    );
  }
}
