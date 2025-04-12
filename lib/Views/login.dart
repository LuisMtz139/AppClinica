import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets.dart';
import 'package:light_center/BusinessLogic/Controllers/login_controller.dart';

Location? anteriorLocation = null;

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
              anteriorLocation = null;
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
                            const SizedBox(width: 16),
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
                        const SizedBox(height: 16),
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
      
        if (!state.locationsList.contains(selectedLocation) &&
            anteriorLocation == null) {
          print("dentro del primer if");
          print(selectedLocation?.city);
          selectedLocation = null;
        }
        if (anteriorLocation != null) {
          print("dentro del segundo if ");
          print(anteriorLocation?.city);
          selectedLocation = anteriorLocation;
        }

        currentDropDownScreen = DropdownButtonFormField<Location>(
          value: selectedLocation,
          decoration: const InputDecoration(
            labelText: 'Clínica',
            prefixIcon: Icon(Icons.location_city),
          ),
          hint: const Text('Seleccione una clínica'),
          items: [
            const DropdownMenuItem<Location>(
              value: null,
              child: Text(
                'Seleccione una clínica',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ...state.locationsList
                .map<DropdownMenuItem<Location>>((Location value) {
              return DropdownMenuItem<Location>(
                value: value,
                child: Text(value.city!.split(' wp:')[0]),
              );
            }).toList(),
          ],
          onTap: () {
            // Imprimir los nombres de las ciudades del menú desplegable en la consola
            print('Opciones del menú desplegable:');
            state.locationsList.forEach((location) {
              print(location.city!.split(' wp:')[0]);
            });
          },
          onChanged: (Location? value) async {
            if (value != null) {
              selectedLocation = value;
              anteriorLocation = value;
              // Imprimir los detalles completos de la ciudad seleccionada en la consola
              print('Detalles de la ciudad seleccionada: ${value.city}');

              // Extraer wp, email, y tel de los detalles de la ciudad seleccionada
              final cityDetails = value.city!.split(',');
              final wp = cityDetails[1].split(':')[1].trim();
              final email = cityDetails[2].split(':')[1].trim();
              final tel = cityDetails[3].split(':')[1].trim();

              // Guardar wp, email, y tel en local storage
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('wp', wp);
              await prefs.setString('email', email);
              await prefs.setString('tel', tel);

              // Imprimir valores del local storage
              printLocalStorageValues();
            } else {
              selectedLocation = null;
            }
          },
          validator: (Location? value) {
            if (value == null) {
              return 'Por favor seleccione una clínica';
            }
            return null;
          },
        );
      }

      if (state is LocationError) {
        currentDropDownScreen = errorScreen(
            context: context, errorMessage: "Error al cargar sucursales");
      }

      return currentDropDownScreen;
    });
  }

  Future<void> printLocalStorageValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wp = prefs.getString('wp');
    String? email = prefs.getString('email');
    String? tel = prefs.getString('tel');

    print('Valores del local storage:');
    print('wp: $wp');
    print('email: $email');
    print('tel: $tel');
  }
}
