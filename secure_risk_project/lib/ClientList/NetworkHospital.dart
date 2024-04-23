import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loginapp/Utilities/CircularLoader.dart';
import 'dart:html' as html;
import 'package:toastification/toastification.dart';

class NetworkHospital {
  final int noworkHospitalId;
  final String hospitalName;
  final String address;
  final String city;
  final String state;
  final int pincode;

  NetworkHospital({
    required this.noworkHospitalId,
    required this.hospitalName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
  });
}

class NetworkHospitalForm extends StatefulWidget {
  int? clientId;

  String? productIdvar;
  String? tpaName;

  NetworkHospitalForm(
      {Key? key,
      required this.clientId,
      required this.productIdvar,
      required this.tpaName})
      : super(key: key);
  @override
  State<NetworkHospitalForm> createState() => _NetworkHospitalFormState();
}

class _NetworkHospitalFormState extends State<NetworkHospitalForm> {
  String? _selectedFilter;
  String? clientDetailsId;
  List<NetworkHospital> _data = [];
  //int totalPages = 1;
  String _searchText = '';
  bool isUpdate = false;
  int _currentPage = 1;
  int _pageSize = 10;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<NetworkHospital> _filteredData = [];
  List<NetworkHospital> hospitalData = [];
  List<String> _filterOptions = ['Clients No'];
  TextEditingController _searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? _nameHasError = "";
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  int pageSize = 7;
  bool _loading = false;
  // void _handleFilterByChange(String? newValue) {
  //   setState(() {
  //     _selectedFilter = newValue;
  //     _filteredData = getFilteredData();
  //     totalPages = (_filteredData.length / _pageSize).ceil();
  //     _currentPage = 1;
  //   });
  // }

  // List<Endorsement> getFilteredData() {
  //   if (_selectedFilter == null) {
  //     return _data;
  //   } else {
  //     return _data

  //         .where((item) => item.endorsementId == _selectedFilter)
  //         .toList();
  //   }
  // }

  // void _handleSearch(String value) {
  //   setState(() {
  //     _searchText = value;
  //     _filteredData = getFilteredData();

  //     if (_searchText.isNotEmpty) {
  //       _filteredData = _filteredData
  //           .where((item) =>
  //               item.endorsementNumber.contains(_searchText) ||
  //               item.fileName.toLowerCase().contains(_searchText.toLowerCase()))
  //           .toList();
  //     }

  //     totalPages = (_filteredData.length / _pageSize).ceil();
  //     _currentPage = 1;
  //   });
  // }

