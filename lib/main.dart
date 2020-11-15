// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc_sample/src/app.dart';
import 'package:flutter/material.dart';

void main() => runZonedGuarded(
      () => runApp(const App()),
      (error, stackTrace) => print('ERROR: $error'),
    );
