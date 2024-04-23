import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Graphs/Donut.dart';
import 'package:loginapp/IntermediaryDetails/intermediary_insurer_list.dart';
import 'package:loginapp/IntermediaryDetails/productTypes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import '../Service.dart';
import '../SideBarComponents/AppBar.dart';

String? _selectedProductType;

class IntermediaryProducts extends StatefulWidget {
  IntermediaryProducts();

  @override
  _IntermediaryProductsState createState() => _IntermediaryProductsState();
}

class ProductType {
  final String categoryName;
  final int categoryId;

  ProductType({
    required this.categoryName,
    required this.categoryId,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
    );
  }
}

class CoverageType {
  final String coverage;
  final int coverageId;

  CoverageType({
    required this.coverage,
    required this.coverageId,
  });

  factory CoverageType.fromJson(Map<String, dynamic> json) {
    return CoverageType(
      coverage: json['coverage'],
      coverageId: json['coverageId'],
    );
  }
}

class _IntermediaryProductsState extends State<IntermediaryProducts> {
  int? _selectedPagination;
  String? _selectedFilter;
  int _currentPage = 1;
  int _pageSize = 10;
  List<Product> _data = [];
  List<Product> _filteredData = [];
  int totalPages = 1;
  String _searchText = '';
  bool _isHovered1 = false;
  int? _selectedProductTypeId;
  List<ProductType> _productTypelist = [];
  late void Function(String? productType) onProductTypeChanged;

  List<int> _paginationOptions = [5, 10, 15, 20];
  List<String> _filterOptions = ['EB', 'NON-EB'];

  @override
  void initState() {
    super.initState();
    _selectedPagination = 10;
    _fetchData();
    fetchProductType();
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
              ApiServices.intermediatoryDetails_get_products_EndPoint),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;

