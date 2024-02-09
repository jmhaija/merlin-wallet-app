import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpFacade {
  HttpFacade({this.ok, this.payload, this.httpStatus, this.headers});
  late dynamic ok;
  late dynamic httpStatus;
  late dynamic headers;
  late dynamic payload;

  Map<String, dynamic> _generateSuccessResponse(response) {
    Map<String, dynamic> respond = {
      'ok': true,
      'httpStatus': response.statusCode ?? '200',
      'headers': response.headers ?? {},
      'payload': response.body ?? {},
    };
    return respond;
  }

  Map<String, dynamic> _generateErrorResponse(error) {
    Map<String, dynamic> respond = {
      'ok': false,
      'httpStatus': error.statusCode,
      'headers': error.headers,
      'payload': error.body
    };
    return respond;
  }

  Future<Map<String, dynamic>> create(dynamic uri, dynamic data, {Map<String, String>? header}) async {
    return http.post(uri, headers: header, body: data).then((value) {
      return _generateSuccessResponse(value);
    }).catchError((onError) => _generateErrorResponse(onError));
  }

  Future<dynamic> retrieve(dynamic uri, {Map<String, String>? header}) async {
    return await http
        .get(uri, headers: header)
        .then((value) => value.statusCode > 299 ? _generateErrorResponse(value) : _generateSuccessResponse(value))
        .catchError((onError) => _generateErrorResponse(onError));
  }

  Future<Map> replace(dynamic uri, String data, Map<String, String> header) {
    return http
        .put(uri, headers: header, body: data)
        .then((value) => _generateSuccessResponse(value))
        .catchError((onError) => _generateErrorResponse(onError));
  }

  Future<Map> update(dynamic uri, String data, [Map<String, String>? header]) {
    return http
        .patch(uri, headers: header, body: data)
        .then((value) => _generateSuccessResponse(value))
        .catchError((onError) => _generateErrorResponse(onError));
  }

  Future<Map> delete(Uri uri, {dynamic data, Map<String, String>? header}) async {
    return http
        .delete(uri, headers: header, body: data)
        .then((value) => _generateSuccessResponse(value))
        .catchError((onError) => _generateErrorResponse(onError));
  }

  upload(uri, File file, Map<String, String> header) async {   
    var request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        'picture', 
        File(file.path).readAsBytesSync(),
        filename: file.path
      )
    );
    // send
    var response = await request.send();
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      //...
    });
  }
}
