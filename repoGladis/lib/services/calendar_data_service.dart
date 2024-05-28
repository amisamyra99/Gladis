import 'package:flutter/material.dart';
import '../models/appointment.dart';


class CalendarDataService {

  // Private constructor to prevent creating new instances
  CalendarDataService._internal();

  // Static, private instance of the class
  static final CalendarDataService _instance = CalendarDataService._internal();

  // Factory constructor that returns the singleton instance
  factory CalendarDataService() {
    return _instance;
  }
  final List<Appointment> _appointments = [];

  // CREATE
  void createAppointment(Appointment appointment) {
    _appointments.add(appointment);
   // _appointments.sort((a, b) => a.startTime!.compareTo(b.startTime!));
  }

  // READ (Get all appointments)
  List<Appointment> getAppointments() {
    return _appointments;
  }

  // READ (Get appointment by ID)
  Appointment? getAppointmentById(String id) {
    return _appointments.firstWhere(
          (appointment) => appointment.id == id,
      orElse: () => Appointment(title: '',), // Return a default Appointment object
    );
  }

  // UPDATE (Update an appointment by ID)
  void updateAppointment(String id, Appointment updatedAppointment) {
    int index = _appointments.indexWhere((appointment) => appointment.id == id);
    if (index != -1) {
      _appointments[index] = updatedAppointment;
      _appointments.sort((a, b) => a.startTime!.compareTo(b.startTime!));
    }
  }

  // DELETE (Remove an appointment by ID)
  void deleteAppointment(String id) {
    _appointments.removeWhere((appointment) => appointment.id == id);
  }

// ... (Your additional methods) ...
  // Get appointments by category

}