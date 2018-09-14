import 'package:flutter/material.dart';

class DialogAlert {
  final String image;
  final String title;
  final String description;
  final String confirm;
  final Function() closeDialogCallBack;
  static DialogAlert instance = new DialogAlert.internal();

  factory DialogAlert() {
    return instance;
  }

  DialogAlert.internal({
    this.image,
    this.title,
    this.description,
    this.confirm,
    this.closeDialogCallBack,
  });

  void closeDialog(BuildContext context) {
    closeDialogCallBack();
    Navigator.pop(context);
  }

  void showAlert(BuildContext context) {
    AlertDialog dialog;
    dialog = new AlertDialog(
      contentPadding: new EdgeInsets.all(0.0),
      content: new Container(
        width: 300.0,
        height: 220.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          children: <Widget>[
            Container(
              height: 170.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    image,
                    height: 50.0,
                    width: 100.0,
                  ),
                  Container(
                    margin: title.isNotEmpty
                        ? EdgeInsets.all(8.0)
                        : EdgeInsets.all(0.0),
                    child: Text(
                      title != null ? title : "",
                      style: TextStyle(
                        color: Color(0xFFe5101d),
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => closeDialog(context),
              child: new Container(
                height: 50.0,
                decoration: new BoxDecoration(
                  color: const Color(0xFFd30c0c),
                ),
                child: new Center(
                  child: new Text(
                    this.confirm != null ? confirm : "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // showDialog(context: context, child: dialog);

    showDialog(barrierDismissible: false, context: context, child: dialog);
  }
}
