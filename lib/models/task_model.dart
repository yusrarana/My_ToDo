import 'package:flutter/material.dart'; // <-- REQUIRED for TimeOfDay

enum Priority { high, medium, low }

class Task {
  final String title;
  final String description;
  final Priority priority;
  final DateTime dateTime;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    DateTime? dateTime,
    this.startTime,
    this.endTime,
  }) : dateTime = dateTime ?? DateTime.now();
}
