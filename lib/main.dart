// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc_sample/src/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runZonedGuarded(
      () {
        Provider.debugCheckInvalidValueType = null;
        runApp(const App());
      },
      (error, stackTrace) => print('ERROR: $error'),
    );
