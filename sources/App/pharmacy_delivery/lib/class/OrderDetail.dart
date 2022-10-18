import 'Medicine.dart';
import 'Orders.dart';

class OrderDetail {
  Orders? orders;
  Medicine? medicine;
  int? quantity;
  double? sumprice;
  String? note;

  OrderDetail(
      { this.orders,
       this.medicine,
       this.quantity,
       this.sumprice,
       this.note});

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orders: json["orders"] == null ? null : Orders.fromJson(json["orders"]),
      medicine: json["medicine"] == null ? null : Medicine.fromJson(json["medicine"]),
      quantity: json["quantity"]  == null ? null :json["quantity"],
      sumprice: json["sumprice"]  == null ? null :json["sumprice"],
      note: json["note"] == null ? null :json["note"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orders": this.orders == null ? null : this.orders?.toJson(),
      "medicine": this.medicine == null ? null :this.medicine?.toJson(),
      "quantity": this.quantity == null ? null :this.quantity,
      "sumprice": this.sumprice == null ? null :this.sumprice ,
      "note": this.note == null ? null :this.note,
    };
  }


//

}
