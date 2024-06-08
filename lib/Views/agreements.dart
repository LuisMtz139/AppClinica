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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber, color: LightCenterColors.mainPurple, size: 80),
              const Text('Para utilizar esta aplicación, es necesario aceptar el reglamento interno así como también atender las indicaciones para las sesiones.',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
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
                            onChanged: (bool? value) => internalRegulations.value = value!
                        );
                      }
                  ),
                  GestureDetector(
                      onTap: () => internalRegulations.value = !internalRegulations.value,
                      child: const Text('Acepto el ')
                  ),
                  GestureDetector(
                    onTap: () => NavigationService.openInternalRegulations(),
                    child: Text('reglamento interno',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: LightCenterColors.mainPurple
                        )
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  ValueListenableBuilder(
                      valueListenable: sessionIndications,
                      builder: (BuildContext context, bool acceptRegulation, _) {
                        return Checkbox(
                            value: acceptRegulation,
                            onChanged: (bool? value) => sessionIndications.value = value!
                        );
                      }
                  ),
                  GestureDetector(
                      onTap: () => sessionIndications.value = !sessionIndications.value,
                      child: const Text('Entiendo las ')
                  ),
                  GestureDetector(
                    onTap: () => NavigationService.openSessionIndications(),
                    child: Text('indicaciones para sesiones',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: LightCenterColors.mainPurple
                        )
                    ),
                  )
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
                          onPressed: acceptRegulations && acceptIndications ? () async {
                            if (internalRegulations.value == false || sessionIndications.value == false) {
                              await NavigationService.showSimpleErrorAlertDialog(title: 'Error', content: 'Es necesario aceptar los términos y condiciones del spa así cómo entender las directivas de atención.');
                            } else {
                              await NavigationService.pushReplacementNamed(NavigationService.loginScreen);
                            }
                          } : null,
                          child: const Text('Continuar')
                      );
                    });
              }),
        ],
      ),
    );
  }
}