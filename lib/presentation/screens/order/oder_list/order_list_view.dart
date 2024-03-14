import 'package:citgroupvn_efood_table/app/core/constants/color_constants.dart';
import 'package:citgroupvn_efood_table/app/util/icon_utils.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/payment.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/widget/oder_update_view.dart';

class OrderListView extends StatefulWidget {
  final bool fromPlaceOrder;

  const OrderListView({
    Key? key,
    this.fromPlaceOrder = false,
  }) : super(key: key);

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  int currentMinute = 0;

  @override
  void initState() {
    // print('order success call');
    // Get.find<OrderController>().getOrderSuccessModel();
    Get.find<OrderController>().setCurrentOrderId = null;

    Get.find<OrderController>().getOrderList().then((List<Order>? list) {
      if (list != null && list.isNotEmpty) {
        Get.find<OrderController>().getCurrentOrder('${list.first.id}').then(
              (value) => Get.find<OrderController>().countDownTimer(),
            );
      } else {
        Get.find<OrderController>().getCurrentOrder(null);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    Get.find<OrderController>().cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isTab(context)
          ? null
          : const CustomAppBar(
              isBackButtonExist: false,
              onBackPressed: null,
              showCart: true,
            ),
      body: !ResponsiveHelper.isTab(context)
          ? _body(context)
          : BodyTemplate(
              body: Flexible(child: _body(context)),
              isOrderDetails: true,
            ),
    );
  }

  Center _body(BuildContext context) {
    return Center(
      child: GetBuilder<OrderController>(builder: (orderController) {
        return orderController.isLoading
            ? Center(child: CustomLoader(color: Theme.of(context).primaryColor))
            : orderController.currentOrderDetails == null &&
                    !orderController.isLoading
                ? NoDataScreen(text: 'you_hove_no_order'.tr)
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListView.builder(
                      itemCount: orderController.orderList!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => const OrdersUpdateScreen(
                                isOrderDetails: true,
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0.2,
                            color: ColorConstant.backgroundColor,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Đơn hàng: #${orderController.orderList![index].id}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        IconsUtils.table,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Số bàn: ${orderController.orderList![index].tableId}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Icon(
                                        IconsUtils.people,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Số người:  ${orderController.orderList![index].numberOfPeople}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Tổng số tiền:${PriceConverter.convertPrice(orderController.orderList![index].orderAmount!.toDouble())}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
      }),
    );
  }
}
