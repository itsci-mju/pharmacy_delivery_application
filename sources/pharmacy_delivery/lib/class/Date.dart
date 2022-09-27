import 'package:intl/intl.dart';

class Date {

  int year;
  int month;
  int dayOfMonth;
  int hourOfDay;
  int minute;
  int second;

  Date({
    required this.year,
    required this.month,
    required this.dayOfMonth,
    required this.hourOfDay,
    required this.minute,
    required this.second,
  });

  factory Date.fromJson(Map<String, dynamic> json) =>
      Date(
        year: json["year"],
        month: json["month"],
        dayOfMonth: json["dayOfMonth"],
        hourOfDay: json["hourOfDay"],
        minute: json["minute"],
        second: json["second"],
      ) ;

  Map<String, dynamic> toJson() =>
      {
        "year": year,
        "month": month,
        "dayOfMonth": dayOfMonth,
        "hourOfDay": hourOfDay,
        "minute": minute,
        "second": second,
      };

  DateTime toDateTime() {
    return  DateTime(
        year, month+1, dayOfMonth, hourOfDay, minute, second);
  }

  DateTime toDateTime2() {
    return  DateTime(
        year, month, dayOfMonth, hourOfDay, minute, second);
  }


  factory Date.toDate(DateTime dateTime) {
    return  Date(year: dateTime.year, month :dateTime.month-1, dayOfMonth:dateTime.day, hourOfDay:dateTime.hour, minute:dateTime.minute, second:dateTime.second);
  }

  factory Date.fromString(String date) {
    final dt = date.split(" ");

    final d = dt[0].split("-");
    final t = dt[1].split(":");


    return Date(
      year: int.parse(d[0]),
      month: int.parse(d[1]),
      dayOfMonth: int.parse(d[2]),
      hourOfDay: int.parse(t[0]),
      minute: int.parse(t[1]),
      second: int.parse(t[2]),
    );
  }


}
String DateTimetoString(DateTime time) {
  DateTime t = DateTime(time.year+543, time.month, time.day, time.hour, time.minute, time.second);
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(t );

}
