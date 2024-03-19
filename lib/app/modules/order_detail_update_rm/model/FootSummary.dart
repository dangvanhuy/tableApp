import 'package:citgroupvn_efood_table/app/util/number_format_utils.dart';
import 'package:citgroupvn_efood_table/data/model/response/oder_product_model.dart';
import 'package:citgroupvn_efood_table/data/model/response/order_details_model.dart';

class FootSummary {
  String originTotal;
  String discount;
  String vat;
  String extra;
  String finalTotal;
  String payed;
  String change;
  FootSummary(
      {this.originTotal = '',
      this.discount = '',
      this.vat = '',
      this.extra = '',
      this.finalTotal = '',
      this.change = '',
      this.payed = ''});
  factory FootSummary.fromOderDetail({required OrderDetails orderDetail}) {
    String originTotal = NumberFormatUtils.formatDong(
        orderDetail.order!.orderAmount!.toString());
    String discount =  NumberFormatUtils.formatDong(
        orderDetail.order!.orderAmount!.toString());
    String vat =  NumberFormatUtils.formatDong(
        orderDetail.order!.orderAmount!.toString());;
    String extra = NumberFormatUtils.formatDong(
        orderDetail.order!.orderAmount!.toString());
    String finalTotal = NumberFormatUtils.formatDong(
        orderDetail.order!.orderAmount!.toString());
    String payed = NumberFormatUtils.formatDong(
        orderDetail.order!.orderAmount!.toString());;
    String change = NumberFormatUtils.formatDong(
        orderDetail.order!.orderAmount!.toString());
    return FootSummary(originTotal: originTotal,
    discount: discount,
    vat: vat,
    extra: extra,
    finalTotal: finalTotal,
    payed: payed,
    change: change
    );

   
  }
  String calculateFinalSummary(){
      return "120000.0";
    }
}
