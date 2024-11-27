import 'package:isar/isar.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';

part 'treatment_model.g.dart';

@collection
class Treatment {
  Id id = Isar.autoIncrement;
  int? productId;
  int? orderId;
  String? name;
  int? availableAppointments;
  List<Appointment>? scheduledAppointments;
  List<DateRange>? dateRanges;
  List<DateTime>? availableDates;
  DateTime? firstDateToSchedule;
  DateTime? lastDateToSchedule;

  @Backlink(to: "treatments")
  final user = IsarLink<User>();
}

@embedded
class Appointment {
  int? id;
  String? date;
  String? time;

  Appointment({this.id, this.date, this.time});

  DateTime? get dateTime => date != null && time != null
      ? Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy H:mm:ss').dateTime
      : null;
  String? get jiffyDate => date != null
      ? Jiffy.parse(date!, pattern: 'dd/MM/yyyy').yMMMMEEEEd
      : null;
  String? get jiffyTime =>
      time != null ? Jiffy.parse(time!, pattern: 'H:mm:ss').jms : null;
  String? get jiffyDateTime => date != null && time != null
      ? Jiffy.parse('${date!} ${time!}', pattern: 'dd/MM/yyyy H:mm:ss')
          .yMMMMEEEEdjm
      : null;
}

@embedded
class DateRange {
  DateTime? initialDate;
  DateTime? endDate;
  int? availableSchedules;

  static const double fontSize = 20.0;
  DateRange({this.initialDate, this.endDate, this.availableSchedules});

  RichText toRichText() {
    if (initialDate != null && endDate != null && availableSchedules != null) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Tienes ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: '$availableSchedules',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: ' cita(s) disponible(s) entre el día ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: '${Jiffy.parseFromDateTime(initialDate!).yMMMMEEEEd}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: ' y el día ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: '${Jiffy.parseFromDateTime(endDate!).yMMMMEEEEd}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          text: '',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }

  @override
  String toString() {
    if (initialDate != null && endDate != null && availableSchedules != null) {
      return 'Tienes $availableSchedules cita(s) disponible(s) entre el día ${Jiffy.parseFromDateTime(initialDate!).yMMMMEEEEd} y el día ${Jiffy.parseFromDateTime(endDate!).yMMMMEEEEd}';
    } else {
      return '';
    }
  }
}
