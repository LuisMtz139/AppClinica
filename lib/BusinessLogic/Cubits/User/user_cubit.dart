import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Repositories/user_repository.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:flutter/material.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<bool> requestWhatsappCode(String whatsappNumber) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.requestUserCode(whatsappNumber);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
        return false;
      } else {
        User? user = await _repository.getUser();
        user ??= User();
        user.whatsappNumber = whatsappNumber;
        if (await _repository.updateUser(user)) {
          emit(UserLoaded(user: user));
          return true;
        } else {
         emit(UserError('Ocurrió un error al registrar el número de WhatsApp'));
         return false;
        }
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al solicitar el código de WhatsApp: $e'));
      return false;
    }
  }

  Future<bool> validateUserCode({required String whatsappNumber, required String userCode}) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.validateUserCode(whatsappNumber: whatsappNumber, userCode: userCode);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
        return false;
      } else {
        User? user = await _repository.getUser();
        user ??= User();
        user.code = userCode;
        user.name = data['Name'];
        if (await _repository.updateUser(user)) {
          NavigationService.showSnackBar(message: 'Su código ha sido verificado. Ingresando al sistema...');

          Future.delayed(const Duration(seconds: 4), (){
            NavigationService.pushReplacementNamed(NavigationService.homeScreen);
            //NavigationService.pushReplacementNamed(NavigationService.treatmentSelection, arguments: TreatmentSelectionArguments(isar: _repository.isar));
          });

          emit(UserLoaded(user: user));
          return true;
        } else {
          emit(UserError('Ocurrió un error al registrar el código de usuario'));
          return false;
        }
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al validar el código de usuario: $e'));
      return false;
    }
  }

  Future<bool> loginWithCredentials({required String whatsappNumber, required String userCode}) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.loginWithCredentials(whatsappNumber: whatsappNumber, userCode: userCode);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
        return false;
      } else {
        User? user = await _repository.getUser();
        user ??= User();
        user.code = userCode;
        user.name = data['Name'];
        //user.currentTreatment = data['DesiredTreatment'];
        //user.appointments = getAppointmentsFromJson(data['Appointments']);
        if (await _repository.updateUser(user)) {
          NavigationService.pushReplacementNamed(NavigationService.homeScreen);
          //NavigationService.pushReplacementNamed(NavigationService.treatmentSelection, arguments: TreatmentSelectionArguments(isar: _repository.isar));
          return true;
        } else {
          emit(UserError('Ocurrió un error al registrar el código de usuario'));
          return false;
        }
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al iniciar sesión: $e'));
      return false;
    }
  }

  Future<void> getUser() async {
    try {
      emit(UserLoading());
      User? user = await _repository.getUser();
      if (user == null) {
        emit(UserLoaded(user: User()));
      } else {
        emit(UserLoaded(user: user));
      }
    } catch (e) {
      emit(UserError('Ocurrió un error al obtener el usuario: $e'));
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _repository.updateUser(user);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el usuario: $e'));
    }
  }

  Future<void> updateUserForLogin({required User user, bool isValidation = false}) async {
    try {
      emit(UserLoading());
      if (isValidation == false) {
        if (await _repository.updateUserForLogin(user) == false) {
          emit(UserError('Error al almacenar la información del usuario'));
        }
      } else {
        if (await _repository.updateUserForValidation(user) == true) {
          await NavigationService.pushReplacementNamed(NavigationService.dashboardScreen);
        } else {
          emit(UserError('Error al almacenar la información del usuario'));
        }
      }
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el usuario: $e'));
    }
  }

  Future<void> setWhatsappNumber(String newNumber) async {
    try {
      await _repository.updateWhatsappNumber(newNumber);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el número de WhatsApp: $e'));
    }
  }

  Future<void> setCode(String newCode) async {
    try {
      await _repository.updateCode(newCode);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar el código de usuario: $e'));
    }
  }

  Future<void> removeWhatsappNumber() async {
    try {
      await _repository.removeWhatsappNumber();
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al remover el número de WhatsApp: $e'));
    }
  }

  Future<void> removeUserCode() async {
    try {
      await _repository.removeUserCode();
      emit(UserUpdated());
    } catch (e) {
      emit(UserError('Ocurrió un error al remover el código de usuario: $e'));
    }
  }

  Future<Map<String, dynamic>> scheduleAppointment({required DateTime day}) async {
    try {
      emit(UserLoading());

      User? user = await _repository.getUser();

      if (user == null) {
        return {
          'scheduled': false,
          'message': 'El usuario no pudo ser encontrado.'
        };
      } else if (user.whatsappNumber == null || user.code == null || user.location.value == null) {
        return {
          'scheduled': false,
          'message': 'El usuario no cuenta con todas sus credenciales.'
        };
      }

      Map<String, dynamic> result =  await _repository.scheduleAppointment(
          user: user,
          day: day
      );

      return result;
    } catch (e) {
      return {
        'scheduled': false,
        'message': 'Ocurrió un error al agendar la cita: ${e.toString()}.'
      };
    }
  }

  Future<bool> updateAppointment({required String whatsappNumber, required DateTime day, required DateTime previousDay}) async {
    try {
      emit(UserLoading());
      Map<String, dynamic> data = await _repository.updateAppointment(
          whatsappNumber: whatsappNumber,
          day: day.toIso8601String().substring(0,day.toIso8601String().indexOf('.')),
          previousDay: previousDay.toIso8601String().substring(0,day.toIso8601String().indexOf('.'))
      );

      if (data.containsKey('Error')) {
        await NavigationService.showSimpleErrorAlertDialog(
            title: 'Error al actualizar',
            content: 'Ocurrió un error al actualizar la cita.\n${data['Error']}');
        return false;
      } else if (data.containsKey('Success')) {
        if (data['Success'] != false) {
          return true;
        }
      }
      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al actualizar',
          content: 'Ocurrió un error en el servidor.');
      return false;
    } catch (e) {
      await NavigationService.showSimpleErrorAlertDialog(
          title: 'Error al actualizar',
          content: 'Ocurrió un error al re-agendar la cita: $e.');
      return false;
    }
  }

  Future<Map<String, dynamic>> cancelAppointment({required Appointment appointment}) async {
    try {
      emit(UserLoading());

      User? user = await _repository.getUser();

      if (user == null) {
        return {
          'canceled': false,
          'message': 'El usuario no pudo ser encontrado.'
        };
      } else if (user.whatsappNumber == null || user.code == null || user.location.value == null) {
        return {
          'canceled': false,
          'message': 'El usuario no cuenta con todas sus credenciales.'
        };
      }

      Map<String, dynamic> result =  await _repository.cancelAppointment(
          user: user,
          appointment: appointment
      );

      return result;
    } catch (e) {
      return {
        'canceled': false,
        'message': 'Ocurrió un error al cancelar la cita: $e.'
      };
    }
  }

  void reloadUserData() async {
    try {
      emit(UserLoading());
      User? user = await _repository.getUser();
      Map<String, dynamic> data = await _repository.loginWithCredentials(whatsappNumber: user!.whatsappNumber!, userCode: user.code!);
      if (data.containsKey('Error')) {
        emit(UserError(data['Error']));
      } else {
        user.name = data['Name'];
        if (await _repository.updateUser(user)) {
          emit(UserLoaded(user: user));
        } else {
          emit(UserError('Ocurrió un error al actualizar la información del usuario'));
        }
      }
    } catch(e) {
      emit(UserError('Ocurrió un error al recargar la información del usuario: $e'));
      Future.delayed(const Duration(seconds: 5), () {
        reloadUserData();
      });
    }
  }

  void emitUpdate() {
    emit(UserUpdated());
  }

  void changeName(String name) async {
    emit(UserLoading());
    User user = await _repository.getUser() ?? User();
    user.name = name;
    await updateUser(user);
    emit(UserUpdated());
  }

  Future<void> updateScreen({required VoidCallback action, required User user}) async {
    try {
      emit(UserLoading());
      action;
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError('Ocurrió un error al actualizar la pantalla: $e'));
    }
  }

  Future<Map<String, dynamic>> validateCredentials() async {
    try {
      //emit(UserLoading());
      User? user = await _repository.getUser();

      if (user == null) {
        return {
          'validation': false,
          'message': 'El usuario no existe.'
        };
      } else if (user.whatsappNumber == null || user.code == null || user.location.value == null) {
        return {
          'validation': false,
          'message': 'El usuario no tiene todas sus credenciales.'
        };
      }

      Map<String, dynamic> result = await _repository.fetchUser(user: user);
      //emit(UserLoaded(user: user));
      return result;
    } catch (e) {
      //emit(UserError('Ocurrió un error al validar la información del usuario: $e'));
      return {
        'validation': false,
        'message': e.toString()
      };
    }
  }

  Future<Map<String, dynamic>> getAppointmentsBySOAP({bool withState = true}) async {
    try {
      if (withState) {
        emit(UserLoading());
      }
      User? user = await _repository.getUser();

      if (user == null) {
        return {
          'updated': false,
          'message': 'El usuario no existe.'
        };
      } else if (user.whatsappNumber == null || user.code == null || user.location.value == null) {
        return {
          'updated': false,
          'message': 'El usuario no tiene todas sus credenciales.'
        };
      }
      //emit(UserLoaded(user: user));
      return await _repository.fetchAppointments(user: user).whenComplete(() {
        if (withState) {
          emit(UserLoaded(user: user));
        }
      });
    } catch (e) {
      emit(UserError('Ocurrió un error al obtener las citas agendadas: $e'));
      return {
        'updated': false,
        'message': 'Ocurrió un error al obtener las citas agendadas: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getAvailableDatesBySOAP() async {
    try {
      emit(UserLoading());
      User? user = await _repository.getUser();

      if (user == null) {
        return {
          'updated': false,
          'message': 'El usuario no existe.'
        };
      } else if (user.whatsappNumber == null || user.code == null || user.location.value == null) {
        return {
          'updated': false,
          'message': 'El usuario no tiene todas sus credenciales.'
        };
      }

      return await _repository.fetchAvailableDates(user: user).whenComplete(() => emit(UserLoaded(user: user)));
    } catch (e) {
      emit(UserError('Ocurrió un error al obtener las fechas disponibles: $e'));
      return {
        'updated': false,
        'message': 'Ocurrió un error al obtener las fechas disponibles: $e'
      };
    }
  }
}