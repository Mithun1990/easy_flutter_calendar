import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/model/Month.dart';
import 'package:flutter_calendar/model/Week.dart';
import 'package:flutter_calendar/model/WeekData.dart';
import 'package:intl/intl.dart';

class EasyFlutterCalendar extends StatefulWidget {
  EasyFlutterCalendar(
      {Key key,
      @required this.onDateChange,
      this.selectedDate,
      this.minDate,
      this.maxDate,
      this.weekHolidays,
      this.selectedDayColor,
      this.titleColor,
      this.weekTitleColor,
      this.weekHolidayTitleColor,
      this.monthDayColor,
      this.titleFontSize,
      this.weekFontSize,
      this.monthDayFontSize,
      this.titleFontFamily,
      this.weekFontFamily,
      this.monthDayFontFamily,
      this.isYearChangeAvailable})
      : assert(onDateChange != null),
        super(key: key);

  DateTime selectedDate;
  DateTime minDate, maxDate;
  int weekFontSize, titleFontSize, monthDayFontSize;
  String weekTitleColor, weekHolidayTitleColor, titleColor, monthDayColor;
  String titleFontFamily, weekFontFamily, monthDayFontFamily;
  String selectedDayColor;
  List<WeekData> weekHolidays;
  ValueChanged<DateTime> onDateChange;
  ValueChanged<DateTime> onMonthChange;
  ValueChanged<DateTime> onYearChange;
  bool isYearChangeAvailable = false;

  @override
  _FlutterCalendar createState() => _FlutterCalendar();
}

