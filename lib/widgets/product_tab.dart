import 'dart:async';

import 'package:base_utils/system/theme_utils.dart';
import 'package:flashsaledemo/arch/injector.dart';
import 'package:rect_getter/rect_getter.dart';
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
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Color _tabTitleColor = CustomColors.onSaleTabTitle;

  HeaderBloc _headerBloc;

  List<Widget> _cachedPages;

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
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
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

  Widget countDownTimer(
      Slot _slot, String startTimeSlotTwo, DataSession _session) {
    if (sub != null) {
      sub.cancel();
      sub = null;
    }
    var now = DateTime.now();
    Container wid = new Container(
      color: Colors.grey[300],
      height: 44.0,
      child:  CountDownTimer(
        height: 44.0 ,
        slots: _slot,
        startTime: now,
        session: _session,
        onDoneTimer: () {
//          showDialog(item);
        },
      ));


    return wid;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> buildTabHeaders(BuildContext context, DataSession sessions) {
    return sessions.slots
        .map(
          (slot) => Tab(
                  child:Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('${slot.toTime()}',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
                        Container(height: 4.0),
                        Text(
                          '${slot.title}',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
              ),
        )
        .toList();
  }

  List<Widget> buildTabViews(BuildContext context, DataSession sessions) {
    if(_cachedPages == null){
      print("===> Building tab views");
      _cachedPages = List<Widget>();
      for (var i = 0; i < sessions.slots.length; i++) {
        _cachedPages.add(BlocProvider<ProductBloc>(
            bloc: ProductBloc(session: sessions, tabIndex: i),
            child: ProductPage(session: sessions, tabIndex: i)));
      }
    }
    return _cachedPages;
  }

  bool _colorChanged = false;

  void initController() {
    _tabController = new TabController(vsync: this, length: 20);

/*_tabController.addListener((){
      print("Tab settled");
      setTabTitleColor(_tabController.index ==  0 ? CustomColors.onSaleTabTitle: CustomColors.upcomingTabTitle);
      _headerBloc.curTabIndex.value = _tabController.index;
    });*/

    _tabController.animation.addListener(() {
      if (_tabController.animation.value !=
          _tabController.animation.value.roundToDouble()) {
        if (!_colorChanged) {
          setTabTitleColor(Colors.black);
          _colorChanged = true;
        }
        print("Animation: moving");
      } else {
        setTabTitleColor(_tabController.index == 0
            ? CustomColors.onSaleTabTitle
            : CustomColors.upcomingTabTitle);
        _colorChanged = false;
        print("Animation: completed");
      }

/*if(_tabController.index != _tabController.previousIndex){
        setTabTitleColor(_tabController.index ==  0 ? CustomColors.red: Colors.green);
      } else {
        setTabTitleColor(Colors.grey);
      }*/
    });
  }
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
  ScrollController _scrollController = new ScrollController();
  double _height = 0.0;
  GlobalKey _keyTopHeader, _keyHeader;
  var _isHeader = false;

  @override
  void initState() {
    super.initState();
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
                    ListView.builder(
                        controller: _scrollController,
                        itemCount: model.length,
                        itemBuilder: (context, index) {
                          _productBloc.indexInput.add(index);
                          if (model.isCountdownTimer(index)) {
                            return Container();
                          }
                          if (model.isBanner(index)) {
                            //return buildBanner(model.bannerUrl);
                            return Container(height: 44.0);
                          } else if (model.isLoadingIndicator(index)) {
                            return buildLoadingIndicator();
                          } else {
                            return ListProduct(item: model.getProduct(index));
                          }
                        }),
                   
                  ],
                );
              } else {
                return emptyProduct(context);
              }
            }));
  }

  Widget emptyProduct(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height - 190.0 - 100.0 - 18.0 - 48.0,
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

  Widget buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }
}
