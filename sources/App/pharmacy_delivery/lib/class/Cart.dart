import 'Medicine.dart';


class Cart{
  double? medPrice;
  Medicine? medicine;
  int? quantity;
  double? sumprice;
  String? note;

  Cart(
      { this.medPrice,
        this.medicine,
        this.quantity,
        this.sumprice,
        this.note});


  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      medPrice: json["medPrice"]== null ? null :json["medPrice"] ,
      medicine: json["medicine"] == null ? null : Medicine.fromJson(json["medicine"]),
      quantity: json["quantity"]  == null ? null :json["quantity"],
      sumprice: json["sumprice"]  == null ? null :json["sumprice"],
      note: json["note"] == null ? null :json["note"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "medPrice": this.medPrice == null ? null :  this.medPrice,
      "medicine": this.medicine == null ? null :this.medicine?.toJson(),
      "quantity": this.quantity == null ? null :this.quantity,
      "sumprice": this.sumprice == null ? null :this.sumprice ,
      "note": this.note == null ? null :this.note,
    };
  }


}

