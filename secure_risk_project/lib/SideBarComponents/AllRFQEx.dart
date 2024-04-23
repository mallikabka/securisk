import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:js_interop';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loginapp/Utilities/CircularLoader.dart';
import 'package:loginapp/Utilities/SessionExpiredDialog.dart';
import 'package:loginapp/EditRfq/EditRenewalStepperPage.dart';
import 'package:loginapp/EditRfq/EditFreshStepperPage.dart';
import 'package:loginapp/Service.dart';
import 'package:loginapp/SideBarComponents/AppBar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../Colours.dart';
import '../FreshPolicyFields/CreateRFQ.dart';
import 'package:toastification/toastification.dart';

class AllRFQEx extends StatefulWidget {
  final VoidCallback onCreateRFQ;

  AllRFQEx({required this.onCreateRFQ});

  @override
  _AllRFQExState createState() => _AllRFQExState();
}

class _AllRFQExState extends State<AllRFQEx> {
  List<Employee> _data = [];
  int _currentPage = 1;
  int _pageSize = 10;
  int totalPages = 1;

  String _searchText = '';
  List<int> _paginationOptions = [5, 10, 15, 20];
  List<Employee> _filteredData = [];
  String? _selectedFilter;
  int? _selectedPagination;
  List<String> _filterOptions = [
    'Processing',
    'Pending',
    'Submitted',
    'Closed',
    'Lost'
  ];

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  int currentStep = 0;
  void onStepBack() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedPagination = 10;
    fetchData();
    // Loader.hideLoader();
    // Loader.showLoader(context);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  void _handlePaginationChange(int? newValue) {
    setState(() {
      _selectedPagination = newValue;
      _pageSize = newValue!;
      totalPages = (_filteredData.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  void _handleFilterByChange(String? newValue) {
    setState(() {
      _selectedFilter = newValue;
      _filteredData = getFilteredData();
      totalPages = (_filteredData.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  List<Employee> getFilteredData() {
    if (_selectedFilter == null) {
      return _data;
    } else {
      return _data.where((item) => item.appStatus == _selectedFilter).toList();
    }
  }

  void fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
          Uri.parse(ApiServices.baseUrl + ApiServices.all_Rfq_Endpoint),
          headers: headers);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        Loader.hideLoader();
        List<Employee> employees =
            jsonData.map<Employee>((json) => Employee.fromJson(json)).toList();
        setState(() {
          _data = employees;
          _filteredData = getFilteredData();
          totalPages = (_filteredData.length / _pageSize).ceil();
        });
      } else if (response.statusCode == 401) {
        DialogUtils.showSessionExpiredDialog(context);
      } else {
        ('failed to load');
      }
    } catch (exception) {
      ('Exception: $exception');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        borderSide: const BorderSide(
          color: Colors.green,
          width: 2,
        ),
        width: 300,
        buttonsBorderRadius: const BorderRadius.all(
          Radius.circular(2),
        ),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: false,
        headerAnimationLoop: true,
        animType: AnimType.bottomSlide,
        title: 'INFO',
        desc: 'Please try again...!',
        descTextStyle: TextStyle(fontWeight: FontWeight.bold),
        showCloseIcon: true,
        btnCancelOnPress: () {
          //  Navigator.of(context).pop();
        },
        btnOkOnPress: () {
          //  Navigator.of(context).pop();
        },
      ).show();
    } finally {
      Loader.hideLoader();
    }
  }

  List<Employee> getCurrentPageData() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return _filteredData.sublist(
        startIndex, endIndex.clamp(0, _filteredData.length));
  }

  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
      _filteredData = getFilteredData();
      if (_searchText.isNotEmpty) {
        _filteredData = _filteredData
            .where((item) =>
                item.insurerName!.contains(_searchText) ||
                item.insurerName!
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                item.phNo!.contains(_searchText) ||
                item.phNo!.toLowerCase().contains(_searchText.toLowerCase()) ||
                item.email!.contains(_searchText) ||
                item.email!.toLowerCase().contains(_searchText.toLowerCase()) ||
                item.policyType!.contains(_searchText) ||
                item.policyType!
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                item.product!.contains(_searchText) ||
                item.product!
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                item.nob!.contains(_searchText) ||
                item.nob!.toLowerCase().contains(_searchText.toLowerCase()) ||
                item.productCategory!.contains(_searchText) ||
                item.productCategory!
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
            .toList();
        totalPages = (_filteredData.length / _pageSize).ceil();
        _currentPage = 1;
      }
    });
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context as BuildContext).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    bool isHovered1 = false;
    bool hasPreviousPage = _currentPage > 1;
    bool hasNextPage = _currentPage < totalPages;
    List<Employee> currentPageData = getCurrentPageData();
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
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.06,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _handleSearch,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: SecureRiskColours
                                      .Button_Color), // Change the color as needed
                            ),
                            labelText: 'Search',
                            labelStyle: TextStyle(
                              color: SecureRiskColours
                                  .Text_Color, // Change the color to your desired color
                            ),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
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
                            hint: Text(
                              'Filter By',
                              style: TextStyle(
                                  color: SecureRiskColours.Text_Color),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          isHovered1 = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHovered1 = false;
                        });
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33),
                          ),
                          backgroundColor: SecureRiskColours.Button_Color,
                          shadowColor: SecureRiskColours.Button_shadow_Color,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateRFQ(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                                width:
                                    5), // Adjust the space between icon and text
                            Text(
                              'Create RFQ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: screenHeight * 0.020,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                // height: screenHeight * 0.8,
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: SecureRiskColours.Table_Heading_Color,
                  ),
                  child: SfDataGrid(
                    headerRowHeight: screenHeight * 0.06,
                    source:
                        EmployeeDataSource(currentPageData, context, fetchData),
                    allowSorting: true,
                    allowMultiColumnSorting: true,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: [
                      GridColumn(
                        columnName: 'S.No',
                        autoFitPadding: EdgeInsets.all(2.0),
                        // padding: EdgeInsets.only(top: 2, bottom: 2),
                        width: screenWidth * 0.055,
                        //height: screenHeight * 0.01,
                        label: Container(
                          padding: EdgeInsets.only(top: 2, bottom: 2),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'S.No',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color),
                          ),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'ProductCategory',
                        autoFitPadding: EdgeInsets.all(2.0),
                        width: screenWidth * 0.095,
                        label: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ProductCategory',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Product',
                        width: screenWidth * 0.15,
                        autoFitPadding: EdgeInsets.all(2.0),
                        label: Container(
                          padding: EdgeInsets.only(top: 2, bottom: 2),
                          alignment: Alignment.center,
                          child: Text(
                            'Product',
                            softWrap: false,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color),
                          ),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Task',
                        // autoFitPadding: EdgeInsets.only(left: 10.0),
                        width: screenWidth * 0.075,
                        label: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Task',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: SecureRiskColours.table_Text_Color)),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Insurer',
                        autoFitPadding: EdgeInsets.only(top: 10),
                        width: screenWidth * 0.07,
                        label: Container(
                          padding: EdgeInsets.only(left: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('Insurer',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: SecureRiskColours.table_Text_Color)),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Nature of business',
                        autoFitPadding: EdgeInsets.all(2.0),
                        width: screenWidth * 0.11,
                        label: Container(
                          padding: EdgeInsets.only(left: 6),
                          alignment: Alignment.centerLeft,
                          child: Text('NatureofBusiness',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: SecureRiskColours.table_Text_Color)),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Phone no',
                        // autoFitPadding: EdgeInsets.only(top: 10),
                        width: screenWidth * 0.082,
                        label: Container(
                          padding: EdgeInsets.only(left: 7),
                          alignment: Alignment.centerLeft,
                          child: Text('Phone No',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: SecureRiskColours.table_Text_Color)),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Email id',
                        autoFitPadding: EdgeInsets.all(2.0),
                        width: screenWidth * 0.12,
                        label: Container(
                          padding: EdgeInsets.only(left: 7),
                          alignment: Alignment.centerLeft,
                          // alignment: Alignment.centerLeft,
                          child: Text(
                            'Email ID',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: SecureRiskColours.table_Text_Color),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Status',
                        //  autoFitPadding: EdgeInsets.only(top: 30),
                        width: screenWidth * 0.068,
                        label: Container(
                          padding: EdgeInsets.only(left: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('Status',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: SecureRiskColours.table_Text_Color)),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Created by',
                        autoFitPadding: EdgeInsets.all(2.0),
                        width: screenWidth * 0.072,
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          alignment: Alignment.centerLeft,
                          child: Text('CreatedOn',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: SecureRiskColours.table_Text_Color)),
                        ),
                        allowSorting: false,
                      ),
                      GridColumn(
                        width: screenWidth * 0.1,
                        columnName: 'Options',
                        autoFitPadding: EdgeInsets.all(2.0),
                        label: Container(
                          alignment: Alignment.center,
                          child: Text('Actions',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: SecureRiskColours.table_Text_Color)),
                        ),
                        allowSorting: false,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Items per page:',
                    style: GoogleFonts.poppins(
                        color: SecureRiskColours.Button_Color),
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
                      style: GoogleFonts.poppins(
                          color: SecureRiskColours.Button_Color),
                    ),
                    onPressed: hasPreviousPage
                        ? () {
                            _goToPage(_currentPage - 1);
                          }
                        : null,
                  ),
                  SizedBox(width: 10),
                  for (int i = _currentPage - 2; i <= _currentPage + 2; i++)
                    if (i == _currentPage)
                      Text(
                        i.toString(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: SecureRiskColours.Button_Color),
                      )
                    else if (i > 0 && i <= totalPages)
                      TextButton(
                        child: Text(
                          i.toString(),
                          style:
                              TextStyle(color: SecureRiskColours.Button_Color),
                        ),
                        onPressed: () {
                          _goToPage(i);
                        },
                      ),
                  if (_currentPage + 2 < totalPages) ...[
                    Text('...'),
                    TextButton(
                      child: Text(
                        totalPages.toString(),
                        style: TextStyle(color: SecureRiskColours.Button_Color),
                      ),
                      onPressed: () {
                        _goToPage(totalPages);
                      },
                    ),
                  ],
                  SizedBox(width: 10),
                  TextButton(
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                          color: SecureRiskColours.Button_Color),
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

