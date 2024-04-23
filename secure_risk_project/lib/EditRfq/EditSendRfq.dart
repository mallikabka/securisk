import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/EditClaimsMisCard.dart';
import 'package:loginapp/EditRfq/EditCoverageCard.dart';
import 'package:loginapp/Service.dart';
import 'package:loginapp/Utilities/CircularLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:universal_platform/universal_platform.dart';

// ignore: must_be_immutable
class EditSendForm extends StatefulWidget {
  late String rfid;
  final dynamic productId;
  final dynamic policyType;
  final dynamic responseProdCategoryId;
  EditSendForm(
      {super.key,
      required this.rfid,
      required this.productId,
      required this.policyType,
      required this.responseProdCategoryId});
  @override
  @override
  _EditSendFormState createState() => _EditSendFormState();
}

class _EditSendFormState extends State<EditSendForm> {
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> data = [];
  List<DownloadItem> downloadItems = [];
  String rfqId = '';

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> claimsapiResponse = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchRfqId function passed from parent
    initializeDownloadItems();
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
      if (widget.productId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Age_Binding,
          "Age Banding Analysis",
        ),
      if (widget.productId == 1001)
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
      if (widget.productId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Employee_Dependent_Data,
          "Employee Dependent Data",
        ),
      DownloadItem(
        ApiServices.baseUrl + ApiServices.download_all,
        "Download All",
      ),

      // Add more DownloadItems as needed
    ];
    List<DownloadItem> renewalItems = [
      if (widget.policyType == "Renewal" && widget.productId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Age_Binding,
          "Age Banding Analysis",
        ),
      if (widget.policyType == "Renewal" && widget.productId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Claims_Analysis,
          "Claims Analysis",
        ),
      if (widget.policyType == "Renewal" && widget.productId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Claims_Mis,
          "Claims Mis",
        ),
      if (widget.policyType == "Renewal" && widget.productId == 1001)
        DownloadItem(
          ApiServices.baseUrl + ApiServices.Employee_Dependent_Data,
          "Employee Dependent Data",
        ),
      if (widget.policyType == "Renewal" && widget.productId == 1001)
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
      DownloadItem(
        ApiServices.baseUrl + ApiServices.download_all,
        "Download All",
      ),
    ];

    setState(() {
      downloadItems =
          widget.policyType == "Renewal" ? renewalItems : freshItems;
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
                                      color: Color(0xFF3EB655), fontSize: 36.0),
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
                                    fontSize: 20.0,
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
                        SizedBox(height: 30.0),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.productId == 1001)
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
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              if (widget.policyType == "Renewal" &&
                                  widget.responseProdCategoryId == 1001)
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
                                          fontSize: 16.0, color: Colors.white),
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
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showDownloadDialog(context, widget.rfid);
                                  },
                                  style: SecureRiskColours.customButtonStyle(),
                                  child: Text(
                                    'Download',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                              )
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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        contentPadding: EdgeInsets.zero,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60,
              width: 440,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: SecureRiskColours.Table_Heading_Color,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: screenWidth * 0.25,
              height: screenHeight * 0.30,
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
          ],
        ),
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

        if ("$name" == "Employee Dependent Data") {
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = "$name.xlsx";
          anchor.click();
          html.Url.revokeObjectUrl(url);
        }
        if ("$name" == "Download All") {
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = "$name.zip";
          anchor.click();
          html.Url.revokeObjectUrl(url);
        } else {
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = "$name.pdf";
          anchor.click();
          html.Url.revokeObjectUrl(url);
        }
      } else if (response.statusCode == 204) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          width: 280,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          headerAnimationLoop: true,
          animType: AnimType.bottomSlide,
          title: 'INFO',
          desc: 'No Data Uploaded...!',
          showCloseIcon: true,
          btnCancelOnPress: () {
            // Navigator.of(context).pop();
          },
          btnOkOnPress: () {
            // Navigator.of(context).pop();
          },
        ).show();
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
          productId: widget.productId,
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
    // var headers = await ApiServices.getHeaders();

    final payload = {
      "to": selectedEmails,
      "documentList": selectedDocumnets,
      "rfqId": rfqId
    };
    Loader.showLoader(context);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      Loader.hideLoader();
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
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // Show a success message to the user if needed
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
  final dynamic productId;
  const DataGridDialog(
      {required this.data, required this.onSendEmail, required this.productId});

  @override
  _DataGridDialogState createState() => _DataGridDialogState();
}

class _DataGridDialogState extends State<DataGridDialog> {
  Map<int, List<String>> selectedEmailsMap = {};
  Map<String, bool> checkboxStates = {
    'IRDA Details': false,
    'RFQ coverage': false,
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
      backgroundColor: Color(0xFFFFFFFF),
      surfaceTintColor: Colors.white,
      title: Text(
        'Emails Report',
        style:
            GoogleFonts.poppins(color: SecureRiskColours.Table_Heading_Color),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith(
            (states) => SecureRiskColours.Table_Heading_Color,
          ),
          dataRowHeight: 50,
          headingRowHeight: 30,
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
                        DataCell(
                          Text(
                            insurer['insurerName'],
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                        DataCell(Text(
                          insurer['location'],
                          style: GoogleFonts.poppins(),
                        )),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.productId == 1001)
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
            Row(
              children: [
                Checkbox(
                  value: checkboxStates['RFQ coverage'] ?? false,
                  onChanged: (value) {
                    setState(() {
                      checkboxStates['RFQ coverage'] = value ?? false;
                    });
                  },
                ),
                Text(
                  'RFQ coverage',
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Adjust the font size as needed
                  ),
                ),
              ],
            ),
            if (widget.productId == 1001)
              Row(
                children: [
                  Checkbox(
                    value: checkboxStates['Ageband Analysis'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        checkboxStates['Ageband Analysis'] = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'Ageband Analysis',
                    style: GoogleFonts.poppins(
                      fontSize: 16, // Adjust the font size as needed
                    ),
                  ),
                ],
              ),
            if (widget.productId == 1001)
              Row(
                children: [
                  Checkbox(
                    value: checkboxStates['Employee details'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        checkboxStates['Employee details'] = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'Employee details',
                    style: GoogleFonts.poppins(
                      fontSize: 16, // Adjust the font size as needed
                    ),
                  ),
                ],
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
            // SizedBox(
            //   width: 320,
            // ),
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
                  Icon(
                    Icons.send,
                    color: Colors.white,
                  ), // Add your desired send icon here
                  SizedBox(width: 8), // Adjust the spacing as needed
                  Text(
                    'Send Email',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: SecureRiskColours.Button_Color),
              onPressed: () {
                Navigator.of(context).pop();
              },
              // style: SecureRiskColours.customButtonStyle(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close,
                      color: Colors.white), // Add your desired close icon here
                  SizedBox(width: 8), // Adjust the spacing as needed
                  Text(
                    'Close',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ],
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
            label: Container(
              margin: EdgeInsets.only(bottom: 25),
              // padding: const EdgeInsets.all(8.0),
              child: SizedBox(
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
          ),
          DataColumn(
            label: Container(
              margin: EdgeInsets.only(bottom: 25),
              child: SizedBox(
                width: 120, // Adjust the width as needed
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
          ),
          DataColumn(
            label: Container(
              margin: EdgeInsets.only(bottom: 25),
              child: SizedBox(
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
          ),
          DataColumn(
            label: Container(
              margin: EdgeInsets.only(bottom: 25),
              child: SizedBox(
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
            width: 120, // Set the desired width for this column
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
