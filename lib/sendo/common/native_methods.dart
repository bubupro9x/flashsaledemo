//import 'dart:async';
//
//import 'package:flutter/services.dart';
//import 'package:meta/meta.dart';
//
//
//Future<dynamic> actionDeepLinkSendo({@required String url}) async {
//  try {
//    final dict = {'url': url};
//    await flashsale.nativeChannel.invokeMethod('actionDeepLink', [dict]);
//  } on PlatformException catch (e) {
//    print('$e');
//  }
//}
//
//Future<dynamic> actionShareSendo({@required String shareUrl}) async {
//  try {
//    final dict = {'shareUrl': shareUrl};
//    await flashsale.nativeChannel.invokeMethod('actionShare', [dict]);
//  } on PlatformException catch (e) {
//    print('$e');
//  }
//}
//
//Future<dynamic> actionProductDetailSendo({@required String id}) async {
//  try {
//    final dict = {'id': id};
//    await flashsale.nativeChannel.invokeMethod('actionProductDetail', [dict]);
//  } on PlatformException catch (e) {
//    print('$e');
//  }
//}
