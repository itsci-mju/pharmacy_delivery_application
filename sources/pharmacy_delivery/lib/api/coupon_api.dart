import 'dart:convert';

import '../class/Coupon.dart';
import '../class/Coupon.dart';
import '../utils/URLRequest.dart';
import '../class/Coupon.dart';
import '../class/Drugstore.dart';
import 'package:http/http.dart' as http;

class CouponApi{
  static   Future<List<Coupon>> listCoupon(Drugstore drugstore) async {
    final jsonDrugstore = drugstore.toJsonDrugstoreID();
    final response = await http.post(Uri.parse(URLRequest.URL_list_coupon),
        body: jsonEncode(jsonDrugstore),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });

    print("fetchCoupon : "+response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> coupons = map["result"];
      //print(coupons.toString());
      //return coupons.map((e) => Coupon.fromJson(e)).toList();

      List<Coupon> listCoupon = [];
      for (dynamic c in coupons) {
        listCoupon.add(Coupon.fromJson(c));
      }

      //print(listCoupon);
      return listCoupon;
    } else {
      throw Exception();
    }
  }

  static  Future checkCoupon(String drugstoreID, String  couponName) async {
    final response = await http.post(Uri.parse(URLRequest.URL_coupon_check),
        body: jsonEncode( {"drugstoreID": drugstoreID, "couponName":couponName}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });

    print("checkCoupon : "+response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      dynamic coupon = map["result"];
      //print(coupons.toString());
      //return coupons.map((e) => Coupon.fromJson(e)).toList();

      Coupon c ;
      if(coupon!=null){
        c = Coupon.fromJson(coupon);
        return c;
      }



    } else {
      throw Exception();
    }
  }

  static   Future<double> minCoupon(String drugstoreID) async {
    final response = await http.post(Uri.parse(URLRequest.URL_coupon_min),
        body: jsonEncode({"drugstoreID": drugstoreID}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });

        print("minCoupon : "+response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      dynamic min_coupon = map["result"];

      return min_coupon;
    } else {
      throw Exception();
    }
  }


}