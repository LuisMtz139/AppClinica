import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/Views/my_payments.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/extensions.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    Widget? currentScreen;
    userCubit.getUser();

    return Scaffold(
      appBar: commonAppBar(),
      drawer: commonDrawer(),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserUpdated || state is UserSaved) {
          userCubit.getUser();
          currentScreen = updatingScreen(context: context);
        }

        if (state is UserLoading) {
          currentScreen = loadingScreen(context: context);
        }

        if (state is UserLoaded) {
          state.user.treatments.load();
          currentScreen = SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Visibility(
                  visible: state.user.treatments.isNotEmpty && state.user.treatments.last.scheduledAppointments != null && state.user.treatments.last.scheduledAppointments!.isNotEmpty,
                    child: Container(
                        decoration: BoxDecoration(
                          color: LightCenterColors.mainPurple.withOpacity(0.9),
                        ),
                        child: Text('Su próxima cita es el día ${state.user.treatments.isNotEmpty && state.user.treatments.last.scheduledAppointments!.isNotEmpty ? state.user.treatments.last.scheduledAppointments!.first.jiffyDate : ''}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ))
                ),

                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.01
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            minRadius: MediaQuery.of(context).size.width * 0.1,
                            child: Image.asset("assets/images/icon-512.png", width: MediaQuery.of(context).size.width * 0.2),
                          ),

                          Text(state.user.name!.toPascalCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(state.user.whatsappNumber!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02
                  ),
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4/3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                    ),
                    children: [
                      GestureDetector(
                        onTap: () => NavigationService.pushNamed(NavigationService.homeScreen),
                        child: Card(
                          color: const Color.fromRGBO(119, 61, 190, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35.0),
                              image: const DecorationImage(image: AssetImage("assets/images/mis_citas.png"), fit: BoxFit.fill)
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Payments(user: state.user))),
                        child: Card(
                          color: const Color.fromRGBO(97, 39, 159, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                image: const DecorationImage(image: AssetImage("assets/images/mis_pagos.jpg"), fit: BoxFit.fill)
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => NavigationService.pushNamed(NavigationService.news),
                        child: Card(
                          color: const Color.fromRGBO(224, 23, 131, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                image: const DecorationImage(image: AssetImage("assets/images/promociones.png"), fit: BoxFit.fill)
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => NavigationService.openLoyalty(),
                        child: Card(
                          color: const Color.fromRGBO(195, 167, 226, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                image: const DecorationImage(image: AssetImage("assets/images/programa_lealtad.jpg"), fit: BoxFit.fill)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UserError) {
          currentScreen = errorScreen(context: context, errorMessage: state.errorMessage.toString());
        }

        currentScreen ??= invalidStateScreen(context: context);

        return currentScreen!;
      }),
    );
  }
}
