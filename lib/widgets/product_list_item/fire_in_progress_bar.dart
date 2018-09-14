
import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flutter/material.dart';

class FireInProgressBar extends StatefulWidget {
  FireInProgressBar({Key key, this.percent, this.title,this.item})
      : super(key: key);

  final double percent;
  final String title;
  Product item;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _FireInProgressBar();
  }
}

class _FireInProgressBar extends State<FireInProgressBar> {
  EdgeInsets edgeAll = EdgeInsets.only(top: 12.0, bottom: 4.0, left: 15.0);
  double _percent;

  @override
  Widget build(BuildContext context) {
    this._percent = (widget.percent != null ? widget.percent : 0.0);
    return _fireInProgressBar(context);
  }

  Widget _fireInProgressBar(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(right: 12.0),
      alignment: Alignment.center,
      constraints: BoxConstraints.expand(height: 30.0, width: 10.0),
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          _containerBackground(edgeAll),
          _containerPercent(edgeAll),
          _containerTitle(edgeAll),
          _imageBurn(),
        ],
      ),
    );
  }

  Container _containerBackground(EdgeInsets edge) {
    return new Container(
      margin: edge,
      decoration: BoxDecoration(
        color: Color(0xFFFBC999),
        borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
      ),
    );
  }

  Container _containerPercent(EdgeInsets edge) {
    return new Container(
      margin: edge,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        Color colorContainer = Color(0xFFD43D3D);
        if (widget.percent <= 0.2) {
          if (widget.percent!=0.0){
            _percent = widget.percent+0.1;
            colorContainer = Color(0xFFD43D3D);
          }
          colorContainer = Color(0xFFD43D3D); //Red
        } else {
          colorContainer = Color(0xFFF47900); //Organ
        }

        if (widget.item.productDisplay == 'burn') {
          colorContainer = Colors.grey;
          this._percent = 1.0;
        }

        return new Container(
          decoration: BoxDecoration(
            color: colorContainer,
            borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
          ),
          width: widget.percent<=0.2?constraints.maxWidth *_percent:constraints.maxWidth * widget.percent,
        );
      }),
    );
  }

  Container _containerTitle(EdgeInsets edge) {
    return new Container(
      margin: edge,
      alignment: Alignment.center,
      child: new Text(
        widget.title,
        textAlign: TextAlign.center,
        style: new TextStyle(color: Colors.white, fontSize: 10.0),
      ),
    );
  }

  Widget _imageBurn() {
    return new Container(
      width: 24.0,
      height: 36.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.cover,
          image: new AssetImage(
            widget.item.productDisplay == 'burn'
                ? "images/cu-san-deal-grey.png"
                : "images/cu-san-deal.png",
          ),
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
//        color: new ColorFi
      ),
    );
  }
}
