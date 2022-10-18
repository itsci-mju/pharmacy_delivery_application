import 'Date.dart';
import 'Drugstore.dart';
import 'Medicine.dart';

class Stock {
  Drugstore? drugstore;
  Medicine? medicine;
  int? medQuantity;
  DateTime? expirationDate;
  double? medPrice;

  Stock({  this.drugstore,  this.medicine,  this.medQuantity,  this.expirationDate,
       this.medPrice});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      drugstore: json["drugstore"] == null ? null :Drugstore.fromJson(json["drugstore"]),
      medicine: json["medicine"] == null ? null : Medicine.fromJson(json["medicine"]),
      medQuantity: json["medQuantity"] == null ? null :json["medQuantity"] ,
      expirationDate:json["expirationDate"]== null ? null : Date.fromJson(json["expirationDate"]).toDateTime(),
      medPrice: json["medPrice"]== null ? null :json["medPrice"] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "drugstore": this.drugstore == null ? null :this.drugstore?.toJson(),
      "medicine": this.medicine == null ? null :this.medicine?.toJson(),
      "medQuantity": this.medQuantity == null ? null :  this.medQuantity,
      "expirationDate":  this.expirationDate == null ? null : Date.toDate(this.expirationDate!).toJson() ,
      "medPrice": this.medPrice == null ? null :  this.medPrice,
    };
  }
//

}
