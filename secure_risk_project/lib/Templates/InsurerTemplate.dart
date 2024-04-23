import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Service.dart';
import 'package:loginapp/Templates/InsurerTemplateDataSource.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:http_parser/http_parser.dart';
import '../Colours.dart';

class InsurerTemplatePojo {
  InsurerTemplatePojo(
      {required this.id,
      required this.templateName,
      required this.templateFileName,
      required this.actions,
      required this.templateType});
  final int id;
  final String templateName;
  final String templateType;
  final String templateFileName;
  final String actions;

  factory InsurerTemplatePojo.fromJson(Map<String, dynamic> json) {
    final actions = json['actions'] as String? ?? 'edit';
    return InsurerTemplatePojo(
      id: json['id'] as int,
      templateName: json['templateName'] as String? ?? '',
      templateType: json['templateType'] as String? ?? '',
      templateFileName: json['templateFileName'] as String? ?? '',
      actions:
          actions, // You can set actions based on your logic or leave it empty
    );
  }
}

Uint8List? fileBytes;
String? fileName;

class InsurerTemplate extends StatefulWidget {
   InsurerTemplate({Key? key}) : super(key: key);

  @override
  State<InsurerTemplate> createState() => _RFQTemplateState();
}

List<String> _locations = ['Before', 'After'];

class _RFQTemplateState extends State<InsurerTemplate> {
  int? _selectedPagination;
  int _pageSize = 10;

  int totalPages = 1;
  int _currentPage = 1;

