import 'dart:convert';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/facades/http_facade.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Uri uriSetter(String uri, [Map<String, dynamic>? query]) {
  Uri parsedURI;
  if (query != null) {
    String queryKey = query.entries.first.key;
    String queryValue = query.entries.first.value;
    parsedURI = Uri.parse('$uri?$queryKey=$queryValue');
  } else {
    parsedURI = Uri.parse(uri);
  }
  return parsedURI;
}

class ApiServiceProvider {
  ApiServiceProvider();
  Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  
  dynamic httpMethod;

  HttpFacade httpFacade = HttpFacade();

  Future<Uri> _generateRequestURI(String url, {dynamic queryParamter}) async {
    String uri = globalSettings['api']['domain'] + url;
    return uriSetter(uri, queryParamter);
  } 

  Future<Map<String, String>> _generateRequestHeaders(Map<String, String>? customHeader) async {
    Map<String, String> mergedHeader = {};
    mergedHeader.addAll(defaultHeaders);

    Map<String, String> tempHeader = {};
    Map<String, String> sessionHeader = {};
    String merlinkClientId = dotenv.get('MERLINK_CLIENT_ID_DEVELOPMENT', fallback: 'Id not found');
    String merlinkClientKey = dotenv.get('MERLINK_CLIENT_KEY_DEVELOPMENT', fallback: 'Key not found');
    String merlinkVersion = dotenv.get('MERLINK_CLIENT_VERSION_DEVELOPMENT', fallback: 'Version not found');

    tempHeader = {
      'merlink-client-id': merlinkClientId,
      'merlink-client-key': merlinkClientKey,
      'merlink-version': merlinkVersion
    };

    if (sharedPreferences.getString('session_id') != null) {
      sessionHeader = {'merlink-session-token': sharedPreferences.getString('session_token')!};
    }

    mergedHeader.addAll(tempHeader);
    mergedHeader.addAll(sessionHeader);

    if (customHeader != null) {
      mergedHeader.addAll(customHeader);
    }
    return mergedHeader;
  }

  Future<dynamic> create(String uri, Map<String, dynamic> data, {Map<String, String>? header}) async {
    Map<String, String> headerReturned = {};
    late Uri parsedURI;
    headerReturned = await _generateRequestHeaders(header);
    parsedURI = await _generateRequestURI(uri);
    var encodedData = json.encode(data);

    return httpFacade.create(parsedURI, encodedData, header: headerReturned);
  }

  Future<dynamic> replace(String uri, Map<String, String> data, Map<String, String>? header) {
    late Map<String, String> headerReturned = {};
    _generateRequestHeaders(header).then((value) => {headerReturned = value});
    var encodedData = json.encode(data);

    return httpFacade.replace(_generateRequestURI(uri), encodedData, headerReturned);
  }

  Future<dynamic> retrieve(String uri, {dynamic data, Map<String, String>? header}) async {
    Map<String, String> headerReturned = {};
    Uri parsedURI = Uri();

    headerReturned = await _generateRequestHeaders(header);
    parsedURI = data.runtimeType.toString() == 'String'
        ? await _generateRequestURI('$uri/$data')
        : await _generateRequestURI(uri, queryParamter: data);
    return await httpFacade.retrieve(parsedURI, header: headerReturned);
  }

  Future<dynamic> update(String uri, Map<String, dynamic> data, {Map<String, String>? header}) async {
    Map<String, String> headerReturned = {};
    Uri parsedURI = Uri();
    _generateRequestHeaders(header).then((value) => {headerReturned = value});
    var encodedData = json.encode(data);
    parsedURI = await _generateRequestURI(uri);

    return httpFacade.update(parsedURI, encodedData, headerReturned);
  }

  Future<dynamic> delete(String uri, {dynamic data, Map<String, String>? header}) async {
    Map<String, String> headerReturned = await _generateRequestHeaders(header);
    Uri parsedURI = await _generateRequestURI(uri);
    if(data != null){
      return httpFacade.delete(parsedURI, data: json.encode(data), header: headerReturned);
    }
    return httpFacade.delete(parsedURI, header: headerReturned);
  }
}
