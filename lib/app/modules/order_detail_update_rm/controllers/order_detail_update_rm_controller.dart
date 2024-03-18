import 'dart:developer';

import 'package:citgroupvn_efood_table/app/modules/order_detail_update_rm/model/FootSummary.dart';
import 'package:citgroupvn_efood_table/app/util/number_format_utils.dart';
import 'package:citgroupvn_efood_table/base/base_common.dart';
import 'package:citgroupvn_efood_table/base/base_controller.dart';
import 'package:citgroupvn_efood_table/data/api/api_checker.dart';
import 'package:citgroupvn_efood_table/data/model/response/oders_list_details.dart';
import 'package:citgroupvn_efood_table/data/model/response/order_details_model.dart';
import 'package:citgroupvn_efood_table/data/repository/order_repo.dart';
import 'package:citgroupvn_efood_table/presentation/screens/cart/cart.dart';
import 'package:get/get.dart';

class OrderDetailUpdateRmController extends BaseController {
  //TODO: Implement OrderDetailUpdateRmController
  OrderDetailUpdateRmController({required this.orderId});
  final orderId;
  Rx<String> idOrder = ''.obs;
  final count = 0.obs;

  final isLoading = true.obs;
  final foundError = false.obs;
  RxList<Order> orderList = <Order>[].obs;
  Rx<OrderDetails> currentOrderDetails = OrderDetails().obs;

  Rx<String> tableId = "".obs;
  Rx<int> peopleNum = 0.obs;

  Rx<FootSummary> footSummaryData = FootSummary().obs;

  final OrderRepo orderRepo =
      OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  @override
  Future<void> onInit() async {
    try {
      idOrder.value = orderId;
      await getOrderDetail(orderId.toString());
      recalculateFinalFoot();

      tableId.value = "${Get.find<SplashController>().getTable(
            currentOrderDetails.value.order?.tableId,
            branchId: currentOrderDetails.value.order?.branchId,
          )?.number}";
      peopleNum.value = Get.find<CartController>().peopleNumber!;

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
              order: OrderList.fromJson(response.body).order?.reversed.toList())
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

  fetchWithNewId(String id) async {
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

  updateTable() async {
   
  }

  

  removeProduct(Details detail) async {
    currentOrderDetails.value.details!.remove(detail);
    recalculateFinalFoot();
    currentOrderDetails.update((val) {});
  }

  recalculateFinalFoot() {
    footSummaryData.value =
        FootSummary.fromOderDetail(orderDetail: currentOrderDetails.value);
    ;
  }

  updateFinal(){
  }
}
