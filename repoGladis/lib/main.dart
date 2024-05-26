
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repo/views/Authentification/widget/custom_scaffold.dart';
import 'package:repo/views/calendar/calendar_home_screen.dart';
import 'package:repo/views/calendar/monthly_screen.dart';
import 'package:repo/views/calendar/monthly_screen2.dart';
import 'package:get/get.dart';
import 'package:repo/views/onboarding/intro_screen.dart';
import 'package:repo/appointment_form_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';




Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  //debugPaintSizeEnabled = true;
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // implement this function to fetch appointments from Firestore
  Future<List<Appointments>> fetchAppointmentsFromFirestore() async {
    try {
      // Fetch appointments from Firestore collection
      final querySnapshot = await FirebaseFirestore.instance.collection(
          'appointments').get();
      // Map each document snapshot to an Appointments object
      final appointments = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Appointments(
          title: data['title'] ?? '',
          startTime: data['startTime'] != null
              ? (data['startTime'] as Timestamp).toDate()
              : null,
          endTime: data['endTime'] != null ? (data['endTime'] as Timestamp)
              .toDate() : null,
        );
      }).toList();
      return appointments;
    } catch (error) {
      print('Error fetching appointments: $error');
      return []; // Return an empty list if there's an error
    }
  }

    @override
    Widget build(BuildContext context) {
      var size = MediaQuery
          .of(context)
          .size; // Get screen size

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,  // Disable debug banner
        title: 'Gladis Ai',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //debugShowMaterialGrid: true,  // Uncomment to show material grid
        // this the first screen that show app when you start the app
        //home: MonthlyScreen(appointments: appointments),
        // Uncomment and use FutureBuilder to fetch appointments
        home: FutureBuilder<List<Appointments>>(
          // Define this function to fetch appointments
          future: fetchAppointmentsFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Once appointments are fetched, pass them to MonthlyScreen
              final appointments = snapshot.data!;
              return MonthlyScreen(appointments: appointments);
            }
          },
        ),

        // Uncomment to add a floating button on every page
        // this the code use to show floating button on every pages
        /*builder: (context,child){
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => _showAppointmentForm(context, null),
              child: Text('Add Appointment'),
            ),
          ),
        );
    },*/

      );
    }
}

// this class has never been used, it was created for test purpose
class HomeScreen extends StatelessWidget {
  void _showAppointmentForm(BuildContext context, DateTime? date) {
    showDialog(
      context: context,
      builder: (context) => AppointmentFormDialog(initialDate: date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: SfCalendar(
        view: CalendarView.month,
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _showAppointmentForm(context, details.date);
          }
        },
      ),
    );
  }
}