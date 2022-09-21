class MedicineType {
  String? typeId;
  String? typeName;

  MedicineType({ this.typeId,  this.typeName});

  factory MedicineType.fromJson(Map<String, dynamic> json) {
    return MedicineType(
      typeId: json["typeId"] == null ? null : json["typeId"] ,
      typeName: json["typeName"]== null ? null : json["typeName"] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "typeId": this.typeId == null ? null : this.typeId,
      "typeName": this.typeName == null ? null : this.typeName,
    };
  }
}
