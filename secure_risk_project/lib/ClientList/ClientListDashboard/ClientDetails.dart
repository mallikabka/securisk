import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Service.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/Colours.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:html' as html;
import 'package:toastification/toastification.dart';

class ClientDetails {
  final int clientDetailsId;
  final String name;
  final String fileName;

  ClientDetails({
    required this.clientDetailsId,
    required this.name,
    required this.fileName,
  });
}

class CLientDetailsForm extends StatefulWidget {
  int? clientId;

  String? productIdvar;
  CLientDetailsForm({
    Key? key,
    required this.clientId,
    required this.productIdvar,
  }) : super(key: key);
  @override
  State<CLientDetailsForm> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<CLientDetailsForm> {
  String? _selectedFilter;
  String? clientDetailsId;
  List<ClientDetails> _data = [];
  int totalPages = 1;
  String _searchText = '';
  bool isUpdate = false;
  int _currentPage = 1;
  int _pageSize = 10;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<ClientDetails> _filteredData = [];
  List<String> _filterOptions = ['Clients No'];
  TextEditingController _searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? _nameHasError = "";
  bool isFileUploaded = false;

  bool isUpdatedFileUploaded = false;

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

  List<ClientDetails> getFilteredData() {
    List<ClientDetails> filteredData = _data;

    if (_selectedFilter != null) {
      print("Filtering by: $_selectedFilter");
      filteredData = filteredData
          .where((item) => item.clientDetailsId == _selectedFilter)
          .toList();
    }

    if (_searchText.isNotEmpty) {
      print("Searching for: $_searchText");
      filteredData = filteredData
          .where((item) => item.name.contains(_searchText.toLowerCase()))
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
          Uri.parse(ApiServices.baseUrl + ApiServices.getAllClientDetails)
              .replace(queryParameters: {
        "clientlistId": clientListId,
        "productId": productId,
        //"rfqId": rfqId,
      });

      final response = await http.get(uploadApiUrl, headers: headers);

      if (response.statusCode == 200) {
        // Parse the response and update the state
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        // Check if the response contains the expected data structure
        if (data != null && data.isNotEmpty) {
          final List<ClientDetails> clientsData = data
              .map((item) => ClientDetails(
                    clientDetailsId: item['clientDetailsId'] ?? '',
                    name: item['clientDetailsName'] ?? '',
                    fileName: item['fileName'] ?? '',
                  ))
              .toList();

          setState(() {
            _filteredData = clientsData;
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

  List<ClientDetails> clientDetailsList = [];

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
      file = result.files.first;
      pickedFiles = result.files;
      setState(() {
        //  pickedFileName = pickedFiles!.first.name;
        pickedFileName = file!.name;
        print(pickedFileName);
        //isFileUploaded = true;
      });

      if (pickedFiles != null) {
        setState(() {
          isFileUploaded = true;
        });
        print("&&&&&&&&&&&&&&&&&&&&&&&&&");
        print(isFileUploaded);
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

  Future<void> createClient(String fileType) async {
    var headers = await ApiServices.getHeaders();
    String clientListId = widget.clientId.toString();
    String? productId = widget.productIdvar;
    print('debug : create client');
    try {
      if (pickedFileName == null) {
        toastification.showError(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'Please pick a file first.',
        );
        return;
      }

      var fileName = pickedFileName!;
      print(fileName);
      Uint8List fileBytes = pickedFiles!.first.bytes!;
      var fileExtension = fileName.split('.').last;
      MediaType contentType = getContentType(fileExtension);

      var multipartFile = http.MultipartFile.fromBytes(
        'fileName',
        fileBytes,
        filename: fileName,
        contentType: contentType,
      );
      print('debug after multipart file');
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.createClientDetails)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,
      });
      print('upload api');
      var request = http.MultipartRequest("POST", uploadApiUrl)
        ..headers.addAll(headers);

      request.files.add(multipartFile);
      request.fields['ClientDetailsName'] = nameController.text;

      final response = await request.send();
      _fetchData();
      clearTextFeilds();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        if (responseData.containsKey('clientDetailsId')) {
          int? clientIds = responseData['clientDetailsId'];
          print('client ID: $clientIds');
          // _fetchData();

          if (clientIds != null) {
            if (clientIds != null) {
              var newClient = ClientDetails(
                clientDetailsId: clientIds,
                name: nameController.text,
                fileName: fileName,
              );
              print("*****************client**************");
              print(newClient);
              _filteredData.add(newClient);
              // _fetchData();
            } else {
              print('client ID is null or empty');
            }
          } else {
            print('client ID is null or empty');
          }
        }
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

  void clearFilteredData() {
    setState(() {
      _filteredData.clear(); // This clears the list
    });
  }

  Future<void> createClientDetailsDialog() {
    double cardWidth = MediaQuery.of(context).size.width * 0.20;
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
                          width: 430,
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
                                  'Create Client Details',
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
                            Container(
                              margin: EdgeInsets.only(right: 340, bottom: 15),
                              child: Text("Name",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            // Endorsement Number Field
                            Container(
                              // height: 50,
                              height: _nameHasError == null ||
                                      _nameHasError!.isEmpty
                                  ? 50.0
                                  : 65.0,
                              margin: EdgeInsets.only(left: 18, right: 18),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Name',
                                  //keyboardType: TextInputType.number,
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

                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Please enter name';
                                //   }
                                //   return null;
                                // },
                                validator: (value) {
                                  setState(() {
                                    _nameHasError = validateString(value);
                                  });
                                  return _nameHasError;
                                },
                              ),
                            ),
                            SizedBox(height: 20), // Spacer

                            // File Upload Field
                            Container(
                              margin: EdgeInsets.only(right: 365, bottom: 10),
                              // margin: EdgeInsets.only(
                              //     right: 120, bottom: 15, left: 15),
                              child: Text(" File",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Color.fromRGBO(25, 26, 25, 1))),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 15, bottom: 15, left: 18),
                                  child: OutlinedButton.icon(
                                    //  style: SecureRiskColours.customButtonStyle(),
                                    onPressed: () async {
                                      // Invoke your file upload function
                                      await pickFile();
                                      setState(() {
                                        localIsFileUploaded = isFileUploaded;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.upload,
                                      color: SecureRiskColours.Button_Color,
                                    ), // The icon
                                    label: Text(
                                      'Upload File',
                                      style: TextStyle(
                                          color:
                                              SecureRiskColours.Button_Color),
                                    ), // The text
                                    // style: ElevatedButton.styleFrom(
                                    //     // You can customize the button's style
                                    //     ),
                                  ),
                                ),
                                if (localIsFileUploaded)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 13),
                                    child: Text(
                                      pickedFileName!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 20), // Spacer

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SecureRiskColours.Button_Color,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  createClient(
                                    "pdf",
                                  );

                                  isFileUploaded = false;

                                  Navigator.pop(context);
                                  // _fetchData();
                                }
                              },
                              child: Text(
                                'Create',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
        );
      },
    );
  }

  Future<void> updateClientDetails(String fileType, String clientId) async {
    var headers = await ApiServices.getHeaders();
    print(clientId);

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
      if (clientId != null && clientId.isNotEmpty) {
        final updateApiUrl = Uri.parse(
          ApiServices.baseUrl +
              ApiServices.updateClientDetails_endpoint +
              '/' +
              clientId,
        ); // Replace with your actual update file API endpoint
        var request = http.MultipartRequest("PUT", updateApiUrl)
          ..headers.addAll(headers);
        request.files.add(multipartFile);

        request.fields['clientDetailsName'] = nameController.text;

        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          //  Show success notification and reset pickedFileName
          toastification.showSuccess(
            context: context,
            autoCloseDuration: Duration(seconds: 2),
            title: 'Client Details updated successfully.....!',
          );

          var updateClient = ClientDetails(
            clientDetailsId: int.parse(clientId),
            name: nameController.text,
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
        print('Client ID is null or empty');
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'Update failed.....!',
      );
    }
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

      if (updatepickFile != null) {
        toastification.showSuccess(
          context: context,
          autoCloseDuration: Duration(seconds: 2),
          title: 'File Picked $UpdatepickedFileName',
        );
        setState(() {
          isUpdatedFileUploaded = true;
        });
      }
    } catch (e) {
      toastification.showError(
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        title: 'File Picked $UpdatepickedFileName',
      );
    }
  }

  Future<void> updateClientDetailsDialog(String clientId) async {
    var headers = await ApiServices.getHeaders();
    bool localUpdatedFileUploaded = isUpdatedFileUploaded;
    try {
      final response = await http.get(
          Uri.parse(
            ApiServices.baseUrl +
                ApiServices.getClientDetailsByClientListId +
                clientId,
          ),
          headers: headers);

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> data = json.decode(response.body);

        // Pre-fill the form fields with the retrieved data
        setState(() {
          nameController.text = data['clientDetailsName'] ?? '';
          UpdatepickedFileName = data['fileName'] ?? '';
          // You might need to handle other fields based on your API response
        });

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
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Update Client Details',
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
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                //keyboardType: TextInputType.number,
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
                                String trimmedText = value.toString().trim();
                                if (trimmedText.isEmpty) {
                                  return 'Please enter a name';
                                }
                                // You can add more validation logic here if needed.
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20), // Spacer

                          // // File Upload Field
                          // Container(
                          //   margin: EdgeInsets.only(left: 12, right: 12),
                          //   child: Row(
                          //     children: [
                          //       Center(
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             OutlinedButton.icon(
                          //               //  style: SecureRiskColours.customButtonStyle(),
                          //               onPressed: () async {
                          //                 // Invoke your file upload function
                          //                 await updatepickFiles();
                          //               },
                          //               icon: Icon(
                          //                 Icons.upload,
                          //                 color: SecureRiskColours.Button_Color,
                          //               ), // The icon
                          //               label: Text(
                          //                 'Upload File',
                          //                 style: TextStyle(
                          //                     color:
                          //                         SecureRiskColours.Button_Color),
                          //               ), // The text
                          //               // style: ElevatedButton.styleFrom(
                          //               //     // You can customize the button's style
                          //               //     ),
                          //             ),
                          //             SizedBox(
                          //               width: 30,
                          //             ),
                          //             if (UpdatepickedFileName != null)
                          //               Text(
                          //                 UpdatepickedFileName ?? "",
                          //                 style: TextStyle(
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: Colors.green),
                          //               ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(
                                right: 400, bottom: 10, left: 20),
                            // margin: EdgeInsets.only(
                            //     right: 120, bottom: 15, left: 15),
                            child: Text(" File",
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Color.fromRGBO(25, 26, 25, 1))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    right: 15, bottom: 15, left: 18),
                                child: OutlinedButton.icon(
                                  //  style: SecureRiskColours.customButtonStyle(),
                                  onPressed: () async {
                                    // Invoke your file upload function
                                    await updatepickFiles();
                                    setState(() {
                                      localUpdatedFileUploaded =
                                          isUpdatedFileUploaded;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.upload,
                                    color: SecureRiskColours.Button_Color,
                                  ), // The icon
                                  label: Text(
                                    'Upload File',
                                    style: TextStyle(
                                        color: SecureRiskColours.Button_Color),
                                  ), // The text
                                  // style: ElevatedButton.styleFrom(
                                  //     // You can customize the button's style
                                  //     ),
                                ),
                              ),
                              if (localUpdatedFileUploaded ||
                                  UpdatepickedFileName != null)
                                Container(
                                  margin: EdgeInsets.only(bottom: 13),
                                  child: Text(
                                    UpdatepickedFileName!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20), // Spacer

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SecureRiskColours.Text_Color,
                            ),
                            onPressed: () {
                              updateClientDetails("pdf", clientId);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'update',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> deleteClientDetails(String clientId) async {
    var headers = await ApiServices.getHeaders();
    try {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete?',
              style: TextStyle(color: Colors.red),
            ),
            content:
                Text('Are you sure you want to delete this Client Details?'),
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
        final apiUrl = Uri.parse(
            ApiServices.baseUrl + ApiServices.deleteClientDetails + clientId);

        final response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200) {
          print('client Details deleted successfully');
          await _fetchData();
        } else {
          print('Failed to delete Client. Status code: ${response.statusCode}');
        }
      } else {
        // User clicked "Cancel" or dismissed the dialog
        print('Deletion canceled by the user');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  downloadFile(String clientListId, String fileName) async {
    final urlString = ApiServices.baseUrl +
        ApiServices.clientDetailsdownloadByClientListId +
        clientListId;

    try {
      var headers = await ApiServices.getHeaders();
      final response = await http.get(
        Uri.parse(urlString),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
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

  downloadAllClientDetails(String fileName) async {
    
     try{

  var headers = await ApiServices.getHeaders();
      String clientListId = widget.clientId.toString();
      String? productId = widget.productIdvar;
      final uploadApiUrl =
          Uri.parse(ApiServices.baseUrl + ApiServices.clientDetailsDownloadAll_endpoint)
              .replace(queryParameters: {
        "clientListId": clientListId,
        "productId": productId,       
      });

  final response = await http.get(uploadApiUrl, headers: headers);    

      if (response.statusCode == 200) {
        print(
            "Received bytes: ${response.bodyBytes.length}"); // Add this line to log the byte length
        if (response.bodyBytes.isNotEmpty) {
          // Check if the bodyBytes is not empty
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = "$fileName.zip";
          anchor.click();
          html.Url.revokeObjectUrl(url);
        } else {
          // Handle the case where response.bodyBytes is empty
          print("The response is empty. No data received.");
        }
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
                        Align(
                          child: Container(
                            height: 40,
                            child: ElevatedButton(
                              style: SecureRiskColours.customButtonStyle(),
                              onPressed: () {
                                downloadAllClientDetails("AllClientDetails");
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 5),
                                    Text(
                                      'Download All ',
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
                            height: 40,
                            child: ElevatedButton(
                              style: SecureRiskColours.customButtonStyle(),
                              onPressed: () {
                                createClientDetailsDialog();
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 5),
                                    Text(
                                      'Create ',
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
                            height: 40,
                            child: ElevatedButton(
                              style: SecureRiskColours.customButtonStyle(),
                              onPressed: () {
                                clearFilteredData();
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 5),
                                    Text(
                                      'Clear ',
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
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: SingleChildScrollView(
                      //  physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          headingRowHeight: 40,
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color>(
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
                                'Name',
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
                                .map((client) => DataRow(cells: [
                                      DataCell(Text(
                                          (_filteredData.indexOf(client) + 1)
                                              .toString())),
                                      DataCell(Text(client.name ?? "N/A")),
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            // _downloadFile(ends.endorsementId
                                            // .toString());
                                            downloadFile(
                                                client.clientDetailsId
                                                    .toString(),
                                                client.fileName);
                                          },
                                          child: Text(
                                            client.fileName ?? "N/A",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color: Color.fromARGB(
                                                    255, 7, 79, 138),
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                      DataCell(Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                await updateClientDetailsDialog(
                                                    client.clientDetailsId
                                                        .toString());
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () async {
                                                await deleteClientDetails(client
                                                    .clientDetailsId
                                                    .toString());
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
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
