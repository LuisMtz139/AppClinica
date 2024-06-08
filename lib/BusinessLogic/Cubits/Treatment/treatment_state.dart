part of 'treatment_cubit.dart';

abstract class TreatmentState {}

class TreatmentInitial extends TreatmentState {}

class TreatmentLoading extends TreatmentState {}


class TreatmentLoaded extends TreatmentState {
  final Treatment treatment;

  TreatmentLoaded({required this.treatment});
}

class TreatmentsLoaded extends TreatmentState {
  final List<Treatment> treatmentsList;

  TreatmentsLoaded({required this.treatmentsList});
}

class TreatmentSaved extends TreatmentState {}

class TreatmentUpdated extends TreatmentState {}

class TreatmentError extends TreatmentState {
  final String errorMessage;

  TreatmentError(this.errorMessage);
}