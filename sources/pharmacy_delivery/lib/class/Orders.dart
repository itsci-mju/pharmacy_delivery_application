import 'package:intl/intl.dart';

import 'Address.dart';
import 'Coupon.dart';
import 'Date.dart';
import 'Review.dart';

class Orders {
  String? orderId;
  DateTime? orderDate;
  int? sumQuantity;
  double? subtotalPrice;
  double? totalPrice;
  String? orderStatus;
  String? receiptId;
  DateTime? payDate;
  double? shippingCost;
  String? shippingCompany;
  String? trackingNumber;
  DateTime? shippingDate;
  Coupon? coupon;
  Address? address;
  Review? review;

  Orders(
      { this.orderId,
       this.orderDate,
       this.sumQuantity,
       this.subtotalPrice,
       this.totalPrice,
       this.orderStatus,
       this.receiptId,
       this.payDate,
       this.shippingCost,
       this.shippingCompany,
       this.trackingNumber,
       this.shippingDate,
       this.coupon,
       this.address,
       this.review});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      orderId: json["orderId"]== null ? null : json["orderId"],
      orderDate: json["orderDate"] == null ? null :Date.fromJson(json["orderDate"]).toDateTime(),
      sumQuantity: json["sumQuantity"]== null ? null : json["sumQuantity"],
      subtotalPrice: json["subtotalPrice"]== null ? null : json["subtotalPrice"],
      totalPrice: json["totalPrice"]== null ? null : json["totalPrice"],
      orderStatus: json["orderStatus"]== null ? null : json["orderStatus"],
      receiptId: json["receiptId"]== null ? null : json["receiptId"],
      payDate: json["payDate"]== null ? null :  Date.fromJson(json["payDate"]).toDateTime(),
      shippingCost: json["shippingCost"]== null ? null : json["shippingCost"],
      shippingCompany: json["shippingCompany"]== null ? null : json["shippingCompany"],
      trackingNumber: json["trackingNumber"]== null ? null : json["trackingNumber"],
      shippingDate:  json["shippingDate"]== null ? null : Date.fromJson(json["shippingDate"]).toDateTime(),
      coupon: json["coupon"]== null ? null : Coupon.fromJson(json["coupon"]),
      address: json["address"]== null ? null : Address.fromJson(json["address"]),
      review: json["review"]== null ? null : Review.fromJson(json["review"]),
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "orderId": this.orderId == null ? null :  this.orderId,
      "orderDate": this.orderDate == null ? null :  Date.toDate(this.orderDate!).toJson() ,
      "sumQuantity": this.sumQuantity == null ? null : this.sumQuantity,
      "subtotalPrice": this.subtotalPrice == null ? null : this.subtotalPrice,
      "totalPrice": this.totalPrice == null ? null : this.totalPrice,
      "orderStatus": this.orderStatus == null ? null : this.orderStatus,
      "receiptId": this.receiptId == null ? null : this.receiptId,
      "payDate": this.payDate == null ? null :  Date.toDate(this.payDate!).toJson() ,
      "shippingCost": this.shippingCost == null ? null : this.shippingCost,
      "shippingCompany": this.shippingCompany == null ? null : this.shippingCompany,
      "trackingNumber": this.trackingNumber == null ? null : this.trackingNumber,
      "shippingDate": this.shippingDate == null ? null : Date.toDate(this.shippingDate!).toJson() ,
      "coupon": this.coupon == null ? null : this.coupon?.toJson(),
      "address": this.address == null ? null : this.address?.toJson(),
      "review": this.review == null ? null : this.review?.toJson(),
    };
  }

//

}
