import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import '../Service.dart';
import '../SideBarComponents/AppBar.dart';
import 'RenewalsDataSource.dart';

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

class ProductType {
  int productId;
  String productName;

  ProductType({
    required this.productId,
    required this.productName,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      productId: json['productId'],
      productName: json['productName'],
    );
  }
}

class InsuranceCompany {
  final String insurerId;
  final String insurerName;

  InsuranceCompany({
    required this.insurerId,
    required this.insurerName,
  });

  factory InsuranceCompany.fromJson(Map<String, dynamic> json) {
    return InsuranceCompany(
      insurerId: json['insurerId'],
      insurerName: json['insurerName'],
    );
  }
}

class Desigantion {
  final int id;
  final String designationName;

  Desigantion({
    required this.id,
    required this.designationName,
  });

  factory Desigantion.fromJson(Map<String, dynamic> json) {
    return Desigantion(
      id: json['id'],
      designationName: json['designationName'],
    );
  }
}

class Tpa {
  final int tpaId;
  final String tpaName;
  final String location;

  Tpa({
    required this.tpaId,
    required this.tpaName,
    required this.location,
  });

  factory Tpa.fromJson(Map<String, dynamic> json) {
    return Tpa(
      tpaId: json['tpaId'],
      tpaName: json['tpaName'],
      location: json['location'],
    );
  }
}

class RenewalsClientList extends StatefulWidget {
  RenewalsClientList();

  @override
  _RenewalsClientListState createState() => _RenewalsClientListState();
}

class _RenewalsClientListState extends State<RenewalsClientList> {
  int? _selectedPagination;
  String? _selectedFilter;
  int _currentPage = 1;
  int _pageSize = 10;
  List<Client> _data = [];
  List<Client> _filteredData = [];
  int totalPages = 1;
  String _searchText = '';
  bool isUpdate = false;

  List<Location> _locationslist = [];
  List<ProductType> _productsList = [];
  List<InsuranceCompany> _InsurenceCompanyList = [];
  List<Desigantion> _designationList = [];
  List<Tpa> _tpaList = [];

  List<String> PolicyTypeList = ['Regular', 'TopUp', 'Self', '1+3', 'Parents'];

  List<int> _paginationOptions = [5, 10, 15, 20];

  String? _selectedLocation;
  String? _selectedProduct;
  String? _selectedInsurenceCompany = "";
  String? _selectedDesignation;
  String? _selectedTpa;
  String? selectedPolicyType = "";

  List<String> _filterOptions = [
    'Mumbai',
    'Pune',
    'Bangalore',
    'Mumbai - Head Office',
    'Chennai',
    'Hyderabad',
  ];

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _selectedPagination = 10;
    _fetchData();
    _fetchLocations();
    _fetchProductType();
    _fetchInsuranceCompany();
    fetchDesignation();
    _fetchDesignation();
    _fetchTpa();
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
          Uri.parse(
              ApiServices.baseUrl + ApiServices.ClientList_getAll_EndPoint),
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
          // .where((item) => item.clientName == _selectedFilter)
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
                item.insurerId.contains(_searchText) ||
                item.clientName
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

  void _onProductTypeChanged(String? productType) {
    setState(() {
      _selectedProduct = productType;
    });
    (_selectedProduct);
  }

  void _onPolicyTypeChanged(String? policyType) {
    setState(() {
      selectedPolicyType = policyType;
    });
    (selectedPolicyType);
  }

  void _onInsuranceChanged(String? insurenceCompany) {
    setState(() {
      _selectedInsurenceCompany = insurenceCompany;
    });
    (_selectedInsurenceCompany);
  }

  void _onDesignationChanged(String? designation) {
    setState(() {
      _selectedDesignation = designation;
    });
    (_selectedDesignation);
  }

  void _onTpaChanged(String? tpa) {
    setState(() {
      _selectedTpa = tpa;
    });
    (_selectedTpa);
  }

