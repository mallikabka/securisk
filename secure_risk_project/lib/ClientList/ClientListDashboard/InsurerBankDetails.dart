import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/EditRfq/EditRestCoverages.dart';
import 'package:loginapp/Service.dart';

import 'dart:html' as html;

import 'package:path_provider/path_provider.dart';

class Insurerbank {
  final int insurerid;
  final String bankName;
  final String branch;
  final String location;
  final String ifscCode;
  final int accountNumber;
  final String accountHolderNumber;

  Insurerbank(
      {required this.insurerid,
      required this.bankName,
      required this.branch,
      required this.location,
      required this.ifscCode,
      required this.accountNumber,
      required this.accountHolderNumber
      // required this.contacts
      });
}

class InsurerBankDetatis extends StatefulWidget {
  int clientId;
  String productId;
  InsurerBankDetatis({
    Key? key,
    required this.clientId,
    required this.productId,
  }) : super(key: key);

  @override
  State<InsurerBankDetatis> createState() => _InsurerBankDetatisState();
}

class _InsurerBankDetatisState extends State<InsurerBankDetatis> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _branchController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _ifscCodeController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _accountHolderNumberController =
      TextEditingController();
  List<Insurerbank> bankList = [];
  void clearTextFeilds() {
    _bankNameController.text = ' ';
    _branchController.text = ' ';

    _locationController.text = ' ';
    _ifscCodeController.text = ' ';
    _accountNumberController.text = ' ';
    _accountHolderNumberController.text = ' ';
  }

  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.getAllInsurerbankdetails)
              .replace(queryParameters: {
        "clientListId": (widget.clientId).toString(),
        "productId": widget.productId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));
