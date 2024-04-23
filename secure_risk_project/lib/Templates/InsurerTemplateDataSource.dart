import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:loginapp/Service.dart';
import 'package:loginapp/Templates/InsurerTemplate.dart';

import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:http_parser/http_parser.dart';
import '../Colours.dart';

import 'dart:html' as html;

class InsurerTemplateDataSource extends DataGridSource {
  List<InsurerTemplatePojo> employees;
  int rowCount;
  final List<InsurerGridRow> insurerRows;
  BuildContext context;
  Future<void> Function() editfunction;
  Future<void> Function() fetchDataFromApi;
  void Function(String? type) onTemplateTypeChange;
  String? selectedLocation;
  List<String> locations;
  Future<void> Function() handleUpload;

  InsurerTemplateDataSource(
      this.employees,
      this.rowCount,
      this.context,
      this.editfunction,
      this.fetchDataFromApi,
      this.onTemplateTypeChange,
      this.selectedLocation,
      this.locations,
      this.handleUpload)
      : insurerRows = employees
            .map((rfqTemplate) => InsurerGridRow(
                rfqTemplate,
                DataGridRow(cells: [
                  DataGridCell<int>(columnName: 'id', value: rfqTemplate.id),
                  DataGridCell<String>(
                      columnName: 'templateName',
                      value: rfqTemplate.templateName),
                  DataGridCell<String>(
                      columnName: 'templateFileName',
                      value: rfqTemplate.templateFileName),
                  DataGridCell<String>(
                      columnName: 'actions', value: rfqTemplate.actions),
                ])))
            .toList();

  List<InsurerGridRow> get rowscount => this.insurerRows;

  @override
  List<DataGridRow> get rows =>
      insurerRows.map((employeeRow) => employeeRow.row).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final rowIndex = rows.indexOf(row);
    final InsurerGridRow insurerRow = insurerRows[rowIndex];
    final InsurerTemplatePojo rfqTemplate = insurerRow.rfqTemplate;

    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 != 0) {
        return Colors.lightGreen[300]!;
      }
      return Colors.transparent;
    }

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'templateFileName') {
          return InkWell(
            onTap: () => {_handleWebDownload(rfqTemplate.id)},
            child: Align(
                alignment: Alignment.center,
                child: Text(rfqTemplate.templateFileName)),
          );
        } else if (dataCell.columnName == 'actions') {
          return _buildPopupMenuButton(
              context,
              rfqTemplate,
              editfunction,
              fetchDataFromApi,
              onTemplateTypeChange,
              selectedLocation,
              locations,
              handleUpload);
        } else {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dataCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
      }).toList(),
    );
  }

  void _handleWebDownload(id) async {
    String apiUrl =
        ApiServices.baseUrl + ApiServices.download_TemplateById + id.toString();
    try {
      html.AnchorElement anchorElement = html.AnchorElement(href: apiUrl);

      anchorElement.click();
    } catch (e) {
      ('Error: $e');
    }
  }

  TextEditingController templateName = TextEditingController();

  PopupMenuButton<String> _buildPopupMenuButton(
    BuildContext context,
    InsurerTemplatePojo rfqTemplate,
    Future<void> Function() editfunction,
    Future<void> Function() fetchDataFromApi,
    void Function(String? type) onTemplateTypeChange,
    String? selectedLocation,
    List<String> locations,
    Future<void> Function() handleUpload,
  ) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
      onSelected: (String selectedValue) {
        if (selectedValue == 'edit') {
          templateName.text = rfqTemplate.templateName;
          selectedLocation = rfqTemplate.templateType;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  height: screenHeight * 0.55,
                  width: screenWidth * 0.32,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Edit Template',
                            style: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
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
                                border: OutlineInputBorder(),
                                hintText: 'Enter Template Name',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Template Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: DropdownButtonFormField<String>(
                                value: selectedLocation,
                                onChanged: (String? newValue) {
                                  onTemplateTypeChange(newValue);
                                },
                                itemHeight: 50,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  // labelText:
                                  //     'Select template type',
                                  border: OutlineInputBorder(),
                                ),
                                hint: Text('Select template type'),
                                items: locations.map<DropdownMenuItem<String>>(
                                  (String location) {
                                    return DropdownMenuItem<String>(
                                      value: location,
                                      child: Text(location),
                                    );
                                  },
                                ).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select template type';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select File',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Card(
                                      elevation: 5,
                                      child:
                                          Text(rfqTemplate.templateFileName)),
                                  IconButton.filledTonal(
                                    iconSize: 32,
                                    icon: Icon(Icons.cloud_upload_outlined),
                                    onPressed: handleUpload,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 37,
                              child: ElevatedButton(
                                style: SecureRiskColours.customButtonStyle(),
                                onPressed: () {
                                  updateTemplateApiCall(fileBytes!,
                                      rfqTemplate.id, fetchDataFromApi);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.update_sharp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Update',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(4.0),
                                  // Set the elevation value
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered))
                                        return Color.fromARGB(255, 133, 56, 56);
                                      return Color.fromARGB(255, 218, 138,
                                          132); // Defer to the widget's default.
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Set the border radius here
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                    Size(100, 43),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 230, 30, 203)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    // Add some spacing between the icon and text
                                    Text(
                                      'Close',
                                      style: GoogleFonts.poppins(fontSize: 18),
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
              );
            },
          );
        } else if (selectedValue == 'delete') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you sure you want to delete this Template'),
                actions: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            var headers = await ApiServices.getHeaders();
                            final response = await http.delete(
                              Uri.parse(ApiServices.baseUrl +
                                  ApiServices.delete_Templates +
                                  '${rfqTemplate.id}'),
                              headers: headers,
                            );
                            if (response.statusCode == 200) {
                              fetchDataFromApi();
                            } else {}
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(4.0),
                            // Set the elevation value
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Color.fromARGB(255, 53, 212, 252);
                                return Color.fromARGB(255, 218, 138,
                                    132); // Defer to the widget's default.
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set the border radius here
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(100, 43),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 31, 143, 248)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              // Add some spacing between the icon and text
                              Text(
                                'Delete',
                                style: GoogleFonts.poppins(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(4.0),
                              // Set the elevation value
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Color.fromARGB(255, 133, 56, 56);
                                  return Color.fromARGB(255, 218, 138,
                                      132); // Defer to the widget's default.
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Set the border radius here
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(100, 43),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 230, 30, 203)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                // Add some spacing between the icon and text
                                Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Future<void> testDataFromApi(empid) async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(
            "${ApiServices.baseUrl}${ApiServices.get_ByID_Template}/${empid}"),
        headers: headers);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<Map<String, dynamic>> updateTemplateApiCall(Uint8List fileBytes,
      int id, Future<void> Function() fetchDataFromApi) async {
    var headers = await ApiServices.getHeaders();
    final apiUrl =
        ApiServices.baseUrl + ApiServices.update_Templates + id.toString();

    var request = http.MultipartRequest("Put", Uri.parse(apiUrl))
      ..headers.addAll(headers);

    request.fields['templateName'] = templateName.text;
    request.fields['templateType'] = selectedLocation!;
    request.fields['type'] = 'insurer';
    if (fileBytes.isNotEmpty) {
      var multipartFile = http.MultipartFile.fromBytes(
        'templateFile',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      selectedLocation = null;
      fetchDataFromApi();
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to send file to backend');
    }
  }
}

class InsurerGridRow {
  final InsurerTemplatePojo rfqTemplate;
  final DataGridRow row;

  InsurerGridRow(this.rfqTemplate, this.row);
}