        setState(() {
          _data = jsonData.map((json) => Product.fromJson(json)).toList();
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

  List<Product> getFilteredData() {
    if (_selectedFilter == null) {
      return _data;
    } else {
      return _data
          .where((item) => item.productCategory == _selectedFilter)
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
                item.product.contains(_searchText) ||
                item.name.toLowerCase().contains(_searchText.toLowerCase()) ||
                item.appStatus
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
            .toList();
      }
      totalPages = (_filteredData.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  void _onProductTypeChanged(String? productType) {
    setState(() {
      _selectedProductType = productType;
    });
  }

  void _onProductTypeChangedSelectedID(int? productType) {
    setState(() {
      _selectedProductTypeId = productType;
    });
  }

  Future<List<ProductType>> fetchProductType() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.InsurerList_ProductType_EndPoint),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<ProductType> productType =
          data.map((json) => ProductType.fromJson(json)).toList();
      return productType;
    } else {
      throw Exception('Failed to load productType');
    }
  }

  void openAddProductDialog(BuildContext context, void _fetchData()) {
    final TextEditingController productNameController = TextEditingController();
    _selectedProductType = null;
    // ignore: unused_local_variable
    ProductType? selectedProductType;
    // ignore: unused_local_variable
    Set<ProductType> productType = _productTypelist.toSet();
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
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: TextField(
                      controller: productNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(
                            r'[0-9!@#\$%^&*(),.?":{}|<>]')), // Deny digits and special symbols
                      ],
                      decoration: InputDecoration(
                        labelText: 'Product Name',
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
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: ProductTypeDropdown(
                      onProductTypeChanged: _onProductTypeChanged,
                      onSelectedIdChanged: _onProductTypeChangedSelectedID,
                      selectedProductType: _selectedProductType,
                      errorText: null,
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
                        onPressed: () {
                          // Call the API with the input data
                          addProduct(
                            productNameController.text,
                            _selectedProductType,
                            _selectedProductTypeId,
                            _fetchData,
                          );

                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: _isHovered1
                              ? Color.fromRGBO(
                                  199, 55, 125, 1.0) // Hovered color
                              : SecureRiskColours.Button_Color,
                        ),
                        child: Text(
                          'Add Product',
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
            );
          },
        );
      },
    );
  }

  Future<void> addProduct(String productName, String? categoryName,
      int? selectedId, void Function() _fetchData) async {
    final Map<String, dynamic> requestBody = {
      "productName": productName,
      "productcategoryId": selectedId
    };

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.post(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.InsurerList_AddProduct_EndPoint),
        body: jsonEncode(requestBody),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _fetchData();
        _showSuccessDialog(context, "Product added");
      } else {
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

  List<Product> getCurrentPageData() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return _filteredData.sublist(
        startIndex, endIndex.clamp(0, _filteredData.length));
  }

  TextEditingController _searchController = TextEditingController();
  // Step 1: Parse the API response into a list of dropdown items

  @override
  Widget build(BuildContext context) {
    List<Product> currentPageData = getCurrentPageData();
    bool hasPreviousPage = _currentPage > 1;
    bool hasNextPage = _currentPage < totalPages;

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
            //crossAxisAlignment: CrossAxisAlignment.start,
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
                            openAddProductDialog(context, _fetchData);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Create Product',
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
                  source: ProductDataSource(
                    currentPageData,
                    context,
                    _fetchData,
                    _onProductTypeChangedSelectedID,
                    _onProductTypeChanged,
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
                          'Name',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Product',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text(
                          'Product',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Coverage',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          'Coverage',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Created On',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text(
                          'Created On',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Updated On',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text(
                          'Updated On',
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
                        padding: EdgeInsets.all(1),
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
                    child: Text('Next'),
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

class ProductGridRow {
  final Product employee;
  final DataGridRow row;
  bool _validateCoverageName = false;

  ProductGridRow(this.employee, this.row);
}

class ProductDataSource extends DataGridSource {
  bool _isHovered1 = false;
  bool _isHovered2 = false;
  final List<ProductGridRow> employeeRows;
  BuildContext context;
  void Function() _fetchData;
  void Function(String? productType) onProductTypeChanged;
  void Function(int? productType) onProductTypeChangedSelectedID;
  ProductDataSource(
    List<Product> employees,
    this.context,
    this._fetchData,
    this.onProductTypeChangedSelectedID,
    this.onProductTypeChanged,
  ) : employeeRows = employees
            .map((employee) => ProductGridRow(
                  employee,
                  DataGridRow(
                    cells: [
                      DataGridCell<String>(
                          columnName: 'S.No',
                          value: (employees.indexOf(employee) + 1).toString()),
                      DataGridCell<String>(
                          columnName: 'Name', value: employee.product),
                      DataGridCell<String>(
                          columnName: 'Product',
                          value: employee.productCategory),
                      DataGridCell<int>(
                          columnName: 'coverageCount',
                          value: employee.coverageCount),
                      DataGridCell<String>(
                          columnName: 'Created On',
                          value: employee.createdDate),
                      DataGridCell<String>(
                          columnName: 'Updated On', value: employee.updateDate),
                      DataGridCell<String>(columnName: 'Actions', value: ''),
                    ],
                  ),
                ))
            .toList();

  @override
  List<DataGridRow> get rows =>
      employeeRows.map((employeeRow) => employeeRow.row).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final rowIndex = rows.indexOf(row);
    final employeeGridRow = employeeRows[rowIndex];
    final employee = employeeGridRow.employee;
    final Product product = employeeGridRow.employee;

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
                    'Show Coverages',
                    style: GoogleFonts.poppins(),
                  ),
                  value: 'showCoverages',
                ),
                PopupMenuItem<String>(
                  child: Text(
                    'Add Coverage',
                    style: GoogleFonts.poppins(),
                  ),
                  value: 'addCoverage',
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
                  /* _handleEditProduct(
                       context, product,_fetchData);*/
                  editProductDialog(context, onProductTypeChanged,
                      onProductTypeChangedSelectedID, _fetchData, product);
                } else if (value == 'showCoverages') {
                  openDialog(context, employee.productId, _fetchData);
                } else if (value == 'addCoverage') {
                  openAddCoverageDialog(context, product, _fetchData);
                } else if (value == 'delete') {
                  _handleDeleteProduct(context, product, _fetchData);
                }
              },
            ),
          );
        } else if (dataCell.columnName == 'Name') {
          return GestureDetector(
            onTap: () {
              ("hi");
              // Pass the coverageNames list to the openDialog method
              openDialog(context, employee.productId, _fetchData);
            },
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
        } else if (dataCell.columnName == 'coverageCount') {
          return GestureDetector(
            onTap: () {
              // Pass the coverageNames list to the openDialog method
              //  openDialog(context, employee.productId,_fetchData);
            },
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
            ),
          );
        }
      }).toList(),
    );
  }

  void openAddCoverageDialog(BuildContext context, Product product, _fetch) {
    TextEditingController coverageName = TextEditingController();
    bool allowSpecialChars = false;
    bool _validateCoverageName = false;
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
              content: SingleChildScrollView(
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
                              'Add Coverage',
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
                      // height: 40,
                      // margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: coverageName,
                              onChanged: (value) {
                                setState(() {
                                  // Allow special characters if input length is greater than or equal to 2
                                  allowSpecialChars = value.length >= 2 &&
                                      !RegExp(r'\d').hasMatch(value);
                                });
                              },
                              inputFormatters: allowSpecialChars
                                  ? null
                                  : [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'[^\w\s]'))
                                    ],
                              decoration: InputDecoration(
                                hintText: 'Enter coverage name',
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
                            SizedBox(
                                height:
                                    5), // Adjust spacing between TextFormField and error text
                            if (_validateCoverageName)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Please enter coverage name',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ]),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15, bottom: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              backgroundColor: SecureRiskColours.Button_Color,
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 25, bottom: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              backgroundColor: SecureRiskColours.Button_Color,
                            ),
                            child: Text(
                              'Add',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            onPressed: () {
                              if (coverageName.text.isEmpty) {
                                setState(() {
                                  _validateCoverageName = true;
                                });
                              } else {
                                // Handle the entered coverage details
                                _fetch();
                                addCoverage(coverageName, product, _fetchData);
                                Navigator.of(context).pop(); // Close the dialog
                              }
                            },
                          ),
                        ),
                      ],
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

  void addCoverage(TextEditingController coverageName, Product product,
      void Function() fetchData) async {
    int productId = product.productId;
    var data = {"coverage": coverageName.text};
    var isUpdated = true;
    var headers = await ApiServices.getHeaders();
    final response = await http.post(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.InsurerList_AddCovarage_EndPoint +
            "$productId"),
        headers: headers,
        body: json.encode(data));
    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchData();
      isUpdated = true;
    }

    if (isUpdated) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Coverage Added Successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the success dialog

                  Navigator.of(context).pop();

                  // Fetch the updated data
                  fetchData();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show an error message if the updation was not successful
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add Coverage.'),
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
  }
}

