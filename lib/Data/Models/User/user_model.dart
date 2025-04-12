import 'package:isar/isar.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';

part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  String? whatsappNumber;
  String? code;
  String? name;
  final location = IsarLink<Location>();
  final treatments = IsarLinks<Treatment>();
}