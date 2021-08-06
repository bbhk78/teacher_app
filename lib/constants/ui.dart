import 'package:flutter/material.dart';

import 'package:boysbrigade/constants/data.dart';

const Duration SPLASH_SCREEN_DURATION = Duration(seconds: 2);

// ignore: non_constant_identifier_names
final Map<String, Color> STATUS_COLORS = <String, Color>{
  StudentAttendance.absent.name: Colors.red.shade100,
  StudentAttendance.sick.name: Colors.orange.shade100,
  StudentAttendance.present.name: Colors.green.shade100,
  StudentAttendance.late.name: Colors.blue.shade100,
  StudentAttendance.pe.name: Colors.purple.shade100,
  StudentAttendance.unknown.name: Colors.grey.shade200,
};

// ignore: non_constant_identifier_names
final List<Color> HALF_YEAR_TILE_COLORS = <Color>[
  Colors.red.shade100,
  Colors.orange.shade100,
  Colors.green.shade100,
  Colors.blue.shade100,
];
