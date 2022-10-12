import 'dart:convert';

import '../utils/URLRequest.dart';
import '../class/Drugstore.dart';
import 'package:http/http.dart' as http;

import '../class/Member.dart';
import '../class/Review.dart';

class ReviewApi{
  static Future<List<Review>> fetchReview(Drugstore drugstore) async {
    final jsonDrugstore = drugstore.toJsonDrugstoreID();
    final response = await http.post(Uri.parse(URLRequest.URL_list_review),
        body: jsonEncode(jsonDrugstore),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("fetchReview : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> reviews = map["result"];

      //print(reviews.toString());

      //return reviews.map((e) => Review.fromJson(e)).toList();

      List<Review> listReview = [];
      if(reviews !=[]){
        for (dynamic r in reviews) {
          listReview.add(Review.fromJson(r));
        }
      }

      return listReview;
    } else {
      throw Exception();
    }
  }

  static Future<double> avg_score_Review(Drugstore drugstore) async {
    final jsonDrugstore = drugstore.toJsonDrugstoreID();
    final response = await http.post(Uri.parse(URLRequest.URL_list_review),
        body: jsonEncode(jsonDrugstore),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("sum_score_Review : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> reviews = map["result"];

      double sumScore = 0.0;

      if(reviews !=[]){
        for (dynamic r in reviews) {
          sumScore+= Review.fromJson(r).score! ;
        }
      }


      return sumScore/reviews.length;
    } else {
      throw Exception();
    }
  }

  static Future<List<Member>> fetchMember_Review(List<Review> listreview) async {
    List<Member>  listMember =[];

    for(Review review in listreview){
      //final jsonReview= review.toJson();
      final response = await http.post(Uri.parse(URLRequest.URL_review_getmember),
          body: jsonEncode({"reviewId": review.reviewId}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print("fetchMember_Review : "+response.body.toString());

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);

        dynamic member = map["result"];

        Member m = Member.fromJson(member);
        listMember.add(m);
      } else {
        throw Exception();
      }
    }

    return listMember;

  }

  static addReview (String orderId, Review review) async {
    final response = await http.post(Uri.parse(URLRequest.URL_review_add),
        body: jsonEncode({"orderId":orderId, "review": jsonEncode(review.toJson()),}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("addReview : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }


}