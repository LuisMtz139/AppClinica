import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/colors.dart';

class Agreements extends StatelessWidget {
  const Agreements({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> internalRegulations = ValueNotifier(false);
    ValueNotifier<bool> sessionIndications = ValueNotifier(false);

    return Scaffold(
      appBar: commonAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber, color: LightCenterColors.mainPurple, size: 80),
                const Text(
                  'Para utilizar esta aplicación, es necesario aceptar el reglamento interno así como también atender las indicaciones para las sesiones.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: internalRegulations,
                      builder: (BuildContext context, bool acceptRegulation, _) {
                        return Checkbox(
                          value: acceptRegulation,
                          onChanged: (bool? value) => internalRegulations.value = value!,
                        );
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => internalRegulations.value = !internalRegulations.value,
                        child: Text.rich(
                          TextSpan(
                            text: 'Acepto el ',
                            children: [
                              TextSpan(
                                text: 'reglamento interno',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: LightCenterColors.mainPurple,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () => NavigationService.openInternalRegulations(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: sessionIndications,
                      builder: (BuildContext context, bool acceptRegulation, _) {
                        return Checkbox(
                          value: acceptRegulation,
                          onChanged: (bool? value) => sessionIndications.value = value!,
                        );
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => sessionIndications.value = !sessionIndications.value,
                        child: Text.rich(
                          TextSpan(
                            text: 'Entiendo las ',
                            children: [
                              TextSpan(
                                text: 'indicaciones para sesiones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: LightCenterColors.mainPurple,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () => NavigationService.openSessionIndications(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: internalRegulations,
              builder: (context, acceptRegulations, _) {
                return ValueListenableBuilder(
                  valueListenable: sessionIndications,
                  builder: (context, acceptIndications, _) {
                    return FilledButton(
                      onPressed: acceptRegulations && acceptIndications
                          ? () async {
                        if (internalRegulations.value == false || sessionIndications.value == false) {
                          await NavigationService.showSimpleErrorAlertDialog(
                            title: 'Error',
                            content: 'Es necesario aceptar los términos y condiciones del spa así cómo entender las directivas de atención.',
                          );
                        } else {
                          await NavigationService.pushReplacementNamed(NavigationService.loginScreen);
                        }
                      }
                          : null,
                      child: const Text('Continuar'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}