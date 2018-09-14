import 'dart:async';

import 'package:base_utils/system/theme_utils.dart';
import 'package:flashsaledemo/arch/injector.dart';

import 'package:flashsaledemo/bloc/bloc_providers.dart';
import 'package:flashsaledemo/bloc/product_bloc.dart';
import 'package:flashsaledemo/bloc/product_header_bloc.dart';
import 'package:flashsaledemo/main.dart';
import 'package:flashsaledemo/model/menu_item.dart';
import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flashsaledemo/model/session_item.dart';
import 'package:flashsaledemo/network/proxy/http_utils.dart';
import 'package:flashsaledemo/res/colors.dart';
import 'package:flashsaledemo/res/strings.dart';
import 'package:flashsaledemo/widgets/count_down_timer.dart';
import 'package:flashsaledemo/widgets/list_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class ProductTab extends StatefulWidget {
  @override
  _ProductTabState createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ProductTab> {
  TabController _tabController;

  Color _tabTitleColor = CustomColors.onSaleTabTitle;

  HeaderBloc _headerBloc;

  void setTabTitleColor(Color color) {
    setState(() {
      _tabTitleColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    _headerBloc = BlocProvider.of<HeaderBloc>(context);
    initController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataSession>(
      stream: _headerBloc.sessions,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(Strings.appBarTitle),
              leading: buildBackButton(context),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    //TODO add methodChannel share
                  },
                )
              ],
              bottom: PreferredSize(
                child: Container(
                  height: 60.0,
                  color: Colors.white,
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    tabs: buildTabHeaders(context, snapshot.data),
                    labelColor: _tabTitleColor,
                    indicatorColor: _tabTitleColor,
                    unselectedLabelColor: Colors.black,
                    indicatorWeight: 1.0,
                  ),
                ),
                preferredSize: Size(double.infinity, 60.0),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: buildTabViews(context, snapshot.data),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> buildTabHeaders(BuildContext context, DataSession sessions) {
    return sessions.slots
        .map(
          (slot) =>
          Tab(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${slot.toTime()}',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                    Text(
                      '${slot.title}',
                      style: TextStyle(
                          fontSize: 11.0, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              )),
    )
        .toList();
  }

  List<Widget> buildTabViews(BuildContext context, DataSession sessions) {
    final pages = List<Widget>();
    for (var i = 0; i < sessions.slots.length; i++) {
      pages.add(BlocProvider<ProductBloc>(
          bloc: ProductBloc(session: sessions, tabIndex: i),
          child: ProductPage(session: sessions, tabIndex: i)));
    }
    return pages;
  }

  bool _colorChanged = false;

  void initController() {
    _tabController = new TabController(vsync: this, length: 20);

    /*_tabController.addListener((){
      print("Tab settled");
      setTabTitleColor(_tabController.index ==  0 ? CustomColors.onSaleTabTitle: CustomColors.upcomingTabTitle);
      _headerBloc.curTabIndex.value = _tabController.index;
    });*/

//    _tabController.animation.addListener(() {
//      if (_tabController.animation.value !=
//          _tabController.animation.value.roundToDouble()) {
//        if (!_colorChanged) {
//          setTabTitleColor(Colors.black);
//          _colorChanged = true;
//        }
//        print("Animation: moving");
//      } else {
//        setTabTitleColor(_tabController.index == 0
//            ? CustomColors.onSaleTabTitle
//            : CustomColors.upcomingTabTitle);
//        _colorChanged = false;
//        print("Animation: completed");
//      }
//
//      /*if(_tabController.index != _tabController.previousIndex){
//        setTabTitleColor(_tabController.index ==  0 ? CustomColors.red: Colors.green);
//      } else {
//        setTabTitleColor(Colors.grey);
//      }*/
//    });
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

class ProductPage extends StatefulWidget {
  ProductPage({Key key, this.session, this.tabIndex}) : super(key: key);
  final DataSession session;
  final int tabIndex;

  @override
  _ProductPageState createState() => new _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductBloc _productBloc;
  ScrollController _controll = new ScrollController();
  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    _controll.addListener(() {
      _height = _controll.offset;
      if (_height <= 44.0) {
        setState(() {});
      }
      print('_controll.offset ${_controll.offset}');
    });
    _productBloc = BlocProvider.of<ProductBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        child: StreamBuilder<ProductsModel>(
            stream: _productBloc.products,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                ProductsModel model = snapshot.data;
                return Stack(
                  children: <Widget>[
                    countDownTimer(widget.session.slots[widget.tabIndex],
                        widget.session.slots[1].slot, widget.session),
                    Container(
                      margin: EdgeInsets.only(top: 0.0),
                        child:
                        ListView.builder(
                            controller: _controll,
                            itemCount: model.length,
                            itemBuilder: (context, index) {
                              _productBloc.indexInput.add(index);
                              if (model.isCountdownTimer(index)) {
                                return Container();
                              }
                              if (model.isBanner(index)) {
                                //return buildBanner(model.bannerUrl);
                                return Container();
                              } else if (model.isLoadingIndicator(index)) {
                                return buildLoadingIndicator();
                              } else {
                                return ListProduct(
                                    item: model.getProduct(index));
                              }
                            }),
                    )
                  ],
                );
              } else {
                return emptyProduct(context);
              }
            }));
  }

  Widget emptyProduct(BuildContext context) {
    return new Container(
      height: MediaQuery
          .of(context)
          .size
          .height - 190.0 - 100.0 - 18.0 - 48.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 120.0,
              height: 120.0,
              margin: EdgeInsets.only(bottom: 16.0),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'images/empty-background.png',
                      width: 120.0,
                      height: 120.0,
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'images/empty-product.png',
                      width: 60.0,
                      height: 60.0,
                    ),
                  )
                ],
              ),
            ),
            Text('Sản phẩm đang được cập nhật',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    color: Color(0xFFE39435)))
          ],
        ),
      ),
    );
  }

  Widget buildBanner(String url) {
    final image = AdvancedNetworkImage(
      url,
      useDiskCache: true,
      //useMemoryCache: false,
    );

    return Image(image: image, fit: BoxFit.cover);
  }

  Widget countDownTimer(Slot _slot, String startTimeSlotTwo,
      DataSession _session) {
    if (sub != null) {
      sub.cancel();
      sub = null;
    }
    var now = DateTime.now();
    Container wid = new Container(
      color: Colors.grey[300],
      height: 44.0,
      child: new CountDownTimer(
        height: 44.0 - _height,
        slots: _slot,
        startTime: now,
        session: _session,
        onDoneTimer: () {
//          showDialog(item);
        },
      ),
    );

    return wid;
  }

  Widget buildLoadingIndicator() {
    return Container(height: 40.0, child: CircularProgressIndicator());
  }
}
