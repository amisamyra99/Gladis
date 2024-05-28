import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:repo/views/calendar/widgets/voiceInputWidget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/appointment.dart' as apt;
import '../../services/calendar_data_service.dart';
import '../../services/speech_recognition_service.dart';
import '../widgets/app_bar.dart';
import 'package:repo/views/calendar/widgets/appointments_form.dart';

class MonthlyScreen2 extends StatelessWidget {
  final speechRecognitionService = SpeechRecognitionService();
  final dataService = CalendarDataService();
   MonthlyScreen2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  CalendarScreen(speechRecognitionService:speechRecognitionService ,dataService:dataService),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  final SpeechRecognitionService speechRecognitionService;
  final CalendarDataService dataService;
  CalendarScreen({super.key, required this.speechRecognitionService,required this.dataService});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<apt.Appointment> _appointments;
  String _recognizedText = ""; // To store text from the service
  @override


  @override
  void initState() {
    super.initState();
    widget.speechRecognitionService.initialize();
    _appointments=widget.dataService.getAppointments();
   /* _appointments = [

      apt.Appointment(
        title: 'Meeting',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
      ),
    ];*/
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isDialOpen = ValueNotifier(false);
    return Scaffold(
      appBar: const MyAppBar(),
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,

          monthViewSettings: const MonthViewSettings(
            agendaStyle: AgendaStyle(),
            showTrailingAndLeadingDates: false,
            showAgenda: true,
            agendaViewHeight: 400,
          ),

          dataSource: apt.AppointmentDataSource(_appointments),
          onTap: (details)
          {
            /*if (details.appointments == null)
              {_showAppointmentForm(details.date);}
            else
              {

              }*/
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
                _appointments=widget.dataService.getAppointments();
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
          SizedBox(width: size.width * 0.50),
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
            onOpen: () => _showAppointmentForm(context,null),
          )
        ],),
     /* floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAppointmentForm(null),
      ),*/
    );
  }

  _getCalendarDataSource() {
    return apt.AppointmentDataSource(_appointments);
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





