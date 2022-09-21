import 'dart:convert';

import 'package:http/http.dart' as http;

import '../class/Message.dart';
import '../utils/URLRequest.dart';
class MessageApi{

  static Future<List<Message>> getListMessage(String adviceId) async {
    final response = await http.post(Uri.parse(URLRequest.URL_message_list),
        body: jsonEncode({"adviceId":adviceId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("getListMessage : "+response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> message = map["result"];

      List<Message> listMessage = [];
      for (dynamic m in message) {
        Message a = Message.fromJson(m);
        listMessage.add(a);
      }
      return listMessage;
    } else {
      throw Exception();
    }
  }
/*
  static Stream<List<Message>> chat(String adviceId) {

   return Stream.periodic(Duration(seconds: 1)).asyncMap((event) => getListMessage(adviceId) );
  }

 */
  static Stream<List<Message>> chat(String adviceId) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      List<Message> listMessage = await getListMessage( adviceId);
      yield listMessage;
    }

  }

  static addMessage(Message message) async {
    final jsonmessage = message.toJson();
    final response = await http.post(Uri.parse(URLRequest.URL_message_add),
        body: jsonEncode({"message": jsonEncode(jsonmessage)}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("addMessage : "+response.body.toString());

    Map<String, dynamic> map = json.decode(response.body);

    if (response.statusCode == 200 && map["result"] != "0") {
      dynamic result = map["result"];
      Message message= Message.fromJson(result);
      return message;

    } else {
      return 0;
    }
  }

}