import 'package:citgroupvn_efood_table/app/components/custom_loader.dart';
import 'package:citgroupvn_efood_table/app/helper/dia_log_helper.dart';
import 'package:citgroupvn_efood_table/data/model/response/order_details_model.dart';
import 'package:citgroupvn_efood_table/app/modules/order_list/controller/order_list_controller.dart';
import 'package:citgroupvn_efood_table/app/modules/home/widget/filter_button_widget.dart';
import 'package:citgroupvn_efood_table/app/modules/order_list/widgets/oder_list_products.dart';
import 'package:citgroupvn_efood_table/app/modules/order/payment_update_screen.dart';
import 'package:intl/intl.dart';

import 'cart.dart';

class CartUpdateView extends StatefulWidget {
  final bool isOrderDetails;
  final String? oderId;
  const CartUpdateView({Key? key, this.oderId, this.isOrderDetails = false})
      : super(key: key);

  @override
  State<CartUpdateView> createState() => _CartUpdateViewState();
}

class _CartUpdateViewState extends State<CartUpdateView> {
  @override
  void initState() {
    if (widget.isOrderDetails) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      Get.find<OrderController>().getOrderList();
      Get.find<OrderListController>().getOrderList();
      Get.find<OrderListController>().fetchMoreData();
      // Get.find<OrderController>().setCurrentOrderId = null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isTab(context)
        ? orderBody()
        : Scaffold(
            appBar: CustomAppBar(
              isBackButtonExist: true,
              showCart: false,
              onBackPressed: () => Get.back(),
            ),
            body: orderBody(),
          );
  }

