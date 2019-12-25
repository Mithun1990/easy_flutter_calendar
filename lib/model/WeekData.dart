import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/model/Week.dart';

class WeekData {
  WeekData(this.weekTitle, this.weekDay, this.weekId);

  final weekTitle;
  final weekDay;
  final weekId;
}

List<WeekData> weeks = <WeekData>[
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
];

Map weekIds = weeks
    .asMap()
    .map((index, value) => MapEntry(weeks[index].weekDay, weeks[index].weekId));

Map weekDays = weeks
    .asMap()
    .map((index, value) => MapEntry(weeks[index].weekId, weeks[index].weekDay));
