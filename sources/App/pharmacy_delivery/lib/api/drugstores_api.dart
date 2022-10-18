import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/URLRequest.dart';
import '../class/Drugstore.dart';
import 'package:http/http.dart' as http;

class DrugstoreApi {
  static Future<List<Drugstore>> searchDrugstore(String query) async {
    final response = await http.post(Uri.parse(URLRequest.URL_list_drugstore));
    print("searchDrugstore : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> drugstores = map["result"];

      /*
      return drugstores.map((e) => Drugstore.fromJson(e)).where((Drugstore) {
        return Drugstore.drugstoreName.contains(query) ||
            Drugstore.drugstoreAddress.contains(query);

      }).toList();
  */
      final List<Drugstore> listDrugstore = [];
      for (dynamic d in drugstores) {
        Drugstore ds = Drugstore.fromJson(d);
        if ((ds.drugstoreName!.toLowerCase().contains(query.toLowerCase()) ||
            ds.drugstoreAddress!.toLowerCase().contains(query.toLowerCase())) ) { //&& query!=""
          listDrugstore.add(ds);
        }
      }

      return listDrugstore;
    } else {
      throw Exception();
    }
  }

/*
  static Future<List<Drugstore>> fetchAllDrugstore() async {
    final response = await http.post(Uri.parse(URLRequest.URL_list_drugstore));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> drugstores = map["result"];
      print("fetchAllDrugstore : "+drugstores.toString());

      return drugstores.map((e) => Drugstore.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }
*/

}
