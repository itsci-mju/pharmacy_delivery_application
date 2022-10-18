import 'Member.dart';

class Address {
  String? addressId;
  String? name;
  String? addressDetail;
  String? tel;
  String? status;
  Member? member;

  Address(
      { this.addressId,
       this.name,
       this.addressDetail,
       this.tel,
        this.status,
       this.member});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json["addressId"] == null ? null :json["addressId"],
      name: json["name"]== null ? null :json["name"],
      addressDetail: json["addressDetail"]== null ? null :json["addressDetail"],
      tel: json["tel"]== null ? null :json["tel"],
      status: json["status"]== null ? null :json["status"],
      member: json["member"]== null ? null : Member.fromJson(json["member"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addressId": this.addressId == null ? null : this.addressId,
      "name": this.name== null ? null : this.name,
      "addressDetail": this.addressDetail== null ? null : this.addressDetail,
      "tel": this.tel== null ? null : this.tel,
      "status": this.status== null ? null : this.status,
      "member": this.member== null ? null : this.member?.toJson(),
    };
  }
}
