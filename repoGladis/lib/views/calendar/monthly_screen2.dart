import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
  late List<Appointment> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = [
      Appointment(
        title: 'Meeting',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: AppointmentDataSource(_appointments),
        onTap: (details) {
          if (details.appointments == null) _showAppointmentForm(details.date);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAppointmentForm(null),
      ),
    );
  }

  _getCalendarDataSource() {
    return AppointmentDataSource(_appointments);
  }

  void _showAppointmentForm(DateTime? date) async {
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
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.date;
    _endDate = widget.date?.add(Duration(hours: 1));
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Start Date'),
                          Text(_startDate?.toString() ?? 'Select Date'),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('End Date'),
                          Text(_endDate?.toString() ?? 'Select Date'),
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
