import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:toastification/toastification.dart';

class Ecardsmenu {
  final int ecardId;
  final String filename;
  Ecardsmenu({required this.filename, required this.ecardId});
}

class Ecards extends StatefulWidget {
  int? clientId;

  String? productId;
  Ecards({
    Key? key,
    required this.clientId,
    required this.productId,
  }) : super(key: key);

  @override
  State<Ecards> createState() => _EcardsState();
}

class _EcardsState extends State<Ecards> {
  void initState() {
    super.initState();
    _fetchData();
  }

  bool isFileupdateUploaded = false;
  bool updatelocalIsFileUploaded = false;
  bool isFileUploaded = false;
  bool localIsFileUploaded = false;
  List<Ecardsmenu> _filteredData = [];
  Future<void> _fetchData() async {
    try {
      var headers = await ApiServices.getHeaders();
      String clientListId = widget.clientId.toString();
      String? productId = widget.productId;
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.getAllEcards)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        // Parse the response and update the state
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        // Check if the response contains the expected data structure
        if (data != null && data.isNotEmpty) {
          final List<Ecardsmenu> endorsements = data
              .map((item) => Ecardsmenu(
                    ecardId: item['ecardId'],
                    filename: item['fileName'] ?? '',
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
      setState(() {
        isFileUploaded = true;
      });
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File Picked $pickedFileName',
      );
    }
  }

  Future<void> uploadFile(String fileType) async {
    var headers = await ApiServices.getHeaders();
    String clientListId = widget.clientId.toString();
    String? productId = widget.productId;

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

      print(fileName);
      var multipartFile = http.MultipartFile.fromBytes(
        'fileName',
        fileBytes,
        filename: fileName,
        contentType: contentType,
      );

      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.createEcards)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
      });

      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);

      request.files.add(multipartFile);

      final response = await request.send();
      _fetchData();
      clearTextFeilds();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        if (responseData.containsKey('ecardId')) {
          int? endorsementIds = responseData['ecardId'];
          print('Ecards ID: $endorsementIds');

          if (endorsementIds != null) {
            var newEndorsement = Ecardsmenu(
              ecardId: responseData['ecardId'],
              filename: fileName,
            );

            _filteredData.add(newEndorsement);
          } else {
            print('Ecards ID is null or empty');
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

  Future<void> deleteEcards(String ecardId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete this Ecards?'),
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
            Uri.parse(ApiServices.baseUrl + ApiServices.deleteEcards + ecardId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('Ecards deleted successfully');
          await _fetchData();
          setState(() {
            // Update _data list to reflect changes
            _filteredData
                .removeWhere((endorsement) => endorsement.ecardId == ecardId);
          });
        } else {
          print('Failed to delete Ecards. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> downloadFile(String ecardId, String fileName) async {
    final urlString =
        ApiServices.baseUrl + ApiServices.downloadByEcards + ecardId;

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

  void clearTextFeilds() {
    // updatepickFile = null;
    pickedFileName = null;
  }

  Future<void> createEcards() {
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
                // key: _formKey,
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
                              'Create Ecards',
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
                            //  if (_formKey.currentState!.validate())
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
                                isFileUploaded = false;
                                Navigator.pop(context);
                              } catch (e) {
                                print('Exception during file upload: $e');
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
  Future<void> updateFile(
      String fileType, String ecardId, BuildContext context) async {
    var headers = await ApiServices.getHeaders();
    print(ecardId);

    try {
      if (UpdatepickedFileName == null) {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Please pick a file first.',
        );
        return;
      }

      String? updateFileName = UpdatepickedFileName!;
      print(updateFileName);
      Uint8List fileBytes = updatepickFile!.first.bytes!;
      var fileExtension = updateFileName.split('.').last;
      MediaType contentType = getContentType(fileExtension);

      var multipartFile = http.MultipartFile.fromBytes(
        'fileName',
        fileBytes,
        filename: updateFileName,
        contentType: contentType,
      );

      // Check if endorsementId is not null or empty
      if (ecardId != null && ecardId.isNotEmpty) {
        final updateApiUrl = Uri.parse(
          ApiServices.baseUrl + ApiServices.updateEcards + ecardId,
        ); // Replace with your actual update file API endpoint
        var request = http.MultipartRequest("PUT", updateApiUrl)
          ..headers.addAll(headers);
        request.files.add(multipartFile);

        final response = await request.send();
        _fetchData();
        clearTextFeilds();
        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> responseData =
              json.decode(await response.stream.bytesToString());
          if (responseData.containsKey('')) {
            int? eCardsId = responseData['ecardId'];
            print(eCardsId);
            if (eCardsId != null) {
              var updateEcards = Ecardsmenu(
                ecardId: eCardsId,
                // endorsementNumber: _endorsementNumber.text,
                filename: updateFileName,
              );

              _filteredData.add(updateEcards);
              await _fetchData();
              setState(() {
                updateFileName = null;
                //_endorsementNumber.clear();
              });
            } else {
              print('Ecards ID is null or empty');
            }
          }
        }
      }
    } catch (e) {}
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

  Future<void> updateEndorsementForm(String ecardId) async {
    print(ecardId);
    updatelocalIsFileUploaded = isFileupdateUploaded;
    var headers = await ApiServices.getHeaders();
    try {
      final response = await http.get(
          Uri.parse(
            ApiServices.baseUrl + ApiServices.getByEcards + ecardId,
          ),
          headers: headers);
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> data = json.decode(response.body);

          setState(() {
            UpdatepickedFileName = data['fileName'] ?? '';
          });

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
                      //  key: _formKey,
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
                                    'update Ecards',
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
                                  await updateFile(
                                      "pdf", ecardId.toString(), context);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: SecureRiskColours.customButtonStyle(),
                          onPressed: () {
                            createEcards();
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
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.6,
                width: screenWidth * 0.8,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      //columnSpacing: 305,
                      columnSpacing: 300,
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
                                    InkWell(
                                      onTap: () {
                                        downloadFile(ends.ecardId.toString(),
                                            ends.filename);
                                      },
                                      child: Text(
                                        ends.filename ?? "N/A",
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
                                                ends.ecardId.toString());
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                        onPressed: () async {
                                          await deleteEcards(
                                              ends.ecardId.toString());
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
