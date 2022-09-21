import 'dart:convert';

import 'package:pharmacy_delivery/class/Member.dart';
import 'package:pharmacy_delivery/utils/user_secure_storage.dart';
import '../utils/URLRequest.dart';
import '../class/Drugstore.dart';
import 'package:http/http.dart' as http;

class MemberApi {
  static doLogin(Member member) async {
    final jsonMember = member.toJsonLogin();
   // print(jsonEncode(jsonMember));
    final response = await http.post(Uri.parse(URLRequest.URL_member_login),
        body: jsonEncode(jsonMember),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("doLoginMember : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {
      dynamic member = map["result"];

      //print(member.toString());
      //print(Member.fromJson(member).toString());
      Member m = Member.fromJson(member);
      UserSecureStorage.setMember(m);
      return 1;
    } else {
      return 0;
      throw Exception();
    }
  }

  static doRegister(Member member) async {
    final jsonMember = member.toJson();
     //print(jsonEncode(jsonMember));
    final response = await http.post(Uri.parse(URLRequest.URL_member_register),
        body: jsonEncode(jsonMember),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("doRegister : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {

      return 1;
    } else {
      return 0;
      throw Exception();
    }
  }

  static Future<List<String>> allUsername() async {
    final response = await http.post(Uri.parse(URLRequest.URL_list_member));
   // print(response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> members = map["result"];

      final List<String> list = await [];
      for (dynamic m in members) {
        Member mb = Member.fromJson(m);
        list.add(mb.MemberUsername!);
      }
      return list;

    } else {
      throw Exception();
    }
  }


/*
  static fetchMember(Member member) async {
    final jsonMember = member.toJsonLogin();
    //print(jsonEncode(jsonMember));
    final response = await http.post(Uri.parse(URLRequest.URL_member_getprofile),
        body: jsonEncode(jsonMember),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("fetchMember : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      dynamic member = map["result"];

      //print(member.toString());

      //print(Member.fromJson(member).toString());
      return Member.fromJson(member);
    } else {
      throw Exception();
    }
  }
  */

}
