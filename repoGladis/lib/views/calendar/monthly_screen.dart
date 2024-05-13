library event_calendar;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  _MonthlyScreenState createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<CalendarScreen> {
  List<Appointment> _appointments = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isDialOpen = ValueNotifier(false);
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
              if (details is CalendarTapDetails &&
                  details.targetElement == CalendarElement.header) {
                // _showAppointmentForm(context, null);
              } else if (details.appointments == null) {
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
              onOpen: () => _showAppointmentForm(context, null),
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
      // Handle form submission
    }
  }
}
