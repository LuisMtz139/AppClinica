import 'package:jiffy/jiffy.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/enums.dart';
import 'package:isar/isar.dart';
import 'package:light_center/extensions.dart';

class UserRepository {
  final Isar isar;

  const UserRepository(this.isar);

  Future<User?> getUser() async {
    User? user = await isar.collection<User>().get(1);
    return user;
  }

  Future<Map<String, dynamic>> requestUserCode(String whatsappNumber) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/request-code',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber' : whatsappNumber
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> validateUserCode({required String whatsappNumber, required String userCode}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/validate-code',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber': whatsappNumber,
          'userCode' : userCode
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> loginWithCredentials({required String whatsappNumber, required String userCode}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/get-info',
        method: HTTPMethod.post,
        body: {
          'whatsappNumber': whatsappNumber,
          'userCode' : userCode
        }
    );
    return response;
  }

  Future<bool> updateUser(User newUser) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<User>().put(newUser) > -1) {
        return true;
      }

      return false;
    });
  }

  Future<bool> updateUserForLogin(User newUser) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<User>().put(newUser) > -1) {
        await newUser.location.save();
        return true;
      }

      return false;
    });
  }

  Future<bool> updateUserForValidation(User newUser) async {
    return await isar.writeTxn(() async {
      if (await isar.collection<User>().put(newUser) > -1) {
        await newUser.treatments.save();
        return true;
      }

      return false;
    });
  }

  Future<bool> updateWhatsappNumber(String newNumber) async {
    User user = await getUser() ?? User() ;
    user.whatsappNumber = newNumber;
    return await updateUser(user);
  }

  Future<bool> updateCode(String newCode) async {
    User user = await getUser() ?? User();
    user.code = newCode;
    return await updateUser(user);
  }

  Future<bool> updateName(String newName) async {
    User user = await getUser() ?? User();
    user.name = newName;
    return await updateUser(user);
  }

  Future<bool> removeWhatsappNumber() async {
    User? user = await getUser();
    if(user != null) {
      user.whatsappNumber = null;
      return await updateUser(user);
    }

    return false;
  }

  Future<bool> removeUserCode() async {
    User? user = await getUser();
    if(user != null) {
      user.code = null;
      return await updateUser(user);
    }

    return false;
  }

  Future<Map<String, dynamic>> scheduleAppointment({required User user, required DateTime day}) async {
    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_RESERVACITAEJECUCION',
        envelopeName: 'SPA_RESERVACITAEJECUCION',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'EXTERNAL_Idref_pedidospresup': user.treatments.last.orderId,
          'EXTERNAL_FechaCandidata': Jiffy.parseFromDateTime(day).format(pattern: 'dd/MM/yyyy').toString(),
          'EXTERNAL_HoraCandidata': day.hour
        }
    );

    if (data.contains('ERR:') || data.isEmpty) {
      if (data.isEmpty) {
        data = 'La cita no pudo ser agendada.';
      } else {
        data = data.replaceAll("ERR: ", "");
      }

      return {
        'scheduled': false,
        'message': data
      };
    } else {
      user.treatments.last.availableAppointments = int.parse(data);
      await isar.writeTxn(() => isar.treatments.put(user.treatments.last));
      await user.treatments.save();
      return {
        'scheduled': true,
        'message': 'La cita para el ${Jiffy.parseFromDateTime(day).yMMMMd} a la(s) ${Jiffy.parseFromDateTime(day).jm}, se agendó exitosamente. Te queda(n) ${user.treatments.last.availableAppointments ?? 0} cita(s) por agendar.'
      };
    }
  }

  Future<Map<String, dynamic>> updateAppointment({required String whatsappNumber, required String day, required String previousDay}) async {
    Map<String, dynamic> response = await sendRequest(
        endPoint: '/appointment',
        method: HTTPMethod.patch,
        body: {
          'whatsappNumber' : whatsappNumber,
          'day': day,
          'previousDay': previousDay
        }
    );
    return response;
  }

  Future<Map<String, dynamic>> cancelAppointment({required User user, required Appointment appointment}) async {
    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_CANCELARESERVACITA',
        envelopeName: 'SPA_CANCELARESERVACITA',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'EXTERNAL_Idspa_postvtaageope': appointment.id,
          'EXTERNAL_FechaCita': Jiffy.parseFromDateTime(appointment.dateTime!).format(pattern: 'dd/MM/yyyy').toString(),
          'EXTERNAL_HoraCita': appointment.dateTime!.hour
        }
    );

    if (data.contains('ERR:') || data.length <= 1) {
      if (data.length == 1) {
        data = 'La cita no pudo ser cancelada.';
      } else {
        data = data.replaceAll("ERR: ", "");
      }

      return {
        'canceled': false,
        'message': data
      };
    } else {
      if (data.contains('Ok')) {
        user.treatments.last.availableAppointments = user.treatments.last.availableAppointments! + 1;
        user.treatments.last.scheduledAppointments = [];
        await isar.writeTxn(() => isar.treatments.put(user.treatments.last));
        await user.treatments.save();
        return {
          'canceled': true,
          'message': 'La cita fue cancelada exitosamente.'
        };
      }

      return {
        'canceled': false,
        'message': 'La cita no pudo ser cancelada.'
      };
    }
  }



  Future<Map<String, dynamic>> fetchUser({required User user}) async {
    //Check when multiple treatments are defined
    await isar.writeTxn(() async {
      await isar.treatments.clear();
    });

    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_VALIDAPACIENTE',
        envelopeName: 'SPA_VALIDAPACIENTE',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'CodVerificador': user.code,
        });

    if (data.contains('ERR:') || data.length <= 1) {
      if (data.length == 1) {
        data = 'No cuenta con ningún paquete, favor de comunicarse con la clínica para realizar la adquisición de un tratamiento.';
      } else {
        data = data.replaceAll("ERR: ", "");
      }

      return {
        'validation': false,
        'message': data
      };
    } else {
      data = data.substring(data.indexOf("€") + 1);
      List<String> patientData = data.split(",");

      late Treatment currentTreatment;

      try {
        user.name = patientData.where((String element) => element.contains('nombrepaciente')).first.trimEqualsData();
        List<Treatment> userTreatments = await user.treatments.filter().findAll();

        // Checks if there's more than one treatment in response (NEED TO ADD), right now I'm just checking the current DB
        if (userTreatments.isEmpty) {
          currentTreatment = Treatment();
          currentTreatment.name = patientData.where((String element) => element.contains('descrippaquetecorporal')).first.trimEqualsData();
          currentTreatment.orderId = int.parse(patientData.where((String element) => element.contains('idpedido')).first.trimEqualsData());
          currentTreatment.productId = int.parse(patientData.where((String element) => element.contains('idpaquete')).first.trimEqualsData());

          if (!patientData.where((String element) => element.contains('vigenciapaquete')).first.trimEqualsData().contains('nodisponible')) {
            currentTreatment.lastDateToSchedule = parseDateTimeFromResponse(patientData.where((String element) => element.contains('vigenciapaquete')).first.trimEqualsData());
          }

          if (!patientData.where((String element) => element.contains('fproxcitaclinica')).first.trimEqualsData().contains('nodisponible')) {
            currentTreatment.scheduledAppointments =
            [
              appointmentFromLogin(
                  date: patientData.where((String element) => element.contains('fproxcitaclinica')).first.trimEqualsData(),
                  time: patientData.where((String element) => element.contains('fproxcitaclinicahora')).first.trimEqualsData())
            ];
          } else {
            currentTreatment.scheduledAppointments = [];
          }

          await isar.writeTxn(() async {
            await isar.treatments.put(currentTreatment);
          });

          user.treatments.add(currentTreatment);
        } else {
          for (Treatment userTreatment in userTreatments) {
            currentTreatment = await user.treatments.filter().orderIdEqualTo(userTreatment.orderId).findFirst() ?? Treatment();
            currentTreatment.name = patientData.where((String element) => element.contains('descrippaquetecorporal')).first.trimEqualsData();
            currentTreatment.orderId = int.parse(patientData.where((String element) => element.contains('idpedido')).first.trimEqualsData());
            currentTreatment.productId = int.parse(patientData.where((String element) => element.contains('idpaquete')).first.trimEqualsData());

            if (!patientData.where((String element) => element.contains('vigenciapaquete')).first.trimEqualsData().contains('nodisponible')) {
              currentTreatment.lastDateToSchedule = parseDateTimeFromResponse(patientData.where((String element) => element.contains('vigenciapaquete')).first.trimEqualsData());
            }

            if (!patientData.where((String element) => element.contains('fproxcitaclinica')).first.trimEqualsData().contains('nodisponible')) {
              currentTreatment.scheduledAppointments =
              [
                appointmentFromLogin(
                    date: patientData.where((String element) => element.contains('fproxcitaclinica')).first.trimEqualsData(),
                    time: patientData.where((String element) => element.contains('fproxcitaclinicahora')).first.trimEqualsData())
              ];
            } else {
              currentTreatment.scheduledAppointments = [];
            }

            await isar.writeTxn(() async {
              await isar.treatments.put(currentTreatment);
            });

            user.treatments.add(currentTreatment);
          }
        }
        await updateUserForValidation(user);
        return {
          'validation': true,
          'message': 'El usuario ha sido actualizado'
        };
      } catch(e) {
        return {
          'validation': false,
          'message': 'Error en la validación:\n${e.toString()}'
        };
      }
    }
  }

  Future<Map<String, dynamic>> fetchAppointments({required User user}) async {
    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_CITASRESERVADAS',
        envelopeName: 'SPA_CITASRESERVADAS',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'EXTERNAL_Idref_pedidospresup': user.treatments.last.orderId
        }
    );

    if (data.contains('ERR:') || data.length <= 1) {

      if (data.length == 1) {
        data = 'No cuenta con ninguna cita agendada.';
      } else {
        data = data.replaceAll("ERR: ", "");
      }

      user.treatments.last.scheduledAppointments = [];
      await isar.writeTxn(() => isar.treatments.put(user.treatments.last));
      await user.treatments.save();

      return {
        'updated': false,
        'message': data
      };
    } else {
      user.treatments.last.scheduledAppointments = [];
      for (String appointmentData in data.substring(0, data.length - 1).split('ð')) {
        List<String> appointmentValues = appointmentData.split(',');
        Appointment currentAppointment = Appointment();
        currentAppointment.id = int.parse(appointmentValues.where((String element) => element.contains('id')).first.trim().trimEqualsData());
        currentAppointment.date = appointmentValues.where((String element) => element.contains('fecha')).first.trim().trimEqualsData();
        currentAppointment.time = appointmentValues.where((String element) => element.contains('hora')).first.trim().trimEqualsData();

        if(currentAppointment.time != null) {
          if(currentAppointment.time!.contains('€')) {
            currentAppointment.time = (currentAppointment.time!.substring(0, currentAppointment.time!.indexOf('€'))).trim();
          }
        }

        if (currentAppointment.time!.length == 1) {
          currentAppointment.time = '0${currentAppointment.time}:00:00';
        } else {
          currentAppointment.time = '${currentAppointment.time}:00:00';
        }
        user.treatments.last.scheduledAppointments!.add(currentAppointment);
      }
      await isar.writeTxn(() => isar.treatments.put(user.treatments.last));
      await user.treatments.save();
      return {
        'updated': true,
        'message': 'Citas descargadas'
      };
    }
  }

  Future<Map<String, dynamic>> fetchAvailableDates({required User user}) async {
    await user.treatments.load();
    user.treatments.last.availableDates = [];

    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_FECHASDISPONIBLES',
        envelopeName: 'SPA_FECHASDISPONIBLES',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'EXTERNAL_Idref_pedidospresup': user.treatments.last.orderId
        }
    );

    if (data.contains('ERR:') || data.length <= 1) {
      if (data.length == 1) {
        data = 'No cuenta con ninguna fecha disponible.';
      } else {
        data = data.replaceAll("ERR: ", "");
      }

      return {
        'updated': false,
        'message': data
      };
    } else {
      String datesString = '';
      String rangesString = '';
      if (data.contains('€')) {
        List<String> datesAux = data.split('€');
        datesString = datesAux[0].substring(0, datesAux[0].lastIndexOf(","));
        rangesString = datesAux[1];
      } else {
        datesString = data.substring(0, data.lastIndexOf(","));
      }

      List<DateTime> dates = [];

      for (String date in datesString.split(",")) {
        try {
          dates.add(Jiffy.parse(date.trim(), pattern: 'dd/MM/yyyy').dateTime);
        } catch(e) {
          return {
            'updated': false,
            'message': 'Ocurrió un error al obtener las fechas disponibles: $e.'
          };
        }
      }

      dates.sort((a,b) => a.compareTo(b));

      List<DateRange> dateRanges = [];
      user.treatments.last.availableAppointments ??= 0;

      if (rangesString.isNotEmpty) {
        for (String range in rangesString.split(",")) {
          dateRanges.add(
              DateRange(
                  initialDate: Jiffy.parse(range.substring(0, range.indexOf('-')), pattern: 'dd/MM/yyyy').dateTime,
                  endDate: Jiffy.parse(range.substring(range.indexOf('-') + 1, range.indexOf('_')), pattern: 'dd/MM/yyyy').dateTime,
                  availableSchedules: int.parse(range.substring(range.indexOf('_') + 1)))
          );
          if (user.treatments.last.availableAppointments != null) {
            user.treatments.last.availableAppointments = user.treatments.last.availableAppointments! + int.parse(range.substring(range.indexOf('_') + 1));
          } else {
            user.treatments.last.availableAppointments = int.parse(range.substring(range.indexOf('_') + 1));
          }
        }
      }

      user.treatments.last.availableDates = dates;
      user.treatments.last.dateRanges = dateRanges;
      await isar.writeTxn(() => isar.treatments.put(user.treatments.last));
      await user.treatments.save();

      return {
        'updated': true,
        'message': 'Fechas descargadas'
      };
    }
  }

  DateTime? parseDateTimeFromResponse(String dateString) {
    try {
      if (dateString.isNotEmpty) {
        return DateTime.parse(dateString);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Appointment appointmentFromLogin({required String date, required String time}) {
    String auxTime = time;
    if (auxTime.length == 1) {
      auxTime = '0$time';
    }

    auxTime += ':00:00';

    return Appointment(
      time: auxTime,
      date: date
    );
  }
}