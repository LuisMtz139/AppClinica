import 'package:isar/isar.dart';

part 'location_model.g.dart';

@collection
class Location {
  Id id = Isar.autoIncrement;
  String? code;
  String? city;
}