  GetBuilder<OrderController> orderBody() {
    final splashController = Get.find<SplashController>();
    final orderListController = Get.find<OrderListController>();
    return GetBuilder<OrderController>(builder: (orderController) {
      return GetBuilder<CartController>(builder: (cartController) {
        DateTime dateTime = DateTime.now();
        List<List<AddOn>> addOnsList = [];
        List<bool> availableList = [];
        double itemPrice = 0;
        double discount = 0;
        double tax = 0;
        double addOns = 0;
        final orderController = Get.find<OrderController>();

        List<CartModel> cartList = cartController.cartList;

        for (var cartModel in cartList) {
          List<AddOn> addOnList = [];
          cartModel.addOnIds?.forEach((addOnId) {
            if (cartModel.product != null &&
                cartModel.product?.addOns! != null) {
              for (AddOn addOns in cartModel.product!.addOns!) {
                if (addOns.id == addOnId.id) {
                  addOnList.add(addOns);
                  break;
                }
              }
            }
          });
          addOnsList.add(addOnList);

          availableList.add(DateConverter.isAvailable(
              cartModel.product?.availableTimeStarts,
              cartModel.product?.availableTimeEnds));

          for (int index = 0; index < addOnList.length; index++) {
            addOns = addOns +
                (addOnList[index].price! *
                    cartModel.addOnIds![index].quantity!.toDouble());
          }
          itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
          discount = discount +
              (cartModel.discountAmount! * cartModel.quantity!.toDouble());
          tax = tax + (cartModel.taxAmount! * cartModel.quantity!.toDouble());
        }
        // double _subTotal = _itemPrice + _tax + _addOns;
        double total = itemPrice -
            discount +
            orderController.previousDueAmount() +
            tax +
            addOns;

        cartController.setTotalAmount = total;
        List<String> orderIdList = [];
        orderController.orderList
            ?.map((order) => orderIdList.add('${'order'.tr}# ${order.id}'))
            .toList();

        return orderController.isLoading || orderController.orderList == null
            ? Center(
                child: CustomLoader(
                color: Theme.of(context).primaryColor,
              ))
            : orderController.orderList!.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge,
                      vertical: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(children: [
                      SizedBox(
                        height: Dimensions.paddingSizeDefault,
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                        child: FilterButtonWidget(
                          type: orderController.currentOrderId == null
                              ? orderIdList.first
                              : orderController.currentOrderId!,
                          onSelected: (id) {
                            orderController.setCurrentOrderId = id;
                            orderController
                                .getCurrentOrder(
                                    id.replaceAll('${'order'.tr}# ', ''),
                                    isLoading: !widget.isOrderDetails)
                                .then((value) {
                              Get.find<OrderController>().cancelTimer();
                              Get.find<OrderController>().countDownTimer();
                            });
                          },
                          items: orderIdList,
                          isBorder: true,
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.paddingSizeSmall,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                splashController
                                            .getTable(
                                                splashController.getTableId())
                                            ?.number ==
                                        null
                                    ? Center(
                                        child: Text(
                                          'add_table_number'.tr,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                        ),
                                      )
                                    : Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${'table'.tr} ${splashController.getTable(splashController.getTableId())?.number} | ',
                                              style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${cartController.peopleNumber ?? 'add'.tr} ${'people'.tr}',
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              DialogHelper.openDialog(
                                context,
                                 TableInputView(),
                              );
                            },
                            child: Image.asset(
                              Images.editIcon,
                              color: Theme.of(context).secondaryHeaderColor,
                              width: Dimensions.paddingSizeExtraLarge,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.isSmallTab() ? 20 : 40),
                      Expanded(
                        child: ListView.builder(
                            itemCount: cartList.length,
                            itemBuilder: (context, index) {
                              CartModel cartItem = cartList[index];
                              List<Variation>? variationList;

                              if (cartItem.product!.branchProduct != null &&
                                  cartItem
                                      .product!.branchProduct!.isAvailable!) {
                                variationList =
                                    cartItem.product!.branchProduct!.variations;
                              } else {
                                variationList = cartItem.product!.variations;
                              }

                              String variationText = '';
                              String addonsName = '';
                              if (cartItem.variation != null &&
                                  cartItem.variation!.isNotEmpty) {
                                cartItem.addOnIds?.forEach((addOn) {
                                  addonsName =
                                      '$addonsName${addOn.name} (${addOn.quantity}), ';
                                });
                                if (addonsName.isNotEmpty) {
                                  addonsName = addonsName.substring(
                                      0, addonsName.length - 2);
                                }
                              }

                              if (variationList != null &&
                                  cartItem.variations!.isNotEmpty) {
                                for (int index = 0;
                                    index < cartItem.variations!.length;
                                    index++) {
                                  if (cartItem.variations![index]
                                      .contains(true)) {
                                    variationText +=
                                        '${variationText.isNotEmpty ? ', ' : ''}${cartItem.product!.variations![index].name} (';
                                    for (int i = 0;
                                        i < cartItem.variations![index].length;
                                        i++) {
                                      if (cartItem.variations![index][i]) {
                                        variationText +=
                                            '${variationText.endsWith('(') ? '' : ', '}${variationList[index].variationValues?[i].level} - ${PriceConverter.convertPrice(variationList[index].variationValues?[i].optionPrice ?? 0)}';
                                      }
                                    }
                                    variationText += ')';
                                  }
                                }
                              }

// thêm
                              late Details details;
                              int a = 0;
                              if (orderController
                                      .currentOrderDetails?.details !=
                                  null) {
                                details = orderController
                                    .currentOrderDetails!.details![index];
                              }

                              Details? orderDetails = orderController
                                  .currentOrderDetails?.details?[index];

                              List<AddOns> addons =
                                  details.productDetails?.addOns ?? [];

                              List<int> addQty = details.addOnQtys ?? [];
                              List<int> ids = details.addOnIds ?? [];
                              double addOnsPrice = 0;
                              if (ids.length == details.addOnPrices?.length &&
                                  ids.length == details.addOnQtys?.length) {
                                for (int i = 0; i < ids.length; i++) {
                                  addOnsPrice = addOnsPrice +
                                      (details.addOnPrices![i] *
                                          details.addOnQtys![i]);
                                }
                              }

                              try {
                                for (AddOns addOn in addons) {
                                  if (ids.contains(addOn.id)) {
                                    addonsName = addonsName +
                                        ('${addOn.name} (${(addQty[a])}), ');
                                    a++;
                                  }
                                }
                              } catch (e) {
                                debugPrint('order details view -$e');
                              }

                              if (addonsName.isNotEmpty) {
                                addonsName = addonsName.substring(
                                    0, addonsName.length - 2);
                              }

                              if (orderDetails != null &&
                                  orderDetails.variations != null &&
                                  orderDetails.variations!.isNotEmpty) {
                                for (Variation variation
                                    in orderDetails.variations!) {
                                  variationText +=
                                      '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                                  for (VariationValue value
                                      in variation.variationValues!) {
                                    variationText +=
                                        '${variationText.endsWith('(') ? '' : ', '}${value.level}';
                                  }
                                  variationText += ')';
                                }
                              } else if (orderDetails != null &&
                                  orderDetails.oldVariations != null &&
                                  orderDetails.oldVariations!.isNotEmpty) {
                                List<String> variationTypes =
                                    orderDetails.oldVariations![0].type != null
                                        ? orderDetails.oldVariations![0].type!
                                            .split('-')
                                        : [];

                                if (variationTypes.length ==
                                    orderDetails.productDetails?.choiceOptions
                                        ?.length) {
                                  int index = 0;
                                  orderDetails.productDetails?.choiceOptions
                                      ?.forEach((choice) {
                                    variationText =
                                        '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
                                    index = index + 1;
                                  });
                                } else {
                                  variationText =
                                      orderDetails.oldVariations?[0].type ?? '';
                                }
                              }

                              return InkWell(
                                onTap: () => DialogHelper.openDialog(
                                  context,
                                  ProductBottomSheet(
                                    product: cartItem.product!,
                                    cart: cartItem,
                                    cartIndex: index,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${cartItem.product!.name ?? ''} ${variationText.isNotEmpty ? '($variationText)' : ''}',
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .color!,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraSmall,
                                                ),
                                                Text(
                                                  PriceConverter.convertPrice(
                                                      cartItem.product?.price ??
                                                          0),
                                                  style: robotoRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraSmall,
                                                ),
                                                if (addonsName.isNotEmpty)
                                                  Text(
                                                      '${'addons'.tr}: $addonsName',
                                                      style: robotoRegular
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      )),
                                              ],
                                            )),
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Text(
                                            '${cartItem.quantity}',
                                            textAlign: TextAlign.center,
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color!),
                                          ),
                                        )),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Text(
                                                PriceConverter.convertPrice(
                                                  cartItem.price! *
                                                      cartItem.quantity!,
                                                ),
                                                textAlign: TextAlign.end,
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .color!),
                                                maxLines: 1,
                                              ),
                                            )),
                                        Expanded(
                                            child: IconButton(
                                          onPressed: () {
                                            cartController
                                                .removeFromCart(index);
                                            showCustomSnackBar(
                                                'cart_item_delete_successfully'
                                                    .tr,
                                                isError: false,
                                                isToast: true);
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                          alignment: Alignment.topRight,
                                          padding: EdgeInsets.zero,
                                          iconSize: Dimensions.paddingSizeLarge,
                                        )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.paddingSizeSmall,
                                    ),
                                    Builder(builder: (context) {
                                      bool render = false;
                                      render = cartList.isNotEmpty &&
                                          cartList.length == index + 1;
                                      return !render
                                          ? Column(
                                              children: [
                                                CustomDivider(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall,
                                                ),
                                              ],
                                            )
                                          : ResponsiveHelper.isSmallTab()
                                              ? _calculationView(
                                                  context,
                                                  itemPrice,
                                                  discount,
                                                  tax,
                                                  addOns,
                                                  orderController,
                                                  total,
                                                )
                                              : const SizedBox();
                                    }),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Column(children: [
                        if (!ResponsiveHelper.isSmallTab())
                          _calculationView(
                            context,
                            itemPrice,
                            discount,
                            tax,
                            addOns,
                            orderController,
                            total,
                          ),
                        Row(
                          children: [
                            if (cartController.cartList.isNotEmpty)
                              SizedBox(
                                width: Dimensions.paddingSizeDefault,
                              ),
                            Expanded(
                              child: CustomButton(
                                  height:
                                      ResponsiveHelper.isSmallTab() ? 40 : 50,
                                  transparent: true,
                                  buttonText: "Thêm sản phẩm",
                                  onPressed: () {
                                    Get.to(() => OderListProducts());
                                  }),
                            ),
                            SizedBox(
                              width: Dimensions.paddingSizeDefault,
                            ),
                            Expanded(
                              child: CustomButton(
                                height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                                buttonText: 'place_order'.tr,
                                onPressed: () {
                                  if (splashController.getTableId() == -1) {
                                    showCustomSnackBar(
                                        'please_input_table_number'.tr);
                                  } else if (cartController.peopleNumber ==
                                      null) {
                                    showCustomSnackBar(
                                        'please_enter_people_number'.tr);
                                  } else if (cartController.cartList.isEmpty) {
                                    showCustomSnackBar(
                                        'please_add_food_to_order'.tr);
                                  } else {
                                    List<Cart> carts = [];
                                    for (int index = 0;
                                        index < cartController.cartList.length;
                                        index++) {
                                      CartModel cart =
                                          cartController.cartList[index];
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
                                            i <
                                                cart.product!.variations!
                                                    .length;
                                            i++) {
                                          if (cart.variations![i]
                                              .contains(true)) {
                                            variations.add(OrderVariation(
                                              name: cart
                                                  .product!.variations![i].name,
                                              values: OrderVariationValue(
                                                  label: []),
                                            ));
                                            if (cart.product!.variations![i]
                                                    .variationValues !=
                                                null) {
                                              for (int j = 0;
                                                  j <
                                                      cart
                                                          .product!
                                                          .variations![i]
                                                          .variationValues!
                                                          .length;
                                                  j++) {
                                                if (cart.variations![i][j]) {
                                                  variations[
                                                          variations.length - 1]
                                                      .values
                                                      ?.label
                                                      ?.add(cart
                                                              .product!
                                                              .variations![i]
                                                              .variationValues?[
                                                                  j]
                                                              .level ??
                                                          '');
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                      carts.add(Cart(
                                        cart.product!.id!.toString(),
                                        cart.discountedPrice.toString(),
                                        '',
                                        variations,
                                        cart.discountAmount!,
                                        cart.quantity!,
                                        cart.taxAmount!,
                                        addOnIdList,
                                        addOnQtyList,
                                      ));
                                    }

                                    PlaceOrderBody placeOrderBody =
                                        PlaceOrderBody(
                                      carts,
                                      total,
                                      Get.find<OrderController>()
                                          .selectedMethod,
                                      Get.find<OrderController>().orderNote ??
                                          '',
                                      'now',
                                      DateFormat('yyyy-MM-dd').format(dateTime),
                                      splashController.getTableId(),
                                      cartController.peopleNumber,
                                      '${splashController.getBranchId()}',
                                      '',
                                      Get.find<OrderController>()
                                              .getOrderSuccessModel()
                                              ?.first
                                              .branchTableToken ??
                                          '',
                                    );

                                    Get.find<OrderController>()
                                        .setPlaceOrderBody = placeOrderBody;

                                    Get.to(
                                      const PaymentUpdateScreen(),
                                      transition: Transition.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 300),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ])
                    ]),
                  )
                : NoDataScreen(text: 'no_order_available'.tr);
      });
    });
  }

  Column _calculationView(
    BuildContext context,
    double itemPrice,
    double discount,
    double tax,
    double addOns,
    OrderController orderController,
    double total,
  ) {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GetBuilder<OrderController>(builder: (orderController) {
              return Flexible(
                child: Text.rich(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    children: orderController.orderNote != null
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
                              text: ' ${orderController.orderNote!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                          ]
                        : [
                            TextSpan(
                              text: 'add_spacial_note_here'.tr,
                              style: robotoRegular.copyWith(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ],
                  ),
                ),
              );
            }),
            InkWell(
              onTap: () {
                DialogHelper.openDialog(
                    context,
                    OrderNoteView(
                      note: Get.find<OrderController>().orderNote,
                      onChange: (note) {
                        Get.find<OrderController>().updateOrderNote(
                          note.trim().isEmpty ? null : note,
                        );
                      },
                    ));
              },
              child: Image.asset(
                Images.editIcon,
                color: Theme.of(context).secondaryHeaderColor,
                width: Dimensions.paddingSizeExtraLarge,
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.isSmallTab()
              ? Dimensions.paddingSizeSmall
              : Dimensions.paddingSizeDefault,
        ),
        CustomDivider(
          color: Theme.of(context).disabledColor,
        ),
        SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        PricesWithType(
          type: 'items_price'.tr,
          amount: PriceConverter.convertPrice(itemPrice),
        ),
        PricesWithType(
            type: 'discount'.tr,
            amount: '- ${PriceConverter.convertPrice(discount)}'),
        PricesWithType(
            type: 'vat_tax'.tr,
            amount: '+ ${PriceConverter.convertPrice(tax)}'),
        PricesWithType(
            type: 'addons'.tr,
            amount: '+ ${PriceConverter.convertPrice(addOns)}'),
        PricesWithType(
            type: 'previous_due'.tr,
            amount:
                '+ ${PriceConverter.convertPrice(orderController.previousDueAmount())}'),
        PricesWithType(
            type: 'total'.tr,
            amount: PriceConverter.convertPrice(total),
            isTotal: true),
        SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
      ],
    );
  }
}

class PricesWithType extends StatelessWidget {
  final String type;
  final String amount;
  final bool isTotal;
  const PricesWithType(
      {Key? key,
      required this.type,
      required this.amount,
      this.isTotal = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: ResponsiveHelper.isSmallTab() ? 4 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: isTotal
                ? robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  )
                : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          Text(amount,
              style: isTotal
                  ? robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    )
                  : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ],
      ),
    );
  }
}



    
    
    
    
    
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: const CustomAppBar(onBackPressed: null, showCart: false),
//       body: CartDetailsUpdate(
//         showButton: !widget.isOrderDetails,
//         // orderId: oderId,
//       ),
//     );
//   }
// }
