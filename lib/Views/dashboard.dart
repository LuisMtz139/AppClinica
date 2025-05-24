import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_center/BusinessLogic/Cubits/User/user_cubit.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';
import 'package:light_center/Views/my_payments.dart';
import 'package:light_center/colors.dart';
import 'package:light_center/extensions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

Map<String, dynamic> parseMonederoResult(String result) {
  final Map<String, dynamic> data = {};
  if (result == null || result.trim().isEmpty) {
    data['saldo'] = null;
    data['historial'] = [];
    return data;
  }
  String saldoRaw;
  String resto;
  if (result.contains('_')) {
    final parts = result.split('_');
    saldoRaw = parts[0];
    resto = parts.sublist(1).join('_');
  } else {
    saldoRaw = '';
    resto = result;
  }
  double? saldo;
  if (saldoRaw.contains(':')) {
    final saldoStr = saldoRaw.split(':').last;
    saldo = double.tryParse(saldoStr);
  }
  data['saldo'] = saldo?.toStringAsFixed(2) ?? 'No disponible';

  final List<Map<String, dynamic>> historial = [];
  final transacciones = resto.split('-');

  for (final t in transacciones) {
    if (t.trim().isEmpty) continue;
    final fechaReg = RegExp(r'(\d{2}/\d{2}/\d{4})');
    final matchFecha = fechaReg.firstMatch(t);
    String? fecha = matchFecha?.group(1);

    String afterFecha = fecha != null
        ? t.substring(t.indexOf(fecha) + fecha.length).trim()
        : t.trim();

    // Extraer el detalle entre la fecha y el primer signo de interrogación (?), sin incluir el ?
    String detalle = '';
    final signoInterrogacionIndex = afterFecha.indexOf('?');
    if (signoInterrogacionIndex > 0) {
      detalle = afterFecha.substring(0, signoInterrogacionIndex).trim();
    } else {
      detalle = afterFecha.trim();
    }
    final montoReg = RegExp(r'\?([\d.]+)€([AC])');
    final matchMonto = montoReg.firstMatch(afterFecha);
    double? monto;
    String? tipo;
    if (matchMonto != null) {
      monto = double.tryParse(matchMonto.group(1)!);
      tipo = matchMonto.group(2) == 'A' ? 'ingreso' : 'egreso';
    }

    historial.add({
      'fecha': fecha ?? '',
      'concepto': detalle,
      'monto': monto?.toStringAsFixed(2) ?? '',
      'tipo': tipo ?? '',
    });
  }
  data['historial'] = historial;
  return data;
}

