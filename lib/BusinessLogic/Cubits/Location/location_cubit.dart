import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Data/Repositories/location_repository.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _repository;
  LocationCubit(this._repository) : super(LocationInitial());

  Future<void> fetchLocations() async {
    try {
      emit(LocationLoading());
      String data = await _repository.getLocationsBySOAP();
      if (data.contains('ERR: Franquicia Desconocida')) {
        emit(LocationError(data));
      } else {
        List auxLocations = data.split("€");
        for (String location in auxLocations) {
          Location currentLocation = await _repository.getLocationByCode(location.substring(0,3)) ?? Location();
          currentLocation.code = location.substring(0,3);
          currentLocation.city = location.substring(3);

          if (await _repository.updateLocation(currentLocation) == false) {
            emit(LocationError('Ocurrió un error al guardar la clínica.'));
            return;
          }

          emit(LocationsLoaded(locationsList: await _repository.getLocations()));
        }
      }
    } catch (e) {
      emit(LocationError('Ocurrió un error al obtener las clínicas del SPA: $e'));
    }
  }
}