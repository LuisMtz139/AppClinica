import 'package:intl/intl.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/event_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:light_center/colors.dart';
import 'package:table_calendar/table_calendar.dart';

List<Appointment> eventsList = [];

late UserCubit userCubit;
Map<DateTime, List> events = {};
late final ValueNotifier<List<Event>> selectedEvents;
late ValueNotifier<DateTime?> selectedDay;
late ValueNotifier<DateTime> focusedDay;
List<DateTime> availableDates = [];

void showModal(
    {required List<Appointment> events,
    required List<String> schedule,
    required User user}) {
  showModalBottomSheet<void>(
    context: NavigationService.context(),
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    builder: (BuildContext context) {
      return eventsModalSheet(
          selectedDay: selectedDay.value!,
          events: eventsList,
          schedule: schedule,
          user: user);
    },
  );
}

List<Appointment> getEventsForDay() {
  return eventsList
      .where((event) => DateUtils.isSameDay(event.dateTime, selectedDay.value))
      .toList();
}

Future<List<String>> getDaySchedule(
    {required DateTime day, required User user}) async {
  try {
    String data = await sendSOAPRequest(
        soapAction: 'http://tempuri.org/SPA_HORASDISPONIBLES',
        envelopeName: 'SPA_HORASDISPONIBLES',
        content: {
          'DSNDataBase': user.location.value!.code,
          'NoWhatsAPP': '521${user.whatsappNumber}',
          'EXTERNAL_FechaCandidata':
              DateFormat("dd/MM/yyyy").format(day).toString()
        });

    if (data.contains('ERR:')) {
      return [
        'Ocurrió un error al cargar los horarios',
        data.replaceAll("ERR: ", ""),
        'Si el error persiste, favor de notificar a LightCenter'
      ];
    } else {
      data = data.substring(0, data.lastIndexOf(","));
      List<String> hours = [];
      for (String hour in data.split(",")) {
        hour = hour.trim();
        if (hour.length == 1) {
          hour = "0$hour:00";
        } else {
          hour = "$hour:00";
        }
        hours.add(hour);
      }
      return hours;
    }
  } catch (e) {
    return [
      'Ocurrió un error al cargar los horarios:',
      e.toString(),
      'Si el error persiste, favor de notificar a LightCenter'
    ];
  }
}

Future<void> scheduleAppointment(
    {required DateTime day, required User user}) async {
  for (Appointment appointment in user.treatments.last.scheduledAppointments!) {
    DateTime appointmentAsDT = appointment.dateTime!;

    if (DateUtils.isSameDay(appointmentAsDT, day)) {
      await showDialog(
        context: NavigationService.context(),
        builder: (BuildContext innerContext) => AlertDialog(
          title: const Text('Seleccione otra fecha'),
          content: const Text('No se puede agendar más de una cita por día'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(innerContext),
              child: Text(
                'Ok',
                style: TextStyle(color: LightCenterColors.mainPurple),
              ),
            ),
          ],
        ),
      );
      return;
    }
  }

  await showDialog(
    barrierDismissible: false,
    context: NavigationService.context(),
    builder: (BuildContext innerContext) => AlertDialog(
      title: const Text('¿Agendar cita?'),
      content: Text(
          '¿Deseas la cita para el ${DateFormat.yMMMMd('es-MX').format(day)} a la(s) ${DateFormat.jm().format(day)}?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(innerContext),
          child: const Text(
            'No',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(innerContext);
            Map<String, dynamic> scheduleResult =
                await userCubit.scheduleAppointment(day: day);

            await showDialog(
              context: NavigationService.context(),
              builder: (BuildContext innerContext) => AlertDialog(
                title: Text(
                  scheduleResult['scheduled']
                      ? 'Éxito al agendar'
                      : 'Error al agendar',
                  style: TextStyle(
                      color: scheduleResult['scheduled']
                          ? LightCenterColors.mainPurple
                          : LightCenterColors.mainBrown),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      scheduleResult['scheduled'] ? Icons.check : Icons.close,
                      color: scheduleResult['scheduled']
                          ? const Color.fromARGB(255, 224, 91, 228)
                          : Colors.red,
                      size: 80,
                    ),
                    Text(scheduleResult['message'])
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      NavigationService.pop();
                    },
                    child: Text(
                      'Cerrar',
                      style: TextStyle(color: LightCenterColors.mainPurple),
                    ),
                  ),
                ],
              ),
            );
            // Closing modalShow
            NavigationService.pop();
            await userCubit.getAvailableDatesBySOAP();
            focusedDay.value = day;
          },
          child: Text(
            'Sí',
            style: TextStyle(color: LightCenterColors.mainPurple),
          ),
        ),
      ],
    ),
  );
}

void manageScheduledAppointment(
    {required BuildContext context,
    required DateTime scheduledDate,
    required User user}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Seleccione una opción'),
      content: Text(
          'Selecciona una opción para la cita del ${DateFormat.yMMMMd('es-MX').format(scheduledDate)} a la(s) ${DateFormat.jm().format(scheduledDate)}'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cerrar',
            style: TextStyle(color: LightCenterColors.mainPurple),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await userCubit.cancelAppointment(
                appointment: user.treatments.last.scheduledAppointments!
                    .where((element) =>
                        isSameDay(element.dateTime, scheduledDate) &&
                        element.dateTime!.hour == scheduledDate.hour)
                    .first);
            //cancelAppointment(context: context, day: scheduledDate, user: user);
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
