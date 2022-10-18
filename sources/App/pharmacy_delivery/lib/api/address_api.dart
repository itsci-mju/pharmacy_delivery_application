import 'dart:convert';

import '../class/Address.dart';
import 'package:http/http.dart' as http;

import '../utils/URLRequest.dart';
class AddressApi{
  static Future listAddress( String MemberUsername) async {
    final response = await http.post(Uri.parse(URLRequest.URL_address_list),
        body: jsonEncode({"MemberUsername": MemberUsername}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("listAddress : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> address = map["result"];

      if (address != []) {
        List<Address> listAddress = [];
        for (dynamic a in address) {
          Address ad = Address.fromJson(a);
          listAddress.add(ad);
        }
        return listAddress;
      }else{
        return null;
      }


    } else {
      throw Exception();
    }
  }

  static addAddress(Address address) async {
    final response = await http.post(Uri.parse(URLRequest.URL_address_add),
        body: jsonEncode({"address":jsonEncode(address.toJson())}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("addAddress : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  static removeAddress(String addressId , String MemberUsername) async {
    final response = await http.post(Uri.parse(URLRequest.URL_address_remove),
        body: jsonEncode({"addressId": addressId, "MemberUsername": MemberUsername}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("removeAddress : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future fetchAddress( String addressId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_address_get),
        body: jsonEncode({"addressId": addressId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("fetchAddress : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 &&  map["result"]!=0) {
      dynamic a = map["result"];

      return Address.fromJson(a);
    } else {
      return null;
    }
  }

}