import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/ClientList/ActiveClientList.dart';
import 'package:loginapp/ClientList/ClientListDashboard/Productsdashboard.dart';
import 'package:loginapp/Colours.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

import '../Service.dart';

class ClientListDataSource extends DataGridSource {
  final List<InsurerGridRow> insurerRows;
  bool _isHovered1 = false;
  BuildContext context;
  void Function() _fetchData;
  void Function(String? designation) onDesignationChanged;
  void Function(String? location) onLocationChanged;
  void Function(String? productType) onProductTypeChanged;
  void Function(String? insurance) onInsuranceCompanyChanged;
  void Function(String? tpa) onTpaChanged;
  void Function(String? policyType) onPolicyTypeChanged;

  List<String> PolicyTypeList = ['Regular', 'TopUp', 'Self', '1+3', 'Parents'];

  List<ProductType> _ProductsList = [];
  List<Location> _locationslist = [];
  List<InsuranceCompany> _InsurenceCompanyList = [];
  List<Desigantion> _designationList = [];
  List<Tpa> _tpaList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _openAddUserDialog(
    BuildContext context,
    Client insurer,
    void Function() _fetchData,
    void Function(String? designation) onDesignationChanged,
  ) {
    final TextEditingController empidController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    Desigantion? selecteddesignation;
    int? designationId;
    Set<Desigantion> designation = _designationList.toSet();
    // bool _isHovered1 = false;
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
              // Wrap the form fields with Form widget
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: 400,
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
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      controller: empidController,
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
                        String trimmedText = value.toString().trim();
                        if (trimmedText == null || trimmedText.isEmpty) {
                          return 'Please enter a employee id';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
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
                      validator: (value) {
                        String trimmedText = value.toString().trim();
                        if (trimmedText == null || trimmedText.isEmpty) {
                          return 'Please enter a name';
                        }
                        // You can add more validation logic here if needed.
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: DropdownButtonFormField<Desigantion>(
                      value: selecteddesignation,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          designationId = newValue.id;
                        }
                        onDesignationChanged(newValue.toString());
                        selecteddesignation = newValue;
                        (designationId);
                      },
                      items: designation.toSet().map((designation) {
                        return DropdownMenuItem<Desigantion>(
                          value: designation,
                          child: Text(designation.designationName),
                        );
                      }).toList(),
                      decoration: InputDecoration(
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
                          return 'Please select a Desigantion';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Id',
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
                    margin: EdgeInsets.only(left: 12, right: 12),
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
                  SizedBox(height: 8),
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
                            ("passed if");
                            addUserToClient(
                              empidController.text,
                              nameController.text,
                              designationId,
                              emailController.text,
                              int.tryParse(phoneNumberController.text) ?? 0,
                              context,
                              _fetchData,
                              insurer.clientId,
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Create',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _isHovered1
                                  ? Colors.white // Hovered color
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> addUserToClient(
    String empId,
    String name,
    int? designationId,
    String mailId,
    int phoneNumber,
    BuildContext context,
    void Function() _fetchData,
    int cid,
  ) async {
    final Map<String, dynamic> requestBody = {
      'employeeId': empId,
      'name': name,
      'designationId': designationId,
      'mailId': mailId,
      'phoneNo': phoneNumber,
    };

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.post(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.ClientList_adduser_EndPoint +
            "/$cid"),
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

  Future<List<User>> fetchUsers(int id) async {
    ('Fetching users for ID: $id'); // Add this  statement

    (id);
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.ClientList_fetchuserList_EndPoint +
            "/$id"),
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

  Future<List<Product>> fetchProducts(int id) async {
    ('Fetching users for ID: $id'); // Add this  statement

    (id);
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.ClientList_fetchproductList_EndPoint +
            "/$id"),
        headers: headers);
    ('API Response: ${response.body}'); // Add this  statement

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
          json.decode(response.body) as List<dynamic>;
      ('Decoded JSON data: $jsonData');

      // Assuming the API response contains a list of users
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch data from the API');
    }
  }

  void openProductsDialogwithColumns(
      BuildContext context,
      int clientId,
      void Function() fetchData,
      // void Function() clientId,
      void Function(String?) onDesi,
      String? _designation) {
    ('Dialog opened for ID: $clientId');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FutureBuilder<List<Product>>(
              future: fetchProducts(clientId),
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
                    contentPadding: EdgeInsets.zero,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: SecureRiskColours.Table_Heading_Color,
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Products',
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
                          SingleChildScrollView(
                            child: DataTable(
                              headingRowColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return Color.fromARGB(31, 187, 213,
                                    219); // Use any color of your choice
                              }),
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'S.No',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Product',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Policy Type',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'TPA List',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Insurance Company',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Actions',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                              rows: snapshot.data!
                                  .map(
                                    (product) => DataRow(
                                      cells: [
                                        DataCell(Text(
                                            (snapshot.data!.indexOf(product) +
                                                    1)
                                                .toString())),
                                        DataCell(Text(product.productName)),
                                        DataCell(Text(product.policyType)),
                                        DataCell(Text(product.tpaId)),
                                        DataCell(
                                            Text(product.insurerCompanyId)),
                                        DataCell(
                                          Row(
                                            children: [
                                              PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  if (value == 'edit') {
                                                    _handleEditProduct(
                                                        clientId,
                                                        context,
                                                        onProductTypeChanged,
                                                        _ProductsList,
                                                        onPolicyTypeChanged,
                                                        PolicyTypeList,
                                                        onTpaChanged,
                                                        _tpaList,
                                                        onInsuranceCompanyChanged,
                                                        _InsurenceCompanyList,
                                                        fetchData,
                                                        product);
                                                  } else if (value ==
                                                      'delete') {
                                                    _handleDeleteProductList(
                                                        context,
                                                        product.productId,
                                                        clientId,
                                                        // product.clientId,
                                                        fetchData);
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
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
                                                      leading:
                                                          Icon(Icons.delete),
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
                        ],
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

  ///Client list Dashboard*********************
  void openProductsDialog(
    BuildContext context,
    int clientId,
    void Function() fetchData,
    void Function(String?) onDesi,
    String? _designation,
    String clientNameVar,
  ) {
    ('Dialog opened for ID: $clientId'); // Add this  statement
    //  int productIdvar;
    String productNameVar;
    String productIdvar;
    int productCategoryIdvar;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FutureBuilder<List<Product>>(
              future: fetchProducts(clientId),
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
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  ('Data is null or empty'); // Add this  statement
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('API returned null or empty data.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close'),
                      ),
                    ],
                  );
                } else {
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
                                  'Products',
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
                        // SizedBox(height: 20),
                        SingleChildScrollView(
                          child: Column(
                            children: snapshot.data!.map((item) {
                              return Column(

                                
                                  children: [
                                    ListTile(
                                      trailing: Text(">",
                                          style: GoogleFonts.poppins(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500)),
                                      title:
                                          Text(item.productName),
                                      focusColor: Colors.grey,
                                      onTap: () {                                       
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              Dashboard(productNameVar:item.productName,productIdvar:item.productId,clientId:clientId,clientNameVar:clientNameVar,tpaNameVar :item.tpaId,insuranceCompanyVar:item.insurerCompanyId)),                                                
                                        );
                                      },
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 1.0,
                                    ),
                                  ]);
                            }).toList(),
                          ),
                        ),
                      ],
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

  void openUsersDialog(
      BuildContext context,
      int clientId,
      void Function() fetchData,
      void Function(String?) onDesi,
      String? _designation) {
    ('Dialog opened for ID: $clientId'); // Add this  statement

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FutureBuilder<List<User>>(
              future: fetchUsers(clientId),
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
                          DataColumn(label: Text('S.No')),
                          DataColumn(label: Text('EmployeeId Id')),
                          DataColumn(label: Text('User Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Phone Number')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: snapshot.data!
                            .map(
                              (user) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      (snapshot.data!.indexOf(user) + 1)
                                          .toString())),
                                  DataCell(Text(user.employeeId)),
                                  DataCell(Text(user.name)),
                                  DataCell(Text(user.mailId)),
                                  DataCell(Text(user.phoneNo)),
                                  DataCell(
                                    Row(
                                      children: [
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _handleEditUser(
                                                clientId,
                                                user,
                                                context,
                                                onDesignationChanged,
                                                _designationList,
                                              );
                                            } else if (value == 'delete') {
                                              _handleDeleteUser(
                                                  context, user.uid, fetchData);
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

  void _handleEditUser(
      int clientId,
      User user,
      BuildContext context,
      void Function(String?) onDesignationChanged,
      List<Desigantion> _designation) {
    int userId = user.uid;

    final TextEditingController empidController =
        TextEditingController(text: user.employeeId);
    final TextEditingController managerNameController =
        TextEditingController(text: user.name);
    final TextEditingController emailController =
        TextEditingController(text: user.mailId);
    final TextEditingController phoneNumberController =
        TextEditingController(text: user.phoneNo.toString());

    Desigantion? selecteddesignation;
    int? designationId;
    Set<Desigantion> designation = _designationList.toSet();

    selecteddesignation = _designation.firstWhere(
        (designation) => designation.designationName == user.designation);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              color: SecureRiskColours.Button_Color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create User'),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: empidController,
                  decoration: InputDecoration(labelText: 'Employee Id'),
                  validator: (value) {
                    String trimmedText = value.toString().trim();
                    if (trimmedText == null || trimmedText.isEmpty) {
                      return 'Please enter a Employee Id';
                    }
                    // You can add more validation logic here if needed.
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: managerNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    String trimmedText = value.toString().trim();
                    if (trimmedText == null || trimmedText.isEmpty) {
                      return 'Please enter a name';
                    }
                    // You can add more validation logic here if needed.
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<Desigantion>(
                  value: selecteddesignation,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      designationId = newValue.id;
                      // Capture the locationId when a location is selected
                    }
                    onDesignationChanged(newValue.toString());
                    selecteddesignation = newValue;
                    (designationId);
                  },
                  items: designation.toSet().map((designation) {
                    return DropdownMenuItem<Desigantion>(
                      value:
                          designation, // Set the value to the entire Location object
                      child: Text(designation.designationName),
                    );
                  }).toList(),
                  decoration: InputDecoration(
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
                      return 'Please select a designationName';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor:
                        Color.fromRGBO(199, 55, 125, 1.0) // Hovered color
                    ,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final Map<String, dynamic> requestBody = {
                        "employeeId": empidController.text,
                        "name": managerNameController.text,
                        "designation": designationId,
                        "mailId": emailController.text,
                        "phoneNo": phoneNumberController.text
                      };
                      try {
                        var headers = await ApiServices.getHeaders();
                        final response = await http.put(
                          Uri.parse(ApiServices.baseUrl +
                              ApiServices.ClientList_edituserList_EndPoint +
                              "/$userId"),
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
                      // openUsersDialog(context, userId);
                      // Close the dialog

                      // Fetch the updated data
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleDeleteUser(
      BuildContext context, int userId, void Function() _fetchData) {
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
                      ApiServices.ClientList_deleteuser_EndPoint +
                      "/$userId"),
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

  void _handleEditClient(
      BuildContext context,
      Client insurer,
      void Function() _fetch,
      void Function(String? location) onLocationChanged,
      List<Location> _locations) {
    int insurerId = insurer.clientId;
    Location? selectedLocation;
    int? locationId;

    final TextEditingController nameController =
        TextEditingController(text: insurer.clientName);

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
                            'Edit Client',
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
                    child: Container(
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
                  ),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: DropdownButtonFormField<Location>(
                        value: selectedLocation ?? _locations.first,
                        // Set the initially selected location

                        onChanged: (newValue) {
                          if (newValue != null) {
                            locationId = newValue
                                .locationId; // Capture the locationId when a location is selected
                          }
                          onLocationChanged(newValue
                              ?.locationName); // Passing locationName instead of toString
                          selectedLocation = newValue;
                          (locationId);
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem<Location>(
                            value: location,
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
                      )),
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
                              "clientName": nameController.text,
                              "location": locationId,
                            };
                            (insurerId);
                            try {
                              var headers = await ApiServices.getHeaders();
                              final response = await http.put(
                                Uri.parse(ApiServices.baseUrl +
                                    ApiServices.ClientList_editclient_EndPoint +
                                    "/$insurerId"),
                                body: jsonEncode(requestBody),
                                headers: headers,
                              );

                              if (response.statusCode == 200) {
                                (response.body);

                                Navigator.of(context).pop();
                                _showSuccessDialog(context, "Client updated");
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
                            'Update',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _isHovered1 ? Colors.white : Colors.white,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleDeleteClient(
      BuildContext context, int cid, void Function() _fetch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: GoogleFonts.poppins(),
          ),
          content: Text('Are you sure you want to delete this Client',
              style: GoogleFonts.poppins()),
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
                      ApiServices.ClientList_deleteclient_EndPoint +
                      "/$cid"),
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

  void _handleEditProduct(
      int? prdId,
      BuildContext context,
      void Function(String? productType) onProductTypeChanged,
      List<ProductType> _productType,
      void Function(String? policyType) onPolicyTypeChanged,
      List<String> _policyType,
      void Function(String? tpa) onTpaChanged,
      List<Tpa> _tpa,
      void Function(String? insurance) onInsuranceCompanyChanged,
      List<InsuranceCompany> _InsurenceCompanyList,
      _fetchData,
      Product product) async {
    ProductType? selectedProductType;
    int? productId;
    Set<ProductType> productType = _ProductsList.toSet();

    InsuranceCompany? selectedInsuranceCompany;
    String? insurerId;
    Set<InsuranceCompany> insuranceCompany = _InsurenceCompanyList.toSet();

    String? selectedPolicyType;
    Set<String> policyTypelist = PolicyTypeList.toSet();

    Tpa? selectedTpa;
    int? tpaId;
    Set<Tpa> tpaType = _tpaList.toSet();

    selectedProductType = _productType.firstWhere(
        (productType) => productType.productName == product.productName);

    selectedInsuranceCompany = _InsurenceCompanyList.firstWhere(
        (insurenceCompany) =>
            insurenceCompany.insurerName == product.insurerCompanyId);
    insurerId = selectedInsuranceCompany.insurerId;

    if (selectedPolicyType == null)
      selectedPolicyType = _policyType
          .firstWhere((policyType) => policyType == product.policyType);

    if (selectedTpa == null)
      selectedTpa = _tpa.firstWhere((tpa) => tpa.tpaName == product.tpaId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              title: Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  color: SecureRiskColours.Table_Heading_Color,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Create Product',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                      child: DropdownButtonFormField<ProductType>(
                        value: selectedProductType,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            productId = newValue.productId;
                          }
                          onProductTypeChanged(newValue.toString());
                          setState(() {
                            selectedProductType = newValue;
                          });
                          (productId);
                        },
                        items: productType.toSet().map((productType) {
                          return DropdownMenuItem<ProductType>(
                            value:
                                productType, // Set the value to the entire Location object
                            child: Text(productType.productName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Product Type',
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
                          if (value == null || value.productName.isEmpty) {
                            return 'Please select a ProductType';
                          }
                          return null;
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Health Insurance (GHI)",
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: DropdownButtonFormField<String>(
                          value: selectedPolicyType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPolicyType = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Policy Type',
                            border: OutlineInputBorder(),
                          ),
                          items: policyTypelist
                              .toSet()
                              .map<DropdownMenuItem<String>>(
                            (String policyType) {
                              return DropdownMenuItem<String>(
                                value: policyType,
                                child: Text(policyType),
                              );
                            },
                          ).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a policyType';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    //SizedBox(height: 10),
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Health Insurance (GHI)",
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: DropdownButtonFormField<Tpa>(
                          value: selectedTpa,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              tpaId = newValue.tpaId;
                            }
                            onTpaChanged(newValue.toString());
                            setState(() {
                              selectedTpa = newValue;
                            });
                          },
                          items: tpaType.map((tpa) {
                            return DropdownMenuItem<Tpa>(
                              value: tpa,
                              child: Text(tpa.tpaName),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'TPA',
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
                            if (value == null || value.tpaName.isEmpty) {
                              return 'Please select a TPA';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    //SizedBox(height: 10),
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Personal Accident (GPA)",
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: DropdownButtonFormField<String>(
                          value: selectedPolicyType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPolicyType = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Policy Type',
                            border: OutlineInputBorder(),
                          ),
                          items: policyTypelist
                              .toSet()
                              .map<DropdownMenuItem<String>>(
                            (String policyType) {
                              return DropdownMenuItem<String>(
                                value: policyType,
                                child: Text(policyType),
                              );
                            },
                          ).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a policyType';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                      child: DropdownButtonFormField<InsuranceCompany>(
                        value: selectedInsuranceCompany,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            insurerId = newValue.insurerId;
                            // Capture the locationId when a location is selected
                          }
                          onInsuranceCompanyChanged(newValue.toString());
                          selectedInsuranceCompany = newValue;
                          (insurerId);
                        },
                        items: insuranceCompany.toSet().map((insuranceCompany) {
                          return DropdownMenuItem<InsuranceCompany>(
                            value:
                                insuranceCompany, // Set the value to the entire Location object
                            child: Text(insuranceCompany.insurerName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'InsuranceCompany',
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
                          if (value == null || value.insurerName.isEmpty) {
                            return 'Please select a InsuranceCompany';
                          }
                          return null;
                        },
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: Color.fromRGBO(
                                199, 55, 125, 1.0) // Hovered color
                            ,
                          ),
                          onPressed: () async {
                            final Map<String, dynamic> requestBody = {
                              "productId": productId,
                              "insurerCompanyId": insurerId,
                              "policyType": selectedPolicyType,
                              "tpaId": tpaId,
                            };
                            (insurerId);
                            try {
                              var headers = await ApiServices.getHeaders();
                              final response = await http.patch(
                                Uri.parse(ApiServices.baseUrl +
                                    ApiServices
                                        .ClientList_editproduct_EndPoint +
                                    "$prdId"),
                                body: jsonEncode(requestBody),
                                headers: headers,
                              );
                              Navigator.of(context).pop();
                              if (response.statusCode == 200) {
                                (response.body);
                                _fetchData();
                                Navigator.of(context).pop();
                                _showSuccessDialog(context, "Product updated");
                              } else {
                                Navigator.of(context).pop();
                                _showErrorDialog(context);
                                ('Error: ${response.statusCode} ${response.body}');
                              }
                            } catch (exception) {
                              ('Exception: $exception');
                            }
                          },
                          child: Text('Update'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleDeleteProductList(BuildContext context, String productId,
      clientId, void Function() _fetchData) {

        String cid = clientId;
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
                      ApiServices.ClientList_deleteproduct_EndPoint +
                      "?" +
                      "productId=" +
                      productId +
                      "&" +
                      "clientListId=" +
                      cid),
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

  void _handleAddProduct(
      int? clientId,
      BuildContext context,
      void Function(String? productType) onProductTypeChanged,
      List<ProductType> _productType,
      void Function(String? policyType) onPolicyTypeChanged,
      List<String> _policyType,
      void Function(String? tpa) onTpaChanged,
      List<Tpa> _tpa,
      void Function(String? insurance) onInsuranceCompanyChanged,
      List<InsuranceCompany> _InsurenceCompanyList,
      _fetch) {
    ProductType? selectedProductType;
    int? productId;
    Set<ProductType> productType = _ProductsList.toSet();

    InsuranceCompany? selectedInsuranceCompany;
    String? insurerId;
    Set<InsuranceCompany> insuranceCompany = _InsurenceCompanyList.toSet();

    String? selectedPolicyType;
    Set<String> policyTypelist = PolicyTypeList.toSet();

    Tpa? selectedTpa;
    int? tpaId = 0;
    Set<Tpa> tpaType = _tpaList.toSet();
    String? tpaIdlist;
    bool _isHovered1 = false;

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
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
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
                              'Create Product',
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
                    // SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                      child: DropdownButtonFormField<ProductType>(
                        value: selectedProductType,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            productId = newValue.productId;
                          }
                          onProductTypeChanged(newValue.toString());
                          setState(() {
                            selectedProductType = newValue;
                          });
                          (productId);
                        },
                        items: productType.toSet().map((productType) {
                          return DropdownMenuItem<ProductType>(
                            value:
                                productType, // Set the value to the entire Location object
                            child: Text(productType.productName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'ProductType',
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
                          if (value == null || value.productName.isEmpty) {
                            return 'Please select a ProductType';
                          }
                          return null;
                        },
                      ),
                    ),
                    // SizedBox(height: 10),
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Health Insurance (GHI)",
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: DropdownButtonFormField<String>(
                          value: selectedPolicyType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPolicyType = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Policy Type',
                            border: OutlineInputBorder(),
                          ),
                          items: policyTypelist
                              .toSet()
                              .map<DropdownMenuItem<String>>(
                            (String policyType) {
                              return DropdownMenuItem<String>(
                                value: policyType,
                                child: Text(policyType),
                              );
                            },
                          ).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a policyType';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    //SizedBox(height: 10),
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Health Insurance (GHI)",
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: DropdownButtonFormField<Tpa>(
                          value: selectedTpa,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              tpaId = newValue.tpaId;
                            }
                            onTpaChanged(newValue.toString());
                            setState(() {
                              selectedTpa = newValue;
                            });
                          },
                          items: tpaType.toSet().map((tpa) {
                            return DropdownMenuItem<Tpa>(
                              value:
                                  tpa, // Set the value to the entire Location object
                              child: Text(tpa.tpaName),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'TPA',
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
                            if (value == null || value.tpaName.isEmpty) {
                              return 'Please select a TPA';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Personal Accident (GPA)",
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: DropdownButtonFormField<String>(
                          value: selectedPolicyType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPolicyType = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Policy Type',
                            border: OutlineInputBorder(),
                          ),
                          items: policyTypelist
                              .toSet()
                              .map<DropdownMenuItem<String>>(
                            (String policyType) {
                              return DropdownMenuItem<String>(
                                value: policyType,
                                child: Text(policyType),
                              );
                            },
                          ).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a policyType';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    //SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                      child: DropdownButtonFormField<InsuranceCompany>(
                        value: selectedInsuranceCompany,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            insurerId = newValue.insurerId;
                            // Capture the locationId when a location is selected
                          }
                          onInsuranceCompanyChanged(newValue.toString());
                          selectedInsuranceCompany = newValue;
                          (insurerId);
                        },
                        items: insuranceCompany.toSet().map((insuranceCompany) {
                          return DropdownMenuItem<InsuranceCompany>(
                            value:
                                insuranceCompany, // Set the value to the entire Location object
                            child: Text(insuranceCompany.insurerName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'InsuranceCompany',
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
                          if (value == null || value.insurerName.isEmpty) {
                            return 'Please select a InsuranceCompany';
                          }
                          return null;
                        },
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10),
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
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: _isHovered1
                                    ? Color.fromRGBO(
                                        199, 55, 125, 1.0) // Hovered color
                                    : SecureRiskColours.Button_Color,
                              ),
                              onPressed: () async {
                                final Map<String, dynamic> requestBody = {
                                  "productId": productId,
                                  "insurerCompanyId": insurerId,
                                  "policyType": selectedPolicyType,
                                  "tpaId": tpaId,
                                };
                                try {
                                  var headers = await ApiServices.getHeaders();
                                  final response = await http.post(
                                    Uri.parse(ApiServices.baseUrl +
                                        ApiServices
                                            .ClientList_addproduct_EndPoint +
                                        "/$clientId"),
                                    body: jsonEncode(requestBody),
                                    headers: headers,
                                  );

                                  if (response.statusCode == 201) {
                                    (response.body);
                                    _fetchData();
                                    Navigator.of(context).pop();
                                    _showSuccessDialog(
                                        context, "Product Added");
                                  } else {
                                    Navigator.of(context).pop();
                                    _showErrorDialog(context);
                                    ('Error: ${response.statusCode} ${response.body}');
                                  }
                                } catch (exception) {
                                  ('Exception: $exception');
                                }
                              },
                              child: Text(
                                'Create',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _isHovered1
                                      ? Colors.white // Hovered color
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  ClientListDataSource(
      List<Client> client,
      this.context,
      this._fetchData,
      this.onDesignationChanged,
      this._designationList,
      this.onLocationChanged,
      this._locationslist,
      this.onProductTypeChanged,
      this._ProductsList,
      this.onInsuranceCompanyChanged,
      this._InsurenceCompanyList,
      this.onTpaChanged,
      this._tpaList,
      this.onPolicyTypeChanged,
      this.PolicyTypeList)
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
                          columnName: 'cid',
                          // value: insurer.insurerId,
                          value: (insurer.clientId.toString())),
                      DataGridCell<String>(
                        columnName: 'clientName',
                        value: insurer.clientName,
                      ),
                      DataGridCell<String>(
                          columnName: 'products',
                          value: (insurer.listOfProducts.length.toString())),
                      DataGridCell<String>(
                          columnName: 'users',
                          // value: insurer.insurerId,
                          value: (insurer.listOfUsers.length.toString())),
                      DataGridCell<String>(
                        columnName: 'location',
                        value: insurer.location,
                      ),
                      DataGridCell<String>(
                        columnName: 'Wellness',
                        value: insurer.wellness,
                      ),
                      DataGridCell<String>(
                        columnName: 'status',
                        value: insurer.status,
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
    (insurer.insurerId);
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'Actions') {
          return Container(
            alignment: Alignment.center,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  child: Text('Show Products', style: GoogleFonts.poppins()),
                  value: 'Show Products',
                ),
                PopupMenuItem<String>(
                  child: Text('Add Product', style: GoogleFonts.poppins()),
                  value: 'Add Product',
                ),
                PopupMenuItem<String>(
                  child: Text('Add User', style: GoogleFonts.poppins()),
                  value: 'addUser',
                ),
                PopupMenuItem<String>(
                  child: Text('Edit', style: GoogleFonts.poppins()),
                  value: 'edit',
                ),
                PopupMenuItem<String>(
                  child: Text('Client Archive', style: GoogleFonts.poppins()),
                  value: 'Client Archive',
                ),
                PopupMenuItem<String>(
                  child: Text('Product Archive', style: GoogleFonts.poppins()),
                  value: 'Product Archive',
                ),
                PopupMenuItem<String>(
                  child: Text('Delete', style: GoogleFonts.poppins()),
                  value: 'delete',
                ),
              ],
              onSelected: (value) {
                (insurer);
                if (value == 'edit') {
                  _handleEditClient(context, insurer, _fetchData,
                      onLocationChanged, _locationslist);
                } else if (value == 'addUser') {
                  _openAddUserDialog(
                      context, insurer, _fetchData, onDesignationChanged);
                } else if (value == 'delete') {
                  _handleDeleteClient(context, insurer.clientId, _fetchData);
                } else if (value == 'Add Product') {
                  _handleAddProduct(
                      insurer.clientId,
                      context,
                      onProductTypeChanged,
                      _ProductsList,
                      onPolicyTypeChanged,
                      PolicyTypeList,
                      onTpaChanged,
                      _tpaList,
                      onInsuranceCompanyChanged,
                      _InsurenceCompanyList,
                      _fetchData);
                  // _handleAddProduct(context,insurer,_fetchData,onProductTypeChanged,_ProductsList,onInsuranceCompanyChanged, _InsurenceCompanyList);
                } else if (value == 'Show Products') {
                  openProductsDialogwithColumns(context, insurer.clientId,
                      _fetchData, onDesignationChanged, insurer.designation);
                }
              },
            ),
          );
        } else if (dataCell.columnName == 'users') {
          return GestureDetector(
            onTap: () {
              ("hi");
              // Pass the CoverageNames list to the openUsersDialog method
              openUsersDialog(context, insurer.clientId, _fetchData,
                  onDesignationChanged, insurer.designation);
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
        } else if (dataCell.columnName == 'clientName') {
          return GestureDetector(
            onTap: () {
              openProductsDialog(
                  context,
                  insurer.clientId,
                  _fetchData,
                  onDesignationChanged,
                  insurer.designation,
                  insurer.clientName);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                dataCell.value.toString(),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 7, 79, 138),
                    decoration: TextDecoration.underline),
              ),
            ),
          );
        } else if (dataCell.columnName == 'products') {
          return GestureDetector(
            onTap: () {
              ("hi");
              // Pass the CoverageNames list to the openUsersDialog method
              openProductsDialogwithColumns(context, insurer.clientId,
                  _fetchData, onDesignationChanged, insurer.designation);
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
