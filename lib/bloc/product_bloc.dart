
import 'dart:async';

import 'package:flashsaledemo/arch/injector.dart';
import 'package:flashsaledemo/bloc/base_bloc.dart';
import 'package:flashsaledemo/model/menu_item.dart';
import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flashsaledemo/model/session_item.dart';
import 'package:flashsaledemo/model/status.dart';
import 'package:flashsaledemo/network/proxy/http_utils.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class ProductBloc extends BaseBloc{
  final _productProxy = Injector.provideProductProxy();

  final _productsController = ReplaySubject<ProductsModel>();

  final _indexController = PublishSubject<int>();

  final _scrollUpButtonVisibleController = PublishSubject<bool>();

  var _tabIndex;

  Observable<ProductsModel> get products => _productsController.stream;

  Sink<int> get indexInput => _indexController.sink;

  Observable<int> get indexOutput => _indexController.stream;

  Observable<bool> get scrollUpButtonVisible =>
      _scrollUpButtonVisibleController.stream;

  Sink<bool> get scrollUpButtonInput => _scrollUpButtonVisibleController.sink;

  ProductsModel _productsModel;

  List<Product> _products;

  DataSession _dataSession;

  bool _loading = false;

  var _page = 1;

  Observable<BannerItem> _banner;

  ProductBloc({DataSession session, int tabIndex, ValueNotifier<int> curTabIndex, Observable<BannerItem> banner}) {
    _dataSession = session;
    _tabIndex = tabIndex;
    _banner = banner;

    _indexController
      ..bufferTime(Duration(milliseconds: 500))
          .where((batch) => batch.isNotEmpty)
          .listen((index) {
        _handleIndexes(index);

        _updateButton(index);
      });

    curTabIndex.addListener((){
      print("Tab changed to ${curTabIndex.value}");
      if(curTabIndex.value == _tabIndex
          && !_productsController.isClosed
          && _productsModel == null){
        print("Loading products");
        _handleFetchInitialProducts();
      }
    });

    //Load immediately if it's the first tab
    if(tabIndex == 0 && _productsModel == null){
      _handleFetchInitialProducts();
    }

  }

  void dispose() {
  }

  void _handleIndexes(List<int> indexList) {
    if (_productsController.isClosed) {
      return;
    }

    final largestIndex = indexList.reduce(max);

    if (largestIndex >= _productsModel.length - 10) {
      if(!_loading){
        _handleFetchMoreProducts();
      }
    }
  }

  Future<dynamic> loadProduct() async {
    DataRequest<List<Product>> dataRequest = DataRequest();
    dataRequest.onSuccess = (itemProduct) {
      _products = itemProduct;
      _page++;
    };
    dataRequest.onFailure = (error) {
      print('Load Category Groups fail! $error');
    };
    return _productProxy.fetchProducts(
        dataRequest, _dataSession.slots[_tabIndex].slot, _page);
  }

  void _handleFetchInitialProducts() async{
    print("Fetching inital products for page $_tabIndex");
     await loadProduct();

     _productsModel = ProductsModel(_products, _banner);
     _productsController.add(_productsModel);
  }

   void _handleFetchMoreProducts() async {
    print("fetching page $_page");
    _loading = true;
    DataRequest<List<Product>> dataRequest = DataRequest();
    dataRequest.onSuccess = (List<Product> itemProduct) {
      _loading = false;

      if (itemProduct.length > 0) {
        _productsModel.addMoreProducts(itemProduct);
        _productsController.add(_productsModel);
        _page++;
      } else {
        _productsModel.streamClosed = true;
        _productsController.close();
      }

    };
    dataRequest.onFailure = (error) {
      print('Load Category Groups fail! $error');
    };
    _productProxy.fetchProducts(
        dataRequest, _dataSession.slots[_tabIndex].slot, _page);

  }

  void _updateButton(List<int> indexes) {
    _scrollUpButtonVisibleController.add(indexes.last >= 7);
  }

  void reload() {
    _page =1 ;
    _handleFetchInitialProducts();
  }

}

class ProductsModel {
  List<Product> products;

  Observable<BannerItem> banner;
  
  var _streamClosed = false;

  ProductsModel(this.products, this.banner);

  int get length => (products!=null?products.length:0) + 3;
  
  Product getProduct(int index) {
    if(isCountdownTimer(index) || isBanner(index)){
      return null;
    }
    return products[index - 2];
  }

  bool isCountdownTimer(int index) => index == 0;
  
  bool isBanner(int index) => index == 1;

  bool isLoadingIndicator(int index) => isEndOfList(index) && !_streamClosed;

  bool isEndOfList(int index) => index == ((products!=null?products.length:0) + 2);

  void addMoreProducts(List<Product> moreProducts){
    products.addAll(moreProducts);
  }

  set streamClosed(bool value) {
    _streamClosed = value;
  }
}
