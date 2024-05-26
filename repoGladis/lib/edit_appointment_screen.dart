import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:repo/appointment_form_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAppointmentScreen extends StatefulWidget {
  final Appointments appointment;

  const EditAppointmentScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  _EditAppointmentScreenState createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late TextEditingController _titleController;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current appointment details
    _titleController = TextEditingController(text: widget.appointment.title);
    _startDate = widget.appointment.startTime ?? DateTime.now();
    _endDate = widget.appointment.endTime ?? DateTime.now().add(Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Appointment'),
        actions: [
          // Save button in the app bar
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Update appointment details in Firestore
              _updateAppointment();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            // Start date picker
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _startDate = date;
                    // Ensure end date is after start date
                    if (_endDate.isBefore(date)) {
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
                child: Text('Start Date: ${_startDate.toString()}'),
              ),
            ),
            SizedBox(height: 8),
            // End date picker
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: _startDate,
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
                child: Text('End Date: ${_endDate.toString()}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to update appointment details in Firestore
  Future<void> _updateAppointment() async {
    try {
      await FirebaseFirestore.instance.collection('appointments').doc(widget.appointment.id).update({
        'title': _titleController.text,
        'startTime': _startDate,
        'endTime': _endDate,
      });
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment updated successfully!')),
      );
      // Navigate back to the appointment details screen
      Navigator.of(context).pop();
    } catch (error) {
      // Show an error message if the appointment could not be updated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update appointment: $error')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _titleController.dispose();
    super.dispose();
  }
}
