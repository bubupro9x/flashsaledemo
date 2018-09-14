import 'package:intl/intl.dart';

class BaseModel {
  String formatPrice(String str) {
    var f = new NumberFormat("#,###", "en_US");
    final finalPrice = f.format(int.parse(str));
    return finalPrice + " đ";
  }

  DateTime convertTimestampToDate(int timestamp) {
    
    final time = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return time;
  }

  String format(int n) {
    return n.toStringAsFixed(n.truncate() == n ? 0 : 2);
  }
}
