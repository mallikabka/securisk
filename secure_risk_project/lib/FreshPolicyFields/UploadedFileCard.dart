import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool isHovered = false;

class UploadedFileCard extends StatelessWidget {
  final String fileType;
  final VoidCallback onClose;
  UploadedFileCard({required this.fileType, required this.onClose});
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.20;
    return SizedBox(
      width: cardWidth, // Adjust the width as needed
      child: Card(
        // shadowColor: Color.fromARGB(255, 10, 10, 10),
        // elevation: 4,
        elevation: isHovered ? 8 : 4, // Add elevation based on hover state
        color: isHovered ? Color.fromARGB(255, 239, 241, 242) : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$fileType',
                style: GoogleFonts.poppins(
                  fontSize: 14, // Adjust the font size
                  //fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
