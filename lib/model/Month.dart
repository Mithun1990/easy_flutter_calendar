import 'package:flutter/material.dart';

import 'WeekData.dart';


class Month {
  Month(
      this.numOfDays,
      this.monthName,
      this.year,
      this.monthId,
      this.prevMonthDays,
      this.monthFirstDay,
      this.selectedDate,
      this.weekHolidaysMap);

  final numOfDays;
  final monthName;
  final year;
  final monthId;
  final prevMonthDays;
  final monthFirstDay;
  DateTime selectedDate;
  Map weekHolidaysMap;

  List<MonthData> getMonths() {
    List<MonthData> list = new List<MonthData>();

    int pervExtraDays = monthFirstDay - 1;
    for (int i = 0; i < pervExtraDays; i++) {
      list.add(MonthData(DateTime(year, monthId - 1, prevMonthDays - i),
          Colors.black12, false, false, false));
    }
    list = list.reversed.toList();

    for (int i = 0; i < numOfDays; i++) {
      int _weekId = ((i + 1 + pervExtraDays) % weeks.length == 0
          ? weeks.length
          : (i + 1 + pervExtraDays) % weeks.length);
      int _weekDay = weekDays[_weekId];

      if (i + 1 == selectedDate.day &&
          monthId == selectedDate.month &&
          selectedDate.year == year) {
        list.add(MonthData(
            DateTime(year, monthId, i + 1),
            weekHolidaysMap.containsKey(_weekDay) ? Colors.red : Colors.white,
            true,
            true,
            weekHolidaysMap.containsKey(_weekDay)));
      } else {
        list.add(MonthData(
            DateTime(year, monthId, i + 1),
            weekHolidaysMap.containsKey(_weekDay) ? Colors.red : Colors.black,
            false,
            true,
            weekHolidaysMap.containsKey(_weekDay)));
      }
    }

    int daysAfterFirstWeek = numOfDays - (weeks.length - (monthFirstDay - 1));
    int extraDays = daysAfterFirstWeek % weeks.length;

    for (int i = 0; i < weeks.length - extraDays; i++) {
      list.add(MonthData(DateTime(year, monthId + 1, i + 1), Colors.black12,
          false, false, false));
    }
    return list;
  }
}

class MonthData {
  MonthData(this._dateTime, this.color, this.isSelected, this.isSelectable,
      this.isHoliday);

  final DateTime _dateTime;
  final color;
  bool isSelected = false;
  bool isSelectable = false;
  bool isHoliday;

  DateTime get dateTime => _dateTime;
}
