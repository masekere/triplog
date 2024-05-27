import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  String _currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _formatCurrentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  String _formatCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _currentTime = _formatCurrentTime();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
          _currentTime,
          style: const TextStyle(color: Color(0xff8b2828)),
        );
  }
}