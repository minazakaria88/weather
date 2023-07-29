import 'package:flutter/material.dart';
import 'package:weather_new_app/dio.dart';
import 'package:weather_new_app/home.dart';

void main() {
  DioHelper.init();
  runApp(
    const MaterialApp(
      home: Home(),
    )
  );
}