class EmployeeDataSource extends DataGridSource {
  final BuildContext context;

  final List<String> _filterOptions = [
    'Processing',
    'Pending',
    'Submitted',
    'Closed',
    'Lost'
  ];
  final VoidCallback fetchDataCallback;

  Future<void> editFuntion(rfid) async {
    var headers = await ApiServices.getHeaders();
    Response response = await http.get(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.EditCorporate_Details_EndPoint +
          rfid),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      var policyType = jsonData["corporateDetails"]["policyType"];
      var productId = jsonData["corporateDetails"]["productId"];
      var responseProdCategoryId =
          jsonData["corporateDetails"]['prodCategoryId'];
      if (policyType == "Fresh") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditFreshStepperPage(
                rfid: rfid, // Pass the rfid value
                productId: productId, // Pass the productId value
                policyType: policyType,
                responseProdCategoryId: responseProdCategoryId),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditRenewalStepperPage(
                rfid: rfid, // Pass the rfid value
                productId: productId, // Pass the productId value
                policyType: policyType,
                responseProdCategoryId: responseProdCategoryId),
          ),
        );
      }
    } else {
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
                  'Failed to edit...!',
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

  EmployeeDataSource(
      List<Employee> employees, this.context, this.fetchDataCallback) {
    dataGridRows = employees
        .asMap()
        .map(
          (index, dataGridRow) => MapEntry(
            index,
            DataGridRow(cells: [
              DataGridCell<int>(
                columnName: 'S.No',
                value: index + 1,
              ),
              DataGridCell<String>(
                columnName: 'ProductCategory',
                value: dataGridRow.productCategory ?? '',
              ),
              DataGridCell<String>(
                columnName: 'Product',
                value: dataGridRow.product ?? '',
              ),
              DataGridCell<String>(
                  columnName: 'Task', value: dataGridRow.policyType),
              DataGridCell<String>(
                  columnName: 'Insurer', value: dataGridRow.insurerName ?? ''),
              DataGridCell<String>(
                  columnName: 'Nature of business',
                  value: dataGridRow.nob ?? ''),
              DataGridCell<String>(
                  columnName: 'Phone no', value: dataGridRow.phNo ?? ''),
              DataGridCell<String>(
                  columnName: 'Email id', value: dataGridRow.email ?? ''),
              DataGridCell<String>(
                  columnName: 'Status', value: dataGridRow.appStatus ?? ''),
              DataGridCell<String>(
                  columnName: 'Created by',
                  value: dataGridRow.createDate ?? ''),
              DataGridCell<String>(
                  columnName: 'Options', value: dataGridRow.rfqId ?? ''),
            ]),
          ),
        )
        .values
        .toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 != 0) {
        return Colors.white;
      } else {
        return Color.fromARGB(255, 244, 245, 243);
      }
    }

    return DataGridRowAdapter(
      color: getRowBackgroundColor(),
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'Options') {
          final status = row.getCells()[8].value;
          final rfid = dataCell.value;
          return FittedBox(
              child: Row(children: [
            Padding(
              padding: EdgeInsets.all(0.0),
              child: IconButton(
                onPressed: () {
                  openDialog(context, status, rfid, fetchDataCallback);
                },
                icon: Tooltip(
                  message: "Move",
                  child: Icon(
                    Icons.movie_edit,
                    size: 15,
                    color: SecureRiskColours.Button_Color,
                  ),
                ),
              ),
            ),
            // Edit functionality
            IconButton(
              onPressed: () {
                editFuntion(rfid);
              },
              icon: Tooltip(
                message: "Edit", // Tooltip text
                child: Icon(
                  Icons.edit_note,
                  size: 15,
                  color: SecureRiskColours.Button_Color,
                ),
              ),
            ),
            //Icon(Icons.edit_note, size: 15),

            IconButton(
              onPressed: () {
                clickedOnDownLoad(rfid, context);
              },
              icon: Tooltip(
                message: "Download", // Tooltip text
                child: Icon(
                  Icons.download,
                  size: 15,
                  color: SecureRiskColours.Button_Color,
                ),
              ),
            ),
            //  Icon(Icons.download, size: 15),
          ]));
        } else {
          return Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                dataCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  String option = "";
  void openDialog(BuildContext context, String selectedOption, rfid,
      VoidCallback fetchDataCallback) {
    option = selectedOption;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 50,
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
                            'Move RFQ',
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
                    height: 20,
                  ),
                  Container(
                    width: 340,
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1), // Customize border color and width
                      borderRadius: BorderRadius.circular(
                          10), // Adjust border radius as needed
                    ),
                    child: DropdownButton<String>(
                      value: option,
                      onChanged: (value) {
                        setState(() {
                          option = value!;
                        });
                      },
                      items: _filterOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: SizedBox(
                        height: 10,
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      hint: Text('Select Status'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: SecureRiskColours.Button_Color,
                  shadowColor: SecureRiskColours.Button_shadow_Color,
                ),
                onPressed: () {
                  _onMovePressed(context, option, rfid, fetchDataCallback);
                },
                child: Text(
                  "Move",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

_onMovePressed(
    BuildContext context, option, rfid, VoidCallback fetchDataCallback) {
  callApi(rfid, option, fetchDataCallback, context);
  Navigator.of(context).pop();
}

void callApi(
    rfid, option, VoidCallback fetchDataCallback, BuildContext context) async {
  var headers = await ApiServices.getHeaders();
  await http
      .patch(
    Uri.parse(ApiServices.baseUrl + ApiServices.all_Rfq_SendRfq + rfid),
    body: jsonEncode({
      'appStatus': option,
    }),
    headers: headers,
  )
      .then((value) async {
    if (value.statusCode == 200) {
      toastification.showSuccess(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Status Updated successfully',
      );
      Loader.showLoader(context);
      fetchDataCallback();
    } else {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Status failed to update...!',
      );
    }
  });
}

void clickedOnDownLoad(rfid, BuildContext context) async {
  (rfid.runtimeType);

  try {
    var headers = await ApiServices.getHeaders();
    String apiUrl = ApiServices.baseUrl + ApiServices.download_Rfq + '$rfid';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Extract filename from Content-Disposition header
      final filename = response.headers['content-disposition']
          ?.split('; ')
          ?.firstWhere((element) => element.startsWith('filename='))
          ?.substring('filename='.length);

      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = "allRfq.pdf";

      anchor.click();
      html.Url.revokeObjectUrl(url);
    } else {
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
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed', style: GoogleFonts.poppins(color: Colors.red)),
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

class Employee {
  Employee(
      this.product,
      this.productCategory,
      this.policyType,
      this.insurerName,
      this.nob,
      this.phNo,
      this.email,
      this.appStatus,
      this.rfqId,
      this.createDate);

  final String? product;
  final String? productCategory;
  final String? policyType;
  final String? insurerName;
  final String? nob;
  final String? phNo;
  final String? email;
  final String? appStatus;
  final String? createDate;
  final String? rfqId;

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      json['product'] as String?,
      json['productCategory'] as String?,
      json['policyType'] as String?,
      json['insurerName'] as String?,
      json['nob'] as String?,
      json['phNo'] as String?,
      json['email'] as String?,
      json['appStatus'] as String?,
      json['rfqId'] as String?,
      json['createDate'] as String?,
    );
  }
}
