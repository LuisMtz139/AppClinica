import 'package:flutter/material.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Data/Models/Location/location_model.dart';
import 'package:light_center/Data/Models/User/user_model.dart';

late GlobalKey<FormState> formKey;
late TextEditingController usernameController;
late TextEditingController passwordController;
late UserCubit userCubit;
late TreatmentCubit treatmentCubit;
late LocationCubit locationCubit;
Location? selectedLocation;

void fillForm(User user) async {
  if (user.id > 0) {
    await user.location.load();
    await user.treatments.load();
  }

  if (user.whatsappNumber != null) {
    usernameController.text = user.whatsappNumber!;
  }

  if (user.code != null) {
    passwordController.text = user.code!;
  }

  if (user.location.value != null) {
    selectedLocation = user.location.value!;
  }
}

void login({required User user}) async {
  if (formKey.currentState!.validate()) {
    user.whatsappNumber = usernameController.text;
    user.code = passwordController.text;
    user.location.value = selectedLocation;
    await userCubit.updateUserForLogin(user: user);
  }
}