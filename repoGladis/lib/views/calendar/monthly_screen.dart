library event_calendar;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:repo/appointment_form_dialog.dart';
//import 'package:repo/appointment_details_screen.dart';
//import 'package:repo/main.dart';
//part 'package:repo/appointment_form_dialog.dart';

// Define a stateless widget for the monthly screen
class MonthlyScreen extends StatelessWidget {
  final List<Appointments> appointments;

  const MonthlyScreen({Key? key, required this.appointments}) : super(key: key);
  // Constructor for MonthlyScreen with an optional key
  //const MonthlyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return a Scaffold with CalendarScreen as the home widget
    return MaterialApp(
      home: CalendarScreen(appointments: appointments),
    );
  }
}

// Define a stateful widget for the calendar screen
class CalendarScreen extends StatefulWidget {
  final List<Appointments> appointments; // Receive appointments in CalendarScreen

  // Constructor to receive appointments
  CalendarScreen({required this.appointments});
  @override
  _MonthlyScreenState createState() => _MonthlyScreenState();
}

// Define the state for CalendarScreen
class _MonthlyScreenState extends State<CalendarScreen> {
  List<Appointments> _appointments = [];  // List to store appointments

  @override
  void initState() {
    super.initState();
    _appointments = widget.appointments; // Initialize appointments from widget
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isDialOpen = ValueNotifier(false);
    return WillPopScope(
      // Handle back button press to close speed dial if open
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Expanded widget to hold the calendar
              Expanded(
                child: SfCalendar(
                  view: CalendarView.month,
                 /* onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.calendarCell) {
                      _showAppointmentForm(context, details.date);
                    }
                  },*/
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.lightBlue, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  todayHighlightColor: Colors.lightBlue,
                  showTodayButton: true,
                  showDatePickerButton: true,
                  monthViewSettings: const MonthViewSettings(
                    agendaStyle: AgendaStyle(),
                    showTrailingAndLeadingDates: false,
                    showAgenda: true,
                    agendaViewHeight: 400,
                  ),
                  dataSource: AppointmentDataSource(_appointments),  // Set data source for appointments
                  onTap: (CalendarTapDetails details) {
                    if (details.appointments != null) {
                      /*final appointment = details.appointments!.first;
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailsScreen(appointment: appointment),
                        ),
                      );*/
                    } else {
                      _showAppointmentForm(context, details.date);
                    }
                  },
                ),
              ),
              // Container to hold the bottom row with buttons
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // InkWell for microphone button
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.mic_rounded, color: Colors.white),
                      ),
                    ),
                    // Speed dial for adding appointments
                    SpeedDial(
                      animatedIcon: AnimatedIcons.add_event,
                      animatedIconTheme: const IconThemeData(color: Colors.white),
                      activeBackgroundColor: Colors.blue,
                      backgroundColor: Colors.blue,
                      closeManually: true,
                      openCloseDial: isDialOpen,
                      curve: Curves.bounceIn,
                      onOpen: () => _showAppointmentForm(context, null),  // Show form on speed dial open
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the appointment form dialog
  void _showAppointmentForm(BuildContext context, DateTime? date) async {
    final form = await showDialog(
      context: context,
      builder: (context) => AppointmentFormDialog(initialDate: date),
    );
    if (form != null) {
      setState(() {
        _appointments.add(form); //Add new appointment to the list
      });
      // Handle form submission
    }
  }
}

// Data source class for appointments in the calendar
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointments> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;  // Get start time of appointment
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;  // Get end time of appointment
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;  // Get title of appointment
  }
}
