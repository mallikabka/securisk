import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/Colours.dart';

// Assuming GridColumn is an existing class
class GridColumn {
  final String columnName;
  final Widget label;

  GridColumn({required this.columnName, required this.label});
}

class CustomGridColumn extends GridColumn {
  CustomGridColumn({required String columnName, required String label})
      : super(
          columnName: columnName,
          label: Container(
            color: SecureRiskColours.Table_Heading_Color,
            padding: EdgeInsets.all(4),
            alignment: Alignment.center,
            child: Text(
              columnName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: SecureRiskColours.table_Text_Color,
              ),
            ),
          ),
        );
}
