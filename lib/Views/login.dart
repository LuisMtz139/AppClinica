import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'custom_widgets.dart';
import 'package:light_center/BusinessLogic/Controllers/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.getUser();

    locationCubit = BlocProvider.of<LocationCubit>(context);
    treatmentCubit = BlocProvider.of<TreatmentCubit>(context);

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
        fillForm(state.user);

        if (state.user.whatsappNumber != null &&
            state.user.code != null &&
            state.user.location.value != null) {
          userCubit.validateCredentials().then((value) async {
            if (value['validation'] == true) {
              await userCubit.getAppointmentsBySOAP(withState: false);
              await NavigationService.pushReplacementNamed(
                  NavigationService.dashboardScreen);
            } else {
              await userCubit.removeUserCode();
              await NavigationService.showSimpleErrorAlertDialog(
                  title: 'Error al iniciar sesión', content: value['message']);
            }
          });
        }

        currentScreen = LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1280 && constraints.maxHeight >= 720) {
              return Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: locationsDropDownMenu()),
                            SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: usernameController,
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  prefix: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.phone),
                                  ),
                                  labelText: 'Ingrese su número de Whatsapp',
                                  hintText: '9617894561',
                                ),
                                validator: (text) {
                                  if (text == null ||
                                      text.isEmpty ||
                                      text.length != 10) {
                                    return 'Favor de ingresar un número de 10 dígitos';
                                  }

                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              prefix: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.lock),
                              ),
                              labelText: 'Ingrese su código de usuario',
                              hintText: '0000'),
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length != 4) {
                              return 'Favor de ingresar un código de 4 dígitos';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                            login(user: state.user);
                          },
                        ),
                        FilledButton(
                          onPressed: () => login(user: state.user),
                          child: const Text('Ingresar'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        locationsDropDownMenu(),
                        TextFormField(
                          controller: usernameController,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            prefix: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.phone),
                            ),
                            labelText: 'Ingrese su número de Whatsapp',
                            hintText: '9617894561',
                          ),
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length != 10) {
                              return 'Favor de ingresar un número de 10 dígitos';
                            }

                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        TextFormField(
                          controller: passwordController,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              prefix: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.lock),
                              ),
                              labelText: 'Ingrese su código de usuario',
                              hintText: '0000'),
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length != 4) {
                              return 'Favor de ingresar un código de 4 dígitos';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                            login(user: state.user);
                          },
                        ),
                        FilledButton(
                          onPressed: () => login(user: state.user),
                          child: const Text('Ingresar'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        );
      }

      if (state is UserError) {
        currentScreen = errorScreen(
            context: context, errorMessage: state.errorMessage.toString());
      }

      currentScreen ??= invalidStateScreen(context: context);

      return Scaffold(
        appBar: commonAppBar(),
        body: currentScreen,
      );
    });
  }

  BlocBuilder locationsDropDownMenu() {
    Widget currentDropDownScreen = const SizedBox.shrink();

    return BlocBuilder<LocationCubit, LocationState>(builder: (context, state) {
      if (state is LocationUpdated || state is LocationSaved) {
        currentDropDownScreen = updatingScreen(context: context);
      }

      if (state is LocationLoading) {
        currentDropDownScreen = loadingScreen(context: context);
      }

      if (state is LocationsLoaded) {
        selectedLocation ??= state.locationsList.first;

        currentDropDownScreen = DropdownMenu<Location>(
          initialSelection: state.locationsList
              .where((element) => element.id == selectedLocation?.id)
              .first,
          leadingIcon: const Icon(Icons.location_city),
          hintText: 'Clínica',
          onSelected: (Location? value) {
            if (value != null) {

              selectedLocation = value;
            }
          },
          dropdownMenuEntries: state.locationsList
              .map<DropdownMenuEntry<Location>>((Location value) {
            return DropdownMenuEntry<Location>(
                value: value, label: value.city!);
          }).toList(),
        );
      }

      if (state is LocationError) {
        currentDropDownScreen = errorScreen(
            context: context, errorMessage: state.errorMessage.toString());
      }

      return currentDropDownScreen;
    });
  }
}
