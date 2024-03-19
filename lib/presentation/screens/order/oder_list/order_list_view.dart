import 'package:citgroupvn_efood_table/app/core/constants/color_constants.dart';
import 'package:citgroupvn_efood_table/app/util/icon_utils.dart';
import 'package:citgroupvn_efood_table/data/model/response/oders_list_details.dart';
import 'package:citgroupvn_efood_table/presentation/controller/oder/order_controller_rm.dart';
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
    Get.find<OrderControllerRM>().getOrderList().then((value) {
      setState(() {});
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
      child: GetBuilder<OrderControllerRM>(builder: (orderController) {
        return orderController.isLoading.value
            ? Center(child: CustomLoader(color: Theme.of(context).primaryColor))
            : orderController.orderList.isEmpty
                ? NoDataScreen(text: 'you_hove_no_order'.tr)
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListView.builder(
                      itemCount: orderController.orderList.value.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => const OrdersUpdateScreen(
                                isOrderDetails: true,
                              ),
                            );
                          },
                          child: _cardItem(
                              order: orderController.orderList.value[index]),
                        );
                      },
                    ),
                  );
      }),
    );
  }

  Card _cardItem({required Order order}) {
    return Card(
      elevation: 0.2,
      color: ColorConstant.backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Đơn hàng: #${order.id}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  IconsUtils.table,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
                Text(
                  "Số bàn: ${order.tableId}",
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
                const SizedBox(width: 5),
                Text(
                  "Số người:  ${order.numberOfPeople}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Tổng số tiền:${PriceConverter.convertPrice(order.orderAmount!.toDouble())}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