void openDialog(BuildContext context, int id, _fetch) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<List<CoverageType>>(
        future: fetchCoverageNamesById(id),
        builder:
            (BuildContext context, AsyncSnapshot<List<CoverageType>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle the case where no data is returned from the API.
            return AlertDialog(
              title: Text('No Data'),
              content: Text('No data available.'),
            );
          } else {
            // Data from the API is available, build the dialog with the data.
            List<CoverageType>? coverageNames = snapshot.data;
            double screenWidth = MediaQuery.of(context).size.width;
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                String editingCoverageName = '';
                return AlertDialog(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  contentPadding: EdgeInsets.zero,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // title: Container(
                  //     color: SecureRiskColours
                  //         .Button_Color, // Set the background color for the title
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 20.0, horizontal: 15.0),
                  //     child: Align(
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           'Coverages',
                  //           style: GoogleFonts.poppins(color: Colors.white),
                  //         ))),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        // height: 60,
                        // width: 340,
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
                                'Coverages',
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
                      Container(
                        width: screenWidth * 0.25,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SingleChildScrollView(
                            child: Card(
                              child: Column(
                                children: List.generate(
                                  coverageNames!.length,
                                  (index) => Card(
                                    color: index % 2 == 0
                                        ? Colors.white
                                        : Colors.white,
                                    child: ListTile(
                                      // ... (rest of your ListTile code)
                                      title:
                                          Text(coverageNames[index].coverage),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              // Show another AlertDialog for editing the coverage name
                                              editingCoverageName =
                                                  coverageNames[index].coverage;
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Edit Coverage Name'),
                                                    content: TextFormField(
                                                      initialValue:
                                                          editingCoverageName,
                                                      onChanged: (value) {
                                                        editingCoverageName =
                                                            value;
                                                      },
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (editingCoverageName
                                                              .trim()
                                                              .isEmpty) {
                                                            // Show an error message if the input is empty
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      'Coverage name cannot be empty')),
                                                            );
                                                          } else {
                                                            // Save the edited coverage name and close the dialog
                                                            handleCoverageEdit(
                                                                coverageNames[
                                                                        index]
                                                                    .coverageId,
                                                                editingCoverageName,
                                                                _fetch);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        },
                                                        child: Text('Save'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await _handleDeleteProductList(
                                                  context,
                                                  coverageNames[index]
                                                      .coverageId);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
        },
      );
    },
  );
}

Future<List<CoverageType>> fetchCoverageNamesById(int id) async {
  var headers = await ApiServices.getHeaders();
  final response = await http.get(
    Uri.parse(ApiServices.baseUrl +
        ApiServices.InsurerList_showCovarage_EndPoint +
        "$id"),
    headers: headers,
  );

  if (response.statusCode == 200) {
    // If the API call is successful, parse the response JSON

    final jsonData = json.decode(response.body) as List<dynamic>;

    // Convert the dynamic list to a list of CoverageType
    final List<CoverageType> coverageNames =
        jsonData.map((json) => CoverageType.fromJson(json)).toList();

    return coverageNames;
  } else {
    // If the API call fails, you can throw an exception or return an empty list, depending on your error handling strategy.
    throw Exception('Failed to load coverage names');
  }
}

void editProductDialog(
    BuildContext context,
    void Function(String? productType) onProductTypeChanged,
    void Function(int? productType) onProductTypeChangedSelectedID,
    void Function() _fetchData,
    Product product) {
  final TextEditingController productNameController = TextEditingController();

  productNameController.text = product.product;
  _selectedProductType = product.productCategory;
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

            // title: Container(
            //   color: SecureRiskColours.Button_Color,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           'Edit Product',
            //           style: GoogleFonts.poppins(color: Colors.white),
            //         ),
            //       ),
            //       IconButton(
            //         onPressed: () {
            //           Navigator.of(context).pop();
            //         },
            //         icon: Icon(
            //           Icons.close,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
                          'Edit Product',
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
                    controller: productNameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: ProductTypeDropdown(
                    onProductTypeChanged: onProductTypeChanged,
                    onSelectedIdChanged: onProductTypeChangedSelectedID,
                    selectedProductType: _selectedProductType,
                    errorText: null,
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
                            ? Color.fromRGBO(199, 55, 125, 1.0) // Hovered color
                            : SecureRiskColours.Button_Color,
                      ),
                      onPressed: () {
                        // Call the API with the input data
                        updateProduct(
                            productNameController.text,
                            _selectedProductType,
                            _fetchData,
                            product.productId,
                            context);
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Update Product',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _isHovered1
                              ? Colors.white // Hovered color
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}

void updateProduct(String productName, String? categoryName,
    void Function() fetchData, int productId, BuildContext context) async {
  var data = {"productName": productName, "categoryName": categoryName};
  var isUpdated = false;
  var headers = await ApiServices.getHeaders();
  final response = await http.patch(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.InsurerList_editProduct_EndPoint +
          "$productId"),
      headers: headers,
      body: json.encode(data));
  if (response.statusCode == 200 || response.statusCode == 201) {
    isUpdated = true;
  }

  fetchData();
  if (isUpdated) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Updated Successfully'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the success dialog
                Navigator.of(context).pop();

                // Fetch the updated data
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    // Show an error message if the updation was not successful
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
}

void _handleDeleteProduct(
    BuildContext context, Product product, void Function() _fetch) {
  int productId = product.productId;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this Product?'),
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
                    ApiServices.InsurerList_deleteProduct_EndPoint +
                    "$productId"),
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
                          onPressed: () async {
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

Future<void> _handleDeleteProductList(BuildContext context, int id) async {
  _IntermediaryProductsState interstate = new _IntermediaryProductsState();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this Coverage?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              var headers = await ApiServices.getHeaders();
              final response = await http.delete(
                Uri.parse(ApiServices.baseUrl +
                    ApiServices.InsurerList_deleteCoverage_EndPoint +
                    "$id"),
                headers: headers,
              );
              bool isDeleted = false;
              if (response.statusCode == 200) {
                isDeleted = true;
              }

              if (isDeleted) {
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Deleted Successfully'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IntermediaryProducts(),
                              ),
                            );

                            // Timer(
                            //   const Duration(seconds: 2),
                            //   () {
                            //     // Navigator.pushNamed(
                            //     //   context,
                            //     //   '/intermediate_page',
                            //     // );

                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) =>
                            //             IntermediaryProducts(),
                            //       ),
                            //     );
                            //   },
                            // );
                            print("Deleted successfully.....");
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
                      content: Text('Failed to delete Coverage.'),
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

Future<void> handleCoverageEdit(
    int productId, String coverageNames, _fetch) async {
  var headers = await ApiServices.getHeaders();
  final response = await http.patch(
    Uri.parse(ApiServices.baseUrl +
        ApiServices.InsurerList_editCoverage_EndPoint +
        "$productId"),
    body: jsonEncode({
      'coverage': coverageNames,
    }),
    headers: headers,
  );
  _fetch();
  (response.body);
}

class Product {
  Product({
    required this.product,
    required this.name,
    required this.coverageCount,
    required this.insurerName,
    required this.nob,
    required this.phNo,
    required this.email,
    required this.appStatus,
    required this.createdDate,
    required this.updateDate,
    required this.coverageNames,
    required this.id,
    required this.productId,
    required this.count,
    required this.coverageId,
    required this.coverage,
    required this.productCategory,
  });

  final String product;
  final int id;
  final int productId;
  final String name;
  final int coverageCount;
  final String insurerName;
  final String nob;
  final String phNo;
  final String email;
  final String appStatus;
  final String createdDate;
  final String updateDate;
  final int count;
  final String coverage;
  final String productCategory;
  final int coverageId;
  final List<String> coverageNames; // New field for coverage details

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product: json['product'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      productId: json['productId'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      coverageCount: json['coverageCount'] as int? ?? 0,
      insurerName: json['insurerName'] as String? ?? '',
      nob: json['nob'] as String? ?? '',
      phNo: json['phNo'] as String? ?? '',
      email: json['email'] as String? ?? '',
      appStatus: json['appStatus'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      updateDate: json['updateDate'] as String? ?? '',
      count: json['coverageCount'] as int? ?? 0,
      coverage: json['coverage'] as String? ?? '',
      productCategory: json['productCategory'] as String? ?? '',
      coverageId: json['coverageId'] as int? ?? 0,
      coverageNames: json['coverageNames'] != null
          ? List<String>.from(json['coverageNames'])
          : [], // Assuming coverageNames is a List<String> in the JSON.
    );
  }
}
