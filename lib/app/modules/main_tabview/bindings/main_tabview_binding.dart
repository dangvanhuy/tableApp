import 'package:citgroupvn_efood_table/base/base_bindings.dart';
import 'package:get/get.dart';

import '../../../../presentation/controller/maintabview/main_tabview_controller.dart';

class MainTabviewBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<MainTabviewController>(
      () => MainTabviewController(),
    );
  }
}
