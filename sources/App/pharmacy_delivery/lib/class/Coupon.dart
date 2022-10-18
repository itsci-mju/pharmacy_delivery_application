import 'Date.dart';
import 'Drugstore.dart';

class Coupon {
  String? couponName;
  double? minimumPrice;
  double? discount;
  int? couponQty;
  DateTime? startDate;
  DateTime? endDate;
  Drugstore? drugstore;

  Coupon(
      { this.couponName,
       this.minimumPrice,
       this.discount,
       this.couponQty,
       this.startDate,
       this.endDate,
       this.drugstore});

  factory Coupon.fromJson(Map<String, dynamic> json) {
    //print(json["startDate"]['year'].toString()+"-"+json["startDate"]['month'].toString()+"-"+json["startDate"]['dayOfMonth'].toString()+" "+json["startDate"]['hourOfDay'].toString()+":"+json["startDate"]['minute'].toString()+":"+json["startDate"]['second'].toString());
    return Coupon(
      couponName: json["couponName"] == null ? null :json["couponName"] ,
      minimumPrice: json["minimumPrice"]== null ? null :json["minimumPrice"] ,
      discount: json["discount"]== null ? null :json["discount"] ,
      couponQty: json["couponQty"]== null ? null :json["couponQty"] ,
     startDate: json["startDate"]== null ? null : Date.fromJson(json["startDate"]).toDateTime(),
      endDate: json["endDate"]== null ? null :Date.fromJson(json["endDate"]).toDateTime(),
      drugstore:json["drugstore"]== null ? null : Drugstore.fromJson(json["drugstore"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "couponName": this.couponName == null ? null : this.couponName ,
      "minimumPrice": this.minimumPrice== null ? null : this.minimumPrice ,
      "discount": this.discount== null ? null : this.discount ,
      "couponQty": this.couponQty== null ? null : this.couponQty ,
      "startDate": this.startDate == null ? null : Date.toDate(this.startDate!).toJson() ,
      "endDate": this.endDate== null ? null : Date.toDate(this.endDate!).toJson() ,
      //"endDate": this.endDate.toIso8601String(),
      "drugstore": this.drugstore== null ? null : this.drugstore?.toJson(),
    };
  }

//

}
/*
class Date {
  int year;
  int month;
  int dayOfMonth;
  int hourOfDay;
  int minute;
  int second;

  Date(
      {required this.year,
      required this.month,
      required this.dayOfMonth,
      required this.hourOfDay,
      required this.minute,
      required this.second});

  factory Date.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return Date(
      year: json["year"],
      month: json["month"],
      dayOfMonth: json["dayOfMonth"],
      hourOfDay:json["hourOfDay"],
      minute: json["minute"],
      second: json["second"],
    );
  }

//

}

 */
