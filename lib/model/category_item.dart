import 'package:flashsaledemo/model/base_model.dart';
import 'package:flutter/foundation.dart';

class CategoryItem extends BaseModel {
  final String icon;
  final String title;
  final String catePath;
  final bool isSelected;

  CategoryItem({Key key, this.title, this.icon, this.catePath, this.isSelected});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
        title: json['title'] as String,
        icon: json['icon'] as String,
        isSelected: false,
        catePath: "");
  }
}