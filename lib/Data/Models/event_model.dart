import 'package:intl/intl.dart';

class Event {
  final String title;
  final DateTime dateTime;
  Event({required this.title, required this.dateTime});

  @override
  String toString() => '$title\n${DateFormat.yMMMMd('es-MX').add_jm().format(dateTime)}';

  String toShortString() => DateFormat.jm().format(dateTime);
}