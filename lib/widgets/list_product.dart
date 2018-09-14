import 'dart:async';

import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flashsaledemo/widgets/dialog.dart';
import 'package:flashsaledemo/widgets/list_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListProduct extends StatefulWidget {
  final Product item;

  ListProduct({Key key, this.item}) : super(key: key);

  @override
  ListProductState createState() => new ListProductState();
}

class ListProductState extends State<ListProduct> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 13.0, bottom: 13.0),
                height: 145.0,
                child: ListProductItem(
                  item: widget.item,
                )),
            itemDivider(),
          ],
        ),
        widget.item.productDisplay != "burn"
            ? Container(

        )
            : Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.4,
              child: Container(
                margin: EdgeInsets.only(top:13.0),
                height: 145.0,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(35.0),
              child: Image.asset('images/icon_b_n_h_t.png'),
            )
          ],
        )
      ],
    );
  }

  Widget itemDivider() {
    return new Divider(
      color: Color(0xFFe3e3e3),
    );
  }

  Widget _getEmptyView(TextTheme textTheme) {
    return new Container(
      color: new Color.fromARGB(225, 241, 241, 241),
      child: new Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.black12)),
        child: new Text(
          "Bạn đã đến cuối danh sách sản phẩm",
          style: textTheme.subhead.copyWith(color: Colors.black38),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void showDialogSapBan(BuildContext context) {
    DialogAlert.instance = DialogAlert.internal(
      title: "",
      description: "Sản phẩm chưa đến giờ bán. \nXin vui lòng quay lại sau",
      image: "images/sapban.png",
      closeDialogCallBack: () => {},
    );
    DialogAlert.instance.showAlert(context);
  }
}
