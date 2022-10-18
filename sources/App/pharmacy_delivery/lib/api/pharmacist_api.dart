import 'dart:convert';

import 'package:pharmacy_delivery/class/Pharmacist.dart';
import 'package:pharmacy_delivery/utils/user_secure_storage.dart';

import '../utils/URLRequest.dart';
import 'package:http/http.dart' as http;

import '../class/Drugstore.dart';

class PharmacistApi {
  static doLogin(Pharmacist pharmacist) async {
    final jsonPharmacist = pharmacist.toJsonLogin();
    //print(jsonEncode(jsonPharmacist));
    final response = await http.post(Uri.parse(URLRequest.URL_pharmacist_login),
        body: jsonEncode(jsonPharmacist),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("doLoginPharmacist : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {
      dynamic pharmacist = map["result"];

      // print(member.toString());
      // print(Pharmacist.fromJson(member).toString());
      Pharmacist p = Pharmacist.fromJson(pharmacist);
      UserSecureStorage.setPharmacist(p);
      return 1;
    } else {
      return 0;
    }
  }

  static doLogout(Pharmacist pharmacist) async {
    final jsonPharmacist = pharmacist.toJsonLogin();
    //print(jsonEncode(jsonPharmacist));
    final response = await http.post(Uri.parse(URLRequest.URL_pharmacist_logout),
        body: jsonEncode(jsonPharmacist),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("doLogoutPharmacist : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<List<Pharmacist>> checkPharmacistOnline(String drugstoreId) async {
    //print(jsonEncode(jsonPharmacist));
    final response = await http.post(Uri.parse(URLRequest.URL_pharmacist_checkonline),
        body: jsonEncode({"drugstoreID":drugstoreId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("checkPharmacistOnline : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> pharmacist = map["result"];

      List<Pharmacist> listPharmacist = [];
      for (dynamic p in pharmacist) {
        listPharmacist.add(Pharmacist.fromJson(p));
      }

      //print(listCoupon);
      return listPharmacist;
    } else {
      throw Exception();
    }
  }


/*
  static fetchPharmacist(Pharmacist pharmacist) async {
    final jsonPharmacist = pharmacist.toJsonLogin();
    print(jsonEncode(jsonPharmacist));
    final response = await http.post(Uri.parse(URLRequest.URL_pharmacist_getprofile),
        body: jsonEncode(jsonPharmacist),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("fetchPharmacist : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      dynamic member = map["result"];

     // print(member.toString());
     // print(Pharmacist.fromJson(member).toString());
      return Pharmacist.fromJson(member);
    } else {
      throw Exception();
    }
  }
 */

}
