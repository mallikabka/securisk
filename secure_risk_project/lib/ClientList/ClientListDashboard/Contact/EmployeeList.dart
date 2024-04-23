import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Department/CreateDepartment.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Validations.dart';

class Employee {
  final int contactId;
  final String employeeId;
  final String name;
  final String email;
  final String mobile;
  final String designation;
  // final String contacts;

  Employee({
    required this.contactId,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.designation,
    // required this.contacts
  });
}

class EmployeeList extends StatefulWidget {
  int clientId;
  String productId;
  EmployeeList({
    Key? key,
    required this.clientId,
    required this.productId,
  }) : super(key: key);
  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? emailError;
  String? phoneError;
  void clearValidationErrors() {
    setState(() {});
  }

  List<String> _filterOptions = [
    's.no',
    'Employee Id',
    "Name",
    "Email",
    "phoneNumber"
  ];
  int? desinationId;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _employeeIdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  // TextEditingController _Controller = TextEditingController();
  Designation? selecteddesignation;
  var _filteredData;
  String? _selectedFilter;
  String? employeeId;
  String? name;
  String? email;
  String? mobile;
  //String? designationId;
  void initState() {
    super.initState();
    _fetchDesignation();
    _fetchData();
  }

  List<Employee> contactList = [];
  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.contactGetAllContacts)
              .replace(queryParameters: {
        "clientListId": (widget.clientId).toString(),
        "productId": widget.productId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (data != null && data.isNotEmpty) {
          final List<Employee> managementList = data
              .map((item) => Employee(
                    contactId: item['contactId'],
                    employeeId: item['employeeId'] ?? '',
                    name: item['name'] ?? '',
                    email: item['email'] ?? '',
                    mobile: item['phoneNumber'] ?? '',
                    designation: item['designation'] ?? '',
                    // contacts: item['contact']
                  ))
              .toList();

          setState(() {
            contactList = managementList;
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

  void clearTextFeilds() {
    _employeeIdController.text = ' ';
    _nameController.text = ' ';

    _emailController.text = ' ';
    _mobileController.text = ' ';

    // selectedRole = " ";
  }

  Future<void> createManagement(
    String? employeeId,
    String? name,
    String? designation,
    String? emailController,
    String? phoneNumber,
    int? designationId,
    BuildContext context,
  ) async {
    ("api call made");
    int? clientId = widget.clientId;
    String? productId = widget.productId;

    final Map<String, dynamic> requestBody = {
      "employeeId": employeeId,
      "name": name,
      //   "designation":designation,
      "email": emailController,
      "phoneNumber": phoneNumber,
      "designation": desinationId,
    };
    (requestBody);
    try {
      var headers = await ApiServices.getHeaders();

      final response = await http.post(
        Uri.parse(
            "${ApiServices.baseUrl}${ApiServices.createmanagement}?clientListId=$clientId&productId=$productId"),
        body: jsonEncode(requestBody),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        (response.body);

        await _fetchData();
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

  List<Designation> _designationlist = [];
  Future<void> deleteContact(String contactId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete this endorsement?'),
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
            ApiServices.baseUrl + ApiServices.deleteManagement + contactId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('Endorsement deleted successfully');
          await _fetchData();
        } else {
          print(
              'Failed to delete endorsement. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> _fetchDesignation() async {
    try {
      List<Designation> designation = await fetchDesignation();
      setState(() {
        _designationlist = designation;
      });
      print(_designationlist);
    } catch (e) {
      // Handle API call error here.
      (e.toString());
    }
  }

  String? selectedDesignation;
  void _onDesignationChanged(String? designation) {
    setState(() {
      selectedDesignation = designation;
    });
    (selectedDesignation);
  }

  Future<void> createMasterList() {
    Set<Designation> designation = _designationlist.toSet();
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
                          'Create Contact Employee',
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
                        controller: _employeeIdController,
                        decoration: InputDecoration(
                          labelText: 'Employee No',
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
                          String trimmedText = value.toString().trim();
                          if (trimmedText.isEmpty) {
                            return 'Please enter an EmployeeNo';
                          }
                          // You can add more validation logic here if needed.
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer

                    // File Upload Field
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
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
                          String trimmedText = value.toString().trim();
                          if (trimmedText.isEmpty) {
                            return 'Please enter an name';
                          }
                          // You can add more validation logic here if needed.
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _emailController,
                        onChanged: (_) => clearValidationErrors(),
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                        keyboardType: TextInputType.emailAddress,
                        // inputFormatters: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.allow(RegExp(
                        //       r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'))
                        // ],
                        validator: (value) {
                          emailError = validateEmail(value);
                          return emailError;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer

                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: _mobileController,
                        onChanged: (_) => clearValidationErrors,
                        decoration: InputDecoration(
                          labelText: 'PhoneNumber',
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
                          phoneError = validatePhoneNumber(value);
                          return phoneError;
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Spacer
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      //  width: 300,
                      //  height: 40,
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          if (value == null || value.designationName.isEmpty) {
                            return 'Please select a designation';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          createManagement(
                            _employeeIdController.text,
                            _nameController.text,
                            selecteddesignation!.designationName,
                            // selecteddesignation!.designationName,
                            _emailController.text,
                            _mobileController.text,
                            desinationId,
                            context,
                          );
                          clearTextFeilds();
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

  String? validateEmail(String? value) {
    final RegExp emailRegex =
        RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    } else if (!emailRegex.hasMatch(value!)) {
      return "Invalid email address";
    } else if (value.substring(value.indexOf('@') + 1).split('.').length != 2) {
      return "Invalid email address";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    } else if (!phoneRegex.hasMatch(value!)) {
      return "Invalid Phone number";
    }
    return null;
  }

  
  
  void _openEditDialog(int mId) {
    print(mId);
    List<Employee> filteredData =
        contactList.where((master) => master.contactId == mId).toList();
    print(filteredData);
    final TextEditingController _employeeIdController =
        TextEditingController(text: filteredData.first.employeeId);

    final TextEditingController _nameController =
        TextEditingController(text: filteredData.first.name);
    final TextEditingController _emailController =
        TextEditingController(text: filteredData.first.email);
    final TextEditingController _mobileController =
        TextEditingController(text: filteredData.first.mobile);

    Set<Designation> designation = _designationlist.toSet();

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
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        height: 60,
                        width: 300,
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
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 15,
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 12, right: 12),
                              child: TextFormField(
                                controller: _employeeIdController,
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            child: TextFormField(
                              controller: _nameController,
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            child: TextFormField(
                              controller: _emailController,
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            child: TextFormField(
                              controller: _mobileController,
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
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
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
                                    mId.toString(),
                                    _employeeIdController.text,
                                    _nameController.text,

                                    _emailController.text,
                                    _mobileController.text,
                                    //selecteddesignation!.designationName,
                                    desinationId!,

                                    //_fetchData,
                                  );
                                  clearTextFeilds();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('Update',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ]))));
      },
    );
  }

  Future<void> updateEmployee(
    String? contactId,
    String? employeeId,
    String? name,
    // String? designation,
    String emailController,
    String? phoneNumber,
    int? designationId,
    //BuildContext context,
  ) async {
    ("api call made");

    final Map<String, dynamic> requestBody = {
      "employeeId": employeeId,
      "name": name,
      "email": emailController,
      "phoneNumber": phoneNumber,
      "designation": designationId,
    };
    (requestBody);

    //try {
    var headers = await ApiServices.getHeaders();
    print(headers);
    final response = await http.patch(
      Uri.parse(
          ApiServices.baseUrl + ApiServices.updateManagement + contactId!),
      body: jsonEncode(requestBody),
      headers: headers,
    );
    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      (response.body);
      await _fetchData();

      _showSuccessDialog(context, "Employee  Updated");
      // clearTextFeilds();
    } else {
      Navigator.of(context).pop();
      _showErrorDialog(context);
      ('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context as BuildContext).size.height;
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
                  children: [
                    Flexible(
                      child: Container(
                        width: 240,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _handleSearch,
                          decoration: InputDecoration(
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
                    Spacer(),
                    Spacer(),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () async {
                            await createMasterList();
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
                width: screenWidth * 1.5,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      //columnSpacing: 305,
                      columnSpacing: 60,
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return SecureRiskColours
                            .Table_Heading_Color; // Use any color of your choice
                      }),
                      columns: [
                        buildDataColumn("S.no"),
                        buildDataColumn("Employee Id"),
                        buildDataColumn("Name"),
                        buildDataColumn("Email"),
                        buildDataColumn("Mobile"),
                        buildDataColumn("Designation"),
                        // buildDataColumn("Contact"),
                        buildDataColumn("Action")
                      ],
                      rows: [
                        ...contactList
                            .map((contact) => DataRow(cells: [
                                  DataCell(Text(
                                      (contactList.indexOf(contact) + 1)
                                          .toString())),
                                  DataCell(Text(contact.employeeId ?? "N/A")),
                                  DataCell(Text(contact.name ?? "N/A")),
                                  DataCell(Text(contact.email ?? "N/A")),
                                  DataCell(Text(contact.mobile ?? "N/A")),
                                  DataCell(Text(contact.designation ?? "N/A")),
                                  // DataCell(
                                  // Text(contact.contacts ?? "N/A")),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            print('Edit button pressed');
                                            _openEditDialog(contact.contactId);
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                        onPressed: () async {
                                          await deleteContact(
                                              contact.contactId.toString());
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

  void _handleFilterByChange(String? value) {}

  void _handleSearch(String value) {}
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
