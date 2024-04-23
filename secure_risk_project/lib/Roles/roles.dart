import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';
import 'package:loginapp/SideBarComponents/AppBar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginapp/Service.dart';
import 'dart:async';
import '../Authentication/AuthGaurd.dart';

List<int> permissionIds = [];
bool dataFetched = false;
var count = 0;

class DataGridItem {
  final String name;
  bool toggleSwitchState;
  final List<PermissionItem> permissions;
  List<PermissionItem> selectedPermissions;

  DataGridItem({
    required this.name,
    required this.toggleSwitchState,
    required this.permissions,
  }) : selectedPermissions = [];
}

class PermissionItem {
  int id;
  String name;

  PermissionItem({required this.id, required this.name});
}

class DataGridProvider extends ChangeNotifier {
  List<DataGridItem> data = [];

  // Function to update the data and notify listeners
  void updateData(List<DataGridItem> newData) {
    data = newData;
    notifyListeners();
  }

  void updatePermissionsToggleSwicth(
      int index, List<PermissionItem> newPermissions, int selectedId) {
    if (data[index].toggleSwitchState) {
      // Select all the permissions
      for (var permission in newPermissions) {
        if (permissionIds.contains(permission.id)) {
          permissionIds.remove(permission.id);
        }
      }
    } else {
      // Deselect all the permissions
      for (var permission in newPermissions) {
        if (!permissionIds.contains(permission.id)) {
          permissionIds.add(permission.id);
        }
      }
    }

    createAndUpdateRoles(selectedId);
    data[index].toggleSwitchState = !data[index].toggleSwitchState;
    notifyListeners();
  }

  void updatePermissions(int index, List<PermissionItem> newPermissions) {
    data[index].selectedPermissions = newPermissions;
    bool arePermissionsEmpty = newPermissions.isNotEmpty;

    for (var item in newPermissions) {}
    if (newPermissions.isNotEmpty) {
      data[index].toggleSwitchState = true;
    } else {
      data[index].toggleSwitchState = false;
    }
    notifyListeners();
  }

  Future<void> createAndUpdateRoles(int selectedId) async {
    var headers = await ApiServices.getHeaders();
    final data = {
      "designationId": selectedId,
      "menuType": permissionIds,
    };

    final response = await http.post(
      Uri.parse(ApiServices.baseUrl + ApiServices.createAndUpdateRoles),
      headers: headers,
      body: jsonEncode(data), // Encode the data as JSON
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // ignore: unused_local_variable
      final dynamic responseData = jsonDecode(response.body);
      // Handle the responseData as needed
    } else {
      throw Exception('Failed to create and update roles');
    }
  }
}

class Roles extends StatefulWidget {
  @override
  _RolesState createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  AuthGaurd authGaurd = new AuthGaurd();

  @override
  void initState() {
    super.initState();
    fetchData();
    authGaurd.authenticateUser().then((data) {
      if (data == false) {
        Navigator.of(context).pushReplacementNamed('/login_page');
      }
    }).catchError((error) {
      ('Error fetching API data: $error');
    });
  }

  List<Map<String, dynamic>> apiResponse = [];

