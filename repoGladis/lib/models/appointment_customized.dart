import 'package:flutter/material.dart';

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
    this.background,
    this.isAllDay
  });
}