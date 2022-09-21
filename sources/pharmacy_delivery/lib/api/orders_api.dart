import 'dart:convert';

import 'package:http/http.dart' as http;

import '../class/Address.dart';
import '../class/Advice.dart';
import '../class/Orders.dart';
import '../utils/URLRequest.dart';
class OrdersApi{
  static Future<List<Advice>> listOrders_status(String status,String MemberUsername) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_list_status),
        body: jsonEncode({"status":status, "MemberUsername":MemberUsername}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("listOrders_status : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      dynamic result = map["result"];

      List<Advice> listAdvice= [];
      for (dynamic a in result) {
        Advice advice = Advice.fromJson(a);
        listAdvice.add(advice);
      }
      return listAdvice;
    } else {
      throw Exception();
    }
  }

  static Future<Orders> fetchOrder(String orderId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_get),
        body: jsonEncode({"orderId":orderId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("fetchOrder : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      dynamic result = map["result"];

      Orders orders = Orders.fromJson(result);
      return orders;
    } else {
      throw Exception();
    }
  }


  static addOrders(int sumQuantity, double subtotalPrice, double shippingCost, Address? address ) async {

    final response = await http.post(Uri.parse(URLRequest.URL_orders_add),
        body: jsonEncode({"sumQuantity":sumQuantity,"subtotalPrice":subtotalPrice,"shippingCost":shippingCost, "address":jsonEncode(address!=null? address.toJson() : null) }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("addOrders : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {
      dynamic result = map["result"];
      Orders orders = Orders.fromJson(result);
      return orders;
    } else {
      return 0;
    }
  }

  static pCancelOrder(String orderId,Advice advice) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_pCancel),
        body: jsonEncode({"orderId":orderId, "advice":jsonEncode(advice.toJson())}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("cancelOrder : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map["result"] != "0") {
      return 1;
    } else {
      return 0;
      throw Exception();
    }
  }

  static confirmOrder(String orderId, String couponName, double totalPrice) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_confirm),
        body: jsonEncode({"orderId":orderId, "couponName":couponName, "totalPrice":totalPrice }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("confirmOrder : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map["result"] != "0") {
      return 1;
    } else {
      return 0;
      throw Exception();
    }
  }

  static cancelOrder_member(Orders orders,String drugstoreID) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_cancel_member),
        body: jsonEncode({"orders":jsonEncode(orders.toJson()), "drugstoreID":drugstoreID }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("cancelOrder_member : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map["result"] != "0") {
      return 1;
    } else {
      return 0;
      throw Exception();
    }
  }


  static payOrders(Advice advice,String receiptId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_pay),
        body: jsonEncode({"advice":jsonEncode(advice.toJson()), "receiptId":receiptId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("payOrders : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {
      dynamic result = map["result"];
      Advice advice = Advice.fromJson(result);
      return advice;
    } else {
      return 0;
    }
  }

/*------------------------- pharmacist -----------------*/
  static Future<List<Advice>> phar_listOrders_status(String status,String pharmacistID) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_list_status_pharmacist),
        body: jsonEncode({"status":status, "pharmacistID":pharmacistID}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("phar_listOrders_status : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      dynamic result = map["result"];

      List<Advice> listAdvice= [];
      for (dynamic a in result) {
        Advice advice = Advice.fromJson(a);
        listAdvice.add(advice);
      }
      return listAdvice;
    } else {
      throw Exception();
    }
  }

  static successStoreOrder(String orderId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_success_store),
        body: jsonEncode({"orderId":orderId }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("successStoreOrder : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map["result"] != "0") {
      return 1;
    } else {
      return 0;
      throw Exception();
    }
  }

  static addShipping(String orderId, String shippingDate, String shippingCompany, String trackingNumber) async {
    final response = await http.post(Uri.parse(URLRequest.URL_orders_add_shipping),
        body: jsonEncode({"orderId":orderId, "shippingDate":shippingDate, "shippingCompany":shippingCompany, "trackingNumber":trackingNumber }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("addShipping : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map["result"] != "0") {
      return 1;
    } else {
      return 0;
      throw Exception();
    }
  }


}