import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/IntermediaryDetails/intermediary_insurer_list.dart';
import 'package:loginapp/Service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

class InsurerDataSource extends DataGridSource {
  final List<InsurerGridRow> insurerRows;
  BuildContext context;
  bool _isHovered1 = false;
  void Function() _fetchData;

  void Function(String? location) onLocationChanged;
  List<Location> _locationslist = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _openAddUserDialog(
    BuildContext context,
    Insurer insurer,
    void Function() _fetchData,
    void Function(String? location) onLocationChanged,
  ) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController managerNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    Location? selectedLocation;
    int? locationId;
    Set<Location> location = _locationslist.toSet();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                              'Add User',
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
                      margin: EdgeInsets.only(left: 15, right: 15),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          // Use regular expression to validate email address format
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          // You can add more validation logic here if needed.
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: TextFormField(
                        controller: managerNameController,
                        decoration: InputDecoration(
                          labelText: 'Manager Name',
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
                            return 'Please enter a manager name';
                          }
                          // You can add more validation logic here if needed.
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          // Use regular expression to validate 10-digit phone number
                          final phoneRegExp = RegExp(r'^\d{10}$');
                          if (!phoneRegExp.hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          // You can add more validation logic here if needed.
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: DropdownButtonFormField<Location>(
                        value: selectedLocation,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            locationId = newValue
                                .locationId; // Capture the locationId when a location is selected
                          }
                          onLocationChanged(newValue.toString());
                          selectedLocation = newValue;
                          (locationId);
                        },
                        items: location.toSet().map((location) {
                          return DropdownMenuItem<Location>(
                            value:
                                location, // Set the value to the entire Location object
                            child: Text(location.locationName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
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
                          if (value == null || value.locationName.isEmpty) {
                            return 'Please select a location';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered1 = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered1 = false;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 5, bottom: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: _isHovered1
                                ? Color.fromRGBO(
                                    199, 55, 125, 1.0) // Hovered color
                                : SecureRiskColours.Button_Color,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addUserToInsurer(
                                insurer.insurerId,
                                emailController.text,
                                managerNameController.text,
                                int.tryParse(phoneNumberController.text) ?? 0,
                                locationId,
                                context,
                                _fetchData,
                              );
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Submit',
                                style: GoogleFonts.poppins(
                                  color: _isHovered1
                                      ? Colors.white // Hovered color
                                      : Colors.white,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addUserToInsurer(
      String insurerid,
      String email,
      String managerName,
      int phoneNumber,
      int? location,
      BuildContext context,
      void Function() _fetchData) async {
    final Map<String, dynamic> requestBody = {
      'email': email,
      'managerName': managerName,
      'phoneNumber': phoneNumber,
      'location': location,
    };
    try {
      var headers = await ApiServices.getHeaders();
      print("********************************************Insurer id*********");
      print(insurerid);
      final response = await http.post(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.InsurerList_Adduser_EndPoint +
            "$insurerid"),
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

  Future<List<User>> fetchUsers(String id) async {
    ('Fetching users for ID: $id'); // Add this  statement
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.InsurerList_fetchuserList_EndPoint +
            "$id"),
        headers: headers);
    ('API Response: ${response.body}'); // Add this  statement

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(response.body) as List<dynamic>;
      ('Decoded JSON data: $jsonData');

      // Assuming the API response contains a list of users
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch data from the API');
    }
  }

  void openUsersDialog(
      BuildContext context,
      String id,
      void Function() fetchData,
      void Function(String?) onLocationChanged,
      String? _selectedLocation) {
    ('Dialog opened for ID: $id'); // Add this  statement

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FutureBuilder<List<User>>(
              future: fetchUsers(id),
              builder: (context, snapshot) {
                ('FutureBuilder - ConnectionState: ${snapshot.connectionState}'); // Add this  statement

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  ('Error: ${snapshot.error}'); // Add this  statement
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to fetch data from the API.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close'),
                      ),
                    ],
                  );
                } else if (snapshot.data == null) {
                  ('Data is null'); // Add this  statement
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('API returned null data.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close'),
                      ),
                    ],
                  );
                } else {
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(255, 233, 249, 251),
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Users'),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text('S.No',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          SecureRiskColours.table_Text_Color))),
                          DataColumn(
                              label: Text('User Name',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          SecureRiskColours.table_Text_Color))),
                          DataColumn(
                              label: Text('Email',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          SecureRiskColours.table_Text_Color))),
                          DataColumn(
                              label: Text('Phone Number',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          SecureRiskColours.table_Text_Color))),
                          DataColumn(
                              label: Text('Action',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          SecureRiskColours.table_Text_Color))),
                        ],
                        rows: snapshot.data!
                            .map(
                              (user) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      (snapshot.data!.indexOf(user) + 1)
                                          .toString())),
                                  DataCell(Text(user.managerName)),
                                  DataCell(Text(user.email)),
                                  DataCell(Text(user.phoneNumber.toString())),
                                  DataCell(
                                    Row(
                                      children: [
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _handleEditUser(
                                                user,
                                                context,
                                                onLocationChanged,
                                                _locationslist,
                                              );
                                            } else if (value == 'delete') {
                                              _handleDeleteUser(context,
                                                  user.userId, fetchData);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<String>>[
                                            PopupMenuItem<String>(
                                              value: 'edit',
                                              child: ListTile(
                                                leading: Icon(Icons.edit),
                                                title: Text('Edit'),
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: ListTile(
                                                leading: Icon(Icons.delete),
                                                title: Text('Delete'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  void _handleEditUser(User user, BuildContext context,
      void Function(String?) onLocationChanged, List<Location> _locations) {
    String usrId = user.userId;

    // Define the controllers for the input fields
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController managerNameController =
        TextEditingController(text: user.managerName);
    final TextEditingController phoneNumberController =
        TextEditingController(text: user.phoneNumber.toString());

    Location? selectedLocation;
    int? locationId;
    Set<Location> location = _locationslist.toSet();

    selectedLocation = _locations
        .firstWhere((location) => location.locationName == user.location);
    locationId = selectedLocation.locationId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 233, 249, 251),
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Edit User'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    }
                    // Use regular expression to validate email address format
                    final emailRegExp =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                    if (!emailRegExp.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    // You can add more validation logic here if needed.
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: managerNameController,
                  decoration: InputDecoration(labelText: 'Manager Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a manager name';
                    }
                    // You can add more validation logic here if needed.
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    // Use regular expression to validate 10-digit phone number
                    final phoneRegExp = RegExp(r'^\d{10}$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    // You can add more validation logic here if needed.
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<Location>(
                  value: selectedLocation,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      locationId = newValue
                          .locationId; // Capture the locationId when a location is selected
                    } else {
                      locationId = 0;
                    }
                    onLocationChanged(newValue.toString());
                    selectedLocation = newValue;
                    (locationId);
                  },
                  items: location.toSet().map((location) {
                    return DropdownMenuItem<Location>(
                      value:
                          location, // Set the value to the entire Location object
                      child: Text(location.locationName),
                    );
                  }).toList(),
                  decoration: InputDecoration(
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
                    if (value == null || value.locationName.isEmpty) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: SecureRiskColours.Button_Color),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final Map<String, dynamic> requestBody = {
                        "email": emailController.text,
                        "managerName": managerNameController.text,
                        "location": locationId,
                        "phoneNumber": phoneNumberController.text
                      };

                      try {
                        var headers = await ApiServices.getHeaders();
                        final response = await http.put(
                          Uri.parse(ApiServices.baseUrl +
                              ApiServices.InsurerList_editUser_EndPoint +
                              "$usrId"),
                          body: jsonEncode(requestBody),
                          headers: headers,
                        );
                        Navigator.of(context).pop();
                        if (response.statusCode == 200) {
                          (response.body);
                          // fetchUsers(userId);

                          Navigator.of(context).pop();
                          _showSuccessDialog(context, "User updated");
                        } else {
                          Navigator.of(context).pop();
                          _showErrorDialog(context);
                          ('Error: ${response.statusCode}');
                        }
                      } catch (exception) {
                        ('Exception: $exception');
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleDeleteUser(
      BuildContext context, String userId, void Function() _fetchData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
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
                      ApiServices.InsurerList_deleteUser_EndPoint +
                      "$userId"),
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
                              Navigator.of(context).pop();
                              // Fetch the updated data
                              _fetchData();
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
                              Navigator.of(context).pop();
                              _fetchData();
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

  void _handleEditInsurer(
      BuildContext context,
      Insurer insurer,
      void Function() _fetch,
      void Function(String?) onLocationChanged,
      List<Location> _locations) {
    // Access the insurerId

    String insId = insurer.insurerId;
    Location? selectedLocation;
    int? locationId;
    Set<Location> location = _locationslist.toSet();

    // Define the controllers for the input fields
    final TextEditingController nameController =
        TextEditingController(text: insurer.insurerName);
    // Fetch the user names from the API

    selectedLocation = _locations
        .firstWhere((location) => location.locationName == insurer.location);
    locationId = selectedLocation.locationId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Insurer Name',
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
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: DropdownButtonFormField<Location>(
                        value: selectedLocation,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            locationId = newValue.locationId;
                            selectedLocation = newValue;
                            // Capture the locationId when a location is selected
                          }
                          onLocationChanged(newValue.toString());
                          selectedLocation = newValue;
                          (locationId);
                        },
                        items: location.toSet().map((location) {
                          return DropdownMenuItem<Location>(
                            value:
                                location, // Set the value to the entire Location object
                            child: Text(location.locationName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
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
                          if (value == null || value.locationName.isEmpty) {
                            return 'Please select a location';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered1 = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered1 = false;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 5, bottom: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: _isHovered1
                                ? Color.fromRGBO(
                                    199, 55, 125, 1.0) // Hovered color
                                : SecureRiskColours.Button_Color,
                          ),
                          onPressed: () async {
                            final Map<String, dynamic> requestBody = {
                              "insurerName": nameController.text,
                              "location": locationId,
                            };

                            try {
                              var headers = await ApiServices.getHeaders();
                              final response = await http.put(
                                Uri.parse(ApiServices.baseUrl +
                                    ApiServices
                                        .InsurerList_editInsurer_EndPoint +
                                    "$insId"),
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
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              color: _isHovered1
                                  ? Colors.white // Hovered color
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleDeleteInsurer(
      BuildContext context, String insurerId, void Function() _fetch) {
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
                      ApiServices.InsurerList_deleteInsurer_EndPoint +
                      "$insurerId"),
                  headers: headers,
                );
                bool isDeleted = false;
                if (response.statusCode == 200) {
                  isDeleted = true;
                  _fetch();
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

  InsurerDataSource(List<Insurer> insurers, this.context, this._fetchData,
      this.onLocationChanged, this._locationslist)
      : insurerRows = insurers
            .map((insurer) => InsurerGridRow(
                  insurer,
                  DataGridRow(
                    cells: [
                      DataGridCell<String>(
                          columnName: 'S.No',
                          // value: insurer.insurerId,
                          value: (insurers.indexOf(insurer) + 1).toString()),
                      DataGridCell<String>(
                        columnName: 'insurerName',
                        value: insurer.insurerName,
                      ),
                      DataGridCell<String>(
                        columnName: 'location',
                        value: insurer.location,
                      ),
                      DataGridCell<String>(
                          columnName: 'usersCount',
                          value: (insurer.listOfUsers.length.toString())),
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
    final Insurer insurer = insurerRow.insurer;

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
                  child: Text('Add User', style: GoogleFonts.poppins()),
                  value: 'addUser',
                ),
                PopupMenuItem<String>(
                  child: Text('Delete', style: GoogleFonts.poppins()),
                  value: 'delete',
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _handleEditInsurer(context, insurer, _fetchData,
                      onLocationChanged, _locationslist);
                } else if (value == 'addUser') {
                  _openAddUserDialog(
                      context, insurer, _fetchData, onLocationChanged);
                } else if (value == 'delete') {
                  _handleDeleteInsurer(context, insurer.insurerId, _fetchData);
                }
              },
            ),
          );
        } else if (dataCell.columnName == 'insurerName') {
          return GestureDetector(
            onTap: () {
              ("hi");
              // Pass the CoverageNames list to the openUsersDialog method
              openUsersDialog(context, insurer.insurerId, _fetchData,
                  onLocationChanged, insurer.location);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                dataCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                // style: GoogleFonts.poppins(color: Colors.green),
              ),
            ),
          );
        } else if (dataCell.columnName == 'usersCount') {
          return GestureDetector(
            onTap: () {
              ("hi");
              // Pass the CoverageNames list to the openUsersDialog method
              openUsersDialog(context, insurer.insurerId, _fetchData,
                  onLocationChanged, insurer.location);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                dataCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                // style: GoogleFonts.poppins(color: Colors.green),
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
            ),
          );
        }
      }).toList(),
    );
  }
}
