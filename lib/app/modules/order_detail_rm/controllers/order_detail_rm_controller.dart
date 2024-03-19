import 'dart:developer';

import 'package:citgroupvn_efood_table/base/base_common.dart';
import 'package:citgroupvn_efood_table/base/base_controller.dart';
import 'package:citgroupvn_efood_table/data/api/api_checker.dart';
import 'package:citgroupvn_efood_table/data/model/response/oders_list_details.dart';
import 'package:citgroupvn_efood_table/data/model/response/order_details_model.dart';
import 'package:citgroupvn_efood_table/data/repository/order_repo.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrderDetailRmController extends BaseController {
  //TODO: Implement OrderDetailRmController
  OrderDetailRmController(
      {required this.isOrderDetails, required this.orderId});
  final bool isOrderDetails;
  final String orderId;
  Rx<String> idOrder = ''.obs;
  final count = 0.obs;

  final isLoading = true.obs;
  final foundError = false.obs;
  RxList<Order> orderList = <Order>[].obs;
  Rx<OrderDetails> currentOrderDetails = OrderDetails().obs;


  final OrderRepo orderRepo =
      OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  @override
  Future<void> onInit() async {
    if (isOrderDetails) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    try {
    idOrder.value =  orderId;
      await getOrderList();
      await getOrderDetail(orderId.toString());
      isLoading.value = false;
    } catch (e) {
      foundError(true);
      log(e.toString());
      isLoading.value = false;
    }
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
      log(BaseCommon.instance.branchTableToken!);
      isLoading.value = true;
      Response response = await orderRepo.getAllOders(
        BaseCommon.instance.branchTableToken ?? '',
      );
      log(response.body.toString());
      if (response.statusCode == 200) {
        orderList.value = OrderList(
                order:
                    OrderList.fromJson(response.body).order?.reversed.toList())
            .order!;
      } else {
        ApiChecker.checkApi(response);
      }
   
  }

  Future<void> getOrderDetail(String idOrder) async {
      Response response = await orderRepo.getOrderDetails(
        idOrder.toString(),
        BaseCommon.instance.branchTableToken ?? "",
      );
      if (response.statusCode == 200) {
        currentOrderDetails.value = OrderDetails.fromJson(response.body);
      } else {
        ApiChecker.checkApi(response);
      }
  }

  fetchWithNewId(String id)async{
     try {
      idOrder.value = id;
      isLoading.value = true;
      await getOrderDetail(idOrder.toString());
      isLoading.value = false;
    } catch (e) {
      foundError(true);
      log(e.toString());
      isLoading.value = false;
    }
  }
}
