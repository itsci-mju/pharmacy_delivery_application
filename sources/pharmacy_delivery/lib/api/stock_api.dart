import 'dart:convert';
import 'package:http/http.dart' as http;
import '../class/Stock.dart';
import '../utils/URLRequest.dart';
import '../utils/storage_image.dart';

class StockApi{
  static Future<List<Stock>> searchStock( String drugstoreId, String query) async {
    final response = await http.post(Uri.parse(URLRequest.URL_stock_list),
        body: jsonEncode({"drugstoreID": drugstoreId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("searchStock : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> stocks = map["result"];

      List<Stock> listStock = [];
      if (stocks != []) {
        for (dynamic s in stocks) {
          Stock st = Stock.fromJson(s);
          if ((st.medicine!.medName!.toLowerCase().contains(query.toLowerCase()) ||
              st.medicine!.medId!.toLowerCase().contains(query.toLowerCase()) ||
              st.medicine!.medDetail!.toLowerCase().contains(query.toLowerCase()))) {
            //String img = await StorageImage().downloadeURL("medicine", st.medicine!.medImg?? 'no_img.jpg');
            //st.medicine!.medImg = img;
            listStock.add(st);
          }
        }
      }


      return listStock;
    } else {
      throw Exception();
    }
  }

  static Future<Stock> fetchStock( String drugstoreId, String medId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_stock_get),
        body: jsonEncode({"drugstoreID": drugstoreId, "medId":medId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("fetchStock : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      dynamic s = map["result"];

      return Stock.fromJson(s);
    } else {
      throw Exception();
    }
  }

  /*
  static Future<List<Stock>> fetchStock( String drugstoreId,List<Medicine> listmedicine) async {
    final response = await http.post(Uri.parse(URLRequest.URL_stock_list),
        body: jsonEncode({"drugstoreID": drugstoreId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("fetchStock : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> stocks = map["result"];

      //print(stocks.toString());

      //return reviews.map((e) => Review.fromJson(e)).toList();

      List<Stock> listStock = [];
      if(stocks !=[]){
        for (dynamic s in stocks) {
          Stock st = Stock.fromJson(s);
          for(Medicine m in listmedicine) {
            if (st.medicine!.medId == m.medId) {
              listStock.add(st);
            }
          }
        }
      }

      return listStock;
    } else {
      throw Exception();
    }
  }
  */

}