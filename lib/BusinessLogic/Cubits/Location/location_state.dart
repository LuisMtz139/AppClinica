part of 'location_cubit.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}


class LocationLoaded extends LocationState {
  final Location location;

  LocationLoaded({required this.location});
}

class LocationsLoaded extends LocationState {
  final List<Location> locationsList;

  LocationsLoaded({required this.locationsList});
}

class LocationSaved extends LocationState {}

class LocationUpdated extends LocationState {}

class LocationError extends LocationState {
  final String errorMessage;

  LocationError(this.errorMessage);
}