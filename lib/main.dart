import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/splashscreen.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Sarkari Karmachari Hospital',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: kBlue),
    home: const LoginPage(),
  ),
);
