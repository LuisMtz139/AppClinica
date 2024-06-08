import 'package:isar/isar.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late final Future<Isar> db;

  IsarService._internal() {
    db = open();
  }

  static final IsarService instance = IsarService._internal();

  factory IsarService() {
    return instance;
  }

  Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [UserSchema, TreatmentSchema, LocationSchema],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }
}