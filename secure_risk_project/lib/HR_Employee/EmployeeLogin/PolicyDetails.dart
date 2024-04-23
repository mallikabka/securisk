import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;

class EmployeePolicyDetails extends StatefulWidget {
  // int clientId;
  // String productId;
  EmployeePolicyDetails({
    Key? key,
    // required this.clientId,
    // required this.productId,
  }) : super(key: key);

  @override
  State<EmployeePolicyDetails> createState() => _EmployeePolicyDetailsState();
}

class _EmployeePolicyDetailsState extends State<EmployeePolicyDetails> {
  void initState() {
    super.initState();

    fetchPolicyData();
  }
// Insurer Name
// Star Health and Allied Insurance Co.Ltd
// Policy Name
// Group Health Insurance (GHI)
// Policy No
// P/130000/01/2021/000388
// Policy Type
// Regular
// Product Name
// Group Health Insurance (GHI)
// Start Date
// 12-10-2023
// End Date
// 11-10-2024

  String? insurerName;
  String? policyName;
  String? PolicyNum;
  String? policyType;
  String? productName;
  String? startDate;
  String? endDate;

  List<PolicyDetails> _policyList = [];
  Future<void> fetchPolicyData() async {
    int clientId = 2552;
    int productId = 1001;
    var headers = await ApiServices.getHeaders();

    String urlString =
        "${ApiServices.baseUrl}${ApiServices.getPolicyById}clientId=$clientId&productId=$productId";
    try {
      final response = await http.get(Uri.parse(urlString), headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, then parse the JSON.

        final data = json.decode(response.body);
        print("Raw policyCopyPath: ${data['policyCopyPath']}");

        setState(() {
          // insurerName = widget.productNameVar;
          //policyNamecontroller.text = data['policyName'] ?? ' ';
          policyName = data['policyName'] ?? ' ';
          insurerName = data['insuranceCompany'] ?? ' ';
          PolicyNum = data['policyNumber'] ?? ' ';
          policyType = data['insuranceBroker'] ?? ' ';
          productName = data['policyName'] ?? ' ';
          startDate = data['policyStartDate'] ?? ' ';

          endDate = data['policyEndDate'] ?? ' ';
        });
        print(data);
        //    print("))))))))))))))))))))))))))))))))))");
        // print(policyCopy);
        // // Use the data as needed
        // print(policyfileName);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load policy data');
      }
    } catch (e) {
      print(e); // Handle the exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Insurance Details'),
      //   theme: ThemeData(
      //   primarySwatch: Colors.blue, // This sets the primary color throughout the app
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.green, // Specific color for all AppBars
      //   ),
      // ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Insurer Name : ${policyName}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Policy Name : ${policyName}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Policy Number : ${PolicyNum}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Policy Type : ${policyType}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Product Name : ${productName}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Start Date : ${startDate}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("End Date : ${endDate}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class PolicyDetails {
  final int policyId;
  final String insurerName;
  final String policyName;
  final String PolicyNum;
  final String policyType;
  final String? productName;
  final String startDate;
  final String? endDate;
//  final String fileName;

  PolicyDetails(
      {required this.policyId,
      required this.insurerName,
      required this.policyName,
      required this.PolicyNum,
      required this.policyType,
      required this.productName,
      required this.startDate,
      required this.endDate});
}
