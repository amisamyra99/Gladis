part of event_calendar;

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';


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
