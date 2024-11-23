import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:light_center/enums.dart';
import 'dart:convert' as convert;
import 'package:xml/xml.dart' as xml;

//const String baseUrl = 'Agregar el servidor al que apunta';
const String baseUrlDEV = '192.168.100.21:3000';
const String apiRoute = '/api/light-center';

Future<Map<String, dynamic>> sendHTTPRequest({required String baseUrl, required String endPoint, required HTTPMethod method, Object? body, Map<String, dynamic>? queryParameters}) async {
  late Response response;

  Map<String, String> headers = {
    'User-Agent': 'Flutter App'
  };

  headers['Accept'] = body == null ? '*/*' : 'application/json';

  if (body != null) {
    headers['Content-Type'] = 'application/json';
  }

  late Uri requestUri;

  if (baseUrl.substring(0,baseUrl.indexOf(":")).contains('s')) {
    requestUri = Uri.https(baseUrl.substring(baseUrl.indexOf(":") + 3), endPoint, queryParameters);
  } else {
    requestUri = Uri.http(baseUrl.substring(baseUrl.indexOf(":") + 3), endPoint, queryParameters);
  }

  //print(requestUri);

  Duration timeOutDuration = const Duration(seconds: 10);

  switch(method) {
    case HTTPMethod.get:
      response = await http.get(requestUri, headers: headers).timeout(timeOutDuration);
      break;

    case HTTPMethod.post:
      response = await http.post(requestUri, headers: headers, body: convert.jsonEncode(body)).timeout(timeOutDuration);
      break;

    case HTTPMethod.patch:
      response = await http.patch(requestUri, headers: headers, body: convert.jsonEncode(body)).timeout(timeOutDuration);
      break;

    case HTTPMethod.delete:
      response = await http.delete(requestUri, headers: headers, body: convert.jsonEncode(body)).timeout(timeOutDuration);
      break;

    default: return {
      'Error': "El método HTTP '${method.toString()}', es inválido",
      'Path': requestUri.path
    };
  }

  String auxResponse = response.body.trim();

  if (auxResponse[0] == '[' && auxResponse[auxResponse.length - 1] == ']') {
    return {
      'list': convert.jsonDecode(auxResponse)
    };
  }

  return await convert.jsonDecode(auxResponse) as Map<String, dynamic>;
}


Future<Map<String, dynamic>> sendRequest({required String endPoint, required HTTPMethod method, Object? body}) async {
  late Response response;

  Map<String, String> headers = {
    'User-Agent': 'Flutter App'
  };

  headers['Accept'] = body == null ? '*/*' : 'application/json';

  if (body != null) {
    headers['Content-Type'] = 'application/json';
  }

  Uri requestUri = Uri.http(baseUrlDEV, '$apiRoute$endPoint', {'q': '{http}'});
  Duration timeOutDuration = const Duration(seconds: 10);

  switch(method) {
    case HTTPMethod.get:
      response = await http.get(requestUri, headers: headers).timeout(timeOutDuration);
      break;

    case HTTPMethod.post:
      response = await http.post(requestUri, headers: headers, body: convert.jsonEncode(body)).timeout(timeOutDuration);
      break;

    case HTTPMethod.patch:
      response = await http.patch(requestUri, headers: headers, body: convert.jsonEncode(body)).timeout(timeOutDuration);
      break;

    case HTTPMethod.delete:
      response = await http.delete(requestUri, headers: headers, body: convert.jsonEncode(body)).timeout(timeOutDuration);
      break;

    default: return {
      'Error': "El método HTTP '${method.toString()}', es inválido",
      'Path': requestUri.path
    };
  }

  return convert.jsonDecode(response.body) as Map<String, dynamic>;
}


const String soapIP = "144.126.130.95";
const String soapPort = "8091";
const String soapServiceEndPoint = "WSGaliaLightCenterApp.asmx";

Duration timeOutDuration = const Duration(seconds: 10);

final Map<String, String> soapHeaders = {
  'Host': '144.126.130.95',
  'Content-Type': 'text/xml; charset=utf-8'
};

final Map<String, String> soap2Headers = {
  'Host': '144.126.130.95',
  'Content-Type': 'application/soap+xml; charset=utf-8'
};

/// Sends an XML document as a SOAP 1.1 request.
///
/// soapAction = The action of the request (equivalent to the endpoint).
///
/// envelopeName = Name of the parent node of the request body.
///
/// content = the general content of the request must be sent in JSON format.
///
/// ```
/// sendSOAPRequest(
/// soapAction: 'http://tempuri.org/SPA_VALIDAPACIENTE',
/// envelopeName: 'SPA_VALIDAPACIENTE',
/// content: {'DSNDataBase': 'MID', 'NoWhatsapp': '5219613662079' }
/// );
/// ```
Future<String> sendSOAPRequest({required String soapAction, required String envelopeName, required Map<String, dynamic> content}) async {
  soapHeaders['SOAPAction'] = soapAction;
  content['TokenAutentificacion'] = 'CriterioOcultoDecifrar@+-.app2023';

  Uri requestUri = Uri.http('$soapIP:$soapPort', '/$soapServiceEndPoint', {'q': '{http}'});
  final builder = xml.XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="utf-8"');
  builder.element(
      'soap:Envelope',
      attributes: {
        'xmlns:xsi': "http://www.w3.org/2001/XMLSchema-instance",
        'xmlns:xsd': "http://www.w3.org/2001/XMLSchema",
        'xmlns:soap': "http://schemas.xmlsoap.org/soap/envelope/"
      },
      nest: () {
        builder.element('soap:Body', nest: () {
          builder.element(
             envelopeName,
              attributes: {
                'xmlns': 'http://tempuri.org/'
              },
              nest: () {
               content.forEach((key, value) {
                 builder.element(key, nest: () => builder.text(value.toString()));
               });
              }
          );
        });
      });
  final document = builder.buildDocument();

  final response = await http.post(
      requestUri,
      headers: soapHeaders,
      body: convert.utf8.encode(document.toString()),
      encoding: convert.utf8
  ).timeout(timeOutDuration);

  final responseDocument = xml.XmlDocument.parse(response.body);

  //Trims document and send the response in String
  final textual = responseDocument.descendants
      .whereType<xml.XmlText>()
      .map((text) => text.value.trim())
      .where((string) => string.isNotEmpty)
      .join('\n');

  return textual;
}

