import 'package:citgroupvn_efood_table/base/base_bindings.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class ProductBinding extends BaseBindings {
  @override
  void injectService() {
     Get.lazyPut<ProductController>(
      () => ProductController(),
    );
  }
}
