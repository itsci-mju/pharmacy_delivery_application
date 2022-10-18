class Owner {
  final String? ownerid;
  final String? ownerName;
  final String? ownerPassword;
  final String? imgLicense;

  Owner(
      { this.ownerid,
       this.ownerName,
       this.ownerPassword,
       this.imgLicense});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      ownerid: json["ownerid"] == null ? null :json["ownerid"]  ,
      ownerName: json["ownerName"] == null ? null : json["ownerName"],
      ownerPassword: json["ownerPassword"] == null ? null : json["ownerPassword"],
      imgLicense: json["imgLicense"] == null ? null :json["imgLicense"] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ownerid": this.ownerid == null ? null : this.ownerid,
      "ownerName": this.ownerName == null ? null : this.ownerName,
      "ownerPassword": this.ownerPassword == null ? null : this.ownerPassword ,
      "imgLicense": this.imgLicense == null ? null : this.imgLicense,
    };
  }

//

/*
 Owner(this.ownerid, this.ownerName, this.ownerPassword, this.imgLicense);

  Owner.fromJson(Map<String, dynamic> json) :
        ownerid = json['ownerid'],
        ownerName = json['ownerName'],
        ownerPassword = json['ownerPassword'],
        imgLicense = json['imgLicense'];

  Owner(
      {required this.ownerid,
      required this.ownerName,
      required this.ownerPassword,
      required this.imgLicense});

  //แปลง jsonString ให้เป็น object
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
        ownerid: json['ownerid'],
        ownerName: json['ownerName'],
        ownerPassword: json['ownerPassword'],
        imgLicense: json['imgLicense']
    );
  }
  */

}
