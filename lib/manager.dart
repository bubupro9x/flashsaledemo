import 'package:flutter/material.dart';

class Constants {
  static String API_URL = '';

  static void init(String flavor) {
    if (flavor == 'production') {
      API_URL = 'https://api.sendo.vn/';
    } else {
      API_URL = 'https://api-pilot.sendo.vn/';
    }
  }
}

class ManagerData {
  String flavor;
  Map<dynamic, dynamic> headers;

  ManagerData({
    @required this.flavor,
  });
}

const String ROUTE_FLASH_SALE_LANDING = 'flashsalelanding';
const String ROUTE_FLASH_SALE = 'flashsale';

class Manager {
  static final Manager instance = new Manager._internal();

  factory Manager() {
    return instance;
  }

  Manager._internal();

  ManagerData data;

  Manager init({@required String flavor}) {
    this.data = ManagerData(flavor: flavor);
    this.data.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Constants.init(flavor);
    return instance;
  }

//  Widget getFlashSaleLanding(String route, BuildContext context) {
//    // var map = parseRoute(route);
//    return new LandingWidget();
//  }
}
