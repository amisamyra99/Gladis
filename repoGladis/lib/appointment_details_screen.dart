import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:repo/appointment_form_dialog.dart';

// Stateless widget for displaying appointment details
class AppointmentDetailsScreen extends StatelessWidget {
  final Appointments appointment; // Appointment details passed to the screen

  // Constructor to initialize the AppointmentDetailsScreen with an appointment
  const AppointmentDetailsScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextStyle for headers
    final TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent);
    // TextStyle for content
    final TextStyle contentStyle = TextStyle(fontSize: 16, color: Colors.grey[700]);

    return Scaffold(
      // App bar with title and edit button
      appBar: AppBar(
        title: Text('Appointment Details'),
        actions: [
          // Edit button in the app bar
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the edit appointment page (yet to implement that page)
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditAppointmentScreen(
                    appointment: appointment,
                  ),
                ),
              );*/
            },
          ),
        ],
      ),
      // Body with appointment details
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4, // Elevation for shadow effect
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ListTile for title with icon and text
                ListTile(
                  leading: Icon(Icons.title, color: Colors.blueAccent),
                  title: Text('Title', style: headerStyle),
                  subtitle: Text(appointment.title, style: contentStyle),
                ),
                Divider(), // Divider for separation
                // ListTile for start time with icon and text
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.green),
                  title: Text('Start Time', style: headerStyle),
                  subtitle: Text(appointment.startTime?.toString() ?? 'N/A', style: contentStyle),
                ),
                Divider(), // Divider for separation
                // ListTile for end time with icon and text
                ListTile(
                  leading: Icon(Icons.calendar_today_outlined, color: Colors.red),
                  title: Text('End Time', style: headerStyle),
                  subtitle: Text(appointment.endTime?.toString() ?? 'N/A', style: contentStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
