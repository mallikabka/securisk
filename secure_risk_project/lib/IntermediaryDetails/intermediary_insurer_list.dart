import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/IntermediaryDetails/insurerDataSource.dart';
import 'package:loginapp/Service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import '../SideBarComponents/AppBar.dart';

class Location {
  final int locationId;
  final String locationName;

  Location({
    required this.locationId,
    required this.locationName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationId'],
      locationName: json['locationName'],
    );
  }
}

class IntermediaryInsurerList extends StatefulWidget {
  IntermediaryInsurerList();

  @override
  _IntermediaryInsurerListState createState() =>
      _IntermediaryInsurerListState();
}

class _IntermediaryInsurerListState extends State<IntermediaryInsurerList> {
  int? _selectedPagination;
  String? _selectedFilter;
  int _currentPage = 1;
  int _pageSize = 10;
  List<Insurer> _data = [];
  List<Insurer> _filteredData = [];
  int totalPages = 1;
  String _searchText = '';
  bool isUpdate = false;

  List<Location> _locationslist = [];

  String? _selectedLocation;

  List<int> _paginationOptions = [5, 10, 15, 20];
  List<String> _filterOptions = [
    'Insurer List',
    'Location',
    'Users',
  ];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _selectedPagination = 10;
    _fetchData();
    _fetchLocations();
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
              ApiServices.InsurerList_getAllInsurer_EndPoint),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;

        setState(() {
          _data = jsonData.map((json) => Insurer.fromJson(json)).toList();
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

  List<Insurer> getFilteredData() {
    if (_selectedFilter == null) {
      return _data;
    } else {
      return _data
          .where((item) => item.insurerName == _selectedFilter)
          .where((item) => item.location == _selectedFilter)
          .where((item) => item.usersCount.toString() == _selectedFilter)
          .toList();
    }
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
      _filteredData = getFilteredData();
      if (_searchText.isNotEmpty) {
        _filteredData = _filteredData
            .where((item) =>
                item.insurerId.contains(_searchText) ||
                item.insurerName
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                item.location.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();
      }
      totalPages = (_filteredData.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  void _onLocationChanged(String? location) {
    setState(() {
      _selectedLocation = location;
    });
    (_selectedLocation);
  }

  void openAddInsurerDialog(
      BuildContext context, void _fetchData(), String insurerId) {
    final TextEditingController insurerNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController managerNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    Location? selectedLocation;
    int? locationId;
    Set<Location> location = _locationslist.toSet();
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                            'Create Insurer',
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          controller: insurerNameController,
                          decoration: InputDecoration(
                            labelText: 'Insurer Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a insurer name';
                            }
                            // You can add more validation logic here if needed.
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: DropdownButtonFormField<Location>(
                            value: selectedLocation,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                locationId = newValue.locationId;
                                // Capture the locationId when a location is selected
                              }
                              _onLocationChanged(newValue.toString());
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
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
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
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: TextFormField(
                                controller: managerNameController,
                                decoration: InputDecoration(
                                  labelText: 'Manager Name',
                                  border: OutlineInputBorder(),
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
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
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
                                  backgroundColor: _isHovered1
                                      ? Color.fromRGBO(
                                          199, 55, 125, 1.0) // Hovered color
                                      : SecureRiskColours.Button_Color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: () {
                                  // Call the API with the input data
                                  if (_formKey.currentState!.validate()) {
                                    addInsurer(
                                      insurerId,
                                      locationId,
                                      emailController.text,
                                      managerNameController.text,
                                      insurerNameController.text,
                                      int.tryParse(
                                              phoneNumberController.text) ??
                                          0,
                                      _fetchData,
                                    );
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  'Create',
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
                      )
                    ],
                  ),
                ]),
              ),
            );
          },
        );
      },
    );
  }

  void addInsurer(
      String insurerId,
      int? locationId,
      String email,
      String managerName,
      String insuranceName,
      int phoneNumber,
      void Function() _fetchData) async {
    final Map<String, dynamic> requestBody = {
      'email': email,
      'managerName': managerName,
      'phoneNumber': phoneNumber,
      'location': locationId,
      "insurerName": insuranceName,
    };
    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.post(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.InsurerList_AddInsurer_EndPoint),
        body: jsonEncode(requestBody),
        headers: headers,
      );

      if (response.statusCode == 200) {
        (response.body);

        setState(() {
          locationId = null;
        });
      } else {
        ('Error: ${response.statusCode}');
      }
    } catch (exception) {
      ('Exception: $exception');
    }
    // fetchData();
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

  Future<List<Location>> fetchLocations() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.ClientList_location_EndPoint),
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

  void _showSuccessDialog(BuildContext context, String operation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Success',
            style: GoogleFonts.poppins(),
          ),
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

  List<Insurer> getCurrentPageData() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return _filteredData.sublist(
        startIndex, endIndex.clamp(0, _filteredData.length));
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Insurer> currentPageData = getCurrentPageData();
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
            //  crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: 215,
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
                        width: 208,
                        height: 37,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                    Align(
                      child: Container(
                        height: 37,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                SecureRiskColours.Button_Color),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    33), // Adjust the border radius as needed
                              ),
                            ),
                          ),
                          onPressed: () {
                            openAddInsurerDialog(context, _fetchData, "");
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Create Insurer',
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
                  source: InsurerDataSource(
                    currentPageData,
                    mainContext,
                    _fetchData,
                    _onLocationChanged,
                    _locationslist,
                  ),
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: [
                    GridColumn(
                      columnName: 'S.No',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        child: Text(
                          'S.No',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Name',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(6),
                        alignment: Alignment.center,
                        child: Text(
                          'Insurer List',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Location',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text(
                          'Location',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Users',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          'Users',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Actions',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: Text(
                          'Actions',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Items per page:',
                    style: GoogleFonts.poppins(),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _selectedPagination,
                    onChanged: _handlePaginationChange,
                    items: _paginationOptions.map((option) {
                      return DropdownMenuItem<int>(
                        value: option,
                        child: Text(option.toString()),
                      );
                    }).toList(),
                  ),
                  TextButton(
                    child: Text(
                      'Previous',
                      style: GoogleFonts.poppins(),
                    ),
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
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(),
                    ),
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
  final Insurer insurer;
  final DataGridRow row;

  InsurerGridRow(this.insurer, this.row);
}

class User {
  User(
      {required this.userId,
      required this.managerName,
      required this.phoneNumber,
      required this.email,
      required this.location});

  final String userId;
  final String email;
  final String location;
  final String managerName;
  final int phoneNumber;
  // New field for coverage details

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String? ?? '',
      managerName: json['managerName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      location: json['location'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as int? ?? 0,
    );
  }
}

class Insurer {
  Insurer({
    required this.insurerId,
    required this.usersCount,
    required this.status,
    required this.insurerName,
    required this.location,
    required this.listOfUsers,
  });

  final String insurerId;
  final int usersCount;
  final bool status;
  final String insurerName;
  final String location;
  final List<User> listOfUsers;
  // New field for coverage details

  factory Insurer.fromJson(Map<String, dynamic> json) {
    final List<User> users = (json['listOfUsers'] as List<dynamic>)
        .map((userJson) => User.fromJson(userJson))
        .toList();

    return Insurer(
      listOfUsers: users,
      insurerId: json['insurerId'] as String? ?? '',
      usersCount: json['usersCount'] as int? ?? 0,
      status: json['status'] as bool? ?? false,
      insurerName: json['insurerName'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}