  int get totalPages {
    return (_networkList.length / pageSize).ceil();
  }

  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
      _filteredData = getFilteredData();
      // _updateDataTable();
    });
  }

  void _handleFilterByChange(String? newValue) {
    setState(() {
      print("Selected Filter: $newValue");
      _selectedFilter = newValue;
      _filteredData = getFilteredData();
      // _updateDataTable();
    });
  }

  List<NetworkHospital> getFilteredData() {
    List<NetworkHospital> filteredData = _data;

    if (_selectedFilter != null) {
      print("Filtering by: $_selectedFilter");
      filteredData = filteredData
          .where((item) => item.noworkHospitalId == _selectedFilter)
          .toList();
    }

    if (_searchText.isNotEmpty) {
      print("Searching for: $_searchText");
      filteredData = filteredData
          .where(
              (item) => item.hospitalName.contains(_searchText.toLowerCase()))
          .toList();
    }

    return filteredData;
  }

  // void _updateDataTable() {
  //   totalPages = (_filteredData.length / _pageSize).ceil();
  //   _currentPage = 1;
  // }

  void initState() {
    super.initState();
    _fetchNetworkDetailsData();
  }

  String rfqId = "ghgj";

  Future<void> _fetchNetworkDetailsData() async {
    try {
      var headers = await ApiServices.getHeaders();

      final getCdBalanceUrl = Uri.parse(
              ApiServices.baseUrl + ApiServices.getAllNetworkHospitalDetails)
          .replace(queryParameters: {
        "clientListId": (widget.clientId).toString(),
        "productId": widget.productIdvar,
      });

      final response = await http.get(getCdBalanceUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        //print(data);

        if (data != null && data.isNotEmpty) {
          final List<NetworkHospital> netwrkList = data
              .map((item) => NetworkHospital(
                    noworkHospitalId: 123,
                    hospitalName: item['hospitalName'] ?? ' ',
                    address: item['address'] ?? ' ',
                    city: item['city'] ?? ' ',
                    state: item['state'] ?? ' ',
                    pincode: item['pinCode'] != null
                        ? int.tryParse(item['pinCode'].toString()) ?? 0
                        : 0,

                    //fileName: item['contact']
                  ))
              .toList();

          setState(() {
            _networkList = netwrkList;
          });
        } else {
          print('Unexpected response format: $data');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (exception) {
      print('Exception: $exception');
    }
  }

  List<NetworkHospital> clientDetailsList = [];

  final url = ApiServices.baseUrl + ApiServices.createClientDetails;

  String? pickedFileName;
  String? UpdatepickedFileName;
  PlatformFile? file;
  PlatformFile? updatefile;
  List<PlatformFile>? pickedFiles;
  List<PlatformFile>? updatepickFile;

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter Name';
    }
    return null;
  }

  void clearTextFeilds() {
    nameController.text = ' ';
    updatepickFile = null;
    pickedFileName = null;
  }

  Future<void> pickFile() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) {
        return; // File picker was canceled or failed
      }

      pickedFiles = result.files;
      setState(() {
        pickedFileName = pickedFiles!.first.name;
        print(pickedFileName);
      });

      if (pickedFiles != null) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File Picked $pickedFileName',
        );
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File Picked $pickedFileName',
      );
    }
  }

  MediaType getContentType(String fileExtension) {
    switch (fileExtension.toLowerCase()) {
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'xlsx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      case 'xls':
        return MediaType('application', 'vnd.ms-excel');
      // Add more cases for other file types as needed
      default:
        return MediaType('application', 'octet-stream'); // Default content type
    }
  }

  Future<void> _uploadFile(BuildContext context) async {
    String? tpaName = widget.tpaName;

    Fluttertoast.showToast(
      msg: '$tpaName is tpa',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP_RIGHT,
      backgroundColor: Color.fromRGBO(4, 7, 17, 1),
      textColor: Colors.white,
    );
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.files.isNotEmpty) {
        pickedFiles = result.files; // Use result.files to assign pickedFiles
        pickedFileName = pickedFiles!.first.name;

        var fileName = pickedFileName!;
        Uint8List fileBytes =
            await pickedFiles!.first.bytes!; // Ensure bytes are loaded

        var fileExtension = fileName.split('.').last;
        var contentType = getContentType(fileExtension);

        var apiUrl = Uri.parse(ApiServices.baseUrl +
                ApiServices.headerValidation_networkHospital)
            .replace(queryParameters: {"tpaName": tpaName});

        var headers = await ApiServices.getHeaders();
        var request = http.MultipartRequest('POST', apiUrl);
        request.headers.addAll(headers);

        var multipartFile = http.MultipartFile.fromBytes(
          'multipartFile',
          fileBytes,
          filename: fileName,
          contentType: contentType,
        );

        request.files.add(multipartFile);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          Map<String, dynamic> validationData = jsonDecode(responseBody);
          bool hospitalNameStatus = validationData['hospitalNameStatus'];
          bool addressStatus = validationData['addressStatus'];
          bool cityStatus = validationData['cityStatus'];
          bool stateStatus = validationData['stateStatus'];
          bool pinCodeStatus = validationData['pinCodeStatus'];

          // Determine overall validation result
          bool overallValidationResult = hospitalNameStatus ||
              addressStatus ||
              cityStatus ||
              stateStatus ||
              pinCodeStatus;

          if (overallValidationResult) {
            _postAdditionalApiCall(context, fileBytes, fileName);
          } else {
            _showErrorDialog(
                context, 'Tpa is not matching . Please try again.');
          }
        } else {
          _showErrorDialog(context, 'HTTP error ${response.statusCode}');
        }
      } else {
        _showErrorDialog(context, 'Please pick a file first.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Empty JSON response from the server.');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Successful'),
          content: Text('All validations passed!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> networkDetailsdata = [];
  Future<void> _postAdditionalApiCall(
      BuildContext context, fileBytes, String fileName) async {
    try {
      String? tpaName = widget.tpaName;

      var headers = await ApiServices.getHeaders();

      final apiUrl = Uri.parse(
              ApiServices.baseUrl + ApiServices.valueValidationNetworkHospital)
          .replace(queryParameters: {"tpaName": tpaName});

      var request = http.MultipartRequest("POST", (apiUrl))
        ..headers.addAll(headers);

      var multipartFile = http.MultipartFile.fromBytes(
        'multipartFile',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);

      final response = await request.send();
      //  print(response);
      if (response.statusCode == 200) {
        final responseStream = await response.stream.bytesToString();

        networkDetailsdata =
            List<Map<String, dynamic>>.from(json.decode(responseStream));

        showEmpDetails(context, networkDetailsdata, fileBytes, fileName);
      } else {
        _showErrorDialog(context, 'HTTP error ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
    }
  }

  Future<void> showEmpDetails(
      BuildContext context,
      List<Map<String, dynamic>> networkDetailsdata,
      Uint8List fileBytes,
      String fileName) async {
    Loader.hideLoader();
    print("data showing");

    if (networkDetailsdata == null) {
      // Handle case where networkDetailsdata is null
      print('networkDetailsdata is null');
      return;
    }

    int successRecords = networkDetailsdata.where((data) {
      return data['hospitalNameStatus'] ??
          false || data['addressStatus'] ??
          false || data['cityStatus'] ??
          false || data['stateStatus'] ??
          false || data['pinCodeStatus'] ??
          false;
    }).length;
    int failedRecords = networkDetailsdata.length - successRecords;
    bool showUploadButton = successRecords == networkDetailsdata.length;

    print(showUploadButton);
    print(failedRecords);
    print(successRecords);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              //  Color(0xFFFFFFFF),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          'Network Hospital Upload ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  // SizedBox(height: 1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          // Your style here...
                          child: Text(
                            'Success Records - $successRecords',
                            style: GoogleFonts.poppins(
                                color: SecureRiskColours.Button_Color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            // Your style here...
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: GestureDetector(
                              onTap: () {
                                // print("dfhgf");
                                // showEmpFailedRecords(context,
                                //     networkDetailsdata, fileBytes, fileName);
                              },
                              child: Text(
                                'Failed Records - $failedRecords',
                                style: GoogleFonts.poppins(
                                  color: Colors
                                      .red, //SecureRiskColours.Button_Color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decorationColor: Colors.red,
                                  // decoration: TextDecoration.underline
                                ),
                                // Your style here...
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              content: SingleChildScrollView(
                child: Container(
                  child: LazyLoadingDataTable(
                    entrollerList: networkDetailsdata,
                  ),
                ),
              ),
              actions: [
                //  if (showUploadButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: SecureRiskColours.Button_Color),
                  onPressed: () async {
                    print(networkDetailsdata);
                    //Loader.showLoader(context);
                    await uploadNetworkHospitalWithTpaName(networkDetailsdata);
                    // renewalcoverageDetailsKey?.currentState
                    //     ?.uploadRenewalEmpdataFile(
                    //         fileBytes, "EmpDepData", fileName);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Upload',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEmpFailedRecords(
      BuildContext context,
      List<Map<String, dynamic>> empDataList,
      Uint8List fileBytes,
      String fileName) {
    Loader.hideLoader();
    int successRecords = empDataList.where((data) {
      return data['hospitalNameStatus'] &&
          data['addressStatus'] &&
          data['cityStatus'] &&
          data['stateStatus'] &&
          data['pinCodeStatus'];
    }).length;
    List<Map<String, dynamic>> empFailedRecords = empDataList.where((data) {
      return !(data['hospitalNameStatus'] &&
          data['addressStatus'] &&
          data['cityStatus'] &&
          data['stateStatus'] &&
          data['pinCodeStatus']);
    }).toList();
    int failedRecords = empDataList.length - successRecords;
    bool showUploadButton = successRecords == empDataList.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          '  Failed Records Employee Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Text(
                              'Failed  Records - $failedRecords',
                              style: GoogleFonts.poppins(
                                  color: SecureRiskColours.Button_Color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              // Your style here...
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                  child: LazyLoadingDataTable(
                    entrollerList: empFailedRecords,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool isEmpDataUploadSuccessful = false;

  Map<String, dynamic> fileResponses = {};

  Future<void> uploadNetworkHospitalWithTpaName(
    List<Map<String, dynamic>> empDataList,
  ) async {
    try {
      var headers = await ApiServices.getHeaders();
      int? clientListId = widget.clientId;
      String? productId = widget.productIdvar;

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.uploadNetworkHospital)
              .replace(queryParameters: {
        "clientListId": clientListId.toString(),
        "productId": productId.toString(),
      });

      final response = await http.post(
        uploadApiUrl,
        headers: headers, // Set headers in options
        body: jsonEncode(empDataList), // Convert list to JSON string
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful upload
        Loader.hideLoader();

        await _fetchNetworkDetailsData();
      } else {
        Loader.hideLoader();
        Fluttertoast.showToast(
          msg: 'Upload failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      // Handle any exceptions
      Loader.hideLoader();
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print('Error: ${e.toString()}'); // Log the error message
    }
  }

  void showErrorDialog(String errorMessage) {
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
                'Failed to download: $errorMessage',
                style: GoogleFonts.poppins(fontSize: 18.0),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
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

  int currentPage = 1;
  List<NetworkHospital> _networkList = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int? indexNumber;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    int snum = startIndex + 1;
    int totalInsurers = _networkList.length;

    final List<NetworkHospital> currentPageNetworkHospitals =
        startIndex < totalInsurers
            ? _networkList.sublist(
                startIndex, endIndex < totalInsurers ? endIndex : totalInsurers)
            : [];
    return Scaffold(
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
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: 240,
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
                              border: Border.all(color: Colors.black26),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton<String>(
                                value: _selectedFilter,
                                onChanged: _handleFilterByChange,
                                items: _filterOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: GoogleFonts.poppins()),
                                  );
                                }).toList(),
                                isExpanded: true,
                                underline: SizedBox(),
                                icon: Icon(Icons.arrow_drop_down),
                                hint: Text('Filter By',
                                    style: GoogleFonts.poppins()),
                              ),
                            ),
                          ),
                        ),
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
                                //   openAddClientDialog(
                                //       context, _fetchData);
                                _uploadFile(context);
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Icon(
                                    //   Icons.add_circle_outline,
                                    //   color: Colors.white,
                                    // ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Upload',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
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
                                backgroundColor: MaterialStateProperty.all(
                                    SecureRiskColours.Button_Color),
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.6,
                    width: screenWidth * 0.8,
                    child: Scrollbar(
                      controller:
                          _horizontalScrollController, // Assign the ScrollController
                      thickness: 10,
                      child: SingleChildScrollView(
                        controller: _horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        //scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: DataTable(
                              //columnSpacing: 305,
                              headingRowHeight: 40,
                              columnSpacing: 120,
                              headingRowColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return SecureRiskColours
                                    .Table_Heading_Color; // Use any color of your choice
                              }),
                              columns: [
                                buildDataColumn("S.no"),
                                buildDataColumn("Hospital Name"),
                                buildDataColumn("Address"),
                                // buildDataColumn("Locality"),
                                buildDataColumn("City"),
                                buildDataColumn("State"),
                                buildDataColumn("Pincode"),
                                //buildDataColumn("File"),
                                //buildDataColumn("Action")
                              ],
                              rows: [
                                // ...cdBalanceList
                                //     .map((cdbalance) =>
                                for (int index = 0;
                                    index < currentPageNetworkHospitals.length;
                                    index++)
                                  DataRow(cells: [
                                    DataCell(Text((_networkList.indexOf(
                                                currentPageNetworkHospitals[
                                                    index]) +
                                            1)
                                        .toString())),
                                    DataCell(Text(
                                        currentPageNetworkHospitals[index]
                                                .hospitalName ??
                                            "N/A")),
                                    DataCell(Text(
                                        currentPageNetworkHospitals[index]
                                                .address ??
                                            "N/A")),
                                    DataCell(Text(
                                        currentPageNetworkHospitals[index]
                                                .city ??
                                            "N/A")),
                                    DataCell(Text(
                                        currentPageNetworkHospitals[index]
                                                .state ??
                                            "N/A")),
                                    DataCell(Text(
                                        currentPageNetworkHospitals[index]
                                            .pincode
                                            .toString())),

                                    // DataCell(Row(
                                    //   children: [
                                    //     IconButton(
                                    //         onPressed: () {
                                    //           // _openEditDialog(
                                    //           //     // insure.cdBalanceId
                                    //           //     1);
                                    //         },
                                    //         icon: Icon(Icons.edit)),
                                    //     IconButton(
                                    //       onPressed: () async {
                                    //         await deleteCDBalanceDetails(
                                    //             // insure.cdBalanceId
                                    //             //     .toString()
                                    //             "1");
                                    //       },
                                    //       icon: Icon(Icons.delete),
                                    //       style: ButtonStyle(
                                    //         foregroundColor:
                                    //             MaterialStateProperty.all(
                                    //                 Colors.red),
                                    //       ),
                                    //     )
                                    //   ],
                                    // ))
                                  ])
                                //     )
                                // .toList()
                              ]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (totalPages > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: currentPage > 1
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                          child: Text('Prev'),
                        ),
                        SizedBox(width: 8.0),
                        Text('$currentPage'),
                        SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: currentPage < totalPages
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                          child: Text(
                            'Next',
                          ),
                        ),
                      ],
                    ),
                ])),
      ),
    ));
  }

  DataColumn buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

class LazyLoadingDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> entrollerList;

  LazyLoadingDataTable({required this.entrollerList});

  @override
  _LazyLoadingDataTableState createState() => _LazyLoadingDataTableState();
}

class _LazyLoadingDataTableState extends State<LazyLoadingDataTable> {
  int visibleRecords = 10; // Number of records initially visible
  int increment = 10; // Number of records to load on each lazy load

  @override
  Widget build(BuildContext context) {
    final ScrollController _horizontalScrollController = ScrollController();
    final ScrollController _verticalScrollController = ScrollController();

    return Column(
      children: [
        Scrollbar(
          thumbVisibility: true,
          controller: _horizontalScrollController,
          thickness: 8,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.grey[300]!; // Set your heading row color
                  },
                ),
                columns: _buildColumns(),
                rows: _buildDataRows(),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: shouldShowLoadMore() ? _loadMoreRecords : _closeScreen,
          child: shouldShowLoadMore()
              ? Text('Load More', style: TextStyle(color: Colors.black))
              : Text('End', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _createDataColumn('Hospital Name'),
      _createDataColumn('Address'),
      _createDataColumn('City'),
      _createDataColumn('State'),
      _createDataColumn('Pincode'),
    ];
  }

  DataColumn _createDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    return List.generate(visibleRecords, (index) {
      if (index < widget.entrollerList.length) {
        Map<String, dynamic> data = widget.entrollerList[index];
        return DataRow(cells: _buildDataCells(data));
      } else {
        return DataRow(cells: [
          DataCell(Text('')), // Placeholder for additional cells
        ]);
      }
    });
  }

  List<DataCell> _buildDataCells(Map<String, dynamic> data) {
    return [
      _buildDataCell(data['hospitalName'], data['hospitalNameStatus']),
      _buildDataCell(data['address'], data['addressStatus']),
      _buildDataCell(data['city'], data['cityStatus']),
      _buildDataCell(data['state'], data['stateStatus']),
      _buildDataCell(data['pinCode'].toString(), data['pinCodeStatus']),
    ];
  }

  DataCell _buildDataCell(String? value, bool? status) {
    return DataCell(
      Text(
        value ?? '',
        style: TextStyle(
          color: status == true ? Colors.black : Colors.red,
        ),
      ),
    );
  }

  void _loadMoreRecords() {
    setState(() {
      visibleRecords += increment;
      if (visibleRecords >= widget.entrollerList.length) {
        visibleRecords = widget.entrollerList.length;
      }
    });
  }

  void _closeScreen() {
    Navigator.pop(context); // Close the current screen
  }

  bool shouldShowLoadMore() {
    return visibleRecords < widget.entrollerList.length;
  }
}

Widget _buildStatusIcon(bool isValid) {
  return Icon(
    isValid ? Icons.check_circle : Icons.cancel,
    color: isValid ? Colors.green : Colors.red,
  );
}
