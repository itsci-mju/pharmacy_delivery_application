import 'MedicineType.dart';

class Medicine {
  String? medId;
  String? medName;
  String? medDetail;
  String? medImg;
  MedicineType? medicineType;

  Medicine(
      { this.medId,
       this.medName,
       this.medDetail,
       this.medImg,
       this.medicineType});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medId: json["medId"] == null ? null :json["medId"],
      medName: json["medName"]== null ? null :json["medName"],
      medDetail: json["medDetail"]== null ? null :json["medDetail"],
      medImg: json["medImg"]== null ? null :json["medImg"],
      medicineType: json["medicineType"]== null ? null : MedicineType.fromJson(json["medicineType"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "medId": this.medId == null ? null : this.medId,
      "medName": this.medName == null ? null :this.medName,
      "medDetail": this.medDetail == null ? null : this.medDetail,
      "medImg": this.medImg == null ? null :this.medImg ,
      "medicineType": this.medicineType == null ?  null : this.medicineType?.toJson(),
    };
  }
//

}
