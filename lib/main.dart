import 'dart:async';

import 'package:flashsaledemo/arch/injector.dart';
import 'package:flashsaledemo/bloc/bloc_providers.dart';
import 'package:flashsaledemo/bloc/product_header_bloc.dart';
import 'package:flashsaledemo/model/event_info.dart';
import 'package:flashsaledemo/model/menu_item.dart';
import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flashsaledemo/model/session_item.dart';
import 'package:flashsaledemo/network/proxy/http_utils.dart';
import 'package:flashsaledemo/network/proxy/session_proxy.dart';
import 'package:flashsaledemo/widgets/count_down_timer.dart';
import 'package:flashsaledemo/widgets/list_product.dart';
import 'package:flashsaledemo/widgets/product_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<HeaderBloc>(
          bloc: HeaderBloc(),
          child: ProductTab(),
      )
//        )
    );
  }
}


