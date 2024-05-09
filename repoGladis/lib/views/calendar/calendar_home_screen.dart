import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarController _controller = CalendarController();
    Color? _headerColor, _viewHeaderColor, _calendarColor;
    var size=MediaQuery.of(context).size;
    return  Scaffold(
      body: SafeArea(
        child:
        SfCalendar(
          view: CalendarView.day,
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.workWeek,
            CalendarView.month,
            CalendarView.schedule,

          ],

          monthViewSettings: const MonthViewSettings(
            agendaStyle: AgendaStyle(

            ),
            showTrailingAndLeadingDates: false,
            showAgenda: true,
            agendaViewHeight: 400,

          ),
          initialDisplayDate: DateTime.now(),
          showDatePickerButton: true,


      ),
      ),


    );
  }
}
