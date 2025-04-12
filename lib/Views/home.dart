import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Home/home_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/Views/schedule.dart';
import 'package:light_center/Views/my_appointments.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const Schedule(),
      const MyAppointments(),
    ];

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: commonAppBar(
              actions: [
                IconButton(
                    onPressed: () => NavigationService.showSimpleErrorAlertDialog(
                      title: '¿Cómo funciona?',
                      content: 'Toque una fecha en el calendario y espere un momento, se presentará un menú con las horas disponibles.\n\nPara agendar un horario, presione la hora en que desea asistir al SPA, la aplicación le notificará si se pudo agendar o si ocurrió un error.',
                    ),
                    icon: const Icon(Icons.help))
              ]
          ),
          body: widgetOptions.elementAt(state.currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Agendar',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.medical_information),
                label: 'Mis Citas',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: state.currentIndex,
            selectedItemColor: Colors.purple,
            onTap: (int selectedIndex) =>
                BlocProvider.of<HomeCubit>(context).changeSelectedIndex(
                    selectedIndex),
          ),
        );
      },
    );
  }
}