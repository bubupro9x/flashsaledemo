
import 'package:flashsaledemo/network/proxy/product_proxy.dart';

class Injector {
  static ProductProxy provideProductProxy() {
    return ProductProxy();
  }

}
