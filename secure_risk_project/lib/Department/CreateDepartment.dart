import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import '../SideBarComponents/AppBar.dart';
import 'DepartmentListDataSource.dart';

class Location {
  final int locationId;
  final String sno;
  final String locationName;
  final int usersNewId;

  Location({
    required this.locationId,
    required this.sno,
    required this.locationName,
    required this.usersNewId,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationId'],
      sno: json['sno'],
      locationName: json['locationName'],
      usersNewId: json['usersNewId'],
    );
  }
}

class Department {
  final int id;
  final String departmentName;
  final String status;

  Department({
    required this.id,
    required this.departmentName,
    required this.status,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      departmentName: json['departmentName'],
      status: json['status'],
    );
  }
}

class Designation {
  final int id;
  final String designationName;
  final String status;

  Designation({
    required this.id,
    required this.designationName,
    required this.status,
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['id'],
      designationName: json['designationName'],
      status: json['status'],
    );
  }
}

class CreateDepartment extends StatefulWidget {
  CreateDepartment();

  @override
  _CreateDepartmentState createState() => _CreateDepartmentState();
}

class _CreateDepartmentState extends State<CreateDepartment> {
  int? _selectedPagination;
  String? _selectedFilter;
  int _currentPage = 1;
  int _pageSize = 10;
  List<Client> _data = [];
  List<Client> _filteredData = [];
  int totalPages = 1;
  bool isUpdate = false;

  List<Location> _locationslist = [];
  List<Designation> _designationlist = [];
  List<Department> _departmentlist = [];
  List<String> _genderlist = ['male', 'female'];

  String? selectedLocation;
  String? selectedDesignation;
  String? selectedDepartment;
  String? selectedGender;

  List<int> _paginationOptions = [5, 10, 15, 20];
  List<String> _filterOptions = [
    'Location Name',
    'Users',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPagination = 10;
    _fetchData();
    _fetchLocations();
    _fetchDesignation();
    _fetchDepartment();
  }

  void _handlePaginationChange(int? newValue) {
    setState(() {
      _selectedPagination = newValue;
      _pageSize = newValue!;
      totalPages = (_filteredData.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  void _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
          Uri.parse(ApiServices.baseUrl +
              ApiServices.CreateLocation_GetLocationEndPoint),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;

        setState(() {
          _data = jsonData.map((json) => Client.fromJson(json)).toList();
          _filteredData = getFilteredData();
          totalPages = (_filteredData.length / _pageSize).ceil();
        });
      } else {
        ('Error: ${response.statusCode}');
      }
    } catch (exception) {
      ('Exception: $exception');
    }
  }

  void _handleFilterByChange(String? newValue) {
    setState(() {
      _selectedFilter = newValue;
      _filteredData = getFilteredData();
      totalPages = (_filteredData.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  List<Client> getFilteredData() {
    if (_selectedFilter == null) {
      return _data;
    } else {
      return _data
          .where((item) => item.locationName == _selectedFilter)
          .where((item) => item.user == _selectedFilter)
          .toList();
    }
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onLocationChanged(String? location) {
    setState(() {
      selectedLocation = location;
    });
    (selectedLocation);
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

  Future<void> _fetchLocations() async {
    try {
      List<Location> locations = await fetchLocations();
      setState(() {
        _locationslist = locations;
      });
    } catch (e) {
      // Handle API call error here.
      (e.toString());
    }
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

  Future<List<Location>> fetchLocations() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.roles_getAllDepartment),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Location> locations =
          data.map((json) => Location.fromJson(json)).toList();
      ("Locations: $locations");
      return locations;
    } else {
      throw Exception('Failed to load locations');
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

  List<Client> getCurrentPageData() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return _filteredData.sublist(
        startIndex, endIndex.clamp(0, _filteredData.length));
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Client> currentPageData = getCurrentPageData();
    bool hasPreviousPage = _currentPage > 1;
    bool hasNextPage = _currentPage < totalPages;
    BuildContext mainContext = context;
    double screenHeight = MediaQuery.of(context as BuildContext).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBarExample(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: 208,
                        height: 37,
                        child: TextField(
                          controller: _searchController,
                          // onChanged: _handleSearch,
                          decoration: InputDecoration(
                            labelText: 'Search',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // _handleSearch(_searchController.text);
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
                        width: 208,
                        height: 37,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
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
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            hint: Text('Filter By'),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    SizedBox(
                      width: 20,
                    ),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            // openAddClientDialog(context, _fetchData);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Create Designation',
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
                        height: 30,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SfDataGrid(
                  headerRowHeight: 40,
                  source: DepartmentListDataSource(
                      currentPageData,
                      mainContext,
                      _fetchData,
                      _onDepartmentChanged,
                      _departmentlist,
                      _onDesignationChanged,
                      _designationlist,
                      _onLocationChanged,
                      _locationslist,
                      _onGenderChanged,
                      _genderlist),
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: [
                    GridColumn(
                      columnName: 'S.No',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        child: Text('S.No',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Department',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        child: Text('Department',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Designation Count',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text('Designation Count',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Actions',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: Text('Actions',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Items per page:', style: GoogleFonts.poppins()),
                  SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _selectedPagination,
                    onChanged: _handlePaginationChange,
                    items: _paginationOptions.map((option) {
                      return DropdownMenuItem<int>(
                        value: option,
                        child: Text(option.toString(),
                            style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                  ),
                  TextButton(
                    child: Text('Previous', style: GoogleFonts.poppins()),
                    onPressed: hasPreviousPage
                        ? () {
                            _goToPage(_currentPage - 1);
                          }
                        : null,
                  ),
                  SizedBox(width: 10),
                  for (int i = 1; i <= totalPages; i++)
                    TextButton(
                      child: Text(
                        i.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: i == _currentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        _goToPage(i);
                      },
                    ),
                  SizedBox(width: 10),
                  TextButton(
                    child: Text('Next', style: GoogleFonts.poppins()),
                    onPressed: hasNextPage
                        ? () {
                            _goToPage(_currentPage + 1);
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InsurerGridRow {
  final Client insurer;
  final DataGridRow row;

  InsurerGridRow(this.insurer, this.row);
}

class User {
  User({
    required this.userId,
    required this.corporateName,
    required this.businessType,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.email,
    required this.phoneNo,
    required this.password,
  });

  final int userId;
  final String corporateName;
  final String businessType;
  final String firstName;
  final String lastName;
  final String employeeId;
  final String dateOfBirth;
  final int age;
  final String gender;
  final String email;
  final String phoneNo;
  final String password;

  // New field for coverage details

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int? ?? 0,
      corporateName: json['corporateName'] as String? ?? '',
      businessType: json['businessType'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNo: json['phoneNo'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }
}

class Client {
  Client({
    required this.locationId,
    required this.sno,
    required this.locationName,
    required this.user,
  });
  final int locationId;
  final String sno;
  final String locationName;
  final int user;

  // New field for coverage details

  factory Client.fromJson(Map<String, dynamic> json) {
    final usersNewId = json['usersNewId'] as List<dynamic>? ?? [];
    return Client(
      locationId: json['locationId'] as int? ?? 0,
      sno: json['sno'] as String? ?? '',
      locationName: json['locationName'] as String? ?? '',
      user: usersNewId.length,
    );
  }
}
