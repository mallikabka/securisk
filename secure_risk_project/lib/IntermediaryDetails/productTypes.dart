import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginapp/Service.dart';

// ignore: must_be_immutable
class ProductTypeDropdown extends StatefulWidget {
  final Function(String?) onProductTypeChanged;
  final Function(int?) onSelectedIdChanged;
  String? selectedProductType;

  ProductTypeDropdown({
    required this.onProductTypeChanged,
    required this.onSelectedIdChanged,
    required this.selectedProductType,
    required errorText,
  });

  @override
  _ProductTypeDropdownState createState() => _ProductTypeDropdownState();
}

class _ProductTypeDropdownState extends State<ProductTypeDropdown> {
  Map<String, int> _productTypes = {};
  String? _selectedProductType;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add the _formKey here

  @override
  void initState() {
    super.initState();
    _selectedProductType = widget.selectedProductType;
    _fetchProductTypes();
  }

  Future<void> _fetchProductTypes() async {
    try {
      Map<String, int> productTypes = await fetchProductTypes();
      setState(() {
        _productTypes = productTypes;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Set the GlobalKey<FormState>
      child: DropdownButtonFormField<String>(
        value: _selectedProductType,
        hint: Text(
          "Select Product Type",
          style: GoogleFonts.poppins(),
        ),
        onChanged: (newValue) {
          setState(() {
            _selectedProductType = newValue;
          });
          widget.onProductTypeChanged(newValue);
          final selectedId = _productTypes[_selectedProductType];
          widget.onSelectedIdChanged(selectedId);
        },
        items: _productTypes.keys.toSet().map((productType) {
          return DropdownMenuItem<String>(
            value: productType,
            child: Text(productType),
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
          if (value == null || value.isEmpty) {
            return 'Please select a product type';
          }
          return null;
        },
      ),
    );
  }

  // Example of how to trigger form validation when needed
}

Future<Map<String, int>> fetchProductTypes() async {
  var headers = await ApiServices.getHeaders();
  final response = await http.get(
      Uri.parse(ApiServices.baseUrl + ApiServices.product_Category_Endpoint),
      headers: headers);

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as List<dynamic>;
    Map<String, int> productTypes = {};

    for (final item in data) {
      final categoryName = item["categoryName"] as String;
      final categoryId = item["categoryId"] as int;
      productTypes[categoryName] = categoryId;
    }

    return productTypes;
  } else {
    throw Exception('Failed to load product types');
  }
}
