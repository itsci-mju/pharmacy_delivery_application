import 'package:pharmacy_delivery/class/Date.dart';

class Review {
  String? reviewId;
  int? score;
  String? comment;
  DateTime? reviewDate;

  Review({this.reviewId, this.score, this.comment, this.reviewDate});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json["reviewId"] == null ? null :json["reviewId"],
      score: json["score"]== null ? null :json["score"],
      comment: json["comment"]== null ? null :json["comment"],
      reviewDate: json["reviewDate"]== null ? null : Date.fromJson(json["reviewDate"]).toDateTime(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reviewId": this.reviewId == null ? null : this.reviewId  ,
      "score": this.score == null ? null : this.score,
      "comment": this.comment == null ? null : this.comment,
      "reviewDate":this.reviewDate == null ? null :  Date.toDate(this.reviewDate!).toJson() , //this.reviewDate?.toIso8601String() ,
    };
  }
//

}
