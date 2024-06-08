import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:light_center/BusinessLogic/Controllers/schedule_controller.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/isar_service.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Row lightCenterText = Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text("Light",
        style: TextStyle(color: LightCenterColors.mainBrown)
    ),
    Container(
      color: LightCenterColors.mainPurple,
      child: const Text('CENTER',
        style: TextStyle(
            color: Colors.white
        ),
      ),
    )
  ],
);

AppBar commonAppBar({
  Widget? title,
  List<Widget>? actions,
  Widget? leading
  }) {
  return AppBar(
    automaticallyImplyLeading: leading == null,
    leading: leading,
    //title: title ?? Image.asset('assets/images/logo_horizontal.png', width: MediaQuery.of(NavigationService.context()).size.width * 0.5),
    title: title ?? const SizedBox.shrink(),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [LightCenterColors.backgroundPink, Colors.white, LightCenterColors.backgroundPurple]
        ),
        image: title == null ? const DecorationImage(image: AssetImage("assets/images/logo_vertical2.png")) : null,
      ),
    ),
    backgroundColor: Colors.deepPurpleAccent,
    centerTitle: true,
    actions: actions ?? [
      IconButton(
          onPressed: () => showAboutDialog(
              context: NavigationService.context(),
              applicationName: 'Light Center',
              applicationVersion: 'Versión 1.1.1',
              applicationLegalese: 'Kranzwide Consultive S.A. de C.V.',
              applicationIcon: Image.asset('assets/images/icon-512.png',
                  width: 50,
                  height: 50
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20
                  ),
                  child: Row(
                    children: [
                      const Text('Desarrollador: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                          )
                      ),
                      GestureDetector(
                        onTap: () => NavigationService.openURL(baseUrl: 'github.com', endPoint: '/ChuyEx'),
                        child: Text('ChuyEx',
                            style: TextStyle(
                                color: LightCenterColors.mainPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                ),

                const Center(child: Text('Contacta a la consultora',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ))
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10
                  ),
                  child: Row(
                    children: [
                      const Text('Pagina Web: '),
                      Flexible(
                        child: GestureDetector(
                          onTap: () => NavigationService.openURL(baseUrl: 'predictionsoft.com.mx', endPoint: ''),
                          child: Text('predictionsoft.com.mx', style: TextStyle(color: LightCenterColors.mainPurple)),
                        ),
                      )
                    ],
                  ),
                ),

                Row(
                  children: [
                    const Text('Email: '),
                    Flexible(
                      child: GestureDetector(
                        onTap: () => NavigationService.sendEmail(email: 'ventas@predictionsoft.com.mx'),
                        child: Text('ventas@predictionsoft.com.mx', style: TextStyle(color: LightCenterColors.mainPurple)),
                      ),
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10
                  ),
                  child: Row(
                    children: [
                      const Text('Facebook: '),
                      Flexible(
                        child: GestureDetector(
                          onTap: () => NavigationService.openURL(baseUrl: 'facebook.com', endPoint: '/PredictionSOFTwareNube'),
                          child: Text('PredictionSOFTwareNube', style: TextStyle(color: LightCenterColors.mainPurple)),
                        ),
                      )
                    ],
                  ),
                ),

                Row(
                  children: [
                    const Text('Teléfono: '),
                    GestureDetector(
                      onTap: () => NavigationService.makeCall(phoneNumber: '5219613662079'),
                      child: Text('9613662079', style: TextStyle(color: LightCenterColors.mainPurple)),
                    )
                  ],
                ),
              ]
          ),
          icon: const Icon(Icons.info))
    ],
  );
}

SizedBox updatingScreen({required BuildContext context, String message = 'Obteniendo datos...'}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: SpinKitHourGlass(color: LightCenterColors.mainPurple),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(message),
          )
        ],
      ),
    ),
  );
}

SizedBox loadingScreen({required BuildContext context, String message = 'Generando presentación...'}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: SpinKitWaveSpinner(
              color: LightCenterColors.mainPurple,
              trackColor: LightCenterColors.backgroundPink,
              waveColor: LightCenterColors.mainBrown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(message),
          )
        ],
      ),
    ),
  );
}

SizedBox errorScreen({required BuildContext context, required String errorMessage}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: $errorMessage'),
          )
        ],
      ),
    ),
  );
}

SizedBox invalidStateScreen({required BuildContext context}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: const Padding(
      padding: EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            color: Colors.orange,
            size: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('El estado no es válido'),
          )
        ],
      ),
    ),
  );
}

SizedBox invalidScreen({required BuildContext context}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: const Padding(
      padding: EdgeInsets.only(
          left: 20.0,
          right:20.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            color: Colors.orange,
            size: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('El contenido no pudo ser cargado.'),
          )
        ],
      ),
    ),
  );
}

