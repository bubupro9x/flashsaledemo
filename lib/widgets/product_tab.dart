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
import 'package:flashsaledemo/res/tab_resource.dart';
import 'package:flashsaledemo/widgets/count_down_timer.dart';
import 'package:flashsaledemo/widgets/list_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:rxdart/rxdart.dart';

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> buildTabHeaders(BuildContext context, DataSession sessions) {
    return sessions.slots
        .map(
          (slot) => Tab(
                child: Container(
                  width: 60.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('${slot.toTime()}',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold)),
                      Container(height: 4.0),
                      Text('${slot.title}',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w300)),
                      Container(height: 4.0),
                    ],
                  ),
                ),
              ),
        )
        .toList();
  }

  List<Widget> buildTabViews(BuildContext context, DataSession sessions) {
    if (_cachedPages == null) {
      _cachedPages = List<Widget>();
      _headerBloc = BlocProvider.of<HeaderBloc>(context);

      for (var i = 0; i < sessions.slots.length; i++) {
        _cachedPages.add(BlocProvider<ProductBloc>(
            bloc: ProductBloc(
                session: sessions,
                tabIndex: i,
                curTabIndex: _headerBloc.curTabIndex,
                banner: _headerBloc.banner),
            child: ProductPage(
              session: sessions,
              tabIndex: i,
              tabResource: i == 0 ? SellingTabResource() : OtherTabResource(),
            )));
      }
    }
    return _cachedPages;
  }

  bool _colorChanged = false;

  void initController() {
    _tabController = new TabController(vsync: this, length: 20);

    _tabController.addListener(() {
      _headerBloc.curTabIndex.value = _tabController.index;
    });

    _tabController.animation.addListener(() {
      if (_tabController.animation.value !=
          _tabController.animation.value.roundToDouble()) {
        if (!_colorChanged) {
          setTabTitleColor(Colors.black);
          _colorChanged = true;
        }
      } else {
        setTabTitleColor(_tabController.index == 0
            ? CustomColors.onSaleTabTitle
            : CustomColors.upcomingTabTitle);
        _colorChanged = false;
      }
    });
  }
}

class ProductPage extends StatefulWidget {
  ProductPage({Key key, this.session, this.tabIndex, this.tabResource})
      : super(key: key);
  final DataSession session;
  final int tabIndex;
  final TabResource tabResource;

  @override
  _ProductPageState createState() => new _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductBloc _productBloc;
  HeaderBloc _headerBloc;
  static const TO_TOP_BUTTON_VISIBLE_THRESHOLD = 700.0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  static const TO_TOP_BUTTON_ANIMATION_THRESHOLD = 1500.0;
  ScrollController _scrollController = new ScrollController();
  bool isShowScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >= TO_TOP_BUTTON_VISIBLE_THRESHOLD) {
        _productBloc.scrollUpButtonInput.add(true);
      } else {
        _productBloc.scrollUpButtonInput.add(false);
      }
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
                    RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: model.length,
                          itemBuilder: (context, index) {
                            _productBloc.indexInput.add(index);
                            if (model.isCountdownTimer(index)) {
                              return countDownTimer(
                                  widget.session.slots[widget.tabIndex],
                                  widget.session.slots[1].slot,
                                  widget.session);
                            }
                            if (model.isBanner(index)) {
                              return buildBanner(model.banner);
                            } else if (model.isEndOfList(index)) {
                              if(model.isLoadingIndicator(index)){
                                return buildLoadingIndicator();
                              } else {
                                return _buildEndOfListIndicator(context);
                              }
                            }  else {
                            return ListProduct(
                              item: model.getProduct(index),
                              tabResource: widget.tabResource,);
                            }
                        })),
                    Positioned(right: 12.0, bottom: 47.0,child: buildScrollUpButton()),
                  ],
                );
              } else {
                return emptyProduct(context);
              }
            }));
  }

  Widget buildScrollUpButton() {
    return StreamBuilder<bool>(
        initialData: false,
        stream: _productBloc.scrollUpButtonVisible,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return AnimatedOpacity(
              opacity: (snapshot.data != null && snapshot.data) ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Material(
                elevation: 4.0,
                shape: CircleBorder(),
                color: Colors.transparent,
                child: Ink.image(
                  image: AssetImage('images/ic_to_top.png'),
                  fit: BoxFit.cover,
                  width: 45.0,
                  height: 45.0,
                  child: InkWell(
                      onTap: () {
                        if (_scrollController.offset <= TO_TOP_BUTTON_ANIMATION_THRESHOLD) {
                          _scrollController.animateTo(0.0,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeIn);
                        } else {
                          _scrollController.jumpTo(0.0);
                        }

                        _productBloc.scrollUpButtonInput.add(false);
                      },
                      child: null
                  ),
                ),
              ));
        });
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

  Widget _buildEndOfListIndicator(BuildContext context) {
    final grey = Color(0xFFd0d0d0);
    final background = Color(0xFFf1f1f1);
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      color: background,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 15.0, right: 11.0),
                height: 1.0,
                color: grey),
          ),
          Text(
            "Bạn đã đến cuối danh sách sản phẩm",
            style: TextStyle(color: grey, fontSize: 15.0),
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 11.0, right: 15.0),
                height: 1.0,
                color: grey),
          )
        ],
      ),
    );
  }

  Widget buildBanner(Observable<BannerItem> banner) {
    return StreamBuilder<BannerItem>(
      stream: banner,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          final image = AdvancedNetworkImage(
            snapshot.data.menuItems[0].banners[0],
            useDiskCache: true,
          );

          return Image(image: image, fit: BoxFit.cover);
        } else {
          return Container(height: 0.0, color: Colors.grey);
        }
      },
    );
  }

  int checkTab = 0;

  Widget countDownTimer(Slot _slot, String startTimeSlotTwo, DataSession _session) {

    _scrollController.addListener(() {
      //print(_scrollController.offset);
      if (_scrollController.offset < 44.0) {
        //print('sub null');
        //sub = null;
      }


    });

    Timer(Duration(seconds: 1), () {
      if (checkTab != widget.tabIndex) {
        //sub = null;
        checkTab = widget.tabIndex;
        setState(() {});
      } else {
        if (widget.tabIndex == 0) {
          //print('tab = 0');
          //sub = null;
        }
      }
    });
    var now = DateTime.now();
    Container wid = new Container(
      color: Colors.grey[200],
      height: 44.0,
      child: new CountDownTimer(
        height: 44.0,
        slots: _slot,
        tabResource: widget.tabResource,
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
    return Center(child: CircularProgressIndicator());
  }

  Future<Null> _handleRefresh() async {
    _productBloc.reload();

    await new Future.delayed(new Duration(seconds: 1));

    return null;
  }
}
