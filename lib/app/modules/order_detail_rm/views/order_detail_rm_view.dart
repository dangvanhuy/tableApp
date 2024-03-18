import 'dart:developer';

import 'package:citgroupvn_efood_table/app/core/constants/color_constants.dart';
import 'package:citgroupvn_efood_table/app/util/number_format_utils.dart';
import 'package:citgroupvn_efood_table/app/util/reponsive_utils.dart';
import 'package:citgroupvn_efood_table/data/model/response/order_details_model.dart';
import 'package:citgroupvn_efood_table/presentation/screens/cart/cart.dart';
import 'package:citgroupvn_efood_table/presentation/screens/cart/cart_screen_update.dart';
import 'package:citgroupvn_efood_table/presentation/screens/home/home.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/payment.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/widget/oder_details_update_view.dart';
import 'package:citgroupvn_efood_table/presentation/screens/splash/splash.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_detail_rm_controller.dart';

class OrderDetailRmView extends BaseView<OrderDetailRmController> {
  const OrderDetailRmView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return ResponsiveHelper.isTab(context)
        ? _tabletView(context)
        : _mobileView(context);
  }

  _tabletView(BuildContext context) {
    return controller.isLoading.value
        ? Center(
            child: CustomLoader(
            color: Theme.of(context).primaryColor,
          ))
        : !controller.foundError.value
            ? Column(
                children: [
                  SizedBox(
                    height: Dimensions.paddingSizeDefault,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                    child: Obx(() => FilterButtonWidget(
                          type: controller.idOrder.value,
                          onSelected: (id) async {
                            await controller.fetchWithNewId(id);
                          },
                          items: controller.orderList.value
                              .map((order) => '${'order'.tr}# ${order.id}')
                              .toList(),
                          isBorder: true,
                        )),
                  ),
                  SizedBox(
                    height: Dimensions.paddingSizeSmall,
                  ),
                  Flexible(child: _mainData(context)),
                ],
              )
            : NoDataScreen(text: 'no_order_available'.tr);
  }

  _mobileView(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        showCart: false,
        onBackPressed: () => Get.back(),
      ),
      bottomNavigationBar: CustomButton(
          width: 300,
          // height: 50,
          buttonText: "Chỉnh sửa đơn hàng",
          fontSize: Dimensions.fontSizeDefault,
          onPressed: () {
          Get.toNamed(Routes.ORDER_DETAIL_UPDATE_RM, parameters: {
            "idOrder":controller.orderId
          });
          }),
      body: Obx(() => _tabletView(context)),
    );
  }

  _mainData(BuildContext context) {
    return controller.currentOrderDetails == null
        ? Center(child: CustomLoader(color: Theme.of(context).primaryColor))
        : SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                _headerSummary(context),
                const SizedBox(height: 40),
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount:
                        controller.currentOrderDetails.value.details?.length,
                    itemBuilder: (context, index) {
                      return _subItemDetail(context,
                          subItem: controller
                              .currentOrderDetails.value.details![index]);
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: UtilsReponsive.height(context, 50)),
                  child: CustomDivider(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                _rowTextFootSummary(title: "Giá sản phẩm", content: NumberFormatUtils.formatDong(controller.currentOrderDetails.value.order!.orderAmount!.toString())),
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                _rowTextFootSummary(title: "Giảm giá", content: NumberFormatUtils.formatDong(controller.currentOrderDetails.value.order!.couponDiscountAmount!.toString())),
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                _rowTextFootSummary(title: "VAT/Thuế", content:  NumberFormatUtils.formatDong(controller.currentOrderDetails.value.order!.totalTaxAmount!.toString())),
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                _rowTextFootSummary(title: "Phụ gia", content: NumberFormatUtils.formatDong(controller.currentOrderDetails.value.order!.totalTaxAmount!.toString())),
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                _rowTextFootSummary(title: "Tổng", content: NumberFormatUtils.formatDong(controller.currentOrderDetails.value.order!.totalTaxAmount!.toString()),isBold: true),
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                _rowTextFootSummary(title: "Số tiền đã thanh toán", content: NumberFormatUtils.formatDong(controller.currentOrderDetails.value.order!.totalTaxAmount!.toString())),
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                _rowTextFootSummary(title: "Thay đổi", content: NumberFormatUtils.formatDong(controller.currentOrderDetails.value.order!.totalTaxAmount!.toString())),
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
              ],
            ),
          );
  }

  Row _rowTextFootSummary(
      {required String title, required String content, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isBold
              ? TextStyleConstant.black20RobotoBold
              : TextStyleConstant.black16Roboto,
        ),
        Text(
          content,
          style: isBold
              ? TextStyleConstant.black20RobotoBold
              : TextStyleConstant.black16Roboto,
        )
      ],
    );
  }

  SizedBox _subItemDetail(BuildContext context, {required Details subItem}) {
    double totalPriceSubItem =
        subItem.productDetails!.price! * subItem.quantity!;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      subItem.productDetails!.name!,
                      style: TextStyleConstant.black16Roboto,
                    ),
                  )),
              Expanded(
                  child: Text(
                subItem.quantity.toString(),
                style: TextStyleConstant.black16Roboto,
              )),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        NumberFormatUtils.formatDong(
                            totalPriceSubItem.toString()),
                        style: TextStyleConstant.black16Roboto,
                      )))
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                      NumberFormatUtils.formatDong(
                          subItem.productDetails!.price!.toString()),
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(
                        UtilsReponsive.height(context, 10))),
                alignment: Alignment.center,
                // margin:,
                child: Text(
                  subItem.productDetails!.productType!.tr,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  Row _headerSummary(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'order_summary'.tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.paddingSizeSmall,
                  ),
                  Text(
                    '${'order'.tr}# ${controller.currentOrderDetails.value.order?.id}',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${'table'.tr} ${Get.find<SplashController>().getTable(
                                controller
                                    .currentOrderDetails.value.order?.tableId,
                                branchId: controller
                                    .currentOrderDetails.value.order?.branchId,
                              )?.number} |',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${controller.currentOrderDetails.value.order?.numberOfPeople ?? 'add'.tr} ${'people'.tr}',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
