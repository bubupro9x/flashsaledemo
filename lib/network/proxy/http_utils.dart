import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum Method { GET, POST }

class DataRequest<T> {
  Function(T data) onSuccess;
  Function(dynamic error) onFailure;
}

class Request {
  final Method method;
  final String host;
  final String path;
  final Map<dynamic, dynamic> params;
  final Map<dynamic, dynamic> headers;

  Request({
    Key key,
    @required this.method,
    @required this.host,
    @required this.path,
    this.params,
    this.headers,
  });

  Function(String data) onSuccess;

  Function(dynamic error) onFailure;
}

class HttpUtils {
  Future<dynamic> request(Request request) async {
    var _requestUri;
    Map<String, String> _rightHeaders = request.headers!=null?Map.from(request.headers):null;
    Map<String, dynamic> _rightParams =
    request.params != null ? Map.from(request.params) : null;

    switch (request.method) {
      case Method.POST:
        _requestUri = Uri.parse(request.host).replace(
          path: request.path,
        );

        debugPrint(
            "--> REQUEST URL: ${request.method.toString()} ${_requestUri.toString()}");
        if(_rightHeaders!=null)
        debugPrint("REQUEST HEADERS: ${_rightHeaders.toString()}");
        if (_rightParams != null)
          debugPrint("REQUEST BODY: ${_rightParams.toString()}");

        return http
            .post(_requestUri,
            headers: _rightHeaders!=null?_rightHeaders:null,
            body: _rightParams != null ? json.encode(_rightParams) : null,
            encoding: utf8)
            .timeout(
          Duration(seconds: 20),
          onTimeout: () {
            debugPrint(
                "<-- REQUEST TIMEOUT: ${request.method.toString()} ${_requestUri.toString()}");
          },
        ).then((response) {
          if (response != null) {
            debugPrint("<-- RESPONSE: ${response.body}");
            request.onSuccess(response.body);
          } else {
            debugPrint("error $response");
          }
        }, onError: (error) {
          debugPrint("ERROR: $error");
          request.onFailure(error);
        });

      case Method.GET:
        _requestUri = Uri.parse(request.host).replace(
          path: request.path,
          queryParameters: _rightParams != null ? _rightParams : null,
        );

        debugPrint(
            "--> REQUEST URL: ${request.method.toString()} ${_requestUri.toString()}");
        if(_rightHeaders!=null)
        debugPrint("REQUEST HEADERS: ${_rightHeaders.toString()}");

        return http.get(_requestUri, headers: _rightHeaders).timeout(
          Duration(seconds: 20),
          onTimeout: () {
            debugPrint(
                "<-- REQUEST TIMEOUT: ${request.method.toString()} ${_requestUri.toString()}");
          },
        ).then((response) {
          if (response != null) {
            debugPrint("<-- RESPONSE: ${response.body}");
            request.onSuccess(response.body);
          } else {
            debugPrint("error $response");
          }
        }, onError: (error) {
          debugPrint("ERROR: $error");
          request.onFailure(error);
        });

      default:
        var error = 'missing method!';
        debugPrint("ERROR: $error");
        request.onFailure(error);
        return null;
    }
  }
}