  Future<void> editfunction() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.edit_Templates),
        headers: headers);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  String _searchText = '';
  List<InsurerTemplatePojo> _filteredData = [];
  String? _selectedFilter;
  List<InsurerTemplatePojo> _data = [];
  List<String> _filterOptions = [
    'Template Name',
  ];
  List<int> _paginationOptions = [5, 10, 15, 20];
  String? _selectedLocation;
  bool flag = false;

  @override
  void initState() {
    super.initState();
    _selectedPagination = 10;
    fetchDataFromApi();
  }

  void onTemplateNameChanged(String name) {
    setState(() {
      templateName.text = name;
    });
  }

  void onTemplateTypeChange(String? type) {
    setState(() {
      _selectedLocation = type;
    });
  }

  void _handlePaginationChange(int? newValue) {
    setState(() {
      _selectedPagination = newValue;
      _pageSize = newValue!;
      totalPages = (_filteredData.length / _pageSize).ceil();
      _currentPage = 1;
    });
  }

  Future<void> fetchDataFromApi() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
      Uri.parse(
          ApiServices.baseUrl + ApiServices.getAll_TemplatesData + 'insurer'),
    headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _data = data.map((item) => InsurerTemplatePojo.fromJson(item)).toList();
        _filteredData = getFilteredData();
        totalPages = (_filteredData.length / _pageSize).ceil();
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  List<InsurerTemplatePojo> getCurrentPageData() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return _filteredData.sublist(
        startIndex, endIndex.clamp(0, _filteredData.length));
  }

  List<InsurerTemplatePojo> getFilteredData() {
    if (_selectedFilter == null) {
      return _data;
    } else {
      return _data
          .where((item) => item.templateName == _selectedFilter)
          .toList();
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

  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
      _filteredData = getFilteredData();
      if (_searchText.isNotEmpty) {
        _filteredData = _filteredData
            .where((item) =>
                item.templateName.contains(_searchText) ||
                item.templateName
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                item.templateName
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
            .toList();
      }
      // totalPages = (_filteredData.length / _pageSize).ceil();
      // _currentPage = 1;
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Color getColor(Set<MaterialState> states) {
    return Colors.blue; // Change this color according to your preference
  }

  TextEditingController _searchController = TextEditingController();
  TextEditingController templateName = TextEditingController();
  TextEditingController templateType = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<InsurerTemplatePojo> currentPageData = getCurrentPageData();
    bool hasPreviousPage = _currentPage > 1;
    bool hasNextPage = _currentPage < totalPages;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    Future<void> _handleUpload() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        fileBytes = result.files.first.bytes;
        fileName = result.files.first.name;
        setState(() {});
      } else {
        fileBytes = null;
        setState(() {});
      }
    }

    Future<Map<String, dynamic>> sendFileToBackend(
      Uint8List fileBytes,
    ) async {
      var headers = await ApiServices.getHeaders();
      final apiUrl = ApiServices.baseUrl + ApiServices.create_Templates;

      var request = http.MultipartRequest("POST", Uri.parse(apiUrl))
        ..headers.addAll(headers);

      request.fields['templateName'] = templateName.text;
      request.fields['templateType'] = _selectedLocation!;
      request.fields['type'] = 'insurer';
      var multipartFile = http.MultipartFile.fromBytes(
        'templateFile',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        fetchDataFromApi();
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to send file to backend');
      }
    }

    Future<void> _sendFile() async {
      if (fileBytes != null) {
        try {
          await sendFileToBackend(fileBytes!);
          await fetchDataFromApi();
        } catch (e) {}
      } else {}
    }

    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(15.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                       EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppBar(
                          automaticallyImplyLeading: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  20.0), // Adjust the top left radius as needed
                              topRight: Radius.circular(
                                  20.0), // Adjust the top right radius as needed
                            ),
                          ),
                          backgroundColor: Colors.white,
                          title: Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:  EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 210,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius:  BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: DropdownButton<String>(
                                        value: _selectedFilter,
                                        onChanged: _handleFilterByChange,
                                        items:
                                            _filterOptions.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        underline:  SizedBox(),
                                        icon:  Icon(Icons.arrow_drop_down),
                                        hint:  Text('Filter By'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  width: 210,
                                  height: 38,
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: _handleSearch,
                                      decoration: InputDecoration(
                                        labelText: 'Search',
                                        suffixIcon: IconButton(
                                          icon:  Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            _handleSearch(
                                                _searchController.text);
                                          },
                                        ),
                                        border:  OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: screenHeight * 0.62,
                                        width: screenWidth * 0.32,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight * 0.08,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10.0),
                                                    topLeft:
                                                        Radius.circular(10.0)),
                                                color: Color.fromARGB(
                                                    255, 140, 198, 245),
                                              ),
                                              width: double.infinity,
                                              padding:
                                                   EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child:  Text(
                                                  'Create Template',
                                                  style: GoogleFonts.poppins(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      // Set your desired text color
                                                      fontSize: 20,
                                                      // Set your desired font size
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(25),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            bottom: 5.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Template Name',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller: templateName,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          'Enter Template Name',
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 2.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Template Type',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            top: 5.0),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: _selectedLocation,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(
                                                          () {
                                                            _selectedLocation =
                                                                newValue;
                                                          },
                                                        );
                                                      },
                                                      itemHeight: 50,
                                                      isExpanded: true,
                                                      decoration:
                                                          InputDecoration(
                                                        // labelText:
                                                        //     'Select template type',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      hint: Text(
                                                          'Select template type'),
                                                      items: _locations.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                        (String location) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: location,
                                                            child:
                                                                Text(location),
                                                          );
                                                        },
                                                      ).toList(),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please select template type';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Select File',
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        IconButton.filledTonal(
                                                          iconSize: 32,
                                                          icon:  Icon(Icons
                                                              .cloud_upload_outlined),
                                                          onPressed:
                                                              _handleUpload,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 37,
                                                    child: ElevatedButton(
                                                      style: SecureRiskColours
                                                          .customButtonStyle(),
                                                      onPressed: () {
                                                        _sendFile();
                                                        Navigator.pop(context);
                                                      },
                                                      child:  Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            'Create',
                                                            style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            left: 10.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: ButtonStyle(
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all<double>(
                                                                    4.0),
                                                        // Set the elevation value
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color?>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .hovered))
                                                              return Color
                                                                  .fromARGB(
                                                                      255,
                                                                      133,
                                                                      56,
                                                                      56);
                                                            return Color.fromARGB(
                                                                255,
                                                                218,
                                                                138,
                                                                132); // Defer to the widget's default.
                                                          },
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0), // Set the border radius here
                                                          ),
                                                        ),
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all<Size>(
                                                          Size(100, 43),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Color
                                                                    .fromARGB(
                                                                        255,
                                                                        230,
                                                                        30,
                                                                        203)),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                           Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                           SizedBox(
                                                              width: 5),
                                                          // Add some spacing between the icon and text
                                                           Text(
                                                            'Close',
                                                            style: GoogleFonts.poppins(
                                                                fontSize: 18),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    height: 37,
                                    child: ElevatedButton(
                                      style:
                                          SecureRiskColours.customButtonStyle(),
                                      onPressed: null,
                                      child:  Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            // You can change this to your desired icon
                                            color: Colors
                                                .white, // Change the color as needed
                                          ),
                                          SizedBox(width: 5),
                                          // Add some spacing between the icon and text
                                          Text(
                                            'Create',
                                            style:
                                                GoogleFonts.poppins(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 0.74,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: Color.fromARGB(255, 227, 242, 253),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SfDataGrid(
                        source: InsurerTemplateDataSource(
                            currentPageData,
                            _data.length,
                            context,
                            editfunction,
                            fetchDataFromApi,
                            onTemplateTypeChange,
                            _selectedLocation,
                            _locations,
                            _handleUpload),
                        footerFrozenRowsCount: 1,
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                             Text('Items per page:'),
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
                              child:  Text('Previous'),
                              onPressed: hasPreviousPage
                                  ? () {
                                      _goToPage(_currentPage - 1);
                                    }
                                  : null,
                            ),
                             SizedBox(width: 10),
                            for (int i = _currentPage - 2;
                                i <= _currentPage + 2;
                                i++)
                              if (i == _currentPage)
                                Text(
                                  i.toString(),
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                )
                              else if (i > 0 && i <= totalPages)
                                TextButton(
                                  child: Text(i.toString()),
                                  onPressed: () {
                                    _goToPage(i);
                                  },
                                ),
                            if (_currentPage + 2 < totalPages) ...[
                               Text('...'),
                              TextButton(
                                child: Text(totalPages.toString()),
                                onPressed: () {
                                  _goToPage(totalPages);
                                },
                              ),
                            ],
                             SizedBox(width: 10),
                            TextButton(
                              child:  Text('Next'),
                              onPressed: hasNextPage
                                  ? () {
                                      _goToPage(_currentPage + 1);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        columns: [
                          GridColumn(
                            columnName: 'id',
                            width: screenWidth * 0.2,
                            label: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Sno',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'templateName',
                            width: screenWidth * 0.2,
                            label: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Template Name',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'templateFileName',
                            width: screenWidth * 0.3,
                            label: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Template File Name',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'actions',
                            width: screenWidth * 0.25,
                            label: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Actions',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
