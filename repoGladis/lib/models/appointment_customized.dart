import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Appointment {
  String id;
  final String title;
  final DateTime? startTime;
  final DateTime? endTime;
  Color? background;
  bool? isAllDay;
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