import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_center/BusinessLogic/Controllers/my_appointments_controller.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';
import 'dart:developer' as developer;


class MyAppointments extends StatelessWidget {
  const MyAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    userCubit = BlocProvider.of<UserCubit>(context);
    treatmentCubit = BlocProvider.of<TreatmentCubit>(context);
    userCubit.getAppointmentsBySOAP();
    Widget? currentScreen;

    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      developer.log('Current state: $state', name: 'MyAppointments');

      if (state is UserUpdated || state is UserSaved) {
        userCubit.getAppointmentsBySOAP();
        currentScreen = updatingScreen(context: context);
      }

      if (state is UserLoading) {
        currentScreen = loadingScreen(context: context);
      }

      if (state is UserLoaded) {
        developer.log('UserLoaded State: ${state.user}', name: 'MyAppointments');

        // Imprimir detalles específicos del usuario y sus citas
        final user = state.user;
        developer.log('User ID: ${user.id}', name: 'MyAppointments');
        developer.log('User Name: ${user.name}', name: 'MyAppointments');
        for (var treatment in user.treatments) {
          developer.log('Treatment ID: ${treatment.id}', name: 'MyAppointments');
          for (var appointment in treatment.scheduledAppointments ?? []) {
            developer.log('Appointment Date: ${appointment.jiffyDateTime}', name: 'MyAppointments');
          }
        }

        state.user.treatments.last.scheduledAppointments ??= [];
        if (state.user.treatments.last.scheduledAppointments!.isEmpty) {
          currentScreen = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Icon(FontAwesomeIcons.calendarXmark,
                      size: 200, color: Colors.red),
                ),
                Text('No tienes citas reservadas',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LightCenterColors.mainBrown))
              ],
            ),
          );
        } else {
          currentScreen = ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount:
                state.user.treatments.last.scheduledAppointments?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text('Citas agendadas',
                          style: TextStyle(
                              color: LightCenterColors.mainBrown,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                    ListTile(
                        title: Text(state.user.treatments.last
                                .scheduledAppointments![index].jiffyDateTime ??
                            'Error al transformar la fecha'),
                        trailing: FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () => cancelAppointment(
                                appointment: state.user.treatments.last
                                    .scheduledAppointments![index]),
                            child: const Text('Cancelar')))
                  ],
                );
              }
              
              return ListTile(
                  title: Text(state.user.treatments.last
                      .scheduledAppointments![index].jiffyDateTime!),
                  trailing: FilledButton(
                      style:
                          FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => cancelAppointment(
                          appointment: state.user.treatments.last
                              .scheduledAppointments![index]),
                      child: const Text('Cancelar')));
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        }
      }

      if (state is UserError) {
        currentScreen = errorScreen(context: context, errorMessage: 'Algo salió mal.\n\nEstamos trabajando para solucionarlo. Por favor, intenta de nuevo en unos momentos o verifique su conexicion a internet.');
        Future.delayed(const Duration(seconds: 5), () {
          userCubit.getAppointmentsBySOAP();
        });
      }

      currentScreen ??= invalidStateScreen(context: context);

      return currentScreen!;
    });
  }
}