import 'package:flashsaledemo/model/product_item_new.dart';
import 'package:flashsaledemo/model/session_item.dart';
import 'package:flashsaledemo/network/proxy/session_proxy.dart';
import 'package:flashsaledemo/widgets/countdown_base.dart';
import 'package:flutter/material.dart';
import 'package:core_plugin/helper.dart';
import 'package:intl/intl.dart';

var sub;

class CountDownTimer extends StatefulWidget  {
  CountDownTimer({Key key,
    this.height,
    this.slots,
    this.startTime,
    this.onDoneTimer,
    this.startTimeSlotTwo,
    this.session})
      : super(key: key);
  final Slot slots;
  final Function onDoneTimer;
  final DateTime startTime;
  final String startTimeSlotTwo;
  final DataSession session;
  final double height;

  @override
  _CountDownTimerState createState() => new _CountDownTimerState();
}

//ToDo
class _CountDownTimerState extends State<CountDownTimer>  {



  List<String> widgetList = ['00', '00', '00'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.readTimestamp();
    return new Container(
      height: 50.0,
      color: Colors.black12,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          this.widget_list_category(context),
          this.widget_timer_contain(context),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }


  void createCountDown(Duration d) {
    if (sub == null) {

      CountDown cd = new CountDown(
        d,
        refresh: new Duration(seconds: 1),
      );

      sub = cd.stream.listen(null);

      sub.onData((Duration d) {
        int server = int.tryParse(serverTime) ?? 0;
        serverTime = '${server + 1}';

        setState(() {
          var strListTimer = this.handleTimerRefresh(d);
          widgetList = strListTimer;
        });
      });

      sub.onDone(() {
        widget.onDoneTimer();
        print('Done');
      });
    }
  }

  void readTimestamp() {
    var now = new DateTime.now();
    int timeStampTemp = 0;
    if (now.millisecondsSinceEpoch <
        DateTime
            .parse(widget.slots.slot)
            .millisecondsSinceEpoch) {
      timeStampTemp =
          DateTime
              .parse(widget.slots.slot)
              .millisecondsSinceEpoch ?? 0;
    } else {
      //selling
      timeStampTemp =
          (widget.session.currentTime + widget.session.waitTime) * 1000 ?? 0;
//      print('timeStampTemp ${timeStampTemp}');
    }
    var date = new DateTime.fromMillisecondsSinceEpoch(timeStampTemp);
    var diff = date.difference(now);
    print('now ${now}');
    var strListTimer = this.handleTimerRefresh(diff);
    print('strListTimer ${strListTimer}');
    widgetList[0] = '${strListTimer[0]}';
    widgetList[1] = '${strListTimer[1]}';
    widgetList[2] = '${strListTimer[2]}';
    this.createCountDown(diff);
  }

  List<String> handleTimerRefresh(Duration d) {
    var strDuration = d.toString().split(':');

    //get second
    var second = strDuration[2].split('.')[0];
    var hours = strDuration[0];
    var minutes = strDuration[1];

    var numberHours = int.tryParse(hours);

    //Check Hour
    if (numberHours < 10) {
      hours = '0${numberHours}';
    } else {
      hours = '${numberHours}';
    }

    return [hours, minutes, second];
  }

  //Widget Category
  Widget widget_list_category(BuildContext context) {
    return new Container(
      width: 0.0,
    );
  }

  //Widget Timer Count Down (Right)
  Widget widget_timer_contain(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(right: 8.0, left: 8.0),
        color: Colors.transparent,
        child: new Container(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: this.containTimer(context, widgetList),
        ) ,)
    );
  }

  List<Widget> containTimer(BuildContext context, List<String> list) {
    List<Widget> listWidget = List<Widget>();

    //Title for Contain Count Down Timer...
    listWidget.add(this.textForTimer(context));
    for (int i = 0; i < list.length; i++) {
      //add count down timer
      listWidget.add(this.widget_contain(context, list[i]));
      if (i < list.length - 1) {
        //add two dots between contain...
        listWidget.add(this.widget_two_dots(context));
      }
    }
    return listWidget;
  }

  //Contain for timer
  Widget widget_contain(BuildContext context, String value) {
    return new Row(
      children: <Widget>[
        new Container(
            width: 25.0,
            height: 20.0,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4.0)),
            child: Center(
              child: new Text(
                value,
                style: new TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFFf5a623),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            )),
      ],
    );
  }

  //Contain two dots
  Widget widget_two_dots(BuildContext context) {
    return new Container(
      width: 10.0,
      alignment: Alignment.center,
      child: new Text(
        ':',
        style: new TextStyle(fontSize: 12.0, color: Colors.black),
      ),
    );
  }

  //Title For Timer CountDown
  Widget textForTimer(BuildContext context) {
    String strTitle = '';
    var now = new DateTime.now();
    if (now.millisecondsSinceEpoch <
        DateTime
            .parse(widget.slots.slot)
            .millisecondsSinceEpoch) {
      strTitle = 'Bắt đầu trong';
    } else {
      //selling
      strTitle = 'Kết thúc trong';
    }

    return new Container(
      padding: EdgeInsets.only(right: 8.0),
      child: new Text(
        strTitle,
        style: new TextStyle(
            fontFamily: 'Roboto', fontSize: 13.0, color: Color(0xFF454545)),
      ),
    );
  }

}
