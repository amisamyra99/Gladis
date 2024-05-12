import 'package:flutter/material.dart';
import 'package:repo/app_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MyAppBar(),
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