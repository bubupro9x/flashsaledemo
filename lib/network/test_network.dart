import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Request {
  final Method method;
  final String url;
  final Map<String, dynamic> parameters = Map();

  Function(String data) onSuccess;
  Function(String data) onFailure;

  Request({Key key, this.method = Method.GET, this.url = ""});
}

enum Method { POST, GET }

class HttpUtility {
  request(Request rq) {
    if (rq.method.toString() == "Method.GET") {
     http.get(rq.url).then((response) {
        if (response.statusCode == 200) {
          rq.onSuccess(response.body);
        }
      }, onError: (error) {
        rq.onFailure(error.toString());
      });
    }
  }
}

demoRequestChoBoGhet() {
  final HttpUtility httpUtillty = HttpUtility();

  final request = Request(
      url: "https://mapi.sendo.vn/mob/product/cat/cong-nghe/may-tinh-bang-cu");
  

  request.onSuccess = (data) {
    print(data);
  };

  request.onFailure = (error) {
    print(error);
  };

  httpUtillty.request(request);
}