class _FlutterCalendar extends State<EasyFlutterCalendar> {
  Month month;
  DateTime _mainDate, _minDate, _maxDate, _selectedDate;
  Map weekHolidaysMap;
  double initial, distance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.isYearChangeAvailable
                      ? Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          width: 40,
                          height: 40,
                          child: InkResponse(
                              onTap: () {
                                gotoPreviousYear();
                              },
                              child: Image.asset(
                                  "assets/icon/icon_left_arriw_year.png")),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: 40,
                    height: 40,
                    child: InkResponse(
                        onTap: () {
                          gotoPreviousMonth();
                        },
                        child: Image.asset(
                            "assets/icon/icon_left_arriw_month.png")),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                    width: 170,
                    child: Text(
                      month.monthName,
                      style: TextStyle(
                          color:
                              hexToColor(widget.titleColor) ?? Colors.lightBlue,
                          fontSize: widget.titleFontSize ?? 18,
                          fontFamily: widget.titleFontFamily ?? null),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    width: 40,
                    height: 40,
                    child: InkResponse(
                        onTap: () {
                          gotoNextMonth();
                        },
                        child: Image.asset(
                            "assets/icon/icon_right_arriw_month.png")),
                  ),
                  widget.isYearChangeAvailable
                      ? Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          width: 40,
                          height: 40,
                          child: InkResponse(
                              onTap: () {
                                gotoNextYear();
                              },
                              child: Image.asset(
                                  "assets/icon/icon_right_arriw_year.png")),
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: weeks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: weeks.length),
                  itemBuilder: (BuildContext context, int index) {
                    return GridTile(
                      child: Center(
                        child: new Text(
                          weeks[index].weekTitle,
                          style: TextStyle(
                              fontSize: widget.weekFontSize ?? 18,
                              fontFamily: widget.weekFontFamily ?? null,
                              color: weekHolidaysMap
                                      .containsKey(weekDays[index + 1])
                                  ? hexToColor(widget.weekHolidayTitleColor) ??
                                      Colors.red
                                  : hexToColor(widget.weekTitleColor) ??
                                      Colors.black),
                        ), //just for testing, will fill with image later
                      ),
                    );
                  }),
            ),
            GestureDetector(
                onPanStart: (DragStartDetails details) {
                  initial = details.globalPosition.dx;
                },
                onPanUpdate: (DragUpdateDetails details) {
                  distance = details.globalPosition.dx - initial;
                },
                onPanEnd: (DragEndDetails details) {
                  initial = 0.0;
                  print(distance);
                  //+ve distance signifies a drag from left to right(start to end)
                  //-ve distance signifies a drag from right to left(end to start)
                  if (distance.isNegative) {
                    gotoNextMonth();
                  } else {
                    gotoPreviousMonth();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: month.getMonths().length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: weeks.length),
                      itemBuilder: (BuildContext context, int index) {
                        return GridTile(
                          child: InkResponse(
                            onTap: () {
                              if (month.getMonths()[index].isSelectable) {
                                _selectedDate =
                                    month.getMonths()[index].dateTime;
                                changeDateTime(
                                    month.getMonths()[index].dateTime);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: month.getMonths()[index].isSelected
                                  ? BoxDecoration(
                                      color:
                                          hexToColor(widget.selectedDayColor) ??
                                              Colors.lightBlueAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    )
                                  : null,
                              child: Center(
                                child: new Text(
                                  month
                                      .getMonths()[index]
                                      .dateTime
                                      .day
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: widget.monthDayFontSize ?? 18,
                                      fontFamily: widget.monthDayFontFamily,
                                      color: hexToColor(widget.monthDayColor) ??
                                          month.getMonths()[index].color),
                                ), //just for testing, will fill with image later
                              ),
                            ),
                          ),
                        );
                      }),
                ))
          ],
        ));
  }

  @override
  void initState() {
    widget.weekHolidays = widget.weekHolidays ?? [none];
    _minDate = widget.minDate ?? DateTime(1900, 1);
    _maxDate = widget.maxDate ?? DateTime(2100, 12);
    weekHolidaysMap = widget.weekHolidays.asMap().map((index, value) =>
        MapEntry(widget.weekHolidays[index].weekDay,
            widget.weekHolidays[index].weekId));
    _mainDate = widget.selectedDate ?? DateTime.now();
    _selectedDate = widget.selectedDate ?? _mainDate;
    print(_mainDate);
    int _currentMonthYear = _mainDate.year;
    int _prevMonthYear = getPrevMonthYear(_mainDate.month, _mainDate.year);
    int _prevMonth = getPrevMonth(_mainDate.month);
    int monthLength = getLengthOfMonth(_mainDate.month, _mainDate.year);
    int _prevMonthLength = getLengthOfMonth(_prevMonth, _prevMonthYear);
    var currentMonthFirstDate = DateTime(_currentMonthYear, _mainDate.month, 1);
    print(currentMonthFirstDate.weekday);
    print(weekIds[currentMonthFirstDate.weekday]);
    month = Month(
        monthLength,
        DateFormat.yMMMM().format(_mainDate),
        _mainDate.year,
        _mainDate.month,
        _prevMonthLength,
        weekIds[currentMonthFirstDate.weekday],
        _selectedDate,
        weekHolidaysMap);
  }

  void changeDateTime(DateTime dateTime) {
    setState(() {
      _mainDate = dateTime;
      widget.onDateChange(dateTime);
      monthConfig(_mainDate);
    });
  }

  void gotoPreviousYear() {
    DateTime date = DateTime(_mainDate.year - 1, _mainDate.month);
    if (date.isBefore(_minDate)) return;
    setState(() {
      _mainDate = date;
      monthConfig(date);
    });
  }

  void gotoNextYear() {
    DateTime date = DateTime(_mainDate.year + 1, _mainDate.month);
    if (date.isAfter(_maxDate)) return;
    setState(() {
      _mainDate = date;
      monthConfig(date);
    });
  }

  void gotoPreviousMonth() {
    DateTime date = DateTime(getPrevMonthYear(_mainDate.month, _mainDate.year),
        getPrevMonth(_mainDate.month));
    if (date.isBefore(_minDate)) return;
    setState(() {
      _mainDate = date;
      monthConfig(date);
    });
  }

  void gotoNextMonth() {
    DateTime date = DateTime(getNextYear(_mainDate.month, _mainDate.year),
        getNextMonth(_mainDate.month));
    if (date.isAfter(_maxDate)) return;
    setState(() {
      _mainDate = date;
      monthConfig(date);
    });
  }

  void monthConfig(var date) {
    int _currentMonthYear = date.year;
    int _prevMonthYear = getPrevMonthYear(date.month, date.year);
    int _prevMonth = getPrevMonth(date.month);
    int monthLength = getLengthOfMonth(date.month, date.year);
    int _prevMonthLength = getLengthOfMonth(_prevMonth, _prevMonthYear);
    var currentMonthFirstDate = DateTime(_currentMonthYear, date.month, 1);
    print(currentMonthFirstDate.weekday);
    print(weekIds[currentMonthFirstDate.weekday]);
    month = Month(
        monthLength,
        DateFormat.yMMMM().format(date),
        date.year,
        date.month,
        _prevMonthLength,
        weekIds[currentMonthFirstDate.weekday],
        _selectedDate,
        weekHolidaysMap);
  }

  int getLengthOfMonth(int month, int year) {
    int daysInMonth = month == 2
        ? 28 +
            (year % 4 == 0 ? 1 : 0) -
            (year % 100 == 0 ? (year % 400 == 0 ? 0 : 1) : 0)
        : 31 - (month - 1) % 7 % 2;
    return daysInMonth;
  }

  int getPrevMonthYear(int month, int year) {
    if (month == 1) {
      year = year - 1;
    }
    return year;
  }

  int getPrevMonth(int month) {
    if (month == 1) {
      month = 12;
    } else {
      month = month - 1;
    }
    return month;
  }

  int getNextMonth(int month) {
    if (month == 12) {
      month = 1;
    } else {
      month = month + 1;
    }
    return month;
  }

  int getNextYear(int month, int year) {
    if (month == 12) {
      year = year + 1;
    }
    return year;
  }

  Color hexToColor(String code) {
    try {
      return code == null
          ? null
          : new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
