import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


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
              if (details.appointments == null) _showAppointmentForm(context, details.date);
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

class AppointmentForm extends StatefulWidget {
  final DateTime? date;

  AppointmentForm({this.date});

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.date ?? DateTime.now();
    _endDate = widget.date?.add(const Duration(hours: 1)) ?? DateTime.now().add(const Duration(hours: 1));
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
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Start Date'),
                          // Text(_startDate?.toString() ?? 'Select Date'),
                          // Remove const in Row above if above is uncommented
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('End Date'),
                          // Text(_endDate?.toString() ?? 'Select Date'),
                          // Remove const in Row above if above is uncommented
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final appointment = Appointment(
                title: _titleController.text,
                startTime: _startDate,
                endTime: _endDate,
              );
              Navigator.of(context).pop(appointment);
            }
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}

class Appointment {
  final String title;
  final DateTime? startTime;
  final DateTime? endTime;

  Appointment({
    required this.title,
    this.startTime,
    this.endTime,
  });
}

class AppointmentDataSource extends CalendarDataSource {
  final List<Appointment> appointments;

  AppointmentDataSource(this.appointments);

  @override
  DateTime getStartTime(int index) {
    return appointments[index].startTime ?? DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].endTime ?? DateTime.now().add(Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return appointments[index].title;
  }
}
