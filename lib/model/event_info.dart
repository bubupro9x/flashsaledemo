// To parse this JSON data, do
//
//     final eventInfo = eventInfoFromJson(jsonString);

import 'dart:convert';

EventInfo eventInfoFromJson(String str) {
  final jsonData = json.decode(str);
  return EventInfo.fromJson(jsonData);
}

String eventInfoToJson(EventInfo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class EventInfo {
  dynamic status;
  String error;
  Data data;

  EventInfo({
    this.status,
    this.error,
    this.data,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) => new EventInfo(
    status: json["status"],
    error: json["error"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "data": data.toJson(),
  };
}

class Data {
  int currentTime;
  EventInfoClass eventInfo;

  Data({
    this.currentTime,
    this.eventInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    currentTime: json["current_time"],
    eventInfo: EventInfoClass.fromJson(json["event_info"]),
  );

  Map<String, dynamic> toJson() => {
    "current_time": currentTime,
    "event_info": eventInfo.toJson(),
  };
}

class EventInfoClass {
  String uri;
  String title;
  String name;
  String titleColor;
  Seo seo;
  BannerSale banner;
  bool eventIcon;
  String themeColor;
  dynamic otherImage;
  List<Breadcrumb> breadcrumb;
  CategoriesColor categoriesColor;
  List<dynamic> categories;
  String rules;
  Trends trends;
  dynamic blocks;
  String jsFileName;
  int startDate;
  int endDate;
  String timeType;
  List<int> timeSlot;
  String updatedAt;
  int countingTime;

  EventInfoClass({
    this.uri,
    this.title,
    this.name,
    this.titleColor,
    this.seo,
    this.banner,
    this.eventIcon,
    this.themeColor,
    this.otherImage,
    this.breadcrumb,
    this.categoriesColor,
    this.categories,
    this.rules,
    this.trends,
    this.blocks,
    this.jsFileName,
    this.startDate,
    this.endDate,
    this.timeType,
    this.timeSlot,
    this.updatedAt,
    this.countingTime,
  });

  factory EventInfoClass.fromJson(Map<String, dynamic> json) => new EventInfoClass(
    uri: json["uri"],
    title: json["title"],
    name: json["name"],
    titleColor: json["title_color"],
    seo: Seo.fromJson(json["seo"]),
    banner: BannerSale.fromJson(json["banner"]),
    eventIcon: json["event_icon"],
    themeColor: json["theme_color"],
    otherImage: json["other_image"],
    breadcrumb: new List<Breadcrumb>.from(json["breadcrumb"].map((x) => Breadcrumb.fromJson(x))),
    categoriesColor: CategoriesColor.fromJson(json["categories_color"]),
    categories: new List<dynamic>.from(json["categories"].map((x) => x)),
    rules: json["rules"],
    trends: Trends.fromJson(json["trends"]),
    blocks: json["blocks"],
    jsFileName: json["js_file_name"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    timeType: json["time_type"],
    timeSlot: new List<int>.from(json["time_slot"].map((x) => x)),
    updatedAt: json["updated_at"],
    countingTime: json["counting_time"],
  );

  Map<String, dynamic> toJson() => {
    "uri": uri,
    "title": title,
    "name": name,
    "title_color": titleColor,
    "seo": seo.toJson(),
    "banner": banner.toJson(),
    "event_icon": eventIcon,
    "theme_color": themeColor,
    "other_image": otherImage,
    "breadcrumb": new List<dynamic>.from(breadcrumb.map((x) => x.toJson())),
    "categories_color": categoriesColor.toJson(),
    "categories": new List<dynamic>.from(categories.map((x) => x)),
    "rules": rules,
    "trends": trends.toJson(),
    "blocks": blocks,
    "js_file_name": jsFileName,
    "start_date": startDate,
    "end_date": endDate,
    "time_type": timeType,
    "time_slot": new List<dynamic>.from(timeSlot.map((x) => x)),
    "updated_at": updatedAt,
    "counting_time": countingTime,
  };
}

  class BannerSale {
  String mobile;
  String desktop;
  List<dynamic> other;

  BannerSale({
    this.mobile,
    this.desktop,
    this.other,
  });

  factory BannerSale.fromJson(Map<String, dynamic> json) => new BannerSale(
    mobile: json["mobile"],
    desktop: json["desktop"],
    other: new List<dynamic>.from(json["other"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "desktop": desktop,
    "other": new List<dynamic>.from(other.map((x) => x)),
  };
}

class Breadcrumb {
  String title;
  String url;
  bool clickable;
  bool isExternalUrl;

  Breadcrumb({
    this.title,
    this.url,
    this.clickable,
    this.isExternalUrl,
  });

  factory Breadcrumb.fromJson(Map<String, dynamic> json) => new Breadcrumb(
    title: json["title"],
    url: json["url"],
    clickable: json["clickable"],
    isExternalUrl: json["isExternalUrl"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
    "clickable": clickable,
    "isExternalUrl": isExternalUrl,
  };
}

class CategoriesColor {
  String backgroundColor;
  String textColor;
  String activeColor;

  CategoriesColor({
    this.backgroundColor,
    this.textColor,
    this.activeColor,
  });

  factory CategoriesColor.fromJson(Map<String, dynamic> json) => new CategoriesColor(
    backgroundColor: json["background_color"],
    textColor: json["text_color"],
    activeColor: json["active_color"],
  );

  Map<String, dynamic> toJson() => {
    "background_color": backgroundColor,
    "text_color": textColor,
    "active_color": activeColor,
  };
}

class Seo {
  String title;
  String description;
  String image;

  Seo({
    this.title,
    this.description,
    this.image,
  });

  factory Seo.fromJson(Map<String, dynamic> json) => new Seo(
    title: json["title"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "image": image,
  };
}

class Trends {
  String background;

  Trends({
    this.background,
  });

  factory Trends.fromJson(Map<String, dynamic> json) => new Trends(
    background: json["background"],
  );

  Map<String, dynamic> toJson() => {
    "background": background,
  };
}
