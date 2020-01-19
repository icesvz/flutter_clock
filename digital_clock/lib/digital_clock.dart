// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
//  _Element.background: Color(0xFF81B3FE),
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  DateTime _dateTimePast = DateTime.now();
  Timer _timer;
  bool _tube_cleaning = false;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTimePast = _dateTime;
      _dateTime = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final date6 = DateFormat('HHmmss').format(_dateTime);
    final imageSize = (MediaQuery.of(context).size.width - 50) / 6;

    _tube_cleaning = false;
    if (('0' == date6[4]) && ('0' == date6[5])) {
      _tube_cleaning = true;
    }

    return Container(
        color: colors[_Element.background],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    _tube_cleaning
                        ? 'images/cleaner.gif'
                        : 'images/' + date6[0] + '.png',
                    width: imageSize),
                Image.asset(
                    _tube_cleaning
                        ? 'images/cleaner.gif'
                        : 'images/' + date6[1] + '.png',
                    width: imageSize),
                Image.asset(
                    _tube_cleaning
                        ? 'images/cleaner.gif'
                        : 'images/' + date6[2] + '.png',
                    width: imageSize),
                Image.asset(
                  _tube_cleaning
                      ? 'images/cleaner.gif'
                      : 'images/' + date6[3] + '.png',
                  width: imageSize,
                ),
                Image.asset(
                  _tube_cleaning
                      ? 'images/cleaner.gif'
                      : 'images/' + date6[4] + '.png',
                  width: imageSize,
                ),
                Image.asset(
                  _tube_cleaning
                      ? 'images/cleaner.gif'
                      : 'images/' + date6[5] + '.png',
                  width: imageSize,
                ),
              ],
            ),
          ],
        ));
  }
}
