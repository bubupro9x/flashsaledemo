import 'dart:async';
import 'package:flashsaledemo/config_widget.dart';
import 'package:flutter/services.dart';



class ChannelManager {
  ChannelManager();

  factory ChannelManager.initial() => ChannelManager();

//action tap product detail
//go to product detail
  Future<Null> actionViewProductDetail(String id) async {
    try {
      final dict = Map<String, dynamic>();
      dict['id'] = id;

      //call to native
      await ConfigWidget.platformChannel
          .invokeMethod('actionProductDetail', [dict]);
    } on PlatformException catch (e) {
      print('loi me no roi;');
    }
  }

  Future<Null> actionViewEventDetail(String id) async {
    try {
      final dict = Map<String, dynamic>();
      dict['id'] = id;

      //call to native
      await ConfigWidget.platformChannel
          .invokeMethod('actionEvent', [dict]);
    } on PlatformException catch (e) {
      print('loi me no roi;');
    }
  }

//init frist view when flutter start run.
//  Future<String> initView() async {
//    final arrayScreens = AppRouter.screens;
//    final dict = Map<String, dynamic>();
//    dict['screen'] = arrayScreens;
//
//    try {
//      call to native
//      final String result =
//          await ConfigWidget.platformChannel.invokeMethod('initView', [dict]);
//      return result;
//    } on PlatformException catch (e) {
//      print('loi me no roi; ${e}');
//      return "";
//    }
//  }

  //call close flash deal
  Future<Null> actionClose() async {
    try {
      //call to native
      await ConfigWidget.platformChannel.invokeMethod('actionCloseScreen');
    } on PlatformException catch (e) {
      print('loi me no roi; ${e}');
    }
  }

  //call to native shared.
  Future<Null> actionShare(String shareUrl) async {
    final dict = Map<String, dynamic>();
    dict['shareUrl'] = shareUrl;

    try {
      //call to native
      await ConfigWidget.platformChannel.invokeMethod('actionShare', [dict]);
    } on PlatformException catch (e) {
      print('loi me no roi; ${e}');
    }
  }
}
