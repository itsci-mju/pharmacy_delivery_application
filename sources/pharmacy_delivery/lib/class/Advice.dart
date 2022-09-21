import 'Date.dart';
import 'Member.dart';
import 'Orders.dart';
import 'Pharmacist.dart';

class Advice {
  String? adviceId;
  DateTime? startTime;
  DateTime? endTime;
  String? adviceTitle;
  String? adviceDetail;
  Pharmacist? pharmacist;
  Member? member;
  Orders? orders;

  Advice(
      { this.adviceId,
       this.startTime,
       this.endTime,
       this.adviceTitle,
       this.adviceDetail,
       this.pharmacist,
       this.member,
       this.orders});

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      adviceId: json["adviceId"]== null ? null :json["adviceId"],
      startTime: json["startTime"] == null ? null :Date.fromJson(json["startTime"]).toDateTime(),
      endTime:  json["endTime"] == null ? null :Date.fromJson(json["endTime"]).toDateTime(),
      adviceTitle: json["adviceTitle"]== null ? null :json["adviceTitle"],
      adviceDetail: json["adviceDetail"]== null ? null :json["adviceDetail"],
      pharmacist: json["pharmacist"]== null ? null : Pharmacist.fromJson(json["pharmacist"]),
      member: json["member"]== null ? null : Member.fromJson(json["member"]),
      orders: json["orders"]== null ? null : Orders.fromJson(json["orders"]) ,
    );
  }




  Map<String, dynamic> toJson() {
    return {
      "adviceId": this.adviceId == null ? null : this.adviceId ,
      "startTime": this.startTime == null ? null : Date.toDate(this.startTime!).toJson() ,
      "endTime": this.endTime == null ? null : Date.toDate(this.endTime!).toJson() ,
      "adviceTitle": this.adviceTitle== null ? null : this.adviceTitle,
      "adviceDetail": this.adviceDetail== null ? null : this.adviceDetail,
      "pharmacist": this.pharmacist== null ? null : this.pharmacist?.toJson(),
      "member": this.member== null ? null : this.member?.toJson(),
      "orders": this.orders== null ? null : this.orders?.toJson(),
    };
  }

}
