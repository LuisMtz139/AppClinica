import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:isar/isar.dart';

class TreatmentRepository {
  final Isar isar;

  const TreatmentRepository(this.isar);

  Future<Treatment?> getTreatmentById(int id) async {
    Treatment? treatment = await isar.collection<Treatment>().get(id);
    return treatment;
  }

  Future<Treatment?> getTreatmentByOrderId(int id) async {
    Treatment? treatment = await isar.collection<Treatment>().filter().orderIdEqualTo(id).findFirst();
    return treatment;
  }

  Future<bool> updateTreatment(Treatment newTreatment) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<Treatment>().put(newTreatment) > -1) {
        return true;
      }

      return false;
    });
  }
}