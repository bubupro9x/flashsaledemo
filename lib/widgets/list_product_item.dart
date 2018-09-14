import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flashsaledemo/res/tab_resource.dart';
import 'package:flashsaledemo/widgets/product_list_item/fire_in_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ListProductItem extends StatefulWidget {
  final Product item;
  final TabResource tabResource;

  ListProductItem({Key key, this.item, this.tabResource}) : super(key: key);

  @override
  ListProductItemState createState() => new ListProductItemState();
}

class ListProductItemState extends State<ListProductItem> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildImage(),
            _itemDescription(widget.item),
          ],
        ));
  }

  Widget buildImage() {
    final image = AdvancedNetworkImage(
      widget.item.image,
      useDiskCache: true,
      //useMemoryCache: false,
    );

    final containerImage = Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: image),
      ),
    );

    return AspectRatio(
      aspectRatio: 1.0,
      child: new SizedBox(
        child: new Stack(
          children: <Widget>[
            containerImage,
            Positioned(
              right: -2.0,
              top: -1.5,
              child: this.icImageSale(
                  '${100 - widget.item.finalPrice / widget.item.price * 100}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget icImageSale(String percent) {
    // Will print error messages to the console.
    final String assetName = 'images/sale2x.png';
    final Widget img = new Image.asset(
      assetName,
      width: 37.0,
      fit: BoxFit.cover,
    );
    return Container(
      child: Stack(
        children: <Widget>[
          img,
          new Positioned(
            top: 4.0,
            left: 3.0,
            right: 0.0,
            child: Text(
              '${double.tryParse(percent).ceil()}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDescription(Product item) {
    final formatCurrency = new NumberFormat("#,##0", "vi_VN");

    //Visible Final Promotion Percent, when == 0 true, else.
    double numberPercent =
        ((item.price - item.finalPrice) * 100 / item.price) * 1.0;

    bool isVisibleSale = false;
    if (numberPercent <= 0) {
      isVisibleSale = true;
    }

    return new Expanded(
      child: new Container(
        margin: const EdgeInsets.only(left: 12.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //Title Product

            item.shoptype == 2
                ? Stack(
              children: <Widget>[
                SvgPicture.asset(
                  "images/senmall.svg",
                  width: 33.0,
                  height: 23.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40.0),
                  child: Text(
                    item.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.4,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
                : Text(
              item.name,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.4,
                color: Colors.black,
              ),
            ),

            //Price Product
            isVisibleSale
                ? new Text(
              '${formatCurrency.format(item.finalPrice)} Đ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.0,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.4,
                color: widget.tabResource.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            )
                : new Text(
              '${formatCurrency.format(item.price)} Đ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11.0,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.lineThrough,
                letterSpacing: -0.3,
                color: Color.fromRGBO(68, 68, 68, 1.0),
              ),
            ),

            //Price Product Sale
            isVisibleSale
                ? new Container()
                : new Text(
              '${formatCurrency.format(item.finalPrice)} Đ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.4,
                color: widget.tabResource.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            //Group Buy Now
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _isShowBuyNowAndProgressBar().toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _isShowBuyNowAndProgressBar() {
    List<Widget> listWidget = List<Widget>();

    //Percent Product Item...
    double stockDouble =
        (widget.item.quantity - widget.item.remain) / widget.item.quantity;

    Container containerWhite = new Container(
      width: 86.0,
      height: 12.0,
    );

    switch (widget.item.productDisplay) {
      case 'buy_now':
        listWidget.add(_progressBar(stockDouble));
        listWidget.add(_button());
        break;

      case 'buy_later':
        listWidget.add(_progressBar(stockDouble));
        listWidget.add(_button());
        break;

      case 'burn':
        listWidget.add(containerWhite);
        listWidget.add(containerWhite);
        break;
    }
    return listWidget;
  }

  Widget _progressBar(double percent) {
    String _title;
    if (widget.item.remain == widget.item.quantity) {
      _title = 'Đang bán';
    }
    int saleStockNumber = widget.item.quantity;
    int stockNumber = widget.item.remain;

    if ((saleStockNumber - stockNumber) * 100 / saleStockNumber > 0.0 &&
        (saleStockNumber - stockNumber) * 100 / saleStockNumber < 80.0) {
      _title = 'Đã bán ${saleStockNumber - stockNumber}';
    }

    if ((saleStockNumber - stockNumber) * 100 / saleStockNumber >= 80.0) {
      _title = 'Sắp hết';
    }

    if (stockNumber == 0) {
      _title = 'Cháy hàng';
    }
    if (widget.item.productDisplay == 'buy_later') {
      _title = 'Sắp bán';
    }

    return new Expanded(
      child: new FireInProgressBar(
          title: _title,
          percent: percent,
          item: widget.item,
          tabResource: widget.tabResource,
      ),
    );
  }

  Widget _button() {
    return new GestureDetector(
      onTap: () {},
      child: new Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: widget.tabResource.decoButton,
        padding:
        EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0, top: 8.0),
        alignment: Alignment.center,
        child: new Text(
          widget.item.buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            color: widget.tabResource.textButton,
          ),
        ),
      ),
    );
  }
}
