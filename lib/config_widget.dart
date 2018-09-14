import 'package:flutter/services.dart';

class ConfigWidget {
  static String domain = "mapi.sendo.vn";
  // static String domain = "mapi-pilot.sendo.vn";

  static const platformChannel = const MethodChannel('com.sendo.flutter.io/native');

  static const eventChannel = EventChannel('com.sendo.flutter.io/event');

  static const screens = ["FlashDealScreen", "TestScreen"];
}