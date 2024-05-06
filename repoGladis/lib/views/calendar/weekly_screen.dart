import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 7,
          showDatePickerButton: true,
        ),
      ),
    );
  }
}
