import 'package:flutter/material.dart';

abstract class TabResource {
  Color get tabTitleColor;

  Color get primaryColor;

  Color get statusBackgroundColor;

  String get discountImagePath;

  Color get statusStartColor;

  Color get statusEndColor;

  bool get hasHotDeal;

  BoxDecoration get decoButton;

  Color get textButton;

  String get imgSale;
}

class OtherTabResource extends TabResource {
  @override
  String get discountImagePath => "images/other_discount_background.png";

  @override
  Color get primaryColor => const Color(0xFF38761d);

  @override
  Color get statusBackgroundColor => const Color(0xFFACCE84);

  @override
  Color get tabTitleColor => const Color(0xFF38761d);

  @override
  Color get statusEndColor => null;

  @override
  Color get statusStartColor => null;

  @override
  bool get hasHotDeal => false;

  @override
  String get imgSale => 'images/sale_green.png';

  @override
  BoxDecoration get decoButton => BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.all(Radius.circular(3.0)));

  @override
  Color get textButton => const Color(0xff38761d);
}

class SellingTabResource extends TabResource {
  @override
  String get discountImagePath => "images/selling_discount_background.png";

  @override
  String get imgSale => 'images/sale_red.png';

  @override
  Color get primaryColor => const Color(0xFFe5101d);

  @override
  Color get statusBackgroundColor => const Color(0xFFfbc999);

  @override
  Color get tabTitleColor => const Color(0xFFd0021b);

  @override
  Color get statusEndColor => const Color(0xFFf47900);

  @override
  Color get statusStartColor => const Color(0xFFff6a42);

  @override
  bool get hasHotDeal => true;

  @override
  BoxDecoration get decoButton => BoxDecoration(
      color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(3.0)));

  @override
  Color get textButton => const Color(0xFFffffff);
}
