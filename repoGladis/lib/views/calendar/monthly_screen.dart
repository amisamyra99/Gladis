import 'package:flutter/material.dart';
import 'package:repo/app_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class MonthlyScreen extends StatelessWidget {
  const MonthlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,
          showTodayButton: true,
          showDatePickerButton: true,
          monthViewSettings: const MonthViewSettings(
            showAgenda: true
          ),

        ),
      ),
    );
  }
}
