import 'package:flutter/material.dart';
import 'package:light_center/Data/Models/User/user_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';

class Payments extends StatelessWidget {
  final User user;
  const Payments({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: commonAppBar(
          title: const Text('Mis Pagos'),
          actions: [
            IconButton(
                onPressed: () => NavigationService.showSimpleErrorAlertDialog(
                  title: '¿Cómo funciona?',
                  content: 'Deslice su dedo de arriba hacia abajo para continuar leyendo (en caso de ser necesario), para leer el texto anterior deslice de abajo hacia arriba.',
                ),
                icon: const Icon(Icons.help))
          ]
      ),
      body: FutureBuilder<String>(
        future: getNews(user: user),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == '') {
              return Center(
                  child: Text('No debe nada',
                    style: TextStyle(
                        color: LightCenterColors.mainBrown,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                    ),
                  )
              );
            }

            return Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                  child: Text(snapshot.data!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: LightCenterColors.mainPurple
                    ),
                  )
              ),
            );
          } else if (snapshot.hasError) {
            return errorScreen(context: context, errorMessage: snapshot.error.toString());
          } else {
            return loadingScreen(context: context);
          }
        },
      ),
    );
  }
}

Future<String> getNews({required User user}) async {
  String data = await sendSOAPRequest(
      soapAction: 'http://tempuri.org/SPA_MISPAGOS',
      envelopeName: 'SPA_MISPAGOS',
      content: {
        'DSNDataBase': user.location.value!.code,
        'NoWhatsAPP': '521${user.whatsappNumber}',
      }
  );

  return data;
}