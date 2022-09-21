import 'dart:convert';


import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/class/Pharmacist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/Member.dart';
import '../class/Orders.dart';
import '../class/Stock.dart';

class UserSecureStorage{

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

 //------------- Member --------------------//
  static Future setMember(Member member) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('member',jsonEncode(member.toJson()));
  }

  static Future getMember() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Member m = Member();
    final value= await prefs.getString('member') ;
    try {
      m =Member.fromJson(jsonDecode(value!));
      return m;
    }catch(Exception){
      return Member();
    }
  }

  //------------- Pharmacist --------------------//
  static Future setPharmacist(Pharmacist pharmacist) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pharmacist',jsonEncode(pharmacist.toJson()));
  }

  static Future<Pharmacist> getPharmacist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Pharmacist p = Pharmacist();
    final value= await prefs.getString('pharmacist') ;
    try {
      p = Pharmacist.fromJson(jsonDecode(value!));
      return p;
    }catch(Exception){
      return Pharmacist();
    }
  }


}

/*
 static final _storage = FlutterSession();

 //------------- Member --------------------//
  static Future setMember(Member member) async {
    await _storage.set('member',member);
  }

  static Future getMember() async {
    Member m = Member();
    final value= await _storage.get('member') ;
    try {
      m =Member.fromJson(value);
      return m;
    }catch(Exception){
      return Member();
    }
  }

  //------------- Pharmacist --------------------//
  static Future setPharmacist(Pharmacist pharmacist) async {
    await _storage.set('pharmacist',pharmacist);
  }

  static Future<Pharmacist> getPharmacist() async {
    Pharmacist p = Pharmacist();
    final value= await _storage.get('pharmacist') ;
    try {
      p = Pharmacist.fromJson(value);
      return p;
    }catch(Exception){
      return Pharmacist();
    }
  }
/*
  //------------- ListCart(List Stock) --------------------//
  static Future setCart(List<Stock> cart) async {
    //cart.map((e) => e.toJson()).toList() ;
    print("jsonEncode(cart)");
    print(jsonEncode(cart.map((e) => e.toJson()).toList()));
    await _storage.set('cart',jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  static Future getCart() async {
    List<Stock> c = [];
    final value= await _storage.get('cart') ;
    try {
      c = value.map((e) => Stock.fromJson(e)).toList() ;
      return c;
    }catch(Exception){
      return c;
    }
  }
*/
 */
