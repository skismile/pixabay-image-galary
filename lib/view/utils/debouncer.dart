import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    // If a timer is already active, cancel it
    _timer?.cancel();

    // Start a new timer
    _timer = Timer(delay, action);
  }
}
