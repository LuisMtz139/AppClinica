import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/Data/Models/Treatment/treatment_model.dart';
import 'package:light_center/Data/Repositories/treatment_repository.dart';
import 'package:light_center/Data/Repositories/user_repository.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/BusinessLogic/Controllers/treatment_selection_controller.dart';

class TreatmentSelectionArguments {
  final Isar isar;
  TreatmentSelectionArguments({required this.isar});
}

class TreatmentSelection extends StatelessWidget {
  const TreatmentSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as TreatmentSelectionArguments;

    userCubit = UserCubit(UserRepository(args.isar));
    treatmentCubit = TreatmentCubit(TreatmentRepository(args.isar));
    userCubit.getUser();

    return Scaffold(
      appBar: commonAppBar(),
      body:  MultiBlocProvider(
          providers: [
            BlocProvider<UserCubit>(create: (_) => userCubit),
            BlocProvider<TreatmentCubit>(create: (_) => treatmentCubit),
          ],
          child: BlocBuilder<UserCubit, UserState>(
              bloc: userCubit,
              builder: (context, state) {
                if (state is UserUpdated || state is UserSaved) {
                  userCubit.getUser();
                  return updatingScreen(context: context);
                }

                if (state is UserLoading) {
                  return loadingScreen(context: context);
                }

                if (state is UserLoaded) {
                  args.isar.treatments.where().findAll().then((value) => treatmentsList = value);

                  return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 16 / 9,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: args.isar.treatments.countSync(),
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(treatmentsList[index].name!),
                              subtitle: Text(
                                'Citas por agendar: ${treatmentsList[index].availableAppointments}'),
                          ),
                        );
                      });
                }
                if (state is UserError) {
                  return errorScreen(
                      context: context, errorMessage: state.errorMessage);
                }

                return invalidStateScreen(context: context);
              })),
    );
  }
}
