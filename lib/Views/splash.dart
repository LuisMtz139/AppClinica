import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:video_player/video_player.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    VideoPlayerController controller = VideoPlayerController.asset('assets/animation.mp4');
    ValueNotifier<bool> videoLoadedNotifier = ValueNotifier<bool>(false);
    controller.initialize().then((value) async {
      await controller.play();
      videoLoadedNotifier.value = true;
    });

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: videoLoadedNotifier,
        builder: (context, isLoaded, _) {
          if (controller.value.isInitialized) {
            UserCubit userCubit = BlocProvider.of<UserCubit>(context);
            LocationCubit locationCubit = BlocProvider.of<LocationCubit>(context);
            userCubit.getUser();

            return Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: FutureBuilder<Map<String, dynamic>>(
                  future: userCubit.validateCredentials(),
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      Future.delayed(const Duration(seconds: 8), (){
                        controller.dispose().whenComplete(() async {
                          if (snapshot.data!['validation'] == true)  {
                            await userCubit.getAppointmentsBySOAP();
                            await NavigationService.pushReplacementNamed(NavigationService.dashboardScreen);
                          } else {
                            if (snapshot.data!['message'] == 'El usuario no existe.') {
                              await NavigationService.pushReplacementNamed(NavigationService.agreementsScreen);
                            } else {
                              await NavigationService.pushReplacementNamed(NavigationService.loginScreen);
                            }
                          }
                        });
                      });

                      if (snapshot.data!['validation'] == false) {
                        locationCubit.fetchLocations();
                      }

                      return Center(
                        child: AspectRatio(
                          aspectRatio: 9/16,
                          //aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return errorScreen(context: context, errorMessage: 'La información del usuario no pudo ser cargada');
                    } else {
                      return loadingScreen(context: context);
                    }
                  }
              ),
            );
          } else {
            return loadingScreen(context: context);
          }
        },
      ),
    );

  }
}