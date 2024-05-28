import 'package:flutter/material.dart';
import 'package:repo/views/calendar/widgets/appointments_form.dart';
import 'package:repo/views/calendar/widgets/voiceInputWidget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:repo/models/appointment.dart' as apt;

import '../../services/speech_recognition_service.dart';
import '../../services/calendar_data_service.dart';
import '../widgets/app_bar.dart';

class ScheduleScreen extends StatelessWidget
{
  final speechRecognitionService = SpeechRecognitionService();
  final dataService = CalendarDataService();

  ScheduleScreen({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarScreen(speechRecognitionService:speechRecognitionService ,dataService:dataService),
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
  //  first create a list of appointments
  List<apt.Appointment> _appointments = [];
  String _recognizedText = ""; // To store text from the service
  @override
  void initState() {
    super.initState();
    // Initialize speech recognition here
    widget.speechRecognitionService.initialize();
    _appointments=widget.dataService.getAppointments();
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
        appBar: const MyAppBar(),
        body: SafeArea(
          child: SfCalendar(
            view: CalendarView.schedule,
            selectionDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.lightBlue, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              shape: BoxShape.rectangle,
            ),
            todayHighlightColor: Colors.lightBlue,
            showTodayButton: true,
            showDatePickerButton: true,
            blackoutDates: const [],
            //dragAndDropSettings: ,
            viewHeaderStyle: const ViewHeaderStyle(backgroundColor: Colors.white),
            backgroundColor: Colors.white,
            scheduleViewSettings:const  ScheduleViewSettings(
                hideEmptyScheduleWeek: true,

                weekHeaderSettings: WeekHeaderSettings(
                    startDateFormat: 'dd MMM ',
                    endDateFormat: 'dd MMM, yy',
                    height: 50,
                    textAlign: TextAlign.center,
                    backgroundColor: Colors.blue,
                    weekTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ))
            ),
            dataSource: apt.AppointmentDataSource(_appointments),
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
