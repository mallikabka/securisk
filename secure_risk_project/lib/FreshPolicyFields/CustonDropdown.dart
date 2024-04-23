import 'package:flutter/material.dart';
import 'package:loginapp/Colours.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  CustomDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.23,
      height: screenHeight * 0.06,
      // Adjust the width as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Color.fromRGBO(113, 114, 111, 1),
        ),
        color: SecureRiskColours.table_Text_Color,
      ),
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          items: items,
          icon: Icon(Icons.arrow_drop_down),
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
