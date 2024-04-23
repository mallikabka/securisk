import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/EditRfq/EditRestCoverages.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class PermiumLifeDetails {
  final int premiumLifeid;
  final int ageBandStart;
  final int ageBandEnd;
  final int sumInsured;
  final int basePremium;
  PermiumLifeDetails({
    required this.premiumLifeid,
    required this.ageBandStart,
    required this.ageBandEnd,
    required this.sumInsured,
    required this.basePremium,

    // required this.contacts
  });
}

class PerLifeCard extends StatefulWidget {
  // const PerLifeCard({super.key});
  int? clientId;

  String? productIdvar;
  PerLifeCard({
    Key? key,
    required this.clientId,
    required this.productIdvar,
  }) : super(key: key);

  @override
  State<PerLifeCard> createState() => _PerLifeCardState();
}

class _PerLifeCardState extends State<PerLifeCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//    {
//   "ageBandStart": 2,
//   "ageBandEnd": 2,
//   "sumInsured": 3,
//   "basePremium": 5
// }
  TextEditingController _ageBandStartController = TextEditingController();
  TextEditingController _ageBandEndController = TextEditingController();
  TextEditingController _sumInsuredController = TextEditingController();
  TextEditingController _basePremiumController = TextEditingController();

  List<PermiumLifeDetails> perLifeList = [];
  String? ageBandStartError = "";
  String? ageBandEndError = "";
  String? sumInsurededError = "";
  String? basePremiumError = "";

  void initState() {
    super.initState();
    _fetchData();
  }

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  exportPremiumLifeDetails(String fileName) async {
    var headers = await ApiServices.getHeaders();
    int? clientId = widget.clientId;
    String? productId = widget.productIdvar;

    String urlString =
        "${ApiServices.baseUrl}${ApiServices.exportLifeCalculator}clientId=$clientId&productId=$productId";

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

  Future<void> createPremiumLifeDetails() {
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
                          'Create Premium Life Detalis',
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
                        controller: _ageBandStartController,
                        decoration: InputDecoration(
                          labelText: 'Age band Start',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            ageBandStartError = validateString(value);
                          });
                          return ageBandStartError;
                        },
                      ),
                    ),

                    SizedBox(height: 20), // Spacer

                    // File Upload Field
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _ageBandEndController,
                        decoration: InputDecoration(
                          labelText: 'Age Band End',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            ageBandEndError = validateString(value);
                          });
                          return ageBandEndError;
                        },
                      ),
                    ),

                    SizedBox(height: 20), // Spacer
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _sumInsuredController,
                        decoration: InputDecoration(
                          labelText: 'Sum Insured',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            sumInsurededError = validateString(value);
                          });
                          return sumInsurededError;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer

                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _basePremiumController,
                        decoration: InputDecoration(
                          labelText: 'Base Premium',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            basePremiumError = validateString(value);
                          });
                          return basePremiumError;
                        },
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                                backgroundColor: SecureRiskColours.Button_Color,
                              ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          createPreLifeDetails(
                            int.tryParse(_ageBandStartController.text),
                            int.tryParse(_ageBandEndController.text),
                            int.tryParse(_sumInsuredController.text),
                            int.tryParse(_basePremiumController.text),
                            context,
                          );
                          //Navigator.of(context).pop();
                          clearTextFeilds();
                        }
                      },
                      child: Text('Create ',style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updatePremiumLifeDetails(int premiumId) {
    List<PermiumLifeDetails> filteredData = perLifeList
        .where((premium) => premium.premiumLifeid == premiumId)
        .toList();
    final TextEditingController ageBandStart =
        TextEditingController(text: filteredData.first.ageBandStart.toString());

    final TextEditingController ageBandEnd =
        TextEditingController(text: filteredData.first.ageBandEnd.toString());
    final TextEditingController sumInsured =
        TextEditingController(text: filteredData.first.sumInsured.toString());

    final TextEditingController basePremium =
        TextEditingController(text: filteredData.first.basePremium.toString());
    final TextEditingController premiumLifeid = TextEditingController(
        text: filteredData.first.premiumLifeid.toString());

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
                          'Update Premium Life Detalis',
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
                        controller: ageBandStart,
                        decoration: InputDecoration(
                          labelText: 'Age band Start',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            ageBandStartError = validateString(value);
                          });
                          return ageBandStartError;
                        },
                      ),
                    ),

                    SizedBox(height: 20), // Spacer

                    // File Upload Field
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: ageBandEnd,
                        decoration: InputDecoration(
                          labelText: 'Age Band End',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            ageBandEndError = validateString(value);
                          });
                          return ageBandEndError;
                        },
                      ),
                    ),

                    SizedBox(height: 20), // Spacer
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: sumInsured,
                        decoration: InputDecoration(
                          labelText: 'Sum Insured',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            sumInsurededError = validateString(value);
                          });
                          return sumInsurededError;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer

                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: basePremium,
                        decoration: InputDecoration(
                          labelText: 'Base Premium',
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          setState(() {
                            basePremiumError = validateString(value);
                          });
                          return basePremiumError;
                        },
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                                backgroundColor: SecureRiskColours.Button_Color,
                              ),
                      onPressed: () async {
                       if (_formKey.currentState!.validate()) {
                          updatePremiumLife(
                            premiumId,
                            int.tryParse(ageBandStart.text),
                            int.tryParse(ageBandEnd.text),
                            int.tryParse(sumInsured.text),
                            int.tryParse(basePremium.text),
                            context,
                          );
                          Navigator.of(context).pop();
                          clearTextFeilds();
                        }
                      },
                      child: Text('Update ',style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void clearTextFeilds() {
    _ageBandStartController.text = ' ';
    _ageBandEndController.text = ' ';

    _sumInsuredController.text = ' ';
    _basePremiumController.text = ' ';
  }

  Future<void> createPreLifeDetails(int? ageBandStart, int? ageBandEnd,
      int? sumInsured, int? basePremium, BuildContext context) async {
    int? clientId = widget.clientId;
    String? productId = widget.productIdvar;

    final Map<String, dynamic> requestBody = {
      "ageBandStart": ageBandStart,
      "ageBandEnd": ageBandEnd,
      "sumInsured": sumInsured,
      "basePremium": basePremium,
    };
    (requestBody);
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.post(
        Uri.parse(
            "${ApiServices.baseUrl}${ApiServices.createPremiumLifeCalculator}?clientId=$clientId&productId=$productId"),
        body: jsonEncode(requestBody),
        headers: headers,
      );
      //print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        (response.body);
        //_showSuccessDialog(context, "bank detalis Added");
        await _fetchData();
        Navigator.of(context).pop();
        _showSuccessDialog(context, "Premium Life Calculator added");
        clearTextFeilds();

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

  Future<void> deletePremiumLifeDetails(String premiumLifeId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete?',
              style: TextStyle(color: Colors.red),
            ),
            content:
                Text('Are you sure you want to delete this Premium Details?'),
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
        final apiUrl = Uri.parse(ApiServices.baseUrl +
            ApiServices.deleteLifeCalculator +
            premiumLifeId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('Premium Life details deleted successfully');
          await _fetchData();
        } else {
          print(
              'Failed to delete premium life. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> updatePremiumLife(
    int? premiumLifeid,
   
    int? ageBandStart,
    int? ageBandEnd,
    int? sumInsured,
    int? basePremium,
    BuildContext context,
    //BuildContext context,
  ) async {
    ("api call made");

    final Map<String, dynamic> requestBody = {
      "ageBandStart": ageBandStart,
      "ageBandEnd": ageBandEnd,
      "sumInsured": sumInsured,
      "basePremium": basePremium,
      "life_premiumCalcuater_id": premiumLifeid,
      "rfqId":"233",
      "productId":"555",
      "clientListId":"666"
    };
    (requestBody);

    //try {
    var headers = await ApiServices.getHeaders();

    final response = await http.patch(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.updateLifePremiumCalculator 
          ),
      body: jsonEncode(requestBody),
      headers: headers,
    );
    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      (response.body);
      await _fetchData();
   

      _showSuccessDialog(context, "Premium Life Details Updated");
      clearTextFeilds();
    } else {
    
      _showErrorDialog(context);
      ('Error: ${response.statusCode}');
    }
  }

  Future<void> _fetchData() async {
    int? clientId = widget.clientId;
    String? productId = widget.productIdvar;
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.get(
        Uri.parse(
            "${ApiServices.baseUrl}${ApiServices.getAllLifePremiumCalculator}?clientId=$clientId&productId=$productId"),
        //body: jsonEncode(requestBody),
        headers: headers,
      );
      //final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (data != null && data.isNotEmpty) {
          final List<PermiumLifeDetails> premiumLifeList = data
              .map((item) => PermiumLifeDetails(
                    premiumLifeid: item['life_premiumCalcuater_id'],
                    ageBandStart: item['ageBandStart'] ?? '',
                    ageBandEnd: item['ageBandEnd'] ?? '',
                    sumInsured: item['sumInsured'] ?? '',
                    basePremium: item['basePremium'] ?? '',

                    // contacts: item['contact']
                  ))
              .toList();

          setState(() {
            perLifeList = premiumLifeList;
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
                            await exportPremiumLifeDetails(
                                "premiumLifeDetails");
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
                            await createPremiumLifeDetails();
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
                width: screenWidth * 0.8,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      //columnSpacing: 305,
                      columnSpacing: 90,
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return SecureRiskColours
                            .Table_Heading_Color; // Use any color of your choice
                      }),
                      columns: [
                        buildDataColumn("S.no"),
                        buildDataColumn("AgeBandStart"),
                        buildDataColumn("AgeBandEnd"),
                        buildDataColumn("sumInsured"),
                        buildDataColumn("BasePremium"),
                        buildDataColumn("Action")
                      ],
                      rows: [
                        ...perLifeList
                            .map((insure) => DataRow(cells: [
                                  DataCell(Text(
                                      (perLifeList.indexOf(insure) + 1)
                                          .toString())),
                                  DataCell(
                                      Text(insure.ageBandStart.toString())),
                                  DataCell(Text(insure.ageBandEnd.toString())),
                                  DataCell(Text(insure.sumInsured.toString())),
                                  DataCell(Text(insure.basePremium.toString())),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            print('Edit button pressed');
                                            updatePremiumLifeDetails( insure.premiumLifeid);
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                        onPressed: () async {
                                          await deletePremiumLifeDetails(
                                              insure.premiumLifeid.toString());
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
