import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Department/CreateDepartment.dart';
import 'package:loginapp/Service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

class DepartmentListDataSource extends DataGridSource {
  final List<InsurerGridRow> insurerRows;
  BuildContext context;
  void Function() _fetchData;
  void Function(String? department) onDepratmentChanged;
  void Function(String? designation) onDesignationChanged;
  void Function(String? location) onLocationChanged;
  void Function(String? gender) onGenderChanged;

  String? selecteddepartment;
  String? selecteddesignation;
  String? selectedLocation;
  String? selectedGender;

  List<Location> _locationslist = [];
  List<Designation> _designationlist = [];
  List<Department> _departmentlist = [];
  List<String> _genderlist = ['Male', 'Female'];

  String? startPeriodError = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _openAddUserDialog(
    BuildContext context,
    Client client,
    void Function() _fetchData,
    void Function(String? designation) onDesignationChanged,
  ) {
    final TextEditingController corporateNameController =
        TextEditingController();
    final TextEditingController businessTypeController =
        TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController empIdController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Department? selecteddepartment;
    Designation? selecteddesignation;
    Location? selectedLocation;
    String? selectedGender;
    Set<Department> department = _departmentlist.toSet();
    Set<Designation> designation = _designationlist.toSet();
    int? locationId;
    int? departmentId;
    int? desinationId;
    Set<Location> location = _locationslist.toSet();
    Set<String> gend = _genderlist.toSet();

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

                // Wrap the form fields with Form widget
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
                              'Create User',
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
                              controller: corporateNameController,
                              decoration: InputDecoration(
                                labelText: 'Corporate Name',
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
                              controller: businessTypeController,
                              decoration: InputDecoration(
                                labelText: 'Business Type',
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
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
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
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
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
                              controller: empIdController,
                              decoration: InputDecoration(
                                labelText: 'Employee Id',
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
                                onDepratmentChanged(newValue.toString());
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
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
                                onDesignationChanged(newValue.toString());
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
                            child: DropdownButtonFormField<Location>(
                              value: selectedLocation,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  locationId = newValue
                                      .locationId; // Capture the locationId when a location is selected
                                }
                                onLocationChanged(newValue.toString());
                                selectedLocation = newValue;
                              },
                              items: location.toSet().map((location) {
                                return DropdownMenuItem<Location>(
                                  value:
                                      location, // Set the value to the entire Location object
                                  child: Text(location.locationName),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: 'Location',
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
                                    value.locationName.isEmpty) {
                                  return 'Please select a location';
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            width: 300,
                            height: 40,
                            margin: EdgeInsets.only(left: 12, right: 12),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Material(
                                shadowColor: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                child: TextFormField(
                                  controller: dateController,
                                  readOnly: true, // Prevents manual text input
                                  decoration: InputDecoration(
                                    hintText: 'Start Date',
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
                                          dateController.text = formattedDate;
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
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
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
                                  return 'Please enter a Age';
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
                            child: DropdownButtonFormField<String>(
                              value: selectedGender,
                              onChanged: (newValue) {
                                onGenderChanged(newValue);
                                selectedGender = newValue;
                              },
                              items: gend.toSet().map((gender) {
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
                                // errorText: _errorText, // Display the error text if validation fails
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a gender';
                                }
                                // You can add more validation logic here if needed.
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
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
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
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Password';
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
                            addUserToClient(
                              corporateNameController.text,
                              businessTypeController.text,
                              firstNameController.text,
                              lastNameController.text,
                              empIdController.text,
                              selecteddepartment!.departmentName,
                              selecteddesignation!.designationName,
                              selectedLocation!.locationName,
                              dateController.text,
                              ageController.text,
                              selectedGender,
                              emailController.text,
                              int.tryParse(phoneNumberController.text) ?? 0,
                              passwordController.text,
                              locationId,
                              desinationId,
                              departmentId,
                              context,
                              _fetchData,
                              client.locationId,
                            );
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

  Future<void> addUserToClient(
    String? corporateNameController,
    String? businessTypeController,
    String firstNameController,
    String lastNameController,
    String empIdController,
    String? department,
    String? designation,
    String? location,
    String? dateController,
    String ageController,
    String? gender,
    String emailController,
    int phoneNumber,
    String passwordController,
    int? locationId,
    int? designationId,
    int? departmentId,
    BuildContext context,
    void Function() _fetchData,
    int cid,
  ) async {
    ("api call made");
    final Map<String, dynamic> requestBody = {
      "corporateName": corporateNameController,
      "businessType": businessTypeController,
      "firstName": firstNameController,
      "lastName": lastNameController,
      "employeeId": empIdController,
      "dateOfBirth": "1998-08-28",
      "age": ageController,
      "gender": gender,
      "email": emailController,
      "phoneNo": phoneNumber,
      "password": passwordController,
    };
    (requestBody);
    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.post(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.Location_add_user +
            "locationId=$locationId&designationId=$designationId&departmentId=$departmentId"),
        body: jsonEncode(requestBody),
        headers: headers,
      );

      if (response.statusCode == 201) {
        (response.body);
        _fetchData();
        Navigator.of(context).pop();
        _showSuccessDialog(context, "User Added");
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
          title: Text('Success'),
          content: Text('$operation successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
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
          title: Text('Error'),
          content: Text('Failed to perform the operation.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _handleEditCreateLocation(
      BuildContext context,
      Client client,
      void Function() _fetch,
      void Function(String? location) onLocationChanged,
      List<Location> _locations) {
    // Access the insurerId
    int insurerId = client.locationId;

    // Define the controllers for the input fields
    final TextEditingController nameController =
        TextEditingController(text: client.locationName);
    // Fetch the user names from the API

    // Initial value for the dropdown
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                width: 340,
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
                        'Edit Insurer',
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
              SizedBox(height: 20),
              Container(
                height: 45,
                margin: EdgeInsets.only(left: 12, right: 12),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Client Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 128, 128, 128),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: SecureRiskColours.Button_Color,
                  ),
                  onPressed: () async {
                    final Map<String, dynamic> requestBody = {
                      "locationName": nameController.text,
                    };
                    (insurerId);
                    try {
                      var headers = await ApiServices.getHeaders();
                      final response = await http.put(
                        Uri.parse(ApiServices.baseUrl +
                            ApiServices.Location_Edit +
                            "$insurerId"),
                        body: jsonEncode(requestBody),
                        headers: headers,
                      );

                      if (response.statusCode == 200) {
                        (response.body);

                        Navigator.of(context).pop();
                        _showSuccessDialog(context, "Insurer updated");
                      } else {
                        Navigator.of(context).pop();
                        _showErrorDialog(context);
                        ('Error: ${response.statusCode} ${response.body}');
                      }
                    } catch (exception) {
                      ('Exception: $exception');
                    }

                    _fetch();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleDeleteCreateLocation(
      BuildContext context, int cid, void Function() _fetch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this insurer?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog when the user selects No
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                var headers = await ApiServices.getHeaders();
                final response = await http.delete(
                  Uri.parse(ApiServices.baseUrl +
                      ApiServices.Delete_location +
                      "$cid"),
                  headers: headers,
                );
                bool isDeleted = false;
                if (response.statusCode == 200) {
                  isDeleted = true;
                }

                Navigator.of(context).pop();

                if (isDeleted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Deleted Successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the success dialog
                              Navigator.of(context).pop();

                              // Fetch the updated data
                              _fetch();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show an error message if the deletion was not successful
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to delete insurer.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the error dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  DepartmentListDataSource(
      List<Client> client,
      this.context,
      this._fetchData,
      this.onDepratmentChanged,
      this._departmentlist,
      this.onDesignationChanged,
      this._designationlist,
      this.onLocationChanged,
      this._locationslist,
      this.onGenderChanged,
      this._genderlist)
      : insurerRows = client
            .map((insurer) => InsurerGridRow(
                  insurer,
                  DataGridRow(
                    cells: [
                      DataGridCell<String>(
                          columnName: 'S.No',
                          // value: insurer.insurerId,
                          value: (client.indexOf(insurer) + 1).toString()),
                      DataGridCell<String>(
                          columnName: 'locationName',
                          // value: insurer.insurerId,
                          value: (insurer.locationName.toString())),
                      DataGridCell<int>(
                        columnName: 'user',
                        value: insurer.user,
                      ),
                      DataGridCell<String>(columnName: 'Actions', value: ''),
                    ],
                  ),
                ))
            .toList();

  @override
  List<DataGridRow> get rows =>
      insurerRows.map((employeeRow) => employeeRow.row).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final rowIndex = rows.indexOf(row);
    final InsurerGridRow insurerRow = insurerRows[rowIndex];
    final Client insurer = insurerRow.insurer;
    ("hii");
    //(insurer.insurerId);
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'Actions') {
          return Container(
            alignment: Alignment.center,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  child: Text(
                    'Edit',
                    style: GoogleFonts.poppins(),
                  ),
                  value: 'edit',
                ),
                PopupMenuItem<String>(
                  child: Text(
                    'Create User',
                    style: GoogleFonts.poppins(),
                  ),
                  value: 'CreateUser',
                ),
                PopupMenuItem<String>(
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(),
                  ),
                  value: 'delete',
                ),
              ],
              onSelected: (value) {
                (insurer);
                if (value == 'edit') {
                  _handleEditCreateLocation(context, insurer, _fetchData,
                      onLocationChanged, _locationslist);
                } else if (value == 'CreateUser') {
                  _openAddUserDialog(
                      context, insurer, _fetchData, onDesignationChanged);
                } else if (value == 'delete') {
                  _handleDeleteCreateLocation(
                      context, insurer.locationId, _fetchData);
                }
              },
            ),
          );
        } else if (dataCell.columnName == 'users') {
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                dataCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(color: Colors.green),
              ),
            ),
          );
        } else if (dataCell.columnName == 'clientName') {
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                dataCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(color: Colors.green),
              ),
            ),
          );
        } else if (dataCell.columnName == 'products') {
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                dataCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(color: Colors.green),
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              dataCell.value.toString(),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(),
            ),
          );
        }
      }).toList(),
    );
  }
}
