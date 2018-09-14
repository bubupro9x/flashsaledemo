
import 'dart:async';

import 'package:flashsaledemo/bloc/base_bloc.dart';
import 'package:flashsaledemo/model/menu_item.dart';
import 'package:flashsaledemo/model/session_item.dart';
import 'package:flashsaledemo/network/proxy/http_utils.dart';
import 'package:flashsaledemo/network/proxy/product_proxy.dart';
import 'package:flashsaledemo/res/strings.dart';
import 'package:flashsaledemo/widgets/count_down_timer.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class HeaderBloc extends BaseBloc {
  DataSession _cachedSessions;

  final _productProxy = ProductProxy.initial();

  final _sessionController = PublishSubject<DataSession>();

  final _bannerController = BehaviorSubject<BannerItem>();

  ValueNotifier<int> curTabIndex;

  Observable<DataSession> get sessions => _sessionController.stream;

  Observable<BannerItem> get banner => _bannerController.stream;

  BannerItem _cachedBanner;

  HeaderBloc(){
    curTabIndex = ValueNotifier(0);

    _sessionController.onListen = () async {
      loadSessions();
    };

    _bannerController.onListen = (){
      loadBanner();
    };
  }

  @override
  void dispose() {
    _sessionController.close();
    _bannerController.close();
  }

  void loadSessions() {
    DataRequest<DataSession> request = DataRequest<DataSession>();

    request.onSuccess = (data){
      addSession(data);
    };

    _productProxy.fetchSessions(request);
  }

  Future<dynamic> loadBanner() async {
    print("Loading banner");
    DataRequest<BannerItem> dataRequest = DataRequest();
    dataRequest.onSuccess = (itemBanner) {
      print("Banner loaded");
      _cachedBanner = itemBanner;
      _bannerController.add(_cachedBanner);
    };

    dataRequest.onFailure = (error) {
      print('Load Category Groups fail! $error');
    };
    return await _productProxy.fetchBanner(dataRequest);
  }

  void addSession(DataSession data) {
    _cachedSessions = data;
    _findTitleForSessions(_cachedSessions);
    _sessionController.add(_cachedSessions);
  }



  void _findTitleForSessions(DataSession sessions) {
    sessions.slots.forEach((slot) {
      if (sessions.slots.first == slot) {
        slot.title = Strings.slotOnSale;
        return;
      }

      DateTime currentTime = getDateOnly(DateTime.now());

      DateTime slotTime = getDateOnly(DateTime.parse(slot.slot));

      Duration interval = slotTime.difference(currentTime);

      if (interval < Duration(days: 1)) {
        slot.title = Strings.slotUpcoming;
      } else if (interval < Duration(days: 2)) {
        slot.title = Strings.slotTomorrow;
      } else if (interval < Duration(days: 3)) {
        slot.title = Strings.slotDayAfterTomorrow;
      } else {
        slot.title = Strings.slotDayMonth(slotTime.day, slotTime.month);
      }
    });
  }

  DateTime getDateOnly(DateTime currentTime) {
    return DateTime(currentTime.year, currentTime.month, currentTime.day);
  }
}