  void openAddClientDialog(BuildContext context, void _fetchData()) {
    final TextEditingController ClientNameController = TextEditingController();
    Location? selectedLocation;
    int? locationId;
    Set<Location> location = _locationslist.toSet();

    ProductType? selectedProductType;
    int? productId;
    Set<ProductType> productType = _productsList.toSet();

    InsuranceCompany? selectedInsuranceCompany;
    String? insurerId;
    Set<InsuranceCompany> insuranceCompany = _InsurenceCompanyList.toSet();

    String? selectedPolicyType;
    Set<String> policyTypelist = PolicyTypeList.toSet();

    Tpa? selectedTpa;
    int? tpaId = 0;
    Set<Tpa> tpaType = _tpaList.toSet();
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 450,
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
                              'Create Client',
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
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        controller: ClientNameController,
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
                        validator: (value) {
                          String trimmedText = value.toString().trim();
                          if (trimmedText == null || trimmedText.isEmpty) {
                            return 'Please enter a client name';
                          }
                          // You can add more validation logic here if needed.
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: DropdownButtonFormField<Location>(
                          value: selectedLocation,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              locationId = newValue.locationId;
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: DropdownButtonFormField<ProductType>(
                          value: selectedProductType,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              productId = newValue.productId;
                            }
                            _onProductTypeChanged(newValue.toString());
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
                    ),
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Health Insurance (GHI)",
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Visibility(
                        visible: selectedProductType?.productName.trim() ==
                            "Group Health Insurance (GHI)",
                        child: DropdownButtonFormField<Tpa>(
                          value: selectedTpa,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              tpaId = newValue.tpaId;
                            }
                            _onTpaChanged(newValue.toString());
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
                    Visibility(
                      visible: selectedProductType?.productName.trim() ==
                          "Group Personal Accident (GPA)",
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: DropdownButtonFormField<InsuranceCompany>(
                          value: selectedInsuranceCompany,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              insurerId = newValue.insurerId;
                              // Capture the locationId when a location is selected
                            }
                            _onInsuranceChanged(newValue.toString());
                            selectedInsuranceCompany = newValue;
                            (insurerId);
                          },
                          items:
                              insuranceCompany.toSet().map((insuranceCompany) {
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
                              return 'Please select a location';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 15),
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
                                // Call the API with the input data
                                if (_formKey.currentState!.validate()) {
                                  addToClient(
                                    ClientNameController.text,
                                    locationId,
                                    productId,
                                    insurerId,
                                    selectedPolicyType,
                                    tpaId,
                                    _fetchData,
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Create',
                                    style: GoogleFonts.poppins(
                                      color: _isHovered1
                                          ? Colors.white // Hovered color
                                          : Colors.white,
                                    )),
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

  Future<void> _fetchProductType() async {
    try {
      List<ProductType> productType = await fetchProducts();
      setState(() {
        _productsList = productType;
      });
    } catch (e) {
      // Handle API call error here.
      (e.toString());
    }
  }

  Future<List<ProductType>> fetchProducts() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.ClientList_productType_EndPoint),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<ProductType> productType =
          data.map((json) => ProductType.fromJson(json)).toList();
      ("ProductType: $productType");
      return productType;
    } else {
      throw Exception('Failed to load productType');
    }
  }

  Future<void> _fetchInsuranceCompany() async {
    try {
      List<InsuranceCompany> insuranceCompany = await fetchInsurance();
      setState(() {
        _InsurenceCompanyList = insuranceCompany;
      });
    } catch (e) {
      (e.toString());
    }
  }

  Future<List<InsuranceCompany>> fetchInsurance() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.ClientList_getAll_Insurance),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<InsuranceCompany> insuranceCompany =
          data.map((json) => InsuranceCompany.fromJson(json)).toList();
      ("InsuranceCompany: $insuranceCompany");
      return insuranceCompany;
    } else {
      throw Exception('Failed to load InsuranceCompany');
    }
  }

  Future<void> _fetchDesignation() async {
    try {
      List<Desigantion> designation = await fetchDesignation();
      setState(() {
        _designationList = designation;
      });
    } catch (e) {
      // Handle API call error here.
      (e.toString());
    }
  }

  Future<List<Desigantion>> fetchDesignation() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(
            ApiServices.baseUrl + ApiServices.ClientList_designation_EndPoint),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Desigantion> designation =
          data.map((json) => Desigantion.fromJson(json)).toList();
      ("designation: $designation");
      return designation;
    } else {
      throw Exception('Failed to load designation');
    }
  }

  Future<void> _fetchTpa() async {
    try {
      List<Tpa> tpa = await fetchTpa();
      setState(() {
        _tpaList = tpa;
      });
    } catch (e) {
      // Handle API call error here.
      (e.toString());
    }
  }

  Future<List<Tpa>> fetchTpa() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.ClientList_tpa_EndPoint),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Tpa> tpa = data.map((json) => Tpa.fromJson(json)).toList();
      ("Tpa: $tpa");
      return tpa;
    } else {
      throw Exception('Failed to load tpa');
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
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: 220,
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
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            openAddClientDialog(context, _fetchData);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Create Client',
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
              //  SizedBox(height: 10),
              Expanded(
                child: SfDataGrid(
                  headerRowHeight: screenHeight * 0.06,
                  source: RenewalsDataSource(
                      currentPageData,
                      mainContext,
                      _fetchData,
                      _onDesignationChanged,
                      _designationList,
                      _onLocationChanged,
                      _locationslist,
                      _onProductTypeChanged,
                      _productsList,
                      _onInsuranceChanged,
                      _InsurenceCompanyList,
                      _onTpaChanged,
                      _tpaList,
                      _onPolicyTypeChanged,
                      PolicyTypeList),
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
                      columnName: 'Id',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        child: Text(
                          'Id',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Client Name',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(6),
                        alignment: Alignment.center,
                        child: Text(
                          'Client Name',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Products',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(6),
                        alignment: Alignment.center,
                        child: Text(
                          'Products',
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
                      columnName: 'Wellness',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          'Wellness',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: SecureRiskColours.table_Text_Color),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Active Status',
                      label: Container(
                        color: SecureRiskColours.Table_Heading_Color,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          'Active Status',
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
                  Text('Items per page:', style: GoogleFonts.poppins()),
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

  void addToClient(
      String text,
      int? locationId,
      int? productId,
      String? insurenceId,
      String? selectPolicyType,
      int? tpaId,
      void Function() fetchData) async {
    final Map<String, dynamic> requestBody = {
      "clientName": text,
      "locationId": locationId,
      "productId": productId,
      "insuranceCompanyId": insurenceId,
      "policyType": selectPolicyType,
      "tpaId": tpaId,
    };
    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.post(
        Uri.parse(ApiServices.baseUrl + ApiServices.ClientList_add_EndPoint),
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
    fetchData();
  }
}

class InsurerGridRow {
  final Client insurer;
  final DataGridRow row;

  InsurerGridRow(this.insurer, this.row);
}

class User {
  User({
    required this.cidId,
    required this.clientName,
    required this.location,
    required this.productType,
    required this.insureCompany,
    required this.products,
    required this.users,
    required this.wellness,
    required this.status,
    required this.policyType,
    required this.tpaList,
    required this.createdDate,
    required this.updatedDate,
    required this.sno,
    required this.empId,
    required this.designation,
    required this.email,
    required this.phoneNumber,
    required this.uid,
    required this.employeeId,
    required this.name,
    required this.mailId,
    required this.phoneNo,
    required this.pid,
    required this.insurerCompany,
  });

  final String cidId;
  final String clientName;
  final String location;
  final String productType;
  final String insureCompany;
  final int products;
  final String users;
  final String wellness;
  final String status;
  final String policyType;
  final String tpaList;
  final String createdDate;
  final String updatedDate;
  final String empId;
  final String designation;
  final String email;
  final String phoneNumber;
  final int sno;
  final int uid;
  final String employeeId;
  final String name;
  final String mailId;
  final String phoneNo;
  final int pid;
  final String insurerCompany;
  // New field for coverage details

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      cidId: json['cidId'] as String? ?? '',
      clientName: json['clientName'] as String? ?? '',
      location: json['location'] as String? ?? '',
      productType: json['productType'] as String? ?? '',
      insureCompany: json['insureCompany'] as String? ?? '',
      products: json['products'] as int? ?? 0,
      users: json['users'] as String? ?? '',
      wellness: json['wellness'] as String? ?? '',
      status: json['status'] as String? ?? '',
      policyType: json['policyType'] as String? ?? '',
      tpaList: json['tpaList'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      updatedDate: json['updatedDate'] as String? ?? '',
      empId: json['empId'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      sno: json['sno'] as int? ?? 0,
      uid: json['uid'] as int? ?? 0,
      pid: json['pid'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      mailId: json['mailId'] as String? ?? '',
      phoneNo: json['phoneNo'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      insurerCompany: json['insurerCompany'] as String? ?? '',
    );
  }
}

class Client {
  Client({
    required this.clientId,
    required this.clientName,
    required this.listOfProducts,
    required this.policyType,
    required this.listOfUsers,
    required this.location,
    required this.status,
    required this.sno,
    required this.productType,
    required this.insureCompany,
    required this.insurerId,
    required this.usersCount,
    required this.insurerName,
    required this.product,
    required this.wellness,
    required this.cid,
    required this.products,
    required this.users,
    required this.tpaList,
    required this.createdDate,
    required this.updatedDate,
    required this.empId,
    required this.designation,
    required this.email,
    required this.phoneNumber,
    required this.pid,
    required this.insurerCompany,
  });

  final String clientName;
  final String location;
  final String productType;
  final String insureCompany;

  final String insurerId;
  final int usersCount;
  final String insurerName;
  final String product;
  final String wellness;
  final String status;
  final int cid;
  final int clientId;

  final String policyType;
  final String tpaList;
  final String createdDate;
  final String updatedDate;
  final String empId;
  final String designation;
  final String email;
  final String phoneNumber;
  final int sno;
  final int products;
  final int users;

  final int pid;
  final String insurerCompany;
  final List<User> listOfUsers;
  final List<User> listOfProducts;
  // New field for coverage details

  factory Client.fromJson(Map<String, dynamic> json) {
    // Parse the list of users from JSON and convert them to User objects
    final List<User> users = (json['listOfUsers'] as List<dynamic>)
        .map((userJson) => User.fromJson(userJson))
        .toList();
    final List<User> products = (json['listOfProducts'] as List<dynamic>)
        .map((userJson) => User.fromJson(userJson))
        .toList();
    return Client(
      listOfUsers: users,
      listOfProducts: products,
      insurerId: json['insurerId'] as String? ?? '',
      usersCount: json['usersCount'] as int? ?? 0,
      insurerName: json['insurerName'] as String? ?? '',
      product: json['product'] as String? ?? '',
      location: json['location'] as String? ?? '',
      wellness: json['wellness'] as String? ?? '',
      status: json['status'] as String? ?? '',
      clientName: json['clientName'] as String? ?? '',
      productType: json['productType'] as String? ?? '',
      insureCompany: json['insureCompany'] as String? ?? '',
      policyType: json['policyType'] as String? ?? '',
      tpaList: json['tpaList'] as String? ?? '',
      createdDate: json['createdDate'] as String? ?? '',
      updatedDate: json['updatedDate'] as String? ?? '',
      empId: json['empId'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      sno: json['sno'] as int? ?? 0,
      cid: json['cid'] as int? ?? 0,
      products: json['products'] as int? ?? 0,
      users: json['users'] as int? ?? 0,
      pid: json['pid'] as int? ?? 0,
      clientId: json['clientId'] as int? ?? 0,
      insurerCompany: json['insurerCompany'] as String? ?? '',
    );
  }
}

class Product {
  Product({
    required this.pid,
    required this.productId,
    required this.productName,
    required this.policyType,
    required this.tpaId,
    required this.insurerCompanyId,
  });

  final int pid;
  final String productId;
  final String productName;
  final String policyType;
  final String tpaId;
  final String insurerCompanyId;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      pid: json['pid'] as int? ?? 0,
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      policyType: json['policyType'] as String? ?? '',
      tpaId: json['tpaId'] as String? ?? '',
      insurerCompanyId: json['insurerCompanyId'] as String? ?? '',
    );
  }
}
