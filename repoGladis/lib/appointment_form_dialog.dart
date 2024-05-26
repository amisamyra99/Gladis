//part event_calender;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a StatefulWidget for the appointment form dialog
class AppointmentFormDialog extends StatefulWidget {
  // Optional initial date for the appointment
  final DateTime? initialDate;

  // Constructor to initialize the initialDate
  AppointmentFormDialog({this.initialDate});

  @override
  _AppointmentFormDialogState createState() => _AppointmentFormDialogState();
}

// Define the state for AppointmentFormDialog
class _AppointmentFormDialogState extends State<AppointmentFormDialog> {
  // Define key for form validation
  final _formKey = GlobalKey<FormState>();
  //final _formKey2 = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Initialize start and end dates
    _startDate = widget.initialDate ?? DateTime.now();
    _endDate = _startDate?.add(Duration(hours: 1));
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;

      try {
        // Add appointment data to Firestore
        await FirebaseFirestore.instance.collection('appointments').add({
          'title': title,
          'startTime': _startDate,
          'endTime': _endDate,
          'timestamp': FieldValue.serverTimestamp(),
        });
        // Close the dialog and show a success message
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment added successfully!')),
        );
      } catch (error) {
        // Show an error message if the appointment could not be added
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add appointment: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Appointment'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input field for the title of the appointment
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                // Input for the start date of the appointment
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                          // Ensure end date is after start date
                          if (_endDate!.isBefore(date)) {
                            _endDate = date.add(Duration(hours: 1));
                          }
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Start Date: ${_startDate?.toLocal().toString().split(' ')[0]}'),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Input for the end date of the appointment
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      // Show date picker for selecting end date
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate!,
                        firstDate: _startDate!,
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('End Date: ${_endDate?.toLocal().toString().split(' ')[0]}'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        // Create button to submit the form
        ElevatedButton(
          onPressed: _submitData,
          child: Text('Create'),
        ),
      ],
    );
  }
}

// Defines a model for appointments
class Appointments {
  final String title;
  final DateTime? startTime;
  final DateTime? endTime;

  // Constructor for the model
  Appointments({
    required this.title,
    this.startTime,
    this.endTime,
  });

  // Convert appointment data to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}


