import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:isar/isar.dart';

class LocationRepository {
  final Isar isar;

  const LocationRepository(this.isar);

  Future<String> getLocationsBySOAP() async {
    return await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_FRANQUICIAS',
        envelopeName: 'SPA_FRANQUICIAS',
        content: {'DameNombreUDN': 'REGISTROINICIAL'}
    );
  }

  Future<bool> updateLocation(Location newLocation) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<Location>().put(newLocation) > -1) {
        return true;
      }

      return false;
    });
  }

  Future<Location?> getLocationById(int id) async {
    Location? location = await isar.collection<Location>().get(id);
    return location;
  }

  Future<Location?> getLocationByCode(String code) async {
    Location? location = await isar.collection<Location>().filter().codeEqualTo(code).findFirst();
    return location;
  }

  Future<List<Location>> getLocations() {
    return isar.collection<Location>().where().findAll();
  }
}