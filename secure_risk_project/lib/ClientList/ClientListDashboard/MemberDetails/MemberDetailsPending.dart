import 'dart:convert';

import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/CreateLocation/CreateLocation.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class Master {
  final int memberId;
  final String employeeNo;
  final String name;
  final String relationShip;
  final String email;
  final String phoneNumber;
  final int sumInsured;
  final String month;
  final String status;
  // final int age;

  Master({
    required this.memberId,
    required this.employeeNo,
    required this.name,
    required this.relationShip,
    required this.email,
    required this.phoneNumber,
    required this.sumInsured,
    required this.month,
    required this.status,
    // required this.age,
  });
}

class PendingList extends StatefulWidget {
  int clientId;
  String productId;
  PendingList({Key? key, required this.clientId, required this.productId})
      : super(key: key);
  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  String? _selectedFilter;

  List<String> _filterOptions = [
    'Employee No',
    'Name',
    'Relationship',
    'Email'
  ];

  List<String> _allOptions = [
    'All',
    'January',
    'February ',
    'March ',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<Location> _locationslist = [];
  List<Designation> _designationlist = [];
  List<Department> _departmentlist = [];
  List<String> _genderlist = ['Male', 'Female'];
  TextEditingController _searchController = TextEditingController();
  List<String> _roleList = ['Admin', 'Employee'];
  String? selectedDesignation;
  String? selectedDepartment;
  String? selectedGender;

  final TextEditingController employeeNoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController relationShipController = TextEditingController();
  final TextEditingController dateOfbirthController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sumInsuredController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Department? selecteddepartment;
  Designation? selecteddesignation;
  String? selectedRole;

  int? locationId;
  int? departmentId;
  int? desinationId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleFilterByChange(String? newValue) {
    setState(() {});
  }

  void _handleAll(String? newValue) {
    setState(() {});
  }

  void initState() {
    super.initState();
    _fetchDesignation();

    _fetchDepartment();
    _fetchData();
  }

  Future<void> _fetchDesignation() async {
    try {
      List<Designation> designation = await fetchDesignation();
      setState(() {
        _designationlist = designation;
      });
    } catch (e) {
      // Handle API call error here.
      (e.toString());
    }
  }

  Future<List<Department>> fetchDepartment() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.roles_getAllDepartment),
        headers: headers);

    if (response.statusCode == 200) {
      (response.body);
      final List<dynamic> data = json.decode(response.body);
      List<Department> department =
          data.map((json) => Department.fromJson(json)).toList();
      ("department: $department");
      return department;
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<void> _fetchDepartment() async {
    try {
      List<Department> department = await fetchDepartment();
      setState(() {
        _departmentlist = department;
      });
      (_departmentlist);
    } catch (e) {
      // Handle API call error here.
      (e.toString());
    }
  }

  void _onDesignationChanged(String? designation) {
    setState(() {
      selectedDesignation = designation;
    });
    (selectedDesignation);
  }

  void _onDepartmentChanged(String? department) {
    setState(() {
      selectedDepartment = department;
    });
    (selectedDepartment);
  }

  void _onGenderChanged(String? gender) {
    setState(() {
      selectedGender = gender;
    });
    (selectedGender);
  }

  void _onRoleChanged(String? role) {
    setState(() {
      selectedRole = role;
    });
    (selectedRole);
  }

  Future<List<Designation>> fetchDesignation() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.getAllDesignations),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Assuming your API response returns a list of strings as locations directly.
      List<Designation> designation =
          data.map((json) => Designation.fromJson(json)).toList();

      ("designation: $designation");
      return designation;
    } else {
      throw Exception('Failed to load designation');
    }
  }

  exportPendingMemberDetails(String fileName) async {
    int clientListId = widget.clientId;
    int? productId = int.tryParse(widget.productId);

    String urlString =
        "${ApiServices.baseUrl}${ApiServices.exportMemberDetailsPendingApi}clientListId=$clientListId&productId=$productId";

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        //final blob = html.Blob([response.bodyBytes]);
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

  pendingMemberDetailsDownloadTemplate(String fileName) async {
    String urlString =
        "${ApiServices.baseUrl}${ApiServices.pendingListDownloadTemplate}";

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        //final blob = html.Blob([response.bodyBytes]);
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

  Future<void> deletePendingMemberDetails(String memberDetailsId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete?', style: TextStyle(color: Colors.red)),
            content:
                Text('Are you sure you want to delete this memberdetails?'),
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
            ApiServices.deleteMemberDetails +
            memberDetailsId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('MemberDetails deleted successfully');
          await _fetchData();
        } else {
          print(
              'Failed to delete MemberDetails. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();

      final uploadApiUrl = Uri.parse(
              'http://14.99.138.131:9981/clientList/memberDetails/getAllPendingList')
          .replace(queryParameters: {
        'productId': widget.productId.toString(), //'1001',
        'clientListId': widget.clientId.toString(), //'1552',
      });

      // final uploadApiUrl = Uri.parse(ApiServices.baseUrl +
      //         ApiServices.getAllMemberdetailsPending)
      //     .replace(queryParameters: {

      //   "productId": 1001,//int.parse(widget.productId),
      //    "clientListId": 1552,//(widget.clientId),
      // });
//  final uploadApiUrl =
//           Uri.parse(ApiServices.baseUrl + ApiServices.getAllMemberdetailsPending)
//               .replace(queryParameters: {
//         "clientListId": (widget.clientId).toString(),
//            "productId": widget.productId,

//       });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (data != null && data.isNotEmpty) {
          final List<Master> masterList = data
              .map((item) => Master(
                    memberId: item['memberId'] ?? '',
                    employeeNo: item['employeeNo'] ?? '',
                    name: item['name'] ?? '',
                    relationShip: item['relationShip'] ?? '',
                    email: item['email'] ?? '',
                    phoneNumber: item['phoneNumber'] ?? '',
                    sumInsured: item['sumInsured'] ?? '',
                    month: item['month'] ?? '',
                    status: item['status'] ?? '',
                    //  age: item['age'] ?? '',
                  ))
              .toList();

          setState(() {
            _masterList = masterList;
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

  Map<String, dynamic> fileResponses = {};

  void _handleSearch(String value) {}
  http.MultipartRequest jsonToFormData(
      http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  List<Master> _masterList = [];

  void clearTextFeilds() {
    employeeNoController.text = ' ';
    nameController.text = ' ';
    relationShipController.text = ' ';
    // selecteddepartment = null;
    // selecteddesignation = null;
    dateOfbirthController.text = ' ';
    ageController.text = ' ';
    // selectedGender = " ";
    emailController.text = ' ';
    phoneNumberController.text = ' ';
    sumInsuredController.text = ' ';
    // selectedRole = " ";
  }

  Future<void> createEmployee(
    String? employeeNo,
    String? name,
    String? relationship,
    String? department,
    String? designation,
    String? dateOfBirthController,
    String ageController,
    String? gender,
    String emailController,
    int phoneNumber,
    int? sumInsured,
    int? designationId,
    int? departmentId,
    String? role,
    BuildContext context,
    void Function() _fetchData,
  ) async {
    ("api call made");
    int? clientId = widget.clientId;
    String? productId = widget.productId;
    String? rfqId = "123";

    final Map<String, dynamic> requestBody = {
      "employeeNo": employeeNo,
      "name": name,
      "relationShip": relationship,
      "gender": gender,
      "dateOfBirth": "1998-08-28",
      "age": int.tryParse(ageController),
      "sumInsured": sumInsured,
      "email": emailController,
      "phoneNumber": phoneNumber,
      "designationId": desinationId,
      "departmentId": departmentId,
      "role": role
    };
    (requestBody);
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.post(
        Uri.parse(
            "${ApiServices.baseUrl}${ApiServices.createEmployeeMemberDetails}?clientListId=$clientId&productId=$productId&rfqId=$rfqId"),
        body: jsonEncode(requestBody),
        headers: headers,
      );
      //print(response);
      if (response.statusCode == 201 || response.statusCode == 200) {
        (response.body);
        _fetchData();
        Navigator.of(context).pop();
        _showSuccessDialog(context, "Employee Added");
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

  Future<void> updateEmployee(
    String? employeeNo,
    String? name,
    String? relationship,
    String? department,
    String? designation,
    String? dateOfBirthController,
    String ageController,
    String? gender,
    String emailController,
    int phoneNumber,
    int? sumInsured,
    int? designationId,
    int? departmentId,
    String? role,
    BuildContext context,
    void Function() _fetchData,
    int memberDetailsId,
  ) async {
    ("api call made");

    final Map<String, dynamic> requestBody = {
      "employeeNo": employeeNo,
      "name": name,
      "relationShip": relationship,
      "gender": gender,
      "dateOfBirth": "1998-08-28",
      "age": int.tryParse(ageController),
      "sumInsured": sumInsured,
      "email": emailController,
      "phoneNumber": phoneNumber,
      "designationId": designationId,
      "departmentId": departmentId,
      "role": role
      // "employeeNo": "343",
      //  "name": "siri",
      //   "relationShip": "wert",
      //    "gender": "Female",
      //    "dateOfBirth": "1998-08-28",
      //    "age": 123,
      //    "sumInsured": 234,
      //     "email": "ert",
      //      "phoneNumber": "456",
      //      "designationId": desinationId,
      //   "departmentId":departmentId,//7,// "CRM",
      //    "role": "Employee"
    };
    (requestBody);

    //try {
    var headers = await ApiServices.getHeaders();
    print(headers);
    final response = await http.patch(
      Uri.parse(
          "${ApiServices.baseUrl}${ApiServices.updateMemberdetails_InAdditionsEndpoint}?memberDetailsId=$memberDetailsId"),
      body: jsonEncode(requestBody),
      headers: headers,
    );
    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      (response.body);
      _fetchData();
      Navigator.of(context).pop();
      _showSuccessDialog(context, "Employee  Updated");
      // clearTextFeilds();
    } else {
      Navigator.of(context).pop();
      _showErrorDialog(context);
      ('Error: ${response.statusCode}');
    }
    // } catch (exception) {
    //   ('Exception: $exception');
    // }
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

  void _openAddUserDialog() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Set<Department> department = _departmentlist.toSet();
    Set<Designation> designation = _designationlist.toSet();
    Set<String> gend = _genderlist.toSet();
    Set<String> roleList = _roleList.toSet();
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
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 680,
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
                              'Create Employee',
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
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: employeeNoController,
                              decoration: InputDecoration(
                                labelText: 'Employee No',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee id';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: relationShipController,
                              decoration: InputDecoration(
                                labelText: 'Relationship',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter relaitonship';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<String>(
                              value: selectedGender,
                              onChanged: (newValue) {
                                _onGenderChanged(newValue);
                                selectedGender = newValue;
                              },
                              items: _genderlist.toSet().map((gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Gender',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a gender';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            width: 300,
                            height: 40,
                            margin: EdgeInsets.only(right: 8),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Material(
                                shadowColor: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                child: TextFormField(
                                  controller: dateOfbirthController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Date Of Birth',
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 13),
                                    suffixIcon: GestureDetector(
                                      onTap: () async {
                                        DateTime? selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );

                                        if (selectedDate != null) {
                                          String formattedDate =
                                              "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                          dateOfbirthController.text =
                                              formattedDate;
                                        }
                                      },
                                      child: Icon(
                                        Icons.calendar_month_sharp,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 18),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(right: 12, left: 8),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: ageController,
                              decoration: InputDecoration(
                                labelText: 'Age',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee id';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Phone Number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<Designation>(
                              isExpanded: true,
                              value: selecteddesignation,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  desinationId = newValue
                                      .id; // Capture the locationId when a location is selected
                                }
                                _onDesignationChanged(newValue.toString());
                                selecteddesignation = newValue;
                                (desinationId);
                              },
                              items: designation.toSet().map((designation) {
                                return DropdownMenuItem<Designation>(
                                  value:
                                      designation, // Set the value to the entire Location object
                                  child: Text(designation.designationName),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Designation',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.designationName.isEmpty) {
                                  return 'Please select a designation';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<Department>(
                              value: selecteddepartment,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  departmentId = newValue
                                      .id; // Capture the locationId when a location is selected
                                }
                                // onDepratmentChanged(newValue.toString());
                                selecteddepartment = newValue;
                              },
                              items: department.toSet().map((department) {
                                return DropdownMenuItem<Department>(
                                  value:
                                      department, // Set the value to the entire Location object
                                  child: Text(department.departmentName),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Department',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.departmentName.isEmpty) {
                                  return 'Please select a Department';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<String>(
                              value: selectedRole,
                              onChanged: (newValue) {
                                //  _onRoleChanged(newValue);
                                selectedRole = newValue;
                              },
                              items: _roleList.toSet().map((role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Role',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a role';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 8, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: sumInsuredController,
                              decoration: InputDecoration(
                                labelText: 'Sum Insured',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Phone Number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: SecureRiskColours.Button_Color,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ("passed if");

                            createEmployee(
                              employeeNoController.text,
                              nameController.text,
                              relationShipController.text,
                              selecteddepartment!.departmentName,
                              selecteddesignation!.designationName,
                              dateOfbirthController.text,
                              ageController.text,
                              selectedGender,
                              emailController.text,
                              int.tryParse(phoneNumberController.text) ?? 0,
                              int.tryParse(sumInsuredController.text) ?? 0,
                              desinationId,
                              departmentId,
                              selectedRole,
                              context,
                              _fetchData,
                            );
                            clearTextFeilds();
                          }
                        },
                        child: Text('Create',
                            style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _openEditDialog(int mId) {
    List<Master> filteredData =
        _masterList.where((master) => master.memberId == mId).toList();
    final TextEditingController employeeNoController =
        TextEditingController(text: filteredData.first.employeeNo);

    final TextEditingController nameController =
        TextEditingController(text: filteredData.first.name);

    final TextEditingController relationShipController =
        TextEditingController(text: filteredData.first.relationShip);

//  final TextEditingController dateOfbirthController =
//         TextEditingController(text: filteredData.first.dateOfBirth);

    final TextEditingController ageController =
        TextEditingController(text: '30');
    // TextEditingController(text: (filteredData.first.age).toString());
    final TextEditingController sumInsuredController =
        TextEditingController(text: (filteredData.first.sumInsured).toString());
    final TextEditingController emailController =
        TextEditingController(text: filteredData.first.email);
    final TextEditingController phoneNumberController =
        TextEditingController(text: filteredData.first.phoneNumber);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Set<Department> department = _departmentlist.toSet();
    Set<Designation> designation = _designationlist.toSet();
    Set<String> gend = _genderlist.toSet();
    Set<String> roleList = _roleList.toSet();
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
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 680,
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
                              'Update Employee',
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
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: employeeNoController,
                              decoration: InputDecoration(
                                labelText: 'Employee No',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee id';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: relationShipController,
                              decoration: InputDecoration(
                                labelText: 'Relationship',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter relaitonship';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<String>(
                              value: selectedGender,
                              onChanged: (newValue) {
                                _onGenderChanged(newValue);
                                selectedGender = newValue;
                              },
                              items: _genderlist.toSet().map((gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Gender',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a gender';
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            width: 300,
                            height: 40,
                            margin: EdgeInsets.only(right: 8),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Material(
                                shadowColor: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                child: TextFormField(
                                  controller: dateOfbirthController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Date Of Birth',
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 13),
                                    suffixIcon: GestureDetector(
                                      onTap: () async {
                                        DateTime? selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );

                                        if (selectedDate != null) {
                                          String formattedDate =
                                              "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                          dateOfbirthController.text =
                                              formattedDate;
                                        }
                                      },
                                      child: Icon(
                                        Icons.calendar_month_sharp,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 18),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(right: 12, left: 8),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: ageController,
                              decoration: InputDecoration(
                                labelText: 'Age',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee id';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Phone Number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<Designation>(
                              isExpanded: true,
                              value: selecteddesignation,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  desinationId = newValue
                                      .id; // Capture the locationId when a location is selected
                                }
                                _onDesignationChanged(newValue.toString());
                                selecteddesignation = newValue;
                                (desinationId);
                              },
                              items: designation.toSet().map((designation) {
                                return DropdownMenuItem<Designation>(
                                  value:
                                      designation, // Set the value to the entire Location object
                                  child: Text(designation.designationName),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Designation',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.designationName.isEmpty) {
                                  return 'Please select a designation';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<Department>(
                              value: selecteddepartment,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  departmentId = newValue
                                      .id; // Capture the locationId when a location is selected
                                }
                                // onDepratmentChanged(newValue.toString());
                                selecteddepartment = newValue;
                              },
                              items: department.toSet().map((department) {
                                return DropdownMenuItem<Department>(
                                  value:
                                      department, // Set the value to the entire Location object
                                  child: Text(department.departmentName),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Department',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.departmentName.isEmpty) {
                                  return 'Please select a Department';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 300,
                            height: 40,
                            child: DropdownButtonFormField<String>(
                              value: selectedRole,
                              onChanged: (newValue) {
                                //  _onRoleChanged(newValue);
                                selectedRole = newValue;
                              },
                              items: _roleList.toSet().map((role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Role',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a role';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 8, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: sumInsuredController,
                              decoration: InputDecoration(
                                labelText: 'Sum Insured',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Phone Number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: SecureRiskColours.Button_Color,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ("passed if");

                            updateEmployee(
                              employeeNoController.text,
                              nameController.text,
                              relationShipController.text,
                              selecteddepartment!.departmentName,
                              selecteddesignation!.designationName,
                              dateOfbirthController.text,
                              ageController.text,
                              selectedGender,
                              emailController.text,
                              int.tryParse(phoneNumberController.text) ?? 0,
                              int.tryParse(sumInsuredController.text) ?? 0,
                              desinationId,
                              departmentId,
                              selectedRole,
                              context,
                              _fetchData,
                              mId,
                            );
                            clearTextFeilds();
                          }
                        },
                        child: Text('Update',
                            style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  int currentPage = 1;
  int pageSize = 6;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    int snum = startIndex + 1;
    int totalInsurers = _masterList.length;

    final List<Master> currentPageInsurers = startIndex < totalInsurers
        ? _masterList.sublist(
            startIndex, endIndex < totalInsurers ? endIndex : totalInsurers)
        : [];

    int? indexNumber;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: 250,
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            onChanged: _handleAll,
                            items: _allOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:
                                    Text(value, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            hint: Text('All', style: GoogleFonts.poppins()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        width: 220,
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            onChanged: _handleFilterByChange,
                            items: _filterOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:
                                    Text(value, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            hint:
                                Text('Filter By', style: GoogleFonts.poppins()),
                          ),
                        ),
                      ),
                    ),
                    //Spacer(),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        width: 240,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _handleSearch,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            labelText: 'Search',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black26,
                              ),
                              onPressed: () {
                                _handleSearch(_searchController.text);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            exportPendingMemberDetails(
                                "member_details_pending");
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Export',
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
                        height: 37,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                SecureRiskColours.Button_Color),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: IconButton(
                            onPressed: () {},
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
                  // physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: DataTable(
                        columnSpacing: 50,
                        headingRowColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return SecureRiskColours.Table_Heading_Color;
                        }),
                        columns: [
                          //  buildDataColumn('No'),
                          buildDataColumn('Emp No'),
                          buildDataColumn('Name'),
                          buildDataColumn('Relationship'),
                          buildDataColumn('Email'),
                          buildDataColumn('Phone'),
                          buildDataColumn('Sum Insured'),
                          buildDataColumn('Status'),
                          buildDataColumn('Month'),
                         // buildDataColumn('Action'),
                        ],
                        rows: [
                          // ..._masterList
                          //     .map((ends) => DataRow(cells: [
                          //           DataCell(Text(ends.employeeNo)),
                          //           DataCell(Text(ends.memberId.toString())),
                          //           DataCell(Text(ends.name)),
                          //           DataCell(Text(ends.relationShip)),
                          //           DataCell(Text(ends.email)),
                          //           DataCell(Text(ends.phoneNumber)),
                          //           DataCell(Text(ends.sumInsured.toString())),
                          //           DataCell(Text("Active")),
                          //           DataCell(Text(ends.month)),
                          //           DataCell(buildActionButtons(ends.memberId)),
                          //         ]))
                          //     .toList()

                          for (int index = 0;
                              index < currentPageInsurers.length;
                              index++)
                            DataRow(cells: [
                              DataCell(
                                  Text(currentPageInsurers[index].employeeNo)),
                              DataCell(Text(currentPageInsurers[index].name)),
                              DataCell(Text(
                                  currentPageInsurers[index].relationShip)),
                              DataCell(Text(currentPageInsurers[index].email)),
                              DataCell(
                                  Text(currentPageInsurers[index].phoneNumber)),
                              DataCell(Text(currentPageInsurers[index]
                                  .sumInsured
                                  .toString())),
                              DataCell(Text(currentPageInsurers[index].status)),
                              DataCell(Text(currentPageInsurers[index].month)),
                              //  DataCell(buildActionButtons(currentPageInsurers[index].memberId)),

                              //  DataCell(Text("Actions")),
                            ])
                        ]),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (totalPages > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 1
                          ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                          : null,
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 8.0),
                    Text('$currentPage'),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: currentPage < totalPages
                          ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                          : null,
                      child: Text(
                        'Next',
                      ),
                    ),
                  ],
                ),
            ])),
      ),
    ));
  }

  Widget buildActionButtons(int mId) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.edit_rounded),
          onPressed: () {
            _openEditDialog(mId);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            deletePendingMemberDetails(mId.toString());
          },
        ),
      ],
    );
  }

  int get totalPages {
    return (_masterList.length / pageSize).ceil();
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
