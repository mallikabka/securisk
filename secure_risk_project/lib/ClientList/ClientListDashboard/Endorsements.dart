import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/FreshPolicyFields/NonEbCoverage.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import 'package:toastification/toastification.dart';

class Endorsement {
  final int endorsementId;
  final String endorsementNumber;
  final String fileName;

  Endorsement({
    required this.endorsementId,
    required this.endorsementNumber,
    required this.fileName,
  });
}

class Endorsements extends StatefulWidget {
  int? clientId;

  String? productIdvar;
  Endorsements({
    Key? key,
    required this.clientId,
    required this.productIdvar,
  }) : super(key: key);
  @override
  State<Endorsements> createState() => _EndorsementsState();
}

class _EndorsementsState extends State<Endorsements> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedFilter;
  String? endorsementId;
  List<Endorsement> _data = [];
  int totalPages = 1;
  String _searchText = '';
  bool isUpdate = false;
  int _currentPage = 1;
  int _pageSize = 10;

  List<Endorsement> _filteredData = [];
  List<String> _filterOptions = ['Endorsements No'];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _endorsementNumber = TextEditingController();

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
  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
      _filteredData = getFilteredData();
      _updateDataTable();
    });
  }

  void _handleFilterByChange(String? newValue) {
    setState(() {
      print("Selected Filter: $newValue");
      _selectedFilter = newValue;
      _filteredData = getFilteredData();
      _updateDataTable();
    });
  }

  List<Endorsement> getFilteredData() {
    List<Endorsement> filteredData = _data;

    if (_selectedFilter != null) {
      print("Filtering by: $_selectedFilter");
      filteredData = filteredData
          .where((item) => item.endorsementNumber == _selectedFilter)
          .toList();
    }

    if (_searchText.isNotEmpty) {
      print("Searching for: $_searchText");
      filteredData = filteredData
          .where((item) =>
              item.endorsementNumber.contains(_searchText.toLowerCase()))
          .toList();
    }

    return filteredData;
  }

  void _updateDataTable() {
    totalPages = (_filteredData.length / _pageSize).ceil();
    _currentPage = 1;
  }

  void initState() {
    super.initState();
    _fetchData();
  }

  String rfqId = "ghgj";

  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      String clientListId = widget.clientId.toString();
      String? productId = widget.productIdvar;
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.getAllEndorsement)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
        "rfqId": rfqId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);
      print('response :$response');
      if (response.statusCode == 200) {
        // Parse the response and update the state
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        // Check if the response contains the expected data structure
        if (data != null && data.isNotEmpty) {
          final List<Endorsement> endorsements = data
              .map((item) => Endorsement(
                    endorsementId: item['endorsementId'] ?? '',
                    endorsementNumber: item['endorsementName'] ?? '',
                    fileName: item['fileName'] ?? '',
                  ))
              .toList();

          setState(() {
            _filteredData = endorsements;
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

  http.MultipartRequest jsonToFormData(
      http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  List<Endorsement> _endorsements = [];

  // final url =
  //     'http://14.99.138.131:9981/clientlist/endorsement/createEndorsement';

  String? pickedFileName;
  String? UpdatepickedFileName;
  PlatformFile? file;
  PlatformFile? updatefile;

  List<PlatformFile>? pickedFiles;

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
        pickedFileName = pickedFiles!.first.name; // Update the pickedFileName
      });
      print(pickedFileName);
      if (pickedFiles != null) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: const Duration(seconds: 2),
          title: 'File Picked $pickedFileName',
        );
      }
      setState(() {
        isFileUploaded = true;
      });
    } catch (e) {
      // Show error message
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Error picking file: $e',
      );
    }
  }

  Future<void> uploadFile(String fileType) async {
    var headers = await ApiServices.getHeaders();
    String clientListId = widget.clientId.toString();
    String? productId = widget.productIdvar;

    try {
      // Check if a file is picked
      if (pickedFileName == null) {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Please pick a file first.',
        );
        return;
      }

      var fileName = pickedFileName!;
      Uint8List fileBytes = pickedFiles!.first.bytes!;
      var fileExtension = fileName.split('.').last;
      MediaType contentType = getContentType(fileExtension);

      var multipartFile = http.MultipartFile.fromBytes(
        'fileName',
        fileBytes,
        filename: fileName,
        contentType: contentType,
      );

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.createEndorsement)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
        "rfqId": rfqId,
      });

      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);

      request.files.add(multipartFile);
      request.fields['endorsementName'] = _endorsementNumber.text;

      final response = await request.send();
      _fetchData();
      clearTextFeilds();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        if (responseData.containsKey('endorsementId')) {
          int? endorsementIds = responseData['endorsementId'];
          print('Endorsement ID: $endorsementIds');

          if (endorsementIds != null) {
            var newEndorsement = Endorsement(
              endorsementId: endorsementIds,
              endorsementNumber: _endorsementNumber.text,
              fileName: fileName,
            );

            _filteredData.add(newEndorsement);
          } else {
            print('Endorsement ID is null or empty');
          }
        }

        // Call fetchData after successful upload
        // await _fetchData();

        // // Show success dialog
        // _showSuccessDialog(context, "bank details Added");

        // // Clear text fields
        // clearTextFeilds();
      } else {
        print('Failed to upload. Status code: ${response.statusCode}');
        // Handle other status codes or show an error notification
      }
    } catch (e, stackTrace) {
      print('Error during file upload: $e');
      print(stackTrace);
      // Handle errors, show user-friendly messages, or log them for further investigation
    }
  }

  void clearTextFeilds() {
    _endorsementNumber.text = ' ';
    updatepickFile = null;
    pickedFileName = null;
  }

  String? endorsementNumberError = "";
  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Field is mandatory';
    }
    return null;
  }

  bool isFileUploaded = false;
  Future<void> createEndorsement() {
    bool localIsFileUploaded = isFileUploaded;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            contentPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Form(
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
                          topRight: Radius.circular(10),
                        ),
                        color: SecureRiskColours.Table_Heading_Color,
                      ),
                      child: Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Create Endorsements',
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        // Endorsement Number Field
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12),
                          child: TextFormField(
                            controller: _endorsementNumber,
                            decoration: InputDecoration(
                              labelText: 'Endorsement Number',
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
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            validator: (value) {
                              setState(() {
                                endorsementNumberError = validateString(value);
                              });
                              return endorsementNumberError;
                            },
                          ),
                        ),
                        SizedBox(height: 20), // Spacer

                        // File Upload Field
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await pickFile();
                                  setState(() {
                                    localIsFileUploaded = isFileUploaded;
                                  }); // Wait for file picking
                                },
                                child: Text("Upload File"),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              if (localIsFileUploaded) Text(pickedFileName!)
                            ],
                          ),
                        ),
                        SizedBox(height: 20), // Spacer

                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (pickedFiles == null || pickedFiles!.isEmpty) {
                                // Show a message if no file is selected
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select a file.'),
                                  ),
                                );
                              } else {
                                try {
                                  await uploadFile("pdf");
                                  Navigator.pop(context);
                                  isFileUploaded = false;
                                } catch (e) {
                                  print('Exception during file upload: $e');
                                }
                              }
                            }
                          },
                          child: Text('Create '),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  List<PlatformFile>? updatepickFile;

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

  Future<void> _handleWebDownload(String name) async {
    try {
      var headers = await ApiServices.getHeaders();
      String clientListId = widget.clientId.toString();
      String? productId = widget.productIdvar;
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.endorsementDownloadapi)
              .replace(queryParameters: {
        "clientlistId": clientListId,
        "productId": productId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        // Extract filename from Content-Disposition header

        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = "$name.zip";
        anchor.click();
        html.Url.revokeObjectUrl(url);
      } else if (response.statusCode == 204) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          width: 280,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          headerAnimationLoop: true,
          animType: AnimType.bottomSlide,
          title: 'INFO',
          desc: 'No Data Uploaded...!',
          showCloseIcon: true,
          btnCancelOnPress: () {
            //  Navigator.of(context).pop();
          },
          btnOkOnPress: () {
            //  Navigator.of(context).pop();
          },
        ).show();
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

  // Future<void> updateFile(String fileType, String endorsementId) async {
  //   var headers = await ApiServices.getHeaders();
  //   print(endorsementId);

  //   try {
  //     if (UpdatepickedFileName == null) {
  //       toastification.showError(
  //         context: context,
  //         autoCloseDuration: Duration(seconds: 2),
  //         title: 'Please pick a file first.',
  //       );
  //       return;
  //     }

  //     String? updateFileName = UpdatepickedFileName!;
  //     print(updateFileName);
  //     Uint8List fileBytes = updatepickFile!.first.bytes!;
  //     var fileExtension = updateFileName.split('.').last;
  //     MediaType contentType = getContentType(fileExtension);

  //     var multipartFile = http.MultipartFile.fromBytes(
  //       'fileName',
  //       fileBytes,
  //       filename: updateFileName,
  //       contentType: contentType,
  //     );

  //     // Check if endorsementId is not null or empty
  //     if (endorsementId != null && endorsementId.isNotEmpty) {
  //       final updateApiUrl = Uri.parse(
  //         ApiServices.baseUrl +
  //             ApiServices.updateEndorsementApi +
  //             endorsementId,
  //       ); // Replace with your actual update file API endpoint
  //       var request = http.MultipartRequest("PUT", updateApiUrl)
  //         ..headers.addAll(headers);
  //       request.files.add(multipartFile);

  //       request.fields['endorsementName'] = _endorsementNumber.text;

  //       final response = await request.send();
  //       _fetchData();
  //       clearTextFeilds();
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         final Map<String, dynamic> responseData =
  //             json.decode(await response.stream.bytesToString());
  //         if (responseData.containsKey('endorsementId')) {
  //           int? endorsementIds = responseData['endorsementId'];
  //           print(endorsementIds);
  //           if (endorsementIds != null) {
  //             var newEndorsement = Endorsement(
  //               endorsementId: endorsementIds,
  //               endorsementNumber: _endorsementNumber.text,
  //               fileName: updateFileName,
  //             );

  //             _filteredData.add(newEndorsement);

  //             setState(() {
  //               updateFileName = null;
  //               _endorsementNumber.clear();
  //             });
  //           } else {
  //             print('Endorsement ID is null or empty');
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {}
  // }

  Future<void> updateFile(String fileType, String endorsementId) async {
    var headers = await ApiServices.getHeaders();
    print(endorsementId);

    try {
      if (UpdatepickedFileName == null) {
        // Show an error message because no file is picked
        // You might want to handle this case appropriately
        return;
      }

      var updateFileName = UpdatepickedFileName!;

      // Proceed with the file update using fileName
      var multipartFile = http.MultipartFile.fromBytes(
        'fileName',
        <int>[], // You need to provide actual file bytes here
        filename: updateFileName,
        contentType: MediaType(
            'application', 'octet-stream'), // Adjust content type as needed
      );

      // Check if endorsementId is not null or empty
      if (endorsementId != null && endorsementId.isNotEmpty) {
        final updateApiUrl = Uri.parse(
          ApiServices.baseUrl +
              ApiServices.updateEndorsementApi +
              endorsementId,
        ); // Replace with your actual update file API endpoint
        var request = http.MultipartRequest("PUT", updateApiUrl)
          ..headers.addAll(headers);
        request.files.add(multipartFile);

        request.fields['endorsementName'] = _endorsementNumber.text;

        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          //  Show success notification and reset pickedFileName
          toastification.showSuccess(
            context: context,
            autoCloseDuration: Duration(seconds: 2),
            title: 'Endorsement updated successfully.....!',
          );

          var updateClient = Endorsement(
            endorsementId: int.parse(endorsementId),
            endorsementNumber: _endorsementNumber.text,
            fileName: updateFileName,
          );
          _filteredData.add(updateClient);

          await _fetchData();
          clearTextFeilds();
        } else {
          // Show an error notification
          toastification.showError(
            context: context,
            autoCloseDuration: Duration(seconds: 2),
            title: 'Update failed.....!',
          );
        }
      } else {
        print('Endorsement ID is null or empty');
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Update failed.....!',
      );
    }
  }

  bool isFileupdateUploaded = false;
  bool updatelocalIsFileUploaded = false;
  Future<void> updateEndorsementForm(String endorsementId) async {
    var headers = await ApiServices.getHeaders();
    try {
      final response = await http.get(
          Uri.parse(
            ApiServices.baseUrl +
                ApiServices.getByIDEndorsement +
                endorsementId,
          ),
          headers: headers);
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          // Parse the response data
          Map<String, dynamic> data = json.decode(response.body);
          print(data);
          // Pre-fill the form fields with the retrieved data
          setState(() {
            _endorsementNumber.text = data['endorsementName'] ?? '';
            UpdatepickedFileName = data['fileName'] ?? '';

            // You might need to handle other fields based on your API response
          });
          print(UpdatepickedFileName);
          // Show the update form
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
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) =>
                        Form(
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
                                topRight: Radius.circular(10),
                              ),
                              color: SecureRiskColours.Table_Heading_Color,
                            ),
                            child: SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'update Endorsements',
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
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              // Endorsement Number Field
                              Container(
                                margin: EdgeInsets.only(left: 12, right: 12),
                                child: TextFormField(
                                  controller: _endorsementNumber,
                                  decoration: InputDecoration(
                                    labelText: 'Endorsement Number',
                                    //keyboardType: TextInputType.number,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 128, 128, 128),
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  validator: (value) {
                                    String trimmedText =
                                        value.toString().trim();
                                    if (trimmedText.isEmpty) {
                                      return 'Please enter an endorsement';
                                    }
                                    // You can add more validation logic here if needed.
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20), // Spacer

                              // File Upload Field
                              Container(
                                margin: EdgeInsets.only(left: 12, right: 12),
                                child: Row(
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await updatepickFiles();
                                              setState(() {
                                                updatelocalIsFileUploaded =
                                                    isFileupdateUploaded;
                                              }); // Wait for file picking
                                            },
                                            child: Text("Upload File"),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          if (updatelocalIsFileUploaded ||
                                              UpdatepickedFileName != null)
                                            Text(UpdatepickedFileName!),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20), // Spacer

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SecureRiskColours.Text_Color,
                                ),
                                onPressed: () async {
                                  await updateFile("pdf", endorsementId);
                                  Navigator.pop(context);
                                  isFileupdateUploaded = false;
                                },
                                child: Text(
                                  'update',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> deleteEndorsement(String endorsementId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete this endorsement?'),
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
        final apiUrl = Uri.parse(ApiServices.baseUrl +
            ApiServices.deleteEndorsement +
            endorsementId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('Endorsement deleted successfully');
          await _fetchData();
          setState(() {
            // Update _data list to reflect changes
            _data.removeWhere(
                (endorsement) => endorsement.endorsementId == endorsementId);
          });
        } else {
          print(
              'Failed to delete endorsement. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> downloadFile(String endorsementId, String fileName) async {
    final urlString =
        ApiServices.baseUrl + ApiServices.downloadApi + endorsementId;

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Check if the response contains valid file data
        if (response.bodyBytes.isNotEmpty) {
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = fileName;

          anchor.click();
          html.Url.revokeObjectUrl(url);
        } else {
          // Handle empty file data
          showErrorDialog('Empty file data');
        }
      } else {
        // Handle other HTTP status codes
        showErrorDialog(
            'Failed to download. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      showErrorDialog('Failed to download. Exception: $e');
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

  Future<void> updatepickFiles() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'xlsx', 'xls'],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      updatepickFile = result.files;
      setState(() {
        UpdatepickedFileName = updatepickFile!.first.name;
        print(UpdatepickedFileName);
      });

      if (UpdatepickedFileName != null) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File Picked $UpdatepickedFileName',
        );
      }
      setState(() {
        isFileupdateUploaded = true;
      });
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File Picked $UpdatepickedFileName',
      );
    }
  }

  void _clearTable() {
    setState(() {
      _filteredData.clear(); // Clear the list of rows
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
//  height: screenHeight * 0.8,
//                 width: screenWidth * 0.8,

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
                  children: [
                    Flexible(
                      child: Container(
                        width: 240,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _handleSearch,
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
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () async {
                            await _handleWebDownload("endorsementDownload");
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Download All ',
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
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            createEndorsement();
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Create ',
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
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            _clearTable();
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  'Clear ',
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
                                  color: Colors.white.withOpacity(
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
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                height: screenHeight * 0.6,
                width: screenWidth * 0.8,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      //columnSpacing: 305,
                      columnSpacing: 160,
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return SecureRiskColours
                            .Table_Heading_Color; // Use any color of your choice
                      }),
                      columns: [
                        DataColumn(
                          label: Text(
                            'S.No',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Endorsement number',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'File',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                      rows: [
                        ..._filteredData
                            .map((ends) => DataRow(cells: [
                                  DataCell(Text(
                                      (_filteredData.indexOf(ends) + 1)
                                          .toString())),
                                  DataCell(
                                      Text(ends.endorsementNumber ?? "N/A")),
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                        downloadFile(
                                            ends.endorsementId.toString(),
                                            ends.fileName);
                                      },
                                      child: Text(
                                        ends.fileName ?? "N/A",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            color:
                                                Color.fromARGB(255, 7, 79, 138),
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            print('Edit button pressed');
                                            updateEndorsementForm(
                                                ends.endorsementId.toString());
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                        onPressed: () async {
                                          await deleteEndorsement(
                                              ends.endorsementId.toString());
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
                                ]))
                            .toList()
                      ]),
                ),
              ),
            ])),
      ),
    ));
  }
}