SizedBox eventsModalSheet({required DateTime selectedDay, required List<Appointment> events, required List<String> schedule, required User user}) {
  events = events.where((event) => DateUtils.isSameDay(event.dateTime, selectedDay)).toList();
  return SizedBox(
    height: MediaQuery.of(NavigationService.context()).size.height * 0.6,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Center(
  child: Text(
    "${DateFormat.EEEE('es-MX').format(selectedDay)}, ${DateFormat.yMMMMd('es-MX').format(selectedDay)}",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: LightCenterColors.mainBrown
    ),
  ),
),

                const Spacer(),
                Flexible(
                  child: IconButton(
                      onPressed: () => NavigationService.pop(),
                      icon: Icon(Icons.close, color: LightCenterColors.mainPurple)),
                )
              ],
            ),
          ),

          Visibility(
              visible: events.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(NavigationService.context()).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('Citas agendadas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: LightCenterColors.mainPurple
                          ),
                        ),
                      ),
                      getScheduleGrid(schedule: events, selectedDay: selectedDay, user: user),
                    ],
                  ),
                ),
              )
          ),

          SizedBox(
            width: MediaQuery.of(NavigationService.context()).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Horas disponibles',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: LightCenterColors.mainPurple
                    ),
                  ),
                ),

                getScheduleGrid(schedule: schedule, selectedDay: selectedDay, user: user),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 10.0
            ),
            child: ElevatedButton(
              child: const Text('Cerrar horario'),
              onPressed: () => NavigationService.pop(),
            ),
          ),
        ],
      ),
    ),
  );
}

GridView getScheduleGrid({required List<dynamic> schedule, required DateTime selectedDay, required User user}) {
  return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 16/9,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        late DateTime currentDateTime;
        if (schedule.runtimeType == List<Appointment>) {
          currentDateTime = schedule[index].dateTime;
        } else {
          currentDateTime = DateTime.parse(''
              '${selectedDay.toString().substring(0,selectedDay.toString().indexOf(' '))}'
              ' ${schedule[index]}');
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
          child: FilledButton(
              onPressed: () async {
                if(schedule.runtimeType == List<Appointment>) {
                  manageScheduledAppointment(context: context, scheduledDate: currentDateTime, user: user);
                } else {
                  await scheduleAppointment(day: currentDateTime, user: user);
                }
              },
              child: Text(
                  DateFormat.jm().format(currentDateTime),
                  textAlign: TextAlign.center
              )
          ),
        );
      }
  );
}

Drawer commonDrawer() {
  return Drawer(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(NavigationService.context()).size.height * 0.05,
                  bottom: 10
              ),
              child: const Center(
                  child: Text('Acuerdos',
                    style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),

            tappableListTileItem(
                icon: Icons.rule,
                title: 'Reglamento',
                action: () => NavigationService.openInternalRegulations()
            ),

            tappableListTileItem(
                icon: Icons.help_center,
                title: 'Indicaciones',
                action: () => NavigationService.openSessionIndications()
            ),

tappableListTileItem(
    icon: Icons.privacy_tip,
    title: 'Aviso de Privacidad',
    action: () => NavigationService.openOnlinePDF(url: 'http://144.126.130.95/ImgsRobotWhatsApp/LightCenterClinicas/Avisodeprivacidad.pdf')
),
          ],
        ),

        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  top: 50,
                  bottom: 20
              ),
              child: Center(
                  child: Text('Contáctanos',
                    style:TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),

            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 30
              ),
              children: [
                FilledButton.icon(
                    onPressed: () => NavigationService.makeCall(),
                    icon: const Icon(Icons.phone),
                    label: const Text('Llamada')),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15
                  ),
                  child: OutlinedButton.icon(
                      onPressed: () => NavigationService.openWhatsappLink(),
                      icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green,),
                      label: const Text('Whatsapp')),
                ),

                OutlinedButton.icon(
                    onPressed: () => NavigationService.sendEmail(),
                    icon: const Icon(FontAwesomeIcons.envelope, color: Colors.blue),
                    label: const Text('Correo')),
              ],
            ),

            TextButton.icon(
                onPressed: () {
                  NavigationService.showAlertDialog(
                      title: const Text('Cerrar Sesión'),
                      content: const Text('¿Deseas cerrar tu sesión actual?'),
                      actions: [
                        TextButton(
                            onPressed: () => NavigationService.pop(),
                            child: const Text('No')
                        ),

                        TextButton(
                            onPressed: () async {
                              final logOutDB = await IsarService.instance.db;
                              logOutDB.writeTxn(() async {
                                await logOutDB.treatments.clear();
                                await logOutDB.users.clear();
                              });
                              NavigationService.cleanNavigation(NavigationService.splashScreen);
                            },
                            child: const Text('Si',
                            style: TextStyle(
                              color: Colors.red
                            ),)
                        )
                      ]
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.red
                  )
                ))
          ],
        )
      ],
    ),
  );
}

GestureDetector tappableListTileItem({required IconData icon, required String title, required VoidCallback action, bool isDisabled = false}) {
  return GestureDetector(
    onTap: isDisabled ? null : action,
    child: ListTile(
      leading: Icon(icon, color: isDisabled ? Colors.grey : null),
      title: Text(title, style: TextStyle(color: isDisabled ? Colors.grey : null)),
    ),
  );
}