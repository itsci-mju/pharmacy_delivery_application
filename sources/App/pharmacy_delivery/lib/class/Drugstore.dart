import 'Owner.dart';

class Drugstore {
  final String? drugstoreID;
  final Owner? owner;
  final String? drugstoreName;
  final String? drugstoreAddress;
  final String? drugstoreTel;
  final String? drugstoreStatus;
  final String? drugstoreImg;

/*
  Drugstore( this.drugstoreID, this.owner, this.drugstoreName,
      this.drugstoreAddress, this.drugstoreTel, this.drugstoreStatus,
      this.drugstoreImg);

 */
  Drugstore({
     this.drugstoreID,
     this.owner,
     this.drugstoreName,
     this.drugstoreAddress,
     this.drugstoreTel,
     this.drugstoreStatus,
     this.drugstoreImg,
  });

  factory Drugstore.fromJson(Map<String, dynamic> json) {
    return Drugstore(
        drugstoreID: json['drugstoreID'] == null ? null :json["drugstoreID"] ,
        owner: json['owner'] == null ? null :Owner.fromJson(json['owner']),
        drugstoreName: json['drugstoreName'] == null ? null :json["drugstoreName"] ,
        drugstoreAddress: json['drugstoreAddress'] == null ? null :json["drugstoreAddress"] ,
        drugstoreTel: json['drugstoreTel'] == null ? null :json["drugstoreTel"] ,
        drugstoreStatus: json['drugstoreStatus']== null ? null :json["drugstoreStatus"] ,
        drugstoreImg: json['drugstoreImg'] == null ? null :json["drugstoreImg"] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "drugstoreID": this.drugstoreID == null ? null : this.drugstoreID,
      "owner":this.owner == null ? null :  this.owner?.toJson(),
      "drugstoreName": this.drugstoreName== null ? null : this.drugstoreName,
      "drugstoreAddress": this.drugstoreAddress== null ? null : this.drugstoreAddress,
      "drugstoreTel": this.drugstoreTel== null ? null : this.drugstoreTel,
      "drugstoreStatus": this.drugstoreStatus== null ? null : this.drugstoreStatus,
      "drugstoreImg": this.drugstoreImg== null ? null : this.drugstoreImg,
    };
  }

  Map<String, dynamic> toJsonDrugstoreID() {
    return {
      "drugstoreID": this.drugstoreID == null ? null : this.drugstoreID,
    };
  }

}
