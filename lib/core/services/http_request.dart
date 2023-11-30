import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/services/secure_storage.dart';

import '../errors.dart';

class HttpRequest {
  static Map<String, String> _headers = {};
  static final http.Client _client = http.Client();

  static includeHeader(String key, String value) {
    _headers[key] = value;
  }

  static _authenticateRequest() async {
    includeHeader("Accept", "application/json");
    SecureStorage pref = await SecureStorage.getInstance();
    var authCred = pref.getString("authCred");
    if (authCred != null) {
      includeHeader(
          "Authorization", "Bearer ${json.decode(authCred)['token']}");
    }
  }

  static Future<http.Response> get(
    String path, {
    String baseUrl = Constants.kBaseurl,
    bool enableDefaultHeaders = true,
    Map<String, String>? addHeaders,
  }) async {
    if (enableDefaultHeaders) await _authenticateRequest();
    Future<http.Response> response = _client.get(
      Uri.parse(baseUrl + path),
      headers: addHeaders ?? _headers,
    );

    return (await _completeRequest(response: response)) as http.Response;
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    String baseUrl = Constants.kBaseurl,
    bool enableDefaultHeaders = true,
    Map<String, String>? addHeaders,
  }) async {
    if (enableDefaultHeaders) await _authenticateRequest();

    Future<http.Response> response = _client.post(Uri.parse(baseUrl + path),
        headers: addHeaders ?? _headers, body: body);

    return (await _completeRequest(response: response)) as http.Response;
  }

  static Future<http.Response> delete(
    String path, {
    Map<String, dynamic>? body,
    String baseUrl = Constants.kBaseurl,
    bool enableDefaultHeaders = true,
    Map<String, String>? addHeaders,
  }) async {
    if (enableDefaultHeaders) await _authenticateRequest();
    Future<http.Response> response = _client.delete(Uri.parse(baseUrl + path),
        headers: addHeaders ?? _headers, body: body);

    return (await _completeRequest(response: response)) as http.Response;
  }

  static Future<http.Response> patch(
    String path,
    Map<String, dynamic> body, {
    String baseUrl = Constants.kBaseurl,
    bool enableDefaultHeaders = true,
    Map<String, String>? addHeaders,
  }) async {
    if (enableDefaultHeaders) await _authenticateRequest();
    Future<http.Response> response = _client.patch(Uri.parse(baseUrl + path),
        headers: addHeaders ?? _headers, body: body);

    return (await _completeRequest(response: response)) as http.Response;
  }

  static Future<http.StreamedResponse> uploadFile(
    String path,
    Map<String, dynamic> body, {
    required List<MultipartFile> bodyFiles,
    required String method,
    String baseUrl = Constants.kBaseurl,
    bool enableDefaultHeaders = true,
    Map<String, String>? addHeaders,
  }) async {
    if (enableDefaultHeaders) await _authenticateRequest();

    MultipartRequest request =
        http.MultipartRequest(method, Uri.parse(baseUrl + path));
    Map<String, String> _auth = addHeaders ?? _headers;
    _auth.forEach((k, v) => request.headers[k] = v);
    body.forEach((key, value) => request.fields[key] = value);
    for (final el in bodyFiles) {
      request.files.add(el);
    }

    Future<http.StreamedResponse> response = request.send();

    return (await _completeRequest(response: response))
        as http.StreamedResponse;
  }

  static Future<http.BaseResponse> _completeRequest(
      {required Future<http.BaseResponse> response}) async {
    return response.onError((err, stack) {
      if (err is SocketException) throw InternetConnectionError();

      if (err is Exception) throw OtherErrors(err);

      return Future.error(err ?? "An error occured");
    }).then((http.BaseResponse value) {
      return value;
    });
  }

  static clearMemory() => _headers = {};
}
