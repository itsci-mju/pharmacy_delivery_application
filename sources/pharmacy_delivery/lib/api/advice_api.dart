 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacy_delivery/class/Advice.dart';
import '../class/Address.dart';
import '../class/Orders.dart';
import '../utils/URLRequest.dart';

class AdviceApi{
  static addAdvice(String MemberUsername, String pharmacistID, String addressId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_advice_add),
        body: jsonEncode({"MemberUsername":MemberUsername,"pharmacistID":pharmacistID, "addressId":addressId }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("addAdvice : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {
      dynamic result = map["result"];

      Advice advice= Advice.fromJson(result);
      return advice;
    } else {
      return 0;
    }
  }

  static updateOrderId(Advice advice, Orders orders) async {
    final response = await http.post(Uri.parse(URLRequest.URL_advice_update_orderId),
        body: jsonEncode({"advice":jsonEncode(advice.toJson()), "orders": jsonEncode(orders.toJson()),}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("updateOrderId : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }
  static endAdvice(Advice advice) async {
    final response = await http.post(Uri.parse(URLRequest.URL_advice_end),
        body: jsonEncode({"advice":jsonEncode(advice.toJson())}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("endAdvice : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  static getAdvice( String adviceId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_advice_get),
        body: jsonEncode({ "adviceId":adviceId }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("getAdvice : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {
      dynamic result = map["result"];

      Advice advice= Advice.fromJson(result);
      return advice;
    } else {
      return 0;
    }
  }

  /*
  static endAdvice_member(String adviceId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_advice_end_member),
        body: jsonEncode({"adviceId":adviceId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("endAdvice_member : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }
   */

}