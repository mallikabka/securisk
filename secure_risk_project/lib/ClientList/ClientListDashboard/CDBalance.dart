import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loginapp/Colours.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Graphs/Donut.dart';
import 'package:loginapp/Service.dart';
import 'package:loginapp/Utilities/CircularLoader.dart';
import 'package:mime/mime.dart';
import 'dart:html' as html;
import 'package:toastification/toastification.dart';

class CdBalance {
  final int cdBalanceId;
  final String policyNumber;
  final String transactionType;
  final String paymentDate;
  final String cdDbCd;
  final int? amount;
  final double balance;
//  final String fileName;

  CdBalance({
    required this.cdBalanceId,
    required this.policyNumber,
    required this.transactionType,
    required this.paymentDate,
    required this.cdDbCd,
    required this.amount,
    required this.balance,
    //required this.fileName
  });
}

class CdBalanceDetatis extends StatefulWidget {
  int clientId;
  String productId;
  CdBalanceDetatis({
    Key? key,
    required this.clientId,
    required this.productId,
  }) : super(key: key);

  @override
  State<CdBalanceDetatis> createState() => _CdBalanceDetatisState();
}

class _CdBalanceDetatisState extends State<CdBalanceDetatis> {
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _branchController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _ifscCodeController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _accountHolderNumberController =
      TextEditingController();
  TextEditingController _searchController = TextEditingController();

