library event_calendar;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:repo/views/Authentification/google_auth.dart';
import 'package:repo/views/Authentification/microsoft_auth.dart';

part 'appointment.dart';

class MonthlyScreen extends StatelessWidget {
  const MonthlyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Appointment> _appointments = [];
  final isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
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
          child: SfCalendar(
            view: CalendarView.month,
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
            dataSource: AppointmentDataSource(_appointments),
            onTap: (details) {
              if (details.appointments == null) {
                _showAppointmentForm(context, details.date);
              }
            },
          ),
        ),
        floatingActionButton: Row(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.fromLTRB(50, 0, 0, 5),
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
            SizedBox(width: size.width * 0.60),
            SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              animatedIconTheme: const IconThemeData(color: Colors.white),
              activeBackgroundColor: Colors.blue,
              backgroundColor: Colors.blue,
              closeManually: true,
              openCloseDial: isDialOpen,
              curve: Curves.bounceIn,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.calendar_today),
                  label: 'Google Calendar',
                  onTap: _fetchGoogleEvents,
                ),
                SpeedDialChild(
                  child: Icon(Icons.calendar_view_day),
                  label: 'Outlook Calendar',
                  onTap: _fetchMicrosoftEvents,
                ),
                SpeedDialChild(
                  child: Icon(Icons.calendar_view_day),
                  label: 'Manual Calendar',
                  onTap: () => _showAppointmentForm(context, null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showAppointmentForm(BuildContext context, DateTime? date) async {
    final form = await showDialog(
      context: context,
      builder: (context) => AppointmentForm(date: date),
    );

    if (form != null) {
      setState(() {
        _appointments.add(form);
      });
    }
  }

  void _fetchGoogleEvents() async {
    final googleAuth = GoogleAuth();
    final account = await googleAuth.signIn();

    if (account != null) {
      final calendarApi = await googleAuth.getCalendarApi(account);
      final events = await calendarApi.events.list('primary');

      setState(() {
        _appointments.addAll(events.items!.map((e) => Appointment(
          startTime: e.start!.dateTime ?? DateTime.now(),
          endTime: e.end!.dateTime ?? DateTime.now().add(Duration(hours: 1)),
          subject: e.summary ?? '',
          color: Colors.blue,
        )).toList());
      });
    }
  }

  void _fetchMicrosoftEvents() async {
    final microsoftAuth = MicrosoftAuth(
      clientId: 'your-client-id',
      clientSecret: 'your-client-secret',
      redirectUrl: 'your-redirect-url',
    );
    final oauthClient = await microsoftAuth.signIn();
    final events = await microsoftAuth.getCalendarEvents(oauthClient);

    setState(() {
      _appointments.addAll(events.map((e) => Appointment(
        startTime: DateTime.parse(e['start']['dateTime']),
        endTime: DateTime.parse(e['end']['dateTime']),
        subject: e['subject'] ?? '',
        color: Colors.green,
      )).toList());
    });
  }
}

// class AppointmentForm extends StatelessWidget {
//   final DateTime? date;
//
//   AppointmentForm({this.date});
//
//   @override
//   Widget build(BuildContext context) {
//     // Implement your appointment form here
//     return Container();
//   }
// }