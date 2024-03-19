import 'package:citgroupvn_efood_table/app/core/constants/color_constants.dart';
import 'package:citgroupvn_efood_table/app/util/number_format_utils.dart';
import 'package:citgroupvn_efood_table/app/util/reponsive_utils.dart';
import 'package:citgroupvn_efood_table/presentation/screens/cart/cart.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/payment.dart';
import 'package:citgroupvn_efood_table/presentation/screens/splash/splash.dart';
import 'package:flutter/material.dart';
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
      body: Obx(() => _tabletView(context)),
    );
  }

  _mainData(BuildContext context) {
    final OrderController orderController = Get.find();
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
                Builder(builder: (context) {
                  bool render = false;
                  if (orderController.currentOrderDetails?.details != null) {
                    render = true;
                  }
                  double itemsPrice = 0;
                  double discount = 0;
                  double tax = 0;
                  double addOnsPrice = 0;
                  List<Details> orderDetails =
                      orderController.currentOrderDetails?.details ?? [];
                  if (orderController.currentOrderDetails?.details != null) {
                    for (Details orderDetails in orderDetails) {
                      itemsPrice = itemsPrice +
                          (orderDetails.price! *
                              orderDetails.quantity!.toInt());
                      discount = discount +
                          (orderDetails.discountOnProduct! *
                              orderDetails.quantity!.toInt());
                      tax = (tax +
                          (orderDetails.taxAmount! *
                              orderDetails.quantity!.toInt()) +
                          orderDetails.addonTaxAmount!);
                    }
                  }

                  double total = itemsPrice - discount + tax;

                  return render
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text.rich(
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              TextSpan(
                                children: orderController.currentOrderDetails
                                            ?.order?.orderNote !=
                                        null
                                    ? [
                                        TextSpan(
                                          text: 'note'.tr,
                                          style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${orderController.currentOrderDetails?.order?.orderNote ?? ''}',
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            CustomDivider(
                              color: Theme.of(context).disabledColor,
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            PriceWithType(
                              type: 'items_price'.tr,
                              amount: PriceConverter.convertPrice(itemsPrice),
                            ),
                            PriceWithType(
                                type: 'discount'.tr,
                                amount:
                                    '- ${PriceConverter.convertPrice(discount)}'),
                            PriceWithType(
                                type: 'vat_tax'.tr,
                                amount:
                                    '+ ${PriceConverter.convertPrice(tax)}'),
                            PriceWithType(
                                type: 'addons'.tr,
                                amount:
                                    '+ ${PriceConverter.convertPrice(addOnsPrice)}'),
                            PriceWithType(
                                type: 'total'.tr,
                                amount: PriceConverter.convertPrice(
                                    total + addOnsPrice),
                                isTotal: true),
                          ],
                        )
                      : Column(
                          children: [
                            CustomDivider(
                                color: Theme.of(context).disabledColor),
                            SizedBox(
                              height: Dimensions.paddingSizeSmall,
                            ),
                          ],
                        );
                }),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: UtilsReponsive.height(context, 50)),
                  child: CustomDivider(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                CustomButton(
                    width: 400,
                    // height: 50,
                    buttonText: "Chỉnh sửa đơn hàng",
                    fontSize: Dimensions.fontSizeDefault,
                    onPressed: () {
                      Get.toNamed(Routes.ORDER_DETAIL_UPDATE_RM,
                          parameters: {"idOrder": controller.orderId});
                    }),
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
    String addonsName = '';

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
