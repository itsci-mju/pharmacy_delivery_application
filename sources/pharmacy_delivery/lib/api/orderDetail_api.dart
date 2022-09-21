import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/class/OrderDetail.dart';

import '../class/Cart.dart';
import '../class/Drugstore.dart';
import '../class/Orders.dart';
import '../utils/URLRequest.dart';

class OrderDetailApi{
  static addOrderDetail(List<Cart> cart, Orders orders, String drugstoreId ) async {
    List<OrderDetail>? listOrderDetail;
    bool test = false;
    for(Cart c in cart) {
      OrderDetail od = OrderDetail(orders: orders,medicine: c.medicine,quantity: c.quantity,sumprice: c.sumprice,note: c.note );
      final response = await http.post(Uri.parse(URLRequest.URL_order_detail_add),
          body: jsonEncode({"orderDetail": jsonEncode(od.toJson()),"drugstoreId":drugstoreId}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print("addOrderDetail : " + response.body.toString());

      Map<String, dynamic> map = json.decode(response.body);

      if (response.statusCode == 200 && map["result"] != "0") {
        final result = map["result"];
        OrderDetail orderDetail = OrderDetail.fromJson(result);
        listOrderDetail?.add(orderDetail);
        test = true;
      } else {
        test = false;
        return 0;
      }
    }

    if(test == true){
      return listOrderDetail;
    }else{
      return 0;
    }
  }

  static Future<List<OrderDetail>> listOrderDetail(String orderId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_order_detail_list),
        body: jsonEncode({"orderId":orderId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("listOrderDetail : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> orderdetails = map["result"];

      final List<OrderDetail> listOrderDetail = [];
      for (dynamic od in orderdetails) {
        listOrderDetail.add(OrderDetail.fromJson(od));
      }

      return listOrderDetail;
    } else {
      throw Exception();
    }
  }




}