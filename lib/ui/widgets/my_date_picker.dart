import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  late DateTime _dateOfBirth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _dateOfBirth,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (selectedDate != null && selectedDate != _dateOfBirth) {
              setState(() {
                _dateOfBirth = selectedDate;
              });
            }
          },
          child: _dateOfBirth != null
              ? Text('Selected date of birth: ${_dateOfBirth.toString()}')
              : const Text('Pick your date of birth'),
        ),
      ),
    );
  }
}
