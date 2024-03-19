import 'dart:ffi';

import 'package:citgroupvn_efood_table/app/core/constants/color_constants.dart';
import 'package:citgroupvn_efood_table/app/modules/product/views/product_list_view.dart';
import 'package:citgroupvn_efood_table/app/util/number_format_utils.dart';
import 'package:citgroupvn_efood_table/app/util/reponsive_utils.dart';
import 'package:citgroupvn_efood_table/data/model/response/order_details_model.dart';
import 'package:citgroupvn_efood_table/data/repository/cart_repo.dart';
import 'package:citgroupvn_efood_table/presentation/screens/cart/cart.dart';
import 'package:citgroupvn_efood_table/presentation/screens/home/home.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/payment_update_screen.dart';
import 'package:citgroupvn_efood_table/presentation/screens/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/order_detail_update_rm_controller.dart';

class OrderDetailUpdateRmView extends BaseView<OrderDetailUpdateRmController> {
  const OrderDetailUpdateRmView({Key? key}) : super(key: key);
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
    final cartController = Get.find<CartController>();
    final List<CartModel> cartList = cartController.cartList;

    return controller.currentOrderDetails == null
        ? Center(child: CustomLoader(color: Theme.of(context).primaryColor))
        : SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                _headerSummary(context),
                const SizedBox(height: 40),
                Obx(() => ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount:
                        controller.currentOrderDetails.value.details?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: _subItemDetail(context,
                            subItem: controller
                                .currentOrderDetails.value.details![index]),
                      );
                    })),
                Builder(builder: (context) {
                  final orderController = Get.find<OrderController>();

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
                SizedBox(
                  height: UtilsReponsive.height(context, 15),
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                      transparent: true,
                      buttonText: " Thêm sản phẩm",
                      onPressed: () {
                        Get.to(() => ProdcutListView());
                      },
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomButton(
                        height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                        buttonText: 'place_order'.tr,
                        onPressed: () {
                          final CartController cartController = Get.find();
                          final SplashController splashController = Get.find();
                          if (splashController.getTableId() == -1) {
                            showCustomSnackBar('please_input_table_number'.tr);
                          } else if (cartController.peopleNumber == null) {
                            showCustomSnackBar('please_enter_people_number'.tr);
                          } else {
                            List<Cart> carts = [];
                            for (int index = 0;
                                index < cartController.cartList.length;
                                index++) {
                              CartModel cart = cartController.cartList[index];
                              List<int> addOnIdList = [];
                              List<int> addOnQtyList = [];
                              List<OrderVariation> variations = [];
                              cart.addOnIds?.forEach((addOn) {
                                addOnIdList.add(addOn.id!);
                                addOnQtyList.add(addOn.quantity!);
                              });

                              if (cart.product != null &&
                                  cart.product!.variations != null &&
                                  cart.variations != null) {
                                for (int i = 0;
                                    i < cart.product!.variations!.length;
                                    i++) {
                                  if (cart.variations![i].contains(true)) {
                                    variations.add(OrderVariation(
                                      name: cart.product!.variations![i].name,
                                      values: OrderVariationValue(label: []),
                                    ));
                                    if (cart.product!.variations![i]
                                            .variationValues !=
                                        null) {
                                      for (int j = 0;
                                          j <
                                              cart.product!.variations![i]
                                                  .variationValues!.length;
                                          j++) {
                                        if (cart.variations![i][j]) {
                                          variations[variations.length - 1]
                                              .values
                                              ?.label
                                              ?.add(cart
                                                      .product!
                                                      .variations![i]
                                                      .variationValues?[j]
                                                      .level ??
                                                  '');
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }

                            Get.to(
                              const PaymentUpdateScreen(),
                              transition: Transition.leftToRight,
                              duration: const Duration(milliseconds: 300),
                            );
                          }
                        },
                      ),
                    ),
                  ],
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      ))),
              IconButton(
                onPressed: () {
                  controller.removeProduct(subItem);
                },
                icon: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.error),
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
                iconSize: Dimensions.paddingSizeLarge,
              )
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
              Expanded(child: SizedBox())
            ],
          )
        ],
      ),
    );
  }

  Row _headerSummary(BuildContext context) {
    final splashController = Get.find<SplashController>();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: Center(
                      child: splashController
                                  .getTable(splashController.getTableId())
                                  ?.number ==
                              null
                          ? Center(
                              child: Text(
                                'add_table_number'.tr,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            )
                          : Obx(() => Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${'table'.tr}  ${controller.tableId.value} | ',
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
                                          '${controller.peopleNum.value} ${'people'.tr}',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      //Pick Số bàn
                      DialogHelper.openDialog(
                        context,
                        TableInputView(
                          callback: () async {
                            await controller.updateTable();
                          },
                        ),
                      );
                    },
                    child: Image.asset(
                      Images.editIcon,
                      height: 30,
                      color: Theme.of(context).secondaryHeaderColor,
                      width: 30,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
