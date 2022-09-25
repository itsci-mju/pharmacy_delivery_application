import 'package:cloud_firestore/cloud_firestore.dart';

import 'Advice.dart';
import 'Date.dart';

class Message {
  String? messageId;
  DateTime? time;
  String? sender;
  String? recipient;
  String? text;
  Advice? advice;
  String? messageType;

  Message(
      { this.messageId,
        this.time,
       this.sender,
       this.recipient,
       this.text,
       this.advice,
      this.messageType});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json["messageId"] == null ? null : json["messageId"],
      time:json["time"] == null ? null : Date.fromJson(json["time"]).toDateTime(),
      sender: json["sender"] == null ? null : json["sender"]  ,
      recipient: json["recipient"]== null ? null :  json["recipient"],
      text: json["text"] == null ? null : json["text"]  ,
      advice: json["advice"] == null ? null : Advice.fromJson(json["advice"]),
      messageType: json["messageType"] == null ? null : json["messageType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "messageId": this.messageId == null ? null : this.messageId ,
      "time":this.time == null ? null : Date.toDate(this.time!).toJson() ,
      "sender": this.sender == null ? null : this.sender,
      "recipient": this.recipient == null ? null : this.recipient,
      "text": this.text== null ? null : this.text,
      "advice":this.advice == null ? null : this.advice?.toJson(),
      "messageType": this.messageType == null ? null : this.messageType ,

    };
  }
/*
  Map<String, dynamic> toJson() {
    return {
      "messageId": this.messageId == null ? null : this.messageId ,
      "time":this.time == null ? null : this.time?.toIso8601String(),
      "sender": this.sender == null ? null : this.sender,
      "recipient": this.recipient == null ? null : this.recipient,
      "text": this.text== null ? null : this.text,
      "advice":this.advice == null ? null : this.advice?.toJson(),
      "messageType": this.messageType == null ? null : this.messageType ,
    };
  }
*/

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      //messageId: doc.get("messageId") == null ? null : doc.get("messageId"),
      time: doc.get("time") == null ? null : Date.fromString(doc.get("time")).toDateTime(),
      sender: doc.get("sender") == null ? null : doc.get("sender")  ,
      recipient: doc.get("recipient")== null ? null :  doc.get("recipient"),
      text: doc.get("text") == null ? null : doc.get("text")  ,
      //advice: doc.get("advice") == null ? null : Advice.fromJson(doc.get("advice")),
      messageType: doc.get("messageType") == null ? null : doc.get("messageType"),
    );
  }


}
