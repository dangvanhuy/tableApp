import 'dart:developer';

import 'package:citgroupvn_efood_table/base/base_common.dart';
import 'package:citgroupvn_efood_table/base/base_controller.dart';
import 'package:citgroupvn_efood_table/data/api/api_checker.dart';
import 'package:citgroupvn_efood_table/data/model/response/oders_list_details.dart';
import 'package:citgroupvn_efood_table/data/model/response/order_details_model.dart';
import 'package:citgroupvn_efood_table/data/repository/order_repo.dart';
import 'package:get/get.dart';

class OrderRmController extends BaseController {
  RxList<Order> orderList = <Order>[].obs;

  final isLoading = true.obs;

  final OrderRepo orderRepo =
      OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find());

  @override
  Future<void> onInit() async {
    await getOrderList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getOrderList() async {
    try {
      log(BaseCommon.instance.branchTableToken!);
      isLoading.value = true;
      Response response = await orderRepo.getAllOders(
        BaseCommon.instance.branchTableToken ?? '',
      );
      log(response.body.toString());
      if (response.statusCode == 200) {
        orderList.value = OrderList(
                    order: OrderList.fromJson(response.body)
                        .order
                        ?.reversed
                        .toList())
                .order ??
            [];
      } else {
        ApiChecker.checkApi(response);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }


    
}
