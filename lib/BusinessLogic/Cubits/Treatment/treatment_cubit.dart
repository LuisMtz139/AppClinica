import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/Data/Repositories/treatment_repository.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';

part 'treatment_state.dart';

class TreatmentCubit extends Cubit<TreatmentState> {
  final TreatmentRepository _repository;

  TreatmentCubit(this._repository) : super(TreatmentInitial());

  Future<void> updateTreatment(Treatment treatment) async {
    try {
      await _repository.updateTreatment(treatment);
      emit(TreatmentUpdated());
    } catch (e) {
      emit(TreatmentError('Ocurrió un error al actualizar el tratamiento: $e'));
    }
  }

  Future<Treatment?> getTreatmentByOrderId(int orderId) async {
    try {
      emit(TreatmentLoading());
      Treatment? currentTreatment = await _repository.getTreatmentByOrderId(orderId) ?? Treatment();
      emit(TreatmentLoaded(treatment: currentTreatment));
      return await _repository.getTreatmentByOrderId(orderId);
    } catch (e) {
      emit(TreatmentError('Ocurrió un error al obtener el tratamiento: $e'));
      return null;
    }
  }

  void emitUpdate() {
    emit(TreatmentUpdated());
  }
}