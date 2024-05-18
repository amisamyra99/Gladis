import 'package:flutter/material.dart';
import 'package:repo/views/calendar/widgets/appointments_form.dart';
import 'package:repo/views/calendar/widgets/voiceInputWidget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:repo/models/appointment_customized.dart' as apt;

import '../../services/speech_recognition_service.dart';


class MonthlyScreen extends StatelessWidget
{
  final speechRecognitionService = SpeechRecognitionService();

   MonthlyScreen({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarScreen(speechRecognitionService:speechRecognitionService ,),
    );
  }
}
class CalendarScreen extends StatefulWidget {
  final SpeechRecognitionService speechRecognitionService;
  CalendarScreen({super.key, required this.speechRecognitionService});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();

}

class _CalendarScreenState extends State<CalendarScreen> {
  //  first create a list of appointments
  List<apt.Appointment> _appointments = [];
  String _recognizedText = ""; // To store text from the service
  @override
  void initState() {
    super.initState();
    // Initialize speech recognition here
    widget.speechRecognitionService.initialize();
  }
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
              if (details is CalendarTapDetails && details.targetElement == CalendarElement.header) {
                // _showAppointmentForm(context, null);
              } else if (details.appointments == null) {
                _showAppointmentForm(context, details.date);
              }
            },
          ),
        ),
        floatingActionButton: Row(
          children: [
            SizedBox(width: size.width * 0.15),
           VoiceInputWidget(
             size: 60,
    onTap: () {
    if (widget.speechRecognitionService.isListening)
    {
    widget.speechRecognitionService.stopListening();
    }
    else
    {
    widget.speechRecognitionService.startListening((text)
    {
    setState(()
    {
    _recognizedText = text;

    }
    );

    },);}
    },
        ),
            // Expanded( // Wrap the SpeedDial widget with Expanded
            //   child: SizedBox(), // Replace this with your SpeedDial widget
            // ),
            SizedBox(width: size.width * 0.60),
            SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              animatedIconTheme: const IconThemeData(color: Colors.white),
              activeBackgroundColor: Colors.blue,
              backgroundColor: Colors.blue,
              closeManually: true,
              openCloseDial: isDialOpen,
              curve: Curves.bounceIn,
              // children: [
              //   SpeedDialChild(
              //     elevation: 0,
              //     child: const Icon(Icons.event, color: Colors.white),
              //     backgroundColor: Colors.blue,
              //     label: 'Create Event',
              //     labelBackgroundColor: Colors.blue,
              //     labelStyle: const TextStyle(color: Colors.white),
              //     // onTap: () => _showAppointmentForm(context, null),
              //   ),
              // ],
              onOpen: () => _showAppointmentForm(context, null),
            )
          ],),
      ),
    );
  }
// this use to print add event over calendar
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