// Función para consumir el servicio web SOAP de monedero electrónico
Future<String> consultarMonederoElectronico(String whatsappNumber) async {
  try {
    String soapEnvelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SPA_MONEDEROELECTRONICO xmlns="http://tempuri.org/">
      <DSNDataBase>001</DSNDataBase>
      <NoWhatsapp>$whatsappNumber</NoWhatsapp>
      <TOKENAUTENTIFICACION>CriterioOcultoDecifrar@+-.app2023</TOKENAUTENTIFICACION>
    </SPA_MONEDEROELECTRONICO>
  </soap:Body>
</soap:Envelope>
''';
    print(soapEnvelope);

    final response = await http.post(
      Uri.parse('http://144.126.130.95:8091/WSGaliaLightCenterApp.asmx'),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/SPA_MONEDEROELECTRONICO',
      },
      body: soapEnvelope,
    );
    print(response.body);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final result =
          document.findAllElements('SPA_MONEDEROELECTRONICOResult').first.text;
      // <-- Aquí se agrega el parser y el encode a json:
      return json.encode(parseMonederoResult(result));
    } else {
      throw Exception('Error al consultar el monedero: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al consultar el monedero: $e');
  }
}

class MonederoElectronicoPage extends StatefulWidget {
  final String whatsappNumber;

  const MonederoElectronicoPage({super.key, required this.whatsappNumber});

  @override
  _MonederoElectronicoPageState createState() =>
      _MonederoElectronicoPageState();
}

class _MonederoElectronicoPageState extends State<MonederoElectronicoPage> {
  late Future<String> monederoFuture;
  final Color monederoColor = const Color.fromRGBO(195, 167, 226, 1);

  @override
  void initState() {
    super.initState();
    monederoFuture = consultarMonederoElectronico(widget.whatsappNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Monedero Electrónico'),
        backgroundColor: monederoColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              monederoColor.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<String>(
          future: monederoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: monederoColor,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar el monedero: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: monederoColor,
                      ),
                      onPressed: () {
                        setState(() {
                          monederoFuture = consultarMonederoElectronico(
                              widget.whatsappNumber);
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              try {
                final data = json.decode(snapshot.data!);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: monederoColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Historial de Transacciones',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: data['historial'] != null &&
                                data['historial'].isNotEmpty
                            ? SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(
                                        label: Text('Fecha',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      DataColumn(
                                        label: Text('Detalle',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      DataColumn(
                                        label: Text('Cargo',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      DataColumn(
                                        label: Text('Abono',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                    rows: data['historial']
                                        .map<DataRow>((transaccion) {
                                      final esIngreso =
                                          transaccion['tipo'] == 'ingreso';
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                              Text(transaccion['fecha'] ?? '')),
                                          DataCell(Text(
                                              transaccion['concepto'] ?? '')),
                                          DataCell(
                                            esIngreso
                                                ? const Text('')
                                                : Text(
                                                    '${transaccion['monto']} MXN',
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                          DataCell(
                                            esIngreso
                                                ? Text(
                                                    '${transaccion['monto']} MXN',
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : const Text(''),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 48,
                                      color: monederoColor.withOpacity(0.7),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No hay transacciones disponibles',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: monederoColor,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: monederoColor,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Saldo Disponible',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '${data['saldo'] ?? '0.0'} MXN',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: monederoColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Saldo disponible',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                );
              } catch (e) {
                // Aquí el bloque modificado para mostrar la tabla en vez de solo texto
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: monederoColor,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: monederoColor,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Saldo Disponible',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '0.0',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: monederoColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Saldo disponible',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: monederoColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Historial de Transacciones',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                  label: Text('Fecha',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text('Detalle',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text('Cargo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text('Abono',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                              rows: [
                                DataRow(
                                  cells: [
                                    DataCell(Text('No se encontró información',
                                        style: TextStyle(color: Colors.grey))),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                    const DataCell(Text('')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: monederoColor.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No se encontró información del monedero',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: monederoColor,
                      ),
                      onPressed: () {
                        setState(() {
                          monederoFuture = consultarMonederoElectronico(
                              widget.whatsappNumber);
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

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
                    visible: state.user.treatments.isNotEmpty &&
                        state.user.treatments.last.scheduledAppointments !=
                            null &&
                        state.user.treatments.last.scheduledAppointments!
                            .isNotEmpty,
                    child: Container(
                        decoration: BoxDecoration(
                          color: LightCenterColors.mainPurple.withOpacity(0.9),
                        ),
                        child: Text(
                          'Su próxima cita es el día ${state.user.treatments.isNotEmpty && state.user.treatments.last.scheduledAppointments!.isNotEmpty ? state.user.treatments.last.scheduledAppointments!.first.jiffyDate : ''}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ))),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.01),
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
                            child: Image.asset("assets/images/icon-512.png",
                                width: MediaQuery.of(context).size.width * 0.2),
                          ),
                          Text(
                            state.user.name!.toPascalCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(state.user.whatsappNumber!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                    ),
                    children: [
                      GestureDetector(
                        onTap: () => NavigationService.pushNamed(
                            NavigationService.homeScreen),
                        child: Card(
                          color: const Color.fromRGBO(119, 61, 190, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/mis_citas.png"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Payments(user: state.user))),
                        child: Card(
                          color: const Color.fromRGBO(97, 39, 159, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/mis_pagos.jpg"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            NavigationService.pushNamed(NavigationService.news),
                        child: Card(
                          color: const Color.fromRGBO(224, 23, 131, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/promociones.png"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      // MONEDERO: texto centrado sobre imagen de fondo
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MonederoElectronicoPage(
                              whatsappNumber: state.user.whatsappNumber!,
                            ),
                          ),
                        ),
                        child: Card(
                          color: const Color.fromRGBO(195, 167, 226, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.14,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(0.0),
                              image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/monedero elect.png"),
                                fit: BoxFit
                                    .fill, // <= Igual que los otros botones
                              ),
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
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/programa_lealtad.jpg"),
                                    fit: BoxFit.fill)),
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
          currentScreen = errorScreen(
              context: context,
              errorMessage:
                  "Algo salió mal.\n\nEstamos trabajando para solucionarlo. Por favor, intenta de nuevo en unos momentos o verifique su conexcion a internet.");
        }

        currentScreen ??= invalidStateScreen(context: context);

        return currentScreen!;
      }),
    );
  }
}
