import 'package:flashsaledemo/model/base_model.dart';
import 'package:flashsaledemo/model/category_item.dart';
import 'package:flutter/foundation.dart';

class MenuItem extends BaseModel {
  final String name;
  final String startTime;
  final String endTime;
  final String sessionId;
  final String description;
  final String sessionStatus;
  final List<CategoryItem> categories;
  final List<String> banners;

  bool isSelected;

  MenuItem(
      {Key key,
      this.name = "",
      this.startTime = "",
      this.banners,
      this.categories,
      this.endTime = "",
      this.sessionId = "",
      this.description = "",
      this.isSelected,
      this.sessionStatus = ""});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    List<CategoryItem> categories2 = List<CategoryItem>().toList();
    List<String> banners2 = List<String>().toList();

    if (json.containsKey('categories') == true) {
      final parsed = json['categories'].cast<Map<String, dynamic>>();
      categories2 = parsed
          .map<CategoryItem>((json) => CategoryItem.fromJson(json))
          .toList();
    }

    if (json.containsKey('banner_url') == true) {
     banners2 = new List<String>.from(json['banner_url']);
    }

    return MenuItem(
        name: json['name'].toString(),
        startTime: json['start_time'].toString(),
        banners: banners2,
        categories: categories2,
        endTime: json['end_time'].toString(),
        sessionId: json['session_id'].toString(),
        description: json['description'].toString(),
        sessionStatus: json['session_status'].toString(),
        isSelected: false);
  }
}

class BannerItem extends BaseModel {
  final String link;
  final String title;
  final List<MenuItem> menuItems;

  BannerItem({this.title, this.link, this.menuItems});
}
