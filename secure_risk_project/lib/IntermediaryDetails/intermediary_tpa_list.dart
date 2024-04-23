import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
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

class Tpa {
  Tpa({
    required this.tpaId,
    required this.tpaName,
    required this.location,
  });

  final int tpaId;

  final String tpaName;
  final String location;

  factory Tpa.fromJson(Map<String, dynamic> json) {
    return Tpa(
      tpaId: json['tpaId'] as int? ?? 0,
      tpaName: json['tpaName'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}

class IntermediaryTpaList extends StatefulWidget {
  IntermediaryTpaList();

  @override
  _IntermediaryTpaListState createState() => _IntermediaryTpaListState();
}

class _IntermediaryTpaListState extends State<IntermediaryTpaList> {
  // bool _isHovered1 = false;
  int? _selectedPagination;
  String? _selectedFilter;
  int _currentPage = 1;
  int _pageSize = 10;
  List<Tpa> _data = [];
  List<Tpa> _filteredData = [];
  int totalPages = 1;
  String _searchText = '';
  bool isUpdate = false;

  List<int> _paginationOptions = [5, 10, 15, 20];
  List<String> _filterOptions = [
    'TPA Name',
    'Location',
  ];

  List<Location> _locationslist = [];
  String? _selectedLocation;
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
          Uri.parse(ApiServices.baseUrl + ApiServices.Tpa_getall_EndPoint),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;

        setState(() {
          _data = jsonData.map((json) => Tpa.fromJson(json)).toList();
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

  List<Tpa> getFilteredData() {
    if (_selectedFilter == null) {
      return _data;
    } else {
      return _data
          .where((item) => item.tpaName == _selectedFilter)
          .where((item) => item.location == _selectedFilter)
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
                item.tpaId.toString().contains(_searchText) ||
                item.tpaName
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

  void openAddTpaDialog(BuildContext context, void _fetchData()) {
    final TextEditingController tpaNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController managerNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    Location? selectedLocation;
    int? locationId;
    Set<Location> location = _locationslist.toSet();
    String? locationName;
    bool _isHovered1 = false;

    setState(() {
      isUpdate = false;
    });
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
                              'Create TPA',
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
                        controller: tpaNameController,
                        decoration: InputDecoration(
                          labelText: 'TPA Name',
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
                            return 'Please enter a insurer name';
                          }
                          RegExp regExp = RegExp(r'^[!@#%^&*(),.?":{}|<>]');
                          if (regExp.hasMatch(value)) {
                            return 'TPA name should not start with a special symbol';
                          }

                          // You can add more validation logic here if needed.
                          return null;
                        },
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
                            locationName = newValue.locationName;
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
                              addTpa(
                                tpaNameController.text,
                                locationName,
                                emailController.text,
                                managerNameController.text,
                                int.tryParse(phoneNumberController.text) ?? 0,
                                _fetchData,
                              );

                              // Close the dialog
                              Navigator.of(context).pop();
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> addTpa(String tpaName, String? location, String email,
      String managerName, int phoneNumber, void Function() _fetchData) async {
    final Map<String, dynamic> requestBody = {
      'tpaName': tpaName,
      'location': location,
      "tpaHeaders": [
        {
          "headerName": "Sample_Headrname",
          "sheetName": "Sample_sheetname",
          "headerAliasName": "aliasname"
        },
        {
          "headerName": "headername",
          "sheetName": "sheetName",
          "headerAliasName": "headerAliasName"
        }
      ]
    };

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.Tpa_Create_EndPoint),
        // Uri.parse(ApiServices.baseUrl + ApiServices.Tpa_Create_EndPoint),
        body: jsonEncode(requestBody),
        headers: headers,
      );

      if (response.statusCode == 201) {
        (response.body);
        _fetchData();
        _showSuccessDialog(context, "Tpa added");
      } else {
        _showErrorDialog(context);
        Navigator.of(context).pop();
        ('Error: ${response.statusCode}');
      }
    } catch (exception) {
      ('Exception: $exception');
    }
  }

  List<Tpa> getCurrentPageData() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return _filteredData.sublist(
        startIndex, endIndex.clamp(0, _filteredData.length));
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Tpa> currentPageData = getCurrentPageData();
    bool hasPreviousPage = _currentPage > 1;
    bool hasNextPage = _currentPage < totalPages;
    double screenHeight = MediaQuery.of(context as BuildContext).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBarExample(),
      ),
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
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                            openAddTpaDialog(context, _fetchData);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Create TPA',
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
                  source: TpaDataSource(currentPageData, context, _fetchData,
                      _onLocationChanged, _locationslist),
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
                          'TPA Name',
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

class TpaGridRow {
  final Tpa tpa;
  final DataGridRow row;

  TpaGridRow(this.tpa, this.row);
}

class TpaDataSource extends DataGridSource {
  bool _isHovered1 = false;
  final List<TpaGridRow> tpaRows;
  BuildContext context;
  void Function() _fetchData;
  void Function(String? location) onLocationChanged;
  List<Location> _locationslist = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TpaDataSource(List<Tpa> tpas, this.context, this._fetchData,
      this.onLocationChanged, this._locationslist)
      : tpaRows = tpas
            .map((Tpa) => TpaGridRow(
                  Tpa,
                  DataGridRow(
                    cells: [
                      DataGridCell<String>(
                          columnName: 'S.No',
                          // value: Tpa.tpaId,
                          value: (tpas.indexOf(Tpa) + 1).toString()),
                      DataGridCell<String>(
                        columnName: 'tpaName',
                        value: Tpa.tpaName,
                      ),
                      DataGridCell<String>(
                        columnName: 'location',
                        value: Tpa.location,
                      ),
                      DataGridCell<String>(columnName: 'Actions', value: ''),
                    ],
                  ),
                ))
            .toList();

  @override
  List<DataGridRow> get rows =>
      tpaRows.map((employeeRow) => employeeRow.row).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final rowIndex = rows.indexOf(row);
    final TpaGridRow tpaRow = tpaRows[rowIndex];
    final Tpa tpa = tpaRow.tpa;

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'Actions') {
          return Container(
            alignment: Alignment.center,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz),
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
                    'Delete',
                    style: GoogleFonts.poppins(),
                  ),
                  value: 'delete',
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _handleEditTpa(context, tpa, _fetchData, onLocationChanged,
                      _locationslist);
                } else if (value == 'delete') {
                  _handleDeleteTpa(context, tpa.tpaId, _fetchData);
                }
              },
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

  void _handleEditTpa(
    BuildContext context,
    Tpa tpa,
    void Function() _fetch,
    void Function(String?) onLocationChanged,
    List<Location> _locations,
  ) {
    int tpaId = tpa.tpaId;
    final TextEditingController tpaNameController =
        TextEditingController(text: tpa.tpaName);

    Location? selectedLocation;
    int? locationId;
    String? locationName;

    selectedLocation = _locations
        .firstWhere((location) => location.locationName == tpa.location);
    locationId = selectedLocation.locationId;
    locationName = selectedLocation.locationName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              title: Container(
                color: SecureRiskColours.Button_Color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Edit Tpa',
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
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: tpaNameController,
                      decoration: InputDecoration(
                        labelText: 'TPA Name',
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
                          return 'Please enter a insurer name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Location>(
                      value: selectedLocation,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          locationId = newValue.locationId;
                          locationName = newValue.locationName;
                        }
                        onLocationChanged(newValue?.locationName);
                        setState(() {
                          selectedLocation = newValue;
                        });
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: _isHovered1
                              ? Color.fromRGBO(199, 55, 125, 1.0)
                              : Colors.white,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final Map<String, dynamic> requestBody = {
                              "tpaName": tpaNameController.text,
                              "location": locationName,
                            };

                            try {
                              var headers = await ApiServices.getHeaders();
                              final response = await http.put(
                                Uri.parse(ApiServices.baseUrl +
                                    ApiServices.Tpa_Update_EndPoint +
                                    '$tpaId'),
                                body: jsonEncode(requestBody),
                                headers: headers,
                              );

                              if (response.statusCode == 200) {
                                Navigator.of(context).pop();
                                _showSuccessDialog(context, "Tpa updated");
                              } else {
                                Navigator.of(context).pop();
                                _showErrorDialog(context);
                              }
                            } catch (exception) {
                              print('Exception: $exception');
                            }
                            _fetch();
                          }
                        },
                        child: Text('Submit',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: _isHovered1 ? Colors.white : Colors.black,
                            )),
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

  void _handleDeleteTpa(
      BuildContext context, int tpaId, void Function() _fetch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this Tpa?'),
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
                      ApiServices.Tpa_Delete_EndPoint +
                      '$tpaId'),
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
                        content: Text('Failed to delete Tpa.'),
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
}