//   "bankName": "sbi",
//   "branch": "hyd",
//   "location": "hyd",
//   "ifscCode": "ioew6788",
//   "accountNumber": 971234567,
//   "accountHolderNumber": "divya"
        if (data != null && data.isNotEmpty) {
          final List<Insurerbank> insurerList = data
              .map((item) => Insurerbank(
                  insurerid: item['insurerId'],
                  bankName: item['bankName'] ?? '',
                  branch: item['branch'] ?? '',
                  location: item['location'] ?? '',
                  ifscCode: item['ifscCode'] ?? '',
                  accountNumber: item['accountNumber'] ?? '',
                  accountHolderNumber: item['accountHolderNumber']
                  // contacts: item['contact']
                  ))
              .toList();

          setState(() {
            bankList = insurerList;
          });
        } else {
          print('Unexpected response format: $data');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (exception) {
      print('Exception: $exception');
    }
  }

  Future<void> createManagement(
    String? bankName,
    String? branch,
    String? location,
    String? ifscCode,
    int? accountNumber,
    String? accountHolderNumber,
    BuildContext context,
  ) async {
    ("api call made");
    int? clientId = widget.clientId;
    String? productId = widget.productId;

    final Map<String, dynamic> requestBody = {
      "bankName": bankName,
      "branch": branch,
      //   "designation":designation,
      "location": location,
      "ifscCode": ifscCode,
      "accountNumber": accountNumber.toString(),
      "accountHolderNumber": accountHolderNumber
    };
    (requestBody);
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.post(
        Uri.parse(
            "${ApiServices.baseUrl}${ApiServices.createInsurerBank}?clientListId=$clientId&productId=$productId"),
        body: jsonEncode(requestBody),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        (response.body);

        await _fetchData();
        Navigator.of(context).pop();
        _showSuccessDialog(context, "bank detalis Added");

        clearTextFeilds();
      } else {
        Navigator.of(context).pop();
        _showErrorDialog(context);
        ('Error: ${response.statusCode}');
      }
    } catch (exception) {
      ('Exception: $exception');
    }
  }

  Future<void> deleteInsureBankDetails(String insureId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content:
                Text('Are you sure you want to delete this insurer detatils?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );

      // Check the user's choice
      if (confirmed == true) {
        // User clicked "OK"
        final apiUrl = Uri.parse(
            ApiServices.baseUrl + ApiServices.deleteInsure + insureId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('insurer bank details deleted successfully');
          await _fetchData();
        } else {
          print(
              'Failed to delete insurer bank details. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }


  void initState() {
    super.initState();

    _fetchData();
  }

  void _showSuccessDialog(BuildContext context, String operation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Success',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            '$operation successfully!',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Failed to perform the operation.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  String? bankNameError = '';
  String? branchError = "";
  String? locationError = "";
  String? ifscError = '';
  String? accountNumberError = "";
  String? accountHolderNumberError = "";
  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  Future<void> createInsurerBankDetails() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          contentPadding: EdgeInsets.zero,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: 450,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: SecureRiskColours.Table_Heading_Color,
                  ),
                  child: Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Insurer Bank Detalis',
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    // Endorsement Number Field
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _bankNameController,
                        decoration: InputDecoration(
                          labelText: 'BankName',
                          //keyboardType: TextInputType.number,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]'))
                        ],
                        validator: (value) {
                          setState(() {
                            bankNameError = validateString(value);
                          });
                          return bankNameError;
                        },
                      ),
                    ),

                    SizedBox(height: 20), // Spacer

                    // File Upload Field
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _branchController,
                        decoration: InputDecoration(
                          labelText: 'Branch',
                          //keyboardType: TextInputType.number,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]'))
                        ],
                        validator: (value) {
                          setState(() {
                            branchError = validateString(value);
                          });
                          return branchError;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          //keyboardType: TextInputType.number,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]'))
                        ],
                        validator: (value) {
                          setState(() {
                            locationError = validateString(value);
                          });
                          return locationError;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer

                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _ifscCodeController,
                        decoration: InputDecoration(
                          labelText: 'IfscCode',
                          //keyboardType: TextInputType.number,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          setState(() {
                            ifscError = validateString(value);
                          });
                          return ifscError;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer

                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _accountNumberController,
                        decoration: InputDecoration(
                          labelText: 'Account Number',
                          //keyboardType: TextInputType.number,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        validator: (value) {
                          setState(() {
                            accountNumberError = validateString(value);
                          });
                          return accountNumberError;
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _accountHolderNumberController,
                        decoration: InputDecoration(
                          labelText: ' Account Holder Number',
                          //keyboardType: TextInputType.number,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        validator: (value) {
                          setState(() {
                            accountHolderNumberError = validateString(value);
                          });
                          return accountHolderNumberError;
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await createManagement(
                              _bankNameController.text,
                              _branchController.text,
                              _locationController.text,
                              _ifscCodeController.text,
                              int.tryParse(_accountNumberController.text),
                              _accountHolderNumberController.text,
                              context);
                        }
                      },
                      child: Text('Create '),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  http.MultipartRequest jsonToFormData(
      http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

//  bool _downloading = false;
//   String _status = '';

//   Future<void> _downloadFile() async {
//     setState(() {
//       _downloading = true;
//       _status = 'Downloading file...';
//     });

//     final url = 'http://14.99.138.131:9981/clientlist/insurerBankDetails/insurerBankDetailsExport?clientListId=1552&productId=1001';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final bytes = response.bodyBytes;
//       final directory = await getExternalStorageDirectory();
//       final filePath = '${directory!.path}/Insurer_Bank_Details.xlsx';
//       final file = File(filePath);
//       await file.writeAsBytes(bytes);

//       setState(() {
//         _downloading = false;
//         _status = 'File downloaded successfully';
//       });
//     } else {
//       setState(() {
//         _downloading = false;
//         _status = 'Failed to download file: ${response.statusCode}';
//       });
//     }
//   }

  exportInsurerBankDetails(String fileName) async {
    var headers = await ApiServices.getHeaders();
    int clientListId = widget.clientId;
    int? productId = int.tryParse(widget.productId);

    String urlString =
        "${ApiServices.baseUrl}${ApiServices.exportInsure}clientListId=$clientListId&productId=$productId";

    try {
      // var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([
          response.bodyBytes
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = fileName;

        anchor.click();
        html.Url.revokeObjectUrl(url);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFFFFFFFF),
              surfaceTintColor: Colors.white,
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

  void _openEditDialog(int insureId) {
    print(insureId);
    List<Insurerbank> filteredData =
        bankList.where((master) => master.insurerid == insureId).toList();
    print(filteredData);
    final TextEditingController _bankNameController =
        TextEditingController(text: filteredData.first.bankName);

    final TextEditingController _branchController =
        TextEditingController(text: filteredData.first.branch);
    final TextEditingController _locationController =
        TextEditingController(text: filteredData.first.location);
    final TextEditingController _ifscCodeController =
        TextEditingController(text: filteredData.first.ifscCode);
    final TextEditingController _accountNumberController =
        TextEditingController(
            text: filteredData.first.accountNumber.toString());
    final TextEditingController _accountHolderNumberController =
        TextEditingController(text: filteredData.first.accountHolderNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            contentPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: SingleChildScrollView(
                child: Form(
              // key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: 450,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: SecureRiskColours.Table_Heading_Color,
                    ),
                    child: Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'update Insurer Bank Detalis',
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      // Endorsement Number Field
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: TextFormField(
                          controller: _bankNameController,
                          decoration: InputDecoration(
                            labelText: 'BankName',
                            //keyboardType: TextInputType.number,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            setState(() {
                              bankNameError = validateString(value);
                            });
                            return bankNameError;
                          },
                        ),
                      ),

                      SizedBox(height: 20), // Spacer

                      // File Upload Field
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: TextFormField(
                          controller: _branchController,
                          decoration: InputDecoration(
                            labelText: 'Branch',
                            //keyboardType: TextInputType.number,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            setState(() {
                              branchError = validateString(value);
                            });
                            return branchError;
                          },
                        ),
                      ),
                      SizedBox(height: 20), // Spacer
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            //keyboardType: TextInputType.number,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            setState(() {
                              locationError = validateString(value);
                            });
                            return locationError;
                          },
                        ),
                      ),
                      SizedBox(height: 20), // Spacer

                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: TextFormField(
                          controller: _ifscCodeController,
                          decoration: InputDecoration(
                            labelText: 'IfscCode',
                            //keyboardType: TextInputType.number,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            setState(() {
                              ifscError = validateString(value);
                            });
                            return ifscError;
                          },
                        ),
                      ),
                      SizedBox(height: 20), // Spacer

                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: TextFormField(
                          controller: _accountNumberController,
                          decoration: InputDecoration(
                            labelText: 'Account Number',
                            //keyboardType: TextInputType.number,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          // validator: (value) {
                          //   setState(() {
                          //     accountNumberError = validateString(value);
                          //   });
                          //   return accountNumberError;
                          // },
                        ),
                      ),

                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: TextFormField(
                          controller: _accountHolderNumberController,
                          decoration: InputDecoration(
                            labelText: ' Account Holder Number',
                            //keyboardType: TextInputType.number,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            setState(() {
                              accountHolderNumberError = validateString(value);
                            });
                            return accountHolderNumberError;
                          },
                        ),
                      ),

                      SizedBox(height: 20),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // if (_formKey.currentState!.validate()) {
                          await updateInsure(
                              insureId,
                              _bankNameController.text,
                              _branchController.text,
                              _locationController.text,
                              _ifscCodeController.text,
                              int.tryParse(_accountNumberController.text),
                              _accountHolderNumberController.text,
                              context);
                        },
                        // },
                        child: Text('update '),
                      ),
                    ],
                  ),
                ],
              ),
            )));
      },
    );
  }

  Future<void> updateInsure(
    int insureId,
    String? bankName,
    String? branch,
    String? location,
    String? ifscCode,
    int? accountNumber,
    String? accountHolderNumber,
    BuildContext context,
    //BuildContext context,
  ) async {
    ("api call made");

    final Map<String, dynamic> requestBody = {
      "insureId": insureId,
      "bankName": bankName,
      "branch": branch,
      //   "designation":designation,
      "location": location,
      "ifscCode": ifscCode,
      "accountNumber": accountNumber.toString(),
      "accountHolderNumber": accountHolderNumber
    };
    (requestBody);

    //try {
    var headers = await ApiServices.getHeaders();

    final response = await http.put(
      Uri.parse(
          ApiServices.baseUrl + ApiServices.updateInsure + insureId.toString()),
      body: jsonEncode(requestBody),
      headers: headers,
    );
    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      (response.body);
      await _fetchData();
      Navigator.of(context).pop();

      _showSuccessDialog(context, "insure detail bank Updated");
      clearTextFeilds();
    } else {
      Navigator.of(context).pop();
      _showErrorDialog(context);
      ('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: Offset(0, 3), // Offset
            ),
          ],
        ),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () async {
                            await exportInsurerBankDetails(fileName);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Export ',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () async {
                            await createInsurerBankDetails();
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Create ',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Align(
                      child: Container(
                        height: 37,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                SecureRiskColours.Button_Color),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black.withOpacity(
                                      0.2), // Light black border color
                                ),
                                borderRadius: BorderRadius.circular(
                                    8), // Adjust the border radius as needed
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: IconButton(
                            onPressed: () {
                              // Handle edit button action for the current row
                            },
                            icon: Icon(Icons.settings, size: 20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.6,
                width: screenWidth * 1.6,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      //columnSpacing: 305,
                      columnSpacing: 55,
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return SecureRiskColours
                            .Table_Heading_Color; // Use any color of your choice
                      }),
                      columns: [
                        buildDataColumn("S.no"),
                        buildDataColumn("BankName"),
                        buildDataColumn("Branch"),
                        buildDataColumn("Location"),
                        buildDataColumn("IfseCode"),
                        buildDataColumn("AccountNumber"),
                        buildDataColumn("AccountHolderNumber"),
                        buildDataColumn("Action")
                      ],
                      rows: [
                        ...bankList
                            .map((insure) => DataRow(cells: [
                                  DataCell(Text((bankList.indexOf(insure) + 1)
                                      .toString())),
                                  DataCell(Text(insure.bankName ?? "N/A")),
                                  DataCell(Text(insure.branch ?? "N/A")),
                                  DataCell(Text(insure.location ?? "N/A")),
                                  DataCell(Text(insure.ifscCode ?? "N/A")),
                                  DataCell(
                                      Text(insure.accountNumber.toString())),
                                  DataCell(Text(
                                      insure.accountHolderNumber ?? "N/A")),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            print('Edit button pressed');
                                            _openEditDialog(insure.insurerid);
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                        onPressed: () async {
                                          await deleteInsureBankDetails(
                                              insure.insurerid.toString());
                                        },
                                        icon: Icon(Icons.delete),
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                      )
                                    ],
                                  ))
                                ]))
                            .toList()
                      ]),
                ),
              ),
            ])),
      ),
    ));
  }

  DataColumn buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
