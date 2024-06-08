import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:light_center/BusinessLogic/Cubits/Home/home_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Location/location_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/BusinessLogic/Cubits/Treatment/treatment_cubit.dart';
import 'package:light_center/Data/Repositories/location_repository.dart';
import 'package:light_center/Services/isar_service.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/Data/Repositories/user_repository.dart';
import 'package:light_center/Data/Repositories/treatment_repository.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Jiffy.setLocale('es_us');

  final IsarService isar = IsarService();
  isar.open();
  runApp(LightCenter(isar: await isar.db));
}

class LightCenter extends StatefulWidget {
  final Isar isar;
  const LightCenter({super.key, required this.isar});

  @override
  State<LightCenter> createState() => _LightCenterState();
}

class _LightCenterState extends State<LightCenter> {
  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = NavigationService();

    return MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(create: (_) => UserCubit(UserRepository(widget.isar))),
          BlocProvider<TreatmentCubit>(create: (_) => TreatmentCubit(TreatmentRepository(widget.isar))),
          BlocProvider<LocationCubit>(create: (_) => LocationCubit(LocationRepository(widget.isar))),
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        ],
        child: MaterialApp(
          title: 'Light Center',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: LightCenterColors.mainPurple),
              useMaterial3: true,
              textTheme: GoogleFonts.montserratTextTheme(
                  Theme.of(context).textTheme
              )
          ),
          debugShowCheckedModeBanner: false, // Quitsa el banner de depuración
          initialRoute: '/',
          navigatorKey: navigationService.getKey(),
          routes: navigationService.routes,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('es', 'MX'),
          supportedLocales: const [
            Locale('es', 'MX'),
            Locale('en', 'US')
          ],
        )
    );
  }
}