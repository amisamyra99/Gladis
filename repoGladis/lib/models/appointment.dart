import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Appointment {
  String id;
  final String title;
  final DateTime? startTime;
  final DateTime? endTime;
  final Color? background;
  final bool? isAllDay;
  //final AppointmentCategory category; // Add category

  Appointment({
    required this.title,
    this.startTime,
    this.endTime,
    this.background,
    this.isAllDay,
    //required this.category, // Make category required
    String? id,
  }) : id = id ?? Uuid().v4();
}

// Define AppointmentCategory enum
enum AppointmentCategory { meeting, appointment, leisure, other }


class AppointmentDataSource extends CalendarDataSource {

  final List<Appointment> appointments;

  AppointmentDataSource(this.appointments);

  @override
  DateTime getStartTime(int index) {
    return appointments[index].startTime ?? DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].endTime ?? DateTime.now().add(const Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return appointments[index].title;
  }

  @override
  bool isAllDay(int index) {

    return appointments![index].isAllDay ?? false;
  }



  @override
  Color getColor(int index) {

    return appointments![index].background ?? Colors.blue;
  }
}
