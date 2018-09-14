import 'dart:async';
import 'dart:convert';
import 'package:flashsaledemo/model/menu_item.dart';
import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flashsaledemo/model/session_item.dart';
import 'package:flashsaledemo/network/proxy/base_proxy.dart';
import 'package:flashsaledemo/network/proxy/http_utils.dart';

class ProductProxy extends BaseProxy {
  ProductProxy();

  factory ProductProxy.initial() => ProductProxy();

  static final String moduleDomail = "/mob/flash-deal/";

  final String uriProducts =
      '/flash-deal/ajax-product/'; //http://mapi-pilot.sendo.vn/mob/flash-deal/products?session_id=1
  final String uriFlashDeal = moduleDomail +
      "sessions/"; //http://mapi-pilot.sendo.vn/mob/flash-deal/sessions

/*
  - Fetch Products
*/

  Future<dynamic> fetchProducts(
      DataRequest<List<Product>> dataRequest, String slot, int page) async {
    final _body = {'slot': slot, 'page': page, 'limit': 30};
    final _request = Request(
        method: Method.POST,
        host: 'https://api.sendo.vn',
        path: '/flash-deal/ajax-product/',
        headers: {'Accept': 'application/x-www-form-urlencoded'},
        params: _body);

    _request.onSuccess = (result) {
      if (result.toString() == null || !result.contains('data')) {
        dataRequest.onSuccess(new List());
        return;
      }
      final parsed =
          json.decode(result)['data']['products'].cast<Map<String, dynamic>>();

      final List<Product> products =
          parsed.map<Product>((json) => Product.fromJson(json)).toList();

      dataRequest.onSuccess(products);
    };

    _request.onFailure = (error) {
      dataRequest?.onFailure(error);
    };

    return httpUtils.request(_request);
  }

  Future<dynamic> fetchBanner(DataRequest<BannerItem> dataRequest) async {
    final _request = Request(
        method: Method.GET,
        host: 'https://mapi.sendo.vn',
        path: 'mob/flash-deal/sessions',
        headers: null,
        params: null);

    _request.onSuccess = (result) {
      BannerItem _output;
      List<MenuItem> _items = new List();
      String _link = "";
      String _title = "";

      if (json.decode(result)['data'] as Map<String, dynamic> == null) {
        dataRequest.onFailure('Request onFailure');
      }

      if (json.decode(result)['data']['list'] != null) {
        final parsed =
        json.decode(result)['data']['list'].cast<Map<String, dynamic>>();
        _items =
            parsed.map<MenuItem>((json) => MenuItem.fromJson(json)).toList();
      }
//
      if (json.decode(result)['data']['link'] != null) {
        _link = json.decode(result)['data']['link'].toString();
      }

      if (json.decode(result)['data']['title'] != null) {
        _title = json.decode(result)['data']['title'].toString();
      }

      _output = BannerItem(title: _title, link: _link, menuItems: _items);

      dataRequest.onSuccess(_output);
    };

    _request.onFailure = (e) {
      dataRequest.onFailure('Request onFailure ${e}');
    };

    httpUtils.request(_request);
  }

  Future<dynamic> fetchSessions(DataRequest<DataSession> dataRequest) async {
    final _request = Request(
      method: Method.POST,
      host: 'https://api.sendo.vn',
      path: '/flash-deal/ajax-deal/',
      headers: null,
      params: null,
    );
    _request.onSuccess = (result) {
      DataSession _output;
      List<Slot> _items = new List();
      String _currentTime = "";
      String _currentSlot = "";
      String _waitTime = "";

      if (json.decode(result)['data'] as Map<String, dynamic> == null) {
        dataRequest.onFailure('Request onFailure');
      }

      if (json.decode(result)['data']['slots'] != null) {
        final parsed =
            json.decode(result)['data']['slots'].cast<Map<String, dynamic>>();
        _items = parsed.map<Slot>((json) => Slot.fromJson(json)).toList();
      }
      if (json.decode(result)['data']['current_time'] != null) {
        _currentTime = json.decode(result)['data']['current_time'].toString();
      }

      if (json.decode(result)['data']['current_slot'] != null) {
        _currentSlot = json.decode(result)['data']['current_slot'].toString();
      }
      if (json.decode(result)['data']['wait_time'] != null) {
        _waitTime = json.decode(result)['data']['wait_time'].toString();
      }

      _output = DataSession(
          currentSlot: _currentSlot,
          currentTime: int.tryParse(_currentTime),
          waitTime: int.tryParse(_waitTime),
          slots: _items);

      dataRequest.onSuccess(_output);
    };
    _request.onFailure = (error) {
      dataRequest?.onFailure(error);
    };

    return httpUtils.request(_request);
  }
}