  List<String> _filterOptions = ['Policy No'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedFilter;
  List<CdBalance> _data = [];

  String _searchText = '';
  bool isUpdate = false;
  int pageSize = 7;
  List<CdBalance> _filteredData = [];

  final ScrollController _horizontalScrollController = ScrollController();
  void clearTextFeilds() {
    _bankNameController.text = ' ';
    _branchController.text = ' ';

    _locationController.text = ' ';
    _ifscCodeController.text = ' ';
    _accountNumberController.text = ' ';
    _accountHolderNumberController.text = ' ';
  }

  Future<void> _fetchCDBalanceData() async {
    try {
      var headers = await ApiServices.getHeaders();

      final getCdBalanceUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.getCdBalanceDetails)
              .replace(queryParameters: {
        "clientId": (widget.clientId).toString(),
        "productId": widget.productId,
      });

      final response = await http.get(getCdBalanceUrl, headers: headers);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print(data);

        if (data != null && data.isNotEmpty) {
          final List<CdBalance> cdList = data
              .map((item) => CdBalance(
                    cdBalanceId: item['cd_balanceId'],
                    policyNumber: item['policyNumber'] ?? ' ',
                    transactionType: item['transactionType'] ?? ' ',
                    paymentDate: item['paymentDate'] ?? ' ',
                    cdDbCd: item['cr_DB_CD'] ?? ' ',
                    amount: item['amount'] != null
                        ? int.tryParse(item['amount'].toString()) ?? 0
                        : 0,
                    balance: (item['balance'] is double)
                        ? item['balance']
                        : double.tryParse(item['balance']?.toString() ?? '') ??
                            0.0,

                    //fileName: item['contact']
                  ))
              .toList();

          setState(() {
            _cdBalanceList = cdList;
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

  Future<void> updateCdBalance(
    int cdBalanceId,
    String? policyNumber,
    String? transactionType,
    double? balance,
    String? paymentDate,
    int? amount,
    String? cdDbCd,
    void _fetchData,
    BuildContext context,
    //BuildContext context,
  ) async {
    ("api call made");

    final Map<String, dynamic> requestBody = {
      "cdId": cdBalanceId,
      "policyNumber": policyNumber,
      "transactionType": transactionType,
      //   "designation":designation,
      "paymentDate": paymentDate,
      "cdDbCd": cdDbCd,
      "amount": amount.toString(),
      "balance": balance
    };
    (requestBody);

    //try {
    var headers = await ApiServices.getHeaders();

    final response = await http.patch(
      Uri.parse(ApiServices.baseUrl +
          ApiServices.updateCdBalance +
          cdBalanceId.toString()),
      body: jsonEncode(requestBody),
      headers: headers,
    );
    print("************************response*****************");
    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      (response.body);
      await _fetchCDBalanceData();
      Navigator.of(context).pop();

      _showSuccessDialog(context, "Cd Balance Updated");
      clearTextFeilds();
    } else {
      Navigator.of(context).pop();
      _showErrorDialog(context, "sdsfsf");
      ('Error: ${response.statusCode}');
    }
  }

  Future<void> deleteCDBalanceDetails(String cdId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete?'),
            content: Text(
                'Are you sure you want to delete this cd balance detatils?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );

      // Check the user's choice
      if (confirmed == true) {
        // User clicked "OK"
        final apiUrl =
            Uri.parse(ApiServices.baseUrl + ApiServices.deleteCdBalance + cdId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('Delete CDBalance details deleted successfully');
          _fetchCDBalanceData();
        } else {
          print(
              'Failed to Delete CDBalance details. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void initState() {
    super.initState();

    _fetchCDBalanceData();
  }

  void _handleFilterByChange(String? newValue) {
    setState(() {
      print("Selected Filter: $newValue");
      _selectedFilter = newValue;
      _filteredData = getFilteredData();
      //  _updateDataTable();
    });
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

  void _showErrorDialog(BuildContext context, String s) {
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

  String? pickedFileName;
  PlatformFile? file;
  String? filePath;

  Future<void> uploadFileInCdBalance(PlatformFile? selectedFile) async {
    String clientId = widget.clientId.toString();
    String? productId = widget.productId;
    var headers = await ApiServices.getHeaders();
    // PlatformFile? selectedFile = await pickFileToUploadCdBalance();
    if (selectedFile != null) {
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.uploadCdBalance)
              .replace(queryParameters: {
        "clientId": clientId,
        "productId": productId,
      });
      // Create a multipart request
      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);
      print("file Picked");

      // Convert PlatformFile to MultipartFile
      var multipartFile = http.MultipartFile.fromBytes(
        'multipartFile', // The key name for the file, as expected by the server
        selectedFile.bytes!,
        filename: selectedFile.name,
        contentType: MediaType(
            'application',
            lookupMimeType(selectedFile
                .name)!), // Optionally set the MIME type of the file here, if known
      );

      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();
      _fetchCDBalanceData();
      if (response.statusCode == 200) {
        print("File uploaded successfully");
      } else {
        print("Failed to upload file");
      }
    } else {
      print("No file was selected.");
    }
  }

  exportCdBalanceDetails(String fileName) async {
    var headers = await ApiServices.getHeaders();
    int clientListId = widget.clientId;
    int? productId = int.tryParse(widget.productId);

    String urlString =
        "${ApiServices.baseUrl}${ApiServices.exportCdBalanceDetails}clientId=$clientListId&productId=$productId";

    try {
      // var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([
          response.bodyBytes
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = fileName;

        anchor.click();
        html.Url.revokeObjectUrl(url);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFFFFFFFF),
              surfaceTintColor: Colors.white,
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
  }

  List<PlatformFile>? pickedFiles;

  Future<void> _uploadFile(BuildContext context) async {
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

        var apiUrl = Uri.parse(
            ApiServices.baseUrl + ApiServices.cdBalanceHeaderValidationApi);

        var headers = await ApiServices.getHeaders();
        var request = http.MultipartRequest('POST', apiUrl);
        request.headers.addAll(headers);

        var multipartFile = http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
          contentType: contentType,
        );

        request.files.add(multipartFile);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          Map<String, dynamic> validationData = jsonDecode(responseBody);
          bool policyNumberStatus = validationData['policyNumber'];
          bool transactionTypeStatus = validationData['transactionType'];
          bool paymentDateStatus = validationData['paymentDate'];
          bool amountStatus = validationData['amount'];
          bool balanceStatus = validationData['balance'];
          bool cr_DB_CDStatus = validationData['cr_DB_CD'];

          // Determine overall validation result
          bool overallValidationResult = policyNumberStatus ||
              transactionTypeStatus ||
              paymentDateStatus ||
              amountStatus ||
              balanceStatus ||
              cr_DB_CDStatus;

          if (overallValidationResult) {
            _postAdditionalApiCall(context, fileBytes, fileName);
          } else {
            _showErrorDialog(
                context, 'File is not matching . Please try again.');
          }
        } else {
          _showErrorDialog(context, 'HTTP error ${response.statusCode}');
        }
      } else {
        _showErrorDialog(context, 'Please pick a file first.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: $e');
    }
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

  void showSuccessDialog(BuildContext context) {
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

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Validation Failed !',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
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

  MediaType getContentType(String fileExtension) {
    switch (fileExtension.toLowerCase()) {
      case 'xlsx':
      case 'xls':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  List<Map<String, dynamic>> cdBalancedata = [];
  Future<void> _postAdditionalApiCall(
      BuildContext context, fileBytes, String fileName) async {
    try {
      //String? tpaName = widget.tpaNameVar;
      print("_postAdditionalApiCall");

      var apiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.cdBalanceValueValidation);

      var headers = await ApiServices.getHeaders();
      var request = http.MultipartRequest('POST', apiUrl);
      request.headers.addAll(headers);

      var multipartFile = http.MultipartFile.fromBytes(
        'multipartFile',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseStream = await response.stream.bytesToString();
        cdBalancedata =
            List<Map<String, dynamic>>.from(json.decode(responseStream));
        print('cd balnace data:$cdBalancedata');

        showUploadDetails(context, cdBalancedata, fileBytes, fileName);
      } else {
        _showErrorDialog(context, 'HTTP error ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
    }
  }

  bool isEmpDataUploadSuccessful = false;

  Map<String, dynamic> fileResponses = {};

  Future<void> uploadCdBalanceFile(
    List<Map<String, dynamic>> empDataList,
  ) async {
    try {
      var headers = await ApiServices.getHeaders();
      int? clientListId = widget.clientId;
      String? productId = widget.productId;

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.uploadCdBalance)
              .replace(queryParameters: {
        "clientId": clientListId.toString(),
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
        await _fetchCDBalanceData();
        // _fetchData(
        //     _selectedMonth); // Fetch updated data after successful upload
        Fluttertoast.showToast(
          msg: 'Uploaded successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // setState(() {
        //   isEmpDataUploadSuccessful = true;
        // });
      } else {
        // Handle upload failure
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

  Future<void> showUploadDetails(
      BuildContext context,
      List<Map<String, dynamic>> CDdata,
      Uint8List fileBytes,
      String fileName) async {
    Loader.hideLoader();
    print("data showing");

    if (CDdata == null) {
      // Handle case where CDdata is null
      print('cd Balance is null');
      return;
    }

    int successRecords = CDdata.where((data) {
      return data['policyNumberStatus'] ??
          false || data['transactionTypeStatus'] ??
          false || data['paymentDateStatus'] ??
          false || data['amountStatus'] ??
          false || data['balanceStatus'] ??
          false || data['cr_DB_CDStatus'] ??
          false;
    }).length;
    int failedRecords = CDdata.length - successRecords;
    bool showUploadButton = successRecords == CDdata.length;
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
                          '  CdBalance Upload ',
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
                                // showEmpFailedRecords(context, CDdata,
                                //     fileBytes, fileName);
                              },
                              child: Text(
                                'Failed Records - $failedRecords',
                                style: GoogleFonts.poppins(
                                  color: Colors
                                      .red, //SecureRiskColours.Button_Color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decorationColor: Colors.red,
                                  //  decoration: TextDecoration.underline
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
                    cdDataList: CDdata,
                  ),
                ),
              ),
              actions: [
                // if (showUploadButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: SecureRiskColours.Button_Color),
                  onPressed: () async {
                    print(CDdata);
                    //Loader.showLoader(context);
                    await uploadCdBalanceFile(CDdata);
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
      return data['policyNumberStatus'] &&
          data['transactionTypeStatus'] &&
          data['paymentDateStatus'] &&
          data['amountStatus'] &&
          data['balanceStatus'] &&
          data['cr_DB_CDStatus'];
    }).length;
    List<Map<String, dynamic>> empFailedRecords = empDataList.where((data) {
      return !(data['policyNumberStatus'] &&
          data['transactionTypeStatus'] &&
          data['paymentDateStatus'] &&
          data['amountStatus'] &&
          data['balanceStatus'] &&
          data['cr_DB_CDStatus']);
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
                    cdDataList: empFailedRecords,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openUpdateCdBalanceDialog(int CdId) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Set<Department> department = _departmentlist.toSet();
    // Set<Designation> designation = _designationlist.toSet();
    // Set<String> gend = _genderlist.toSet();
    // Set<String> roleList = _roleList.toSet();
    List<CdBalance> filteredData = _cdBalanceList
        .where((cdbalance) => cdbalance.cdBalanceId == CdId)
        .toList();
    final TextEditingController policyNumberController =
        TextEditingController(text: filteredData.first.policyNumber);
    final int cdBalanceId = filteredData.first.cdBalanceId;
    final TextEditingController transactionTypeController =
        TextEditingController(text: filteredData.first.transactionType);

    final TextEditingController paymentDateController =
        TextEditingController(text: filteredData.first.paymentDate);

//  final TextEditingController dateOfbirthController =
//         TextEditingController(text: filteredData.first.dateOfBirth);

    final TextEditingController amountController =
        TextEditingController(text: (filteredData.first.amount).toString());

    final TextEditingController balanceController =
        TextEditingController(text: (filteredData.first.balance).toString());

    final TextEditingController cdDbCdController =
        TextEditingController(text: filteredData.first.cdDbCd);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            contentPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 680,
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
                              'Update CDBalance',
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: policyNumberController,
                              decoration: InputDecoration(
                                labelText: 'Policy No',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a policy number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: transactionTypeController,
                              decoration: InputDecoration(
                                labelText: 'Transaction Type',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: amountController,
                              decoration: InputDecoration(
                                labelText: 'Amount',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter relaitonship';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(right: 12, left: 8),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: balanceController,
                              decoration: InputDecoration(
                                labelText: 'Balance',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a employee id';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 15),
                        //   child: Container(
                        //     margin: EdgeInsets.only(left: 12, right: 12),
                        //     width: 300,
                        //     height: 40,
                        //     child: DropdownButtonFormField<String>(
                        //       value: selectedGender,
                        //       onChanged: (newValue) {
                        //         _onGenderChanged(newValue);
                        //         selectedGender = newValue;
                        //       },
                        //       items: _genderlist.toSet().map((gender) {
                        //         return DropdownMenuItem<String>(
                        //           value: gender,
                        //           child: Text(gender),
                        //         );
                        //       }).toList(),
                        //       decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.symmetric(
                        //             horizontal: 10, vertical: 5),
                        //         labelText: 'Gender',
                        //         border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.all(
                        //             Radius.circular(3),
                        //           ),
                        //           borderSide: BorderSide(
                        //             color: Color.fromARGB(255, 128, 128, 128),
                        //           ),
                        //         ),
                        //       ),
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return 'Please select a gender';
                        //         }
                        //         return null;
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            width: 300,
                            height: 40,
                            margin: EdgeInsets.only(right: 8),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Material(
                                shadowColor: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                child: TextFormField(
                                  controller: paymentDateController,
                                  readOnly: true, // Prevents manual text input
                                  decoration: InputDecoration(
                                    labelText: 'Payment Date',
                                    hintText: 'Payment Date',
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 13),
                                    suffixIcon: GestureDetector(
                                      onTap: () async {
                                        DateTime? selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );

                                        if (selectedDate != null) {
                                          String formattedDate =
                                              "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                          paymentDateController.text =
                                              formattedDate;
                                        }
                                      },
                                      child: Icon(
                                        Icons.calendar_month_sharp,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 18),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            width: 300,
                            height: 40,
                            child: TextFormField(
                              controller: cdDbCdController,
                              decoration: InputDecoration(
                                labelText: 'CR_DB_CDController',
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 15),
                        //   child: Container(
                        //     margin: EdgeInsets.only(left: 12, right: 12),
                        //     width: 300,
                        //     height: 40,
                        //     child: TextFormField(
                        //       controller: phoneNumberController,
                        //       decoration: InputDecoration(
                        //         labelText: 'Phone Number',
                        //         border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.all(
                        //             Radius.circular(3),
                        //           ),
                        //           borderSide: BorderSide(
                        //             color: Color.fromARGB(255, 128, 128, 128),
                        //           ),
                        //         ),
                        //       ),
                        //       keyboardType: TextInputType.number,
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return 'Please enter a Phone Number';
                        //         }
                        //         return null;
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(width: 15),
                    //     Padding(
                    //       padding: EdgeInsets.only(bottom: 15),
                    //       child: Container(
                    //         margin: EdgeInsets.only(right: 8),
                    //         width: 300,
                    //         height: 40,
                    //         child: DropdownButtonFormField<Designation>(
                    //           isExpanded: true,
                    //           value: selecteddesignation,
                    //           onChanged: (newValue) {
                    //             if (newValue != null) {
                    //               desinationId = newValue
                    //                   .id; // Capture the locationId when a location is selected
                    //             }
                    //             _onDesignationChanged(newValue.toString());
                    //             selecteddesignation = newValue;
                    //             (desinationId);
                    //           },
                    //           items: designation.toSet().map((designation) {
                    //             return DropdownMenuItem<Designation>(
                    //               value:
                    //                   designation, // Set the value to the entire Location object
                    //               child: Text(designation.designationName),
                    //             );
                    //           }).toList(),
                    //           decoration: InputDecoration(
                    //             contentPadding: EdgeInsets.symmetric(
                    //                 horizontal: 10, vertical: 5),
                    //             labelText: 'Designation',
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(3),
                    //               ),
                    //               borderSide: BorderSide(
                    //                 color: Color.fromARGB(255, 128, 128, 128),
                    //               ),
                    //             ),
                    //           ),
                    //           validator: (value) {
                    //             if (value == null ||
                    //                 value.designationName.isEmpty) {
                    //               return 'Please select a designation';
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(width: 15),
                    //     Padding(
                    //       padding: EdgeInsets.only(bottom: 15),
                    //       child: Container(
                    //         margin: EdgeInsets.only(left: 12, right: 12),
                    //         width: 300,
                    //         height: 40,
                    //         child: DropdownButtonFormField<Department>(
                    //           //    filteredData.first.department
                    //           value: selecteddepartment,
                    //           onChanged: (newValue) {
                    //             if (newValue != null) {
                    //               departmentId = newValue
                    //                   .id; // Capture the locationId when a location is selected
                    //             }
                    //             // onDepratmentChanged(newValue.toString());
                    //             selecteddepartment = newValue;
                    //           },
                    //           items: department.toSet().map((department) {
                    //             return DropdownMenuItem<Department>(
                    //               value:
                    //                   department, // Set the value to the entire Location object
                    //               child: Text(department.departmentName),
                    //             );
                    //           }).toList(),
                    //           decoration: InputDecoration(
                    //             contentPadding: EdgeInsets.symmetric(
                    //                 horizontal: 10, vertical: 5),
                    //             labelText: 'Department',
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(3),
                    //               ),
                    //               borderSide: BorderSide(
                    //                 color: Color.fromARGB(255, 128, 128, 128),
                    //               ),
                    //             ),
                    //           ),
                    //           validator: (value) {
                    //             if (value == null ||
                    //                 value.departmentName.isEmpty) {
                    //               return 'Please select a Department';
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     SizedBox(width: 15),
                    //     Padding(
                    //       padding: EdgeInsets.only(bottom: 15),
                    //       child: Container(
                    //         margin: EdgeInsets.only(right: 8),
                    //         width: 300,
                    //         height: 40,
                    //         child: DropdownButtonFormField<String>(
                    //           value: selectedRole,
                    //           onChanged: (newValue) {
                    //             //  _onRoleChanged(newValue);
                    //             selectedRole = newValue;
                    //           },
                    //           items: _roleList.toSet().map((role) {
                    //             return DropdownMenuItem<String>(
                    //               value: role,
                    //               child: Text(role),
                    //             );
                    //           }).toList(),
                    //           decoration: InputDecoration(
                    //             contentPadding: EdgeInsets.symmetric(
                    //                 horizontal: 10, vertical: 5),
                    //             labelText: 'Role',
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(3),
                    //               ),
                    //               borderSide: BorderSide(
                    //                 color: Color.fromARGB(255, 128, 128, 128),
                    //               ),
                    //             ),
                    //           ),
                    //           validator: (value) {
                    //             if (value == null || value.isEmpty) {
                    //               return 'Please select a role';
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 18,
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.only(bottom: 15),
                    //       child: Container(
                    //         margin: EdgeInsets.only(left: 8, right: 12),
                    //         width: 300,
                    //         height: 40,
                    //         child: TextFormField(
                    //           controller: sumInsuredController,
                    //           decoration: InputDecoration(
                    //             labelText: 'Sum Insured',
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(3),
                    //               ),
                    //               borderSide: BorderSide(
                    //                 color: Color.fromARGB(255, 128, 128, 128),
                    //               ),
                    //             ),
                    //           ),
                    //           keyboardType: TextInputType.number,
                    //           validator: (value) {
                    //             if (value == null || value.isEmpty) {
                    //               return 'Please enter a Phone Number';
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: SecureRiskColours.Button_Color,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ("passed if");
                            //                              String? cd_balanceId,
                            //   String? policyNumber,
                            //   String? transactionType,
                            //   String? paymentDate,
                            //   int amount,
                            //   int balance,
                            //   String cr_DB_CD,
                            //   BuildContext context,
                            //  // void Function() _fetchData,
                            //   int memberDetailsId,

                            updateCdBalance(
                              cdBalanceId,
                              policyNumberController.text,
                              transactionTypeController.text,
                              double.tryParse(paymentDateController.text),
                              amountController.text,
                              int.tryParse(balanceController.text) ?? 0,
                              cdDbCdController.text,
                              _fetchCDBalanceData,
                              context,
                            );
                            //clearTextFeilds();
                          }
                        },
                        child: Text('Update',
                            style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  //***********************Upload Validation ennd*************** */

  // Future<void> updateCdBalance(
  //   int cdBalanceId,
  //   String? policyNumber,
  //   String? transactionType,
  //   double? balance,
  //   String? paymentDate,
  //   int? amount,
  //   String? cdDbCd,
  //   BuildContext context,
  //   //BuildContext context,
  // ) async {
  //   ("api call made");

  //   final Map<String, dynamic> requestBody = {
  //     "cdId": cdBalanceId,
  //     "policyNumber": policyNumber,
  //     "transactionType": transactionType,
  //     //   "designation":designation,
  //     "paymentDate": paymentDate,
  //     "cdDbCd": cdDbCd,
  //     "amount": amount.toString(),
  //     "balance": balance
  //   };
  //   (requestBody);

  //   //try {
  //   var headers = await ApiServices.getHeaders();

  //   final response = await http.put(
  //     Uri.parse(ApiServices.baseUrl +
  //         ApiServices.updateInsure +
  //         cdBalanceId.toString()),
  //     body: jsonEncode(requestBody),
  //     headers: headers,
  //   );
  //   print(response);
  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     (response.body);
  //     await _fetchCDBalanceData();
  //     Navigator.of(context).pop();

  //     _showSuccessDialog(context, "Cd Balance Updated");
  //     clearTextFeilds();
  //   } else {
  //     Navigator.of(context).pop();
  //     _showErrorDialog(context, "sdsfsf");
  //     ('Error: ${response.statusCode}');
  //   }
  // }

  List<CdBalance> getFilteredData() {
    List<CdBalance> filteredData = _data;

    // if (_selectedFilter != null) {
    //   print("Filtering by: $_selectedFilter");
    //   filteredData = filteredData
    //       .where((item) => item.cdBalanceId == _selectedFilter)
    //       .toList();
    // }

    if (_searchText.isNotEmpty) {
      print("Searching for: $_searchText");
      filteredData = filteredData
          .where(
              (item) => item.policyNumber.contains(_searchText.toLowerCase()))
          .toList();
    }

    return filteredData;
  }

  // void _updateDataTable() {
  //   totalPages = (_filteredData.length / pageSize).ceil();
  //   currentPage = 1;
  // }
  int get totalPages {
    return (_cdBalanceList.length / pageSize).ceil();
  }

  // void _handleSearch(String value) {
  //   setState(() {
  //     _searchText = value;
  //     _filteredData = getFilteredData();
  //     _updateDataTable();
  //   });
  // }

  int currentPage = 1;

  List<CdBalance> _cdBalanceList = [];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int? indexNumber;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    int snum = startIndex + 1;
    int totalInsurers = _cdBalanceList.length;

    final List<CdBalance> currentPageCdBalances = startIndex < totalInsurers
        ? _cdBalanceList.sublist(
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
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        width: 240,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          //onChanged: _handleSearch,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            labelText: 'Search',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black26,
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
                        width: 220,
                        height: 38,
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
                                child:
                                    Text(value, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            hint:
                                Text('Filter By', style: GoogleFonts.poppins()),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () async {
                            await exportCdBalanceDetails("cdBalance");
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Export ',
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
                      width: 10,
                    ),
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () async {
                            //await uploadFileInCdBalanceHeaderValidation();
                            //await uploadFileInCdBalance();
                            await _uploadFile(context);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Upload',
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
                    ///physics: AlwaysScrollableScrollPhysics(),
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    //scrollDirection: Axis.vertical,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: DataTable(
                          //columnSpacing: 305,
                          headingRowHeight: 40,
                          columnSpacing: 80,
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return SecureRiskColours
                                .Table_Heading_Color; // Use any color of your choice
                          }),
                          columns: [
                            buildDataColumn("S.no"),
                            buildDataColumn("Policy Number"),
                            buildDataColumn("Transaction Type"),
                            buildDataColumn("Payment Date"),
                            buildDataColumn("Amount"),
                            buildDataColumn("CD/DB/CD"),
                            buildDataColumn("Balance"),
                            buildDataColumn("File"),
                            buildDataColumn("Action")
                          ],
                          rows: [
                            // ...cdBalanceList
                            //     .map((cdbalance) =>
                            for (int index = 0;
                                index < currentPageCdBalances.length;
                                index++)
                              DataRow(cells: [
                                DataCell(Text((_cdBalanceList.indexOf(
                                            currentPageCdBalances[index]) +
                                        1)
                                    .toString())),
                                DataCell(Text(
                                    currentPageCdBalances[index].policyNumber ??
                                        "N/A")),
                                DataCell(Text(currentPageCdBalances[index]
                                        .transactionType ??
                                    "N/A")),
                                DataCell(Text(
                                    currentPageCdBalances[index].paymentDate ??
                                        "N/A")),
                                DataCell(Text(
                                    currentPageCdBalances[index].cdDbCd ??
                                        "N/A")),
                                DataCell(Text(currentPageCdBalances[index]
                                    .amount
                                    .toString())),
                                DataCell(Text(currentPageCdBalances[index]
                                        .balance
                                        .toString() ??
                                    "N/A")),
                                DataCell(Text("cdBalance.xls")),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _openUpdateCdBalanceDialog(
                                              currentPageCdBalances[index]
                                                  .cdBalanceId);
                                        },
                                        icon: Icon(Icons.edit)),
                                    IconButton(
                                      onPressed: () async {
                                        await deleteCDBalanceDetails(
                                            // insure.cdBalanceId
                                            //     .toString()
                                            currentPageCdBalances[index]
                                                .cdBalanceId
                                                .toString());
                                      },
                                      icon: Icon(Icons.delete),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                      ),
                                    )
                                  ],
                                ))
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
  final List<Map<String, dynamic>> cdDataList;

  LazyLoadingDataTable({required this.cdDataList});

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
      _createDataColumn('Policy Number'),
      _createDataColumn('Transaction Type'),
      _createDataColumn('Payment Date'),
      _createDataColumn('Amount'),
      _createDataColumn('Balance'),
      _createDataColumn('Cr_Db_Cd')
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
      if (index < widget.cdDataList.length) {
        print('length of data :$index');
        Map<String, dynamic> data = widget.cdDataList[index];
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
      _buildDataCell(data['policyNumber'], data['policyNumberStatus']),
      _buildDataCell(data['transactionType'], data['transactionTypeStatus']),
      _buildDataCell(data['paymentDate'], data['paymentDateStatus']),
      _buildDataCell(data['amount'].toString(), data['amountStatus']),
      _buildDataCell(data['balance'].toString(), data['balanceStatus']),
      _buildDataCell(data['cr_DB_CD'], data['cr_DB_CDStatus'])
    ];
  }

  DataCell _buildDataCell(String? value, bool? status) {
    return DataCell(
      Text(
        value ?? ' ',
        style: TextStyle(
          color: status == true ? Colors.black : Colors.red,
        ),
      ),
    );
  }

  void _loadMoreRecords() {
    setState(() {
      visibleRecords += increment;
      if (visibleRecords >= widget.cdDataList.length) {
        visibleRecords = widget.cdDataList.length;
      }
    });
  }

  void _closeScreen() {
    Navigator.pop(context); // Close the current screen
  }

  bool shouldShowLoadMore() {
    return visibleRecords < widget.cdDataList.length;
  }
}

Widget _buildStatusIcon(bool isValid) {
  return Icon(
    isValid ? Icons.check_circle : Icons.cancel,
    color: isValid ? Colors.green : Colors.red,
  );
}