  Future<void> fetchData() async {
    var headers = await ApiServices.getHeaders();

    final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.getAllDesignations),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        apiResponse = List<Map<String, dynamic>>.from(responseData);
        selectedId = apiResponse[0]['id'];
      });
      fetchPermissionsData();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void updatedSelectedId(id) {
    setState(() {
      selectedId = id;

      dataFetched = false;
    });
  }

  Future<void> fetchPermissionsData() async {
    var headers = await ApiServices.getHeaders();
    final response = await http.get(
        Uri.parse(ApiServices.baseUrl +
            ApiServices.fetchAllPermissionsByDesignationId +
            '$selectedId'),
        headers: headers);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> responseData = jsonDecode(response.body);

      // Convert the list to a Set<int>
      final List<int> responseSet = List<int>.from(responseData);
      setState(() {
        permissionIds = responseSet;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget buildSpace(screenHeight) {
    return Expanded(
      flex: 2,
      child: Container(
        height: screenHeight * 1.2,
      ),
    );
  }

  Widget buildRoles(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
      flex: 9,
      child: Container(
        height: screenHeight * 1.2,
        child: Column(
          children: [
            Container(
              width: screenWidth * 1,
              decoration: BoxDecoration(
                color: SecureRiskColours.Table_Heading_Color,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Action",
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 40),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("Permission",
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            Container(
              height: screenHeight * 1,
              width: screenWidth * 1,
              child: MyRolesDataGrid(
                selectedId: selectedId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int selectedId = -1;

  Widget buildDesignations(
    BuildContext context,
    void Function(dynamic id) updatedSelectedId,
    List<Map<String, dynamic>> apiResponse,
    Future<void> Function() fetchPermissionsData,
  ) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<DataGridProvider>(
        builder: (context, dataGridProvider, child) {
      return Expanded(
          flex: 2,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Container(
                height: screenHeight * 1.2,
                child: ListView.builder(
                  itemCount: apiResponse.length,
                  itemBuilder: (BuildContext context, int index) {
                    final designation = apiResponse[index];
                    final id = designation['id'];
                    final designationName = designation['designationName'];

                    return InkWell(
                      onTap: () {
                        updatedSelectedId(id);

                        fetchPermissionsData();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                          color: id == selectedId
                              ? SecureRiskColours.Button_Color
                              : null,
                        ),
                        child: Text(
                          designationName,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: id == selectedId
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => DataGridProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.1),
            child: AppBarExample(),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: screenHeight * 1.2,
              child: Row(
                children: [
                  // buildSpace(screenHeight),
                  buildDesignations(context, updatedSelectedId, apiResponse,
                      fetchPermissionsData),
                  buildRoles(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyRolesDataGrid extends StatefulWidget {
  late int selectedId;

  MyRolesDataGrid({super.key, required this.selectedId});

  @override
  MyRolesDataGridState createState() => MyRolesDataGridState();
}

class MyRolesDataGridState extends State<MyRolesDataGrid> {
  // Add a flag to track if data is fetched

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataAndConfigureProvider(context);
    dataFetched = true;
    count = 3;
  }

  @override
  Widget build(BuildContext context) {
    if (!dataFetched) {
      fetchDataAndConfigureProvider(context); // Fetch data only once
      dataFetched = true; // Set the flag to true
    }
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return SecureRiskColours.toggleOn;
        }

        return SecureRiskColours.toggleOff;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return SecureRiskColours.toggleOn;
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return SecureRiskColours.toggleOff;
        }

        return null;
      },
    );
    return Consumer<DataGridProvider>(
      builder: (context, dataGridProvider, child) {
        // Check if data is still loading

        if (dataGridProvider.data.isEmpty) {
          while (count > 0 && dataGridProvider.data.isEmpty) {
            dataFetched = false;
            //  fetchDataAndConfigureProvider(context);
            count--;
          }
          return FractionallySizedBox(
            widthFactor: 0.1, // Adjust the width factor as needed (0.0 to 1.0)
            heightFactor:
                0.1, // Adjust the height factor as needed (0.0 to 1.0)
            child: CircularProgressIndicator(),
          ); // Show loading indicator
        } else if (dataGridProvider.data.isNotEmpty) {
          // Display the data once it's available

          return ListView.builder(
            itemCount: dataGridProvider.data.length,
            itemBuilder: (context, index) {
              final item = dataGridProvider.data[index];
              // final bgColor = index.isOdd ? Colors.grey[100] : Colors.white;
              return Container(
                color: Colors.white,
                child: Card(
                  // elevation: 5,
                  child: ListTile(
                    title: Text(item.name,
                        style: GoogleFonts.poppins(fontSize: 13)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: 0.9,
                          child: Switch(
                            value: item.toggleSwitchState,
                            overlayColor: overlayColor,
                            // trackColor: trackColor,
                            activeColor: SecureRiskColours.Button_Color,
                            thumbColor: MaterialStatePropertyAll<Color>(
                                SecureRiskColours.Button_Color),
                            onChanged: (newValue) {
                              for (var i in item.permissions) {}
                              Provider.of<DataGridProvider>(context,
                                      listen: false)
                                  .updatePermissionsToggleSwicth(index,
                                      item.permissions, widget.selectedId);
                            },
                          ),
                        ),
                        Transform.scale(
                          scale: 0.9,
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              bool flag = true;
                              // builded(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ChangeNotifierProvider.value(
                                    value: dataGridProvider,
                                    child: EditDialog(
                                        item, index, widget.selectedId, flag),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  // Function to fetch data from API and configure the provider
  Future<void> fetchDataAndConfigureProvider(BuildContext context) async {
    try {
      // Simulate an API call (replace with your actual API call)
      final apiResponse =
          await fetchApiData(); // Assuming fetchApiData is an async function to fetch data
      final List<DataGridItem> newData = configureDataGridItems(apiResponse);

      // Update the DataGridProvider with the fetched and configured data
      Provider.of<DataGridProvider>(context, listen: false).updateData(newData);
    } catch (error) {}
  }

  // Replace this with your actual API call to fetch data
  Future<String> fetchApiData() async {
    var headers = await ApiServices.getHeaders();
    try {
      final response = await http.get(
          Uri.parse(ApiServices.baseUrl + ApiServices.rolesGetAllOperation),
          headers: headers);

      if (response.statusCode == 200) {
        // Check ifa the response status code is 200 (OK)
        return response.body;
      } else {
        // Handle error cases here, for example, by throwing an exception
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network issues
      throw Exception('Failed to fetch data: $error');
    }
  }

  List<DataGridItem> configureDataGridItems(String apiResponse) {
    List<dynamic> apiData = json.decode(apiResponse);
    Map<String, Set<String>> menuTypeToPermissions = {};

    for (var item in apiData) {
      String menuType = item['menuType'];
      String menuName = item['menuName'];

      if (!menuTypeToPermissions.containsKey(menuType)) {
        menuTypeToPermissions[menuType] = Set<String>();
      }

      menuTypeToPermissions[menuType]!.add(menuName);
    }

    List<DataGridItem> configuredData = [];

    for (String menuType in menuTypeToPermissions.keys) {
      List<PermissionItem> permissions = menuTypeToPermissions[menuType]!
          .map((menuName) => PermissionItem(
                id: apiData.firstWhere((item) =>
                    item['menuType'] == menuType &&
                    item['menuName'] == menuName)['id'],
                name: menuName,
              ))
          .toList();
      bool toggleSwitchState = permissions
          .any((permission) => permissionIds.contains(permission.id));
      configuredData.add(DataGridItem(
        name: menuType,
        toggleSwitchState: toggleSwitchState,
        permissions: permissions,
      ));
    }

    return configuredData;
  }
}

// ignore: must_be_immutable
class EditDialog extends StatefulWidget {
  final DataGridItem item;
  final int index;
  final int selectedId;
  bool flag;

  EditDialog(this.item, this.index, this.selectedId, this.flag);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  bool toggleSwitchState = false; // Initially, set to off
  List<Map<String, dynamic>> allOperations = [];
  bool selectAll = false;
  int matchCount = 0;
  List<PermissionItem> previousPermissions = [];

  @override
  void initState() {
    super.initState();
    toggleSwitchState = widget.item.selectedPermissions.isNotEmpty;
    fetchApiData();
    initialCreatePermissionsList(permissionIds);
  }

  Future<void> createAndUpdateRoles() async {
    var headers = await ApiServices.getHeaders();
    final data = {
      "designationId": widget.selectedId,
      "menuType": permissionIds,
    };

    final response = await http.post(
      Uri.parse(ApiServices.baseUrl + ApiServices.createAndUpdateRoles),
      headers: headers,
      body: jsonEncode(data), // Encode the data as JSON
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
      throw Exception('Failed to create and update roles');
    }
  }

  Future<void> fetchApiData() async {
    var headers = await ApiServices.getHeaders();
    try {
      final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.rolesGetAllOperation),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Check if the response status code is 200 (OK)
        allOperations =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        widget.item.selectedPermissions =
            createPermissionsList(allOperations, permissionIds);
      } else {
        // Handle error cases here, for example, by throwing an exception
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network issues
      throw Exception('Failed to fetch data: $error');
    }
  }

  List<PermissionItem> createPermissionsList(
      List<Map<String, dynamic>> allOperations,
      List<int> allPermittedOperations) {
    List<PermissionItem> permissions = [];

    for (var operation in allOperations) {
      if (allPermittedOperations.contains(operation['id']) &&
          widget.item.name == operation['menuType']) {
        permissions.add(
            PermissionItem(id: operation['id'], name: operation['menuName']));
      }
    }

    return permissions;
  }

  Future<List<PermissionItem>> initialCreatePermissionsList(
      List<int> allPermittedOperations) async {
    var headers = await ApiServices.getHeaders();
    try {
      final response = await http.get(
        Uri.parse(ApiServices.baseUrl + ApiServices.rolesGetAllOperation),
        headers: headers,
      );

      if (response.statusCode == 200) {
        allOperations =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        List<PermissionItem> permissions = [];

        for (var operation in allOperations) {
          if (allPermittedOperations.contains(operation['id']) &&
              widget.item.name == operation['menuType']) {
            permissions.add(PermissionItem(
                id: operation['id'], name: operation['menuName']));
          }
        }
        previousPermissions = permissions;

        for (int i = 0; i < widget.item.permissions.length; i++) {
          bool flag = permissionIds.contains(widget.item.permissions[i].id);
          if (flag) {
            count++;
          }
        }
        return permissions;
        // widget.item.selectedPermissions = createPermissionsList(allOperations, permissionIds);
      } else {
        // Handle error cases here, for example, by throwing an exception
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors, such as network issues
      throw Exception('Failed to fetch data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.item.selectedPermissions =
          createPermissionsList(allOperations, permissionIds);
      widget.flag = false;
    });

    return
        //AlertDialog(
        // title: Container(
        //   // Set the background color for the title
        //   //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        //   decoration: BoxDecoration(
        //     color: SecureRiskColours.Table_Heading_Color,
        //     border: Border.all(color: Colors.grey),
        //     borderRadius: BorderRadius.circular(5),
        //   ),

        // backgroundColor: Color.fromARGB(255, 255, 255, 255),
        // contentPadding: EdgeInsets.zero,
        // surfaceTintColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(15.0),
        // ),

        AlertDialog(
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
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: SecureRiskColours.Table_Heading_Color,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   'Edit Home',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Text(
                    'Edit ${widget.item.name}',
                    style: GoogleFonts.poppins(color: Colors.white),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < 1; i++)
                ListTile(
                  title: Text('Select All'),
                  leading: Checkbox(
                    value: selectAll,
                    onChanged: (bool? value) {
                      setState(() {
                        selectAll = value!;
                        if (selectAll) {
                          // Select all the permissions
                          for (var permission in widget.item.permissions) {
                            if (!permissionIds.contains(permission.id)) {
                              permissionIds.add(permission.id);
                              widget.item.selectedPermissions.add(permission);
                            }
                          }
                        } else {
                          // Deselect all the permissions
                          for (var permission in widget.item.permissions) {
                            if (permissionIds.contains(permission.id)) {
                              permissionIds.remove(permission.id);
                              widget.item.selectedPermissions
                                  .remove(permission);
                            }
                          }
                        }
                      });
                    },
                  ),
                ),
              for (int i = 0; i < widget.item.permissions.length; i++)
                ListTile(
                  title: Text(widget.item.permissions[i].name),
                  leading: Checkbox(
                    value:
                        permissionIds.contains(widget.item.permissions[i].id),
                    // value: widget.item.selectedPermissions
                    //     .contains(widget.item.permissions[i]),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            widget.item.selectedPermissions
                                .add(widget.item.permissions[i]);
                          } else {
                            widget.item.selectedPermissions
                                .remove(widget.item.permissions[i]);
                          }
                          if (permissionIds
                              .contains(widget.item.permissions[i].id)) {
                            permissionIds.remove(widget.item.permissions[i].id);
                          } else {
                            permissionIds.add(widget.item.permissions[i].id);
                          }
                          setState(() {});

                          // Update the toggleSwitchState based on selectedPermissions
                          toggleSwitchState =
                              widget.item.selectedPermissions.isNotEmpty;
                        }
                      });
                    },
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ElevatedButton(
              onPressed: () {
                createAndUpdateRoles();
                toggleSwitchState = widget.item.selectedPermissions.isNotEmpty;
                Provider.of<DataGridProvider>(context, listen: false)
                    .updatePermissions(
                        widget.index, widget.item.selectedPermissions);

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SecureRiskColours
                    .Button_Color, // Change the color to your desired color
              ),
              child: Text(
                "Save",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
          // SizedBox(
          //   width: 10,
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     _restartPage(context);
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: SecureRiskColours.Back_Button_Color,
          //   ),
          //   child: Text(
          //     "Cancel",
          //     style: GoogleFonts.poppins(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _restartPage(BuildContext context) {
    // Navigate to the same page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => Roles()),
    );
  }
}
