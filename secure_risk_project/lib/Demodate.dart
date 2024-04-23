import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoDatePicker

class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = _formatDate(selectedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 250,
          height: 50,
          child: TextField(
            controller: _dateController,
            onTap: () => _selectDate(context),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Select Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              DatePickerWidget(),
              SizedBox(
                height: 60,
              ),
              DatePickerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
