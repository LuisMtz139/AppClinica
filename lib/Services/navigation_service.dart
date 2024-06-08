import 'package:flutter/material.dart';
import 'package:light_center/Views/agreements.dart';
import 'package:light_center/Views/dashboard.dart';
import 'package:light_center/Views/login.dart';
import 'package:light_center/Views/home.dart';
import 'package:light_center/Views/news.dart';
import 'package:light_center/Views/pdf.dart';
import 'package:light_center/Views/splash.dart';
import 'package:light_center/Views/treatment_selection.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationService {
  static const String splashScreen = "/";
  static const String agreementsScreen = '/agreements';
  static const String loginScreen = '/login';
  static const String dashboardScreen = '/dashboard';
  static const String homeScreen = '/home';
  static const String treatmentSelection = '/treatmentSelection';
  static const String news = '/news';
  static const String nutritionalOrientation = '/nutritional';

  static late final GlobalKey<NavigatorState> _navigationKey;

  NavigationService._internal() {
    _navigationKey = GlobalKey<NavigatorState>();
  }

  final Map<String, Widget Function(BuildContext)> routes = {
    splashScreen: (context) => const Splash(),
    agreementsScreen: (context) => const Agreements(),
    loginScreen: (context) => const Login(),
    dashboardScreen: (context) => const Dashboard(),
    treatmentSelection: (context) => const TreatmentSelection(),
    homeScreen: (context) => const HomePage(),
    news: (context) => const News()
  };

  static final NavigationService instance = NavigationService._internal();

  factory NavigationService() {
    return instance;
  }

  static Future<dynamic> pushNamed(String route, {Object? arguments}) {
    return _navigationKey.currentState!.pushNamed(route, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(String route,
      {Object? arguments}) {
    return _navigationKey.currentState!
        .pushReplacementNamed(route, arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(String route, {Object? arguments}) {
    return _navigationKey.currentState!
        .popAndPushNamed(route, arguments: arguments);
  }

  static Future<dynamic> cleanNavigation(String route, {Object? arguments}) {
    _navigationKey.currentState!.popUntil((route) => route.isFirst);
    return _navigationKey.currentState!
        .pushReplacementNamed(route, arguments: arguments);
  }

  static void pop() {
    return _navigationKey.currentState!.pop();
  }

  static void removeAllRoutes() {
    _navigationKey.currentState!.popUntil((route) => route.isFirst);
  }

  static bool mounted() {
    return _navigationKey.currentContext!.mounted;
  }

  static BuildContext context() {
    return _navigationKey.currentContext!;
  }

  GlobalKey<NavigatorState> getKey() {
    return _navigationKey;
  }

  static void showSnackBar(
      {required String message,
      SnackBarAction? snackBarAction,
      Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(_navigationKey.currentContext!).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: snackBarAction,
    ));
  }

  static Future<dynamic> showAlertDialog(
      {required Widget title,
      required Widget content,
      List<Widget>? actions}) async {
    await showDialog<dynamic>(
      barrierDismissible: false,
      context: _navigationKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  static Future<dynamic> showSimpleErrorAlertDialog(
      {required String title, required String content}) async {
    return await showDialog<dynamic>(
      barrierDismissible: false,
      context: _navigationKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              //onPressed: () => pop(),
              onPressed: () => removeAllRoutes(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
    );
  }

  static void makeCall({String phoneNumber = '5219995514492'}) async {
    Uri requestUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(requestUri)) {
      await launchUrl(requestUri);
    }
  }

  static void openWhatsappLink({String message = ''}) async {
    Uri requestUri = Uri.https('wa.me', '/5219994916865', {'text': message});
    if (await canLaunchUrl(requestUri)) {
      await launchUrl(requestUri, mode: LaunchMode.inAppWebView);
    }
  }

  static void sendEmail(
      {String email = 'lightcenterclinicas@predictionsoft.com.mx'}) async {
    Uri requestUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(requestUri)) {
      await launchUrl(requestUri);
    }
  }

static Future<dynamic> openInternalRegulations() async {
  return _navigationKey.currentState!.push(MaterialPageRoute(
      builder: (context) => PDFScreen(pdfName: 'http://144.126.130.95/ImgsRobotWhatsApp/LightCenterClinicas/Reglamento%20Interno.pdf', isURL: true)));
}


static Future<dynamic> openSessionIndications() async {
  return _navigationKey.currentState!.push(MaterialPageRoute(
      builder: (context) => PDFScreen(pdfName: 'http://144.126.130.95/ImgsRobotWhatsApp/LightCenterClinicas/Indicaciones%20para%20Sesiones.pdf', isURL: true)));
}

  static Future<dynamic> openOnlinePDF({required String url}) async {
    return _navigationKey.currentState!.push(MaterialPageRoute(
        builder: (context) => PDFScreen(pdfName: url, isURL: true)));
  }

  static Future<dynamic> openLoyalty() async {
    return _navigationKey.currentState!.push(MaterialPageRoute(
        builder: (context) => const PDFScreen(pdfName: 'Programa de lealtad')));
  }

  static void openURL(
      {bool secureConnection = true,
      required String baseUrl,
      required String endPoint}) async {
    late Uri requestUri;
    if (secureConnection == true) {
      requestUri = Uri.https(baseUrl, endPoint);
    } else {
      requestUri = Uri.http(baseUrl, endPoint);
    }

    if (await canLaunchUrl(requestUri)) {
      await launchUrl(requestUri, mode: LaunchMode.inAppWebView);
    }
  }
}
