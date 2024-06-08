import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Services/network_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUser();

    Widget? currentScreen;

    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserUpdated || state is UserSaved) {
        userCubit.getUser();
        currentScreen = updatingScreen(context: context);
      }

      if (state is UserLoading) {
        currentScreen = loadingScreen(context: context);
      }

      if (state is UserLoaded) {
        currentScreen = FutureBuilder<List<String>>(
          future: getNews(dsnDatabase: state.user.location.value!.code!),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                    child: Text('No hay promociones',
                      style: TextStyle(
                          color: LightCenterColors.mainBrown,
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),
                    )
                );
              }

              ValueNotifier<int> currentSlide = ValueNotifier(0);
              final CarouselController carouselController = CarouselController();

              return Column(
                children: [
                  Expanded(
                    child: CarouselSlider(
                        carouselController: carouselController,
                        items: snapshot.data!.map((item) => GestureDetector(
                          onTap: () {
                            NavigationService.openWhatsappLink(message: '¡Hola!, quiero información de la promo "${item.substring(item.lastIndexOf('/') + 1, item.lastIndexOf('.'))}"');
                          },
                          child: Image.network(
                            item,
                            fit: BoxFit.fill,
                            height: screenHeight,
                          ),
                        )).toList(),
                        options: CarouselOptions(
                            height: screenHeight,
                            viewportFraction: 1,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              currentSlide.value = index;
                            }
                        )
                    ),
                  ),

                  ValueListenableBuilder<int>(
                    valueListenable: currentSlide,
                    builder: (context, index, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: snapshot.data!.asMap().entries.map((entry) {
                          return Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : LightCenterColors.mainPurple)
                                    .withOpacity(currentSlide.value == entry.key ? 0.9 : 0.4)),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return errorScreen(context: context, errorMessage: snapshot.error.toString());
            } else {
              return loadingScreen(context: context);
            }
          },
        );
      }

      if (state is UserError) {
        currentScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
      }

      currentScreen ??= invalidStateScreen(context: context);

      return Scaffold(
        appBar: commonAppBar(
            title: const Text('Promociones'),
            actions: [
              IconButton(
                  onPressed: () => NavigationService.showSimpleErrorAlertDialog(
                    title: '¿Cómo funciona?',
                    content: 'Deslice su dedo de izquierda a derecha para mostrar la siguiente imagen, para regresar a la imagen anterior, deslice de derecha a izquierda.\n\nDe un toque a una imagen para solicitar información de la promoción por Whatsapp.',
                  ),
                  icon: const Icon(Icons.help))
            ]
        ),
        body: currentScreen,
      );
    });
  }
}

Future<List<String>> getNews({required String dsnDatabase}) async {
  String data = await sendSOAPRequest(
      soapAction: 'http://tempuri.org/SPA_FUNCIONUTILERIA',
      envelopeName: 'SPA_FUNCIONUTILERIA',
      content: {
        'DSNDataBase': dsnDatabase,
        'NomFuncion': 'PROMOSVIGENTES',
      }
  );

  if (data.contains('ERR:') || data.length == 1) {
    if (data.length == 1) {
      data = 'No cuenta con ninguna fecha disponible.';
    } else {
      data = data.replaceAll("ERR: ", "");
    }
    await NavigationService.showSimpleErrorAlertDialog(title: 'Error', content: 'Ocurrió un error al obtener las promociones');

    return [];
  } else {
    data = data.substring(0, data.lastIndexOf(","));
    return data.split(",");
  }
}