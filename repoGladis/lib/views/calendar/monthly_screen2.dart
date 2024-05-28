import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:switcher_button/switcher_button.dart';

import '../widgets/app_bar.dart';

class MonthlyScreen2 extends StatelessWidget {
  const MonthlyScreen2({Key? key}) : super(key: key);
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


  @override
  void initState() {
    super.initState();
    _appointments = [

      Appointment(
        title: 'Meeting',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SfCalendar(
        view: CalendarView.schedule,
        dataSource: AppointmentDataSource(_appointments),
        onTap: (details) 
        {
          if (details.appointments == null)
            {_showAppointmentForm(details.date);}
          else
            {

            }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
   late  bool? _isAllDay;

  @override
  void initState() {
    super.initState();
    _startDate = widget.date;
    _endDate = widget.date?.add(Duration(hours: 1));
    _isAllDay=false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Event'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
           Row(
             children: [
               Text('isAllDay'),
               SizedBox(width: 120,),
               SwitcherButton(
                 value: true,
                 offColor: Colors.white,
                 onColor: Colors.blue,
                 onChange: (value) {

                   if (value==true)
                     {
                       _isAllDay=true;
                     }
                   else
                   {
                      _isAllDay=false;
                   }

                 },
               )
             ],
           ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showOmniDateTimePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                        lastDate: DateTime.now().add(const Duration(days: 3652),),
                        is24HourMode: false,
                        isShowSeconds: false,
                        minutesInterval: 1,
                        secondsInterval: 1,
                        isForce2Digits: true,
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                          maxHeight: 650,
                        ),
                      );

                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                const SizedBox(width: 16),
               /* Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),

                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                ),*/

                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showOmniDateTimePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                          DateTime(1600).subtract(const Duration(days: 3652)),
                          lastDate: DateTime.now().add(const Duration(days: 3652),),
                          is24HourMode: false,
                          isShowSeconds: false,
                          minutesInterval: 1,
                          secondsInterval: 1,
                          isForce2Digits: true,
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          constraints: const BoxConstraints(
                            maxWidth: 350,
                            maxHeight: 650,
                          ),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: ()
          {
            if (_formKey.currentState!.validate()) {
              final appointment = Appointment(
                title: _titleController.text,
                startTime: _startDate,
                endTime: _endDate,
                isAllDay: _isAllDay,
              );
              Navigator.of(context).pop(appointment);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class Appointment {
  final String title;
  final DateTime? startTime;
  final DateTime? endTime;
  Color? background;
  bool? isAllDay;


  Appointment({
    required this.title,
    this.startTime,
    this.endTime,
    this.background=Colors.green,
    this.isAllDay=false
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
  bool isAllDay(int index) {
    return appointments[index].isAllDay!;
  }

  @override
  String getSubject(int index) {
    return appointments[index].title;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background!;
  }
}
