import 'Drugstore.dart';

class Pharmacist {
  String? pharmacistID;
  String? pharmacistPassword;
  String? pharmacistName;
  String? pharmacistImg;
  String? imgCeritficate;
  String? pharmacistMobile;
  String? pharmacistEmail;
  String? pharmacistStatus;
  Drugstore? drugstore;


  Pharmacist.login(this.pharmacistID, this.pharmacistPassword);

  Pharmacist(
      { this.pharmacistID,
       this.pharmacistPassword,
       this.pharmacistName,
       this.pharmacistImg,
       this.imgCeritficate,
       this.pharmacistMobile,
       this.pharmacistEmail,
       this.pharmacistStatus,
       this.drugstore});

  factory Pharmacist.fromJson(Map<String, dynamic> json) {
    return Pharmacist(
      pharmacistID: json["pharmacistID"] == null ? null :json["pharmacistID"],
      pharmacistPassword: json["pharmacistPassword"]== null ? null :json["pharmacistPassword"],
      pharmacistName: json["pharmacistName"]== null ? null :json["pharmacistName"],
      pharmacistImg: json["pharmacistImg"]== null ? null :json["pharmacistImg"],
      imgCeritficate: json["imgCeritficate"]== null ? null :json["imgCeritficate"],
      pharmacistMobile: json["pharmacistMobile"]== null ? null :json["pharmacistMobile"],
      pharmacistEmail: json["pharmacistEmail"]== null ? null :json["pharmacistEmail"],
      pharmacistStatus: json["pharmacistStatus"]== null ? null :json["pharmacistStatus"],
      drugstore: json["drugstore"] == null ? null :Drugstore.fromJson(json["drugstore"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pharmacistID": this.pharmacistID == null ? null : this.pharmacistID ,
      "pharmacistPassword": this.pharmacistPassword == null ? null : this.pharmacistPassword ,
      "pharmacistName": this.pharmacistName == null ? null : this.pharmacistName,
      "pharmacistImg": this.pharmacistImg == null ? null : this.pharmacistImg,
      "imgCeritficate": this.imgCeritficate == null ? null : this.imgCeritficate,
      "pharmacistMobile": this.pharmacistMobile == null ? null : this.pharmacistMobile,
      "pharmacistEmail": this.pharmacistEmail == null ? null : this.pharmacistEmail,
      "pharmacistStatus": this.pharmacistStatus == null ? null : this.pharmacistStatus,
      "drugstore": this.drugstore == null ? null :this.drugstore?.toJson(),
    };
  }
  Map<String, dynamic> toJsonLogin() {
    return {
    "pharmacistID": this.pharmacistID == null ? null : this.pharmacistID ,
    "pharmacistPassword": this.pharmacistPassword == null ? null : this.pharmacistPassword ,
    };
  }

//

}
