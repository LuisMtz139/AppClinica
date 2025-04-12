import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/colors.dart';
import 'package:intl/intl.dart';

late UserCubit userCubit;
late TreatmentCubit treatmentCubit;

List<Widget> scheduledAppointmentsList(List<String> appointmentsList) {
  List<Widget> scheduledAppointmentsList = [];
  if (appointmentsList.isNotEmpty) {
    scheduledAppointmentsList =
        List<Widget>.generate(appointmentsList.length, (index) {
      return Container(
        color: index.isEven
            ? LightCenterColors.backgroundPurple
            : LightCenterColors.backgroundPink,
        child: ListTile(
          title: Text(DateFormat.yMMMMd('es-MX').format(DateTime.parse(appointmentsList[index])).toString()),
          subtitle: Text(DateFormat.jm().format(DateTime.parse(appointmentsList[index])).toString()),
        ),
      );
    });
  }

  return scheduledAppointmentsList;
}

void cancelAppointment({required Appointment appointment}) {
  showDialog(
    context: NavigationService.context(),
    builder: (BuildContext context) => AlertDialog(
      title: const Text('¿Cancelar cita?'),
      content: Text('¿Deseas cancelar la cita agendada el ${appointment.jiffyDate} a la(s) ${appointment.jiffyTime}?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => NavigationService.pop(),
          child: Text('No',
            style: TextStyle(
                color: LightCenterColors.mainPurple
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            NavigationService.pop();
            Map<String, dynamic> cancelResult = await userCubit.cancelAppointment(appointment: appointment);
            await NavigationService.showAlertDialog(
                title: Text(cancelResult['canceled'] ? 'Éxito al cancelar' : 'Error al cancelar',
                    style: TextStyle(
                        color: cancelResult['canceled'] ? LightCenterColors.mainPurple : LightCenterColors.mainBrown
                    )
                ),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cancelResult['canceled'] ? Icons.check : Icons.close,
                        color: cancelResult['canceled'] ? Colors.green : Colors.red,
                        size: 80,
                      ),

                      Text(cancelResult['message'])
                    ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      NavigationService.pop();
                      userCubit.getAppointmentsBySOAP();
                    },
                    child: Text('Cerrar',
                      style: TextStyle(
                          color: LightCenterColors.mainPurple
                      ),
                    ),
                  ),
                ]
            );
          },
          child: const Text('Sí',
            style: TextStyle(
                color: Colors.red
            ),
          ),
        ),
      ],
    ),
  );
}