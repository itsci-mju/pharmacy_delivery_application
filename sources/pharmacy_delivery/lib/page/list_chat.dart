import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../class/Member.dart';
import '../class/Message.dart';
import '../utils/constants.dart';

class ListChat extends StatefulWidget {
  const ListChat({Key? key}) : super(key: key);

  @override
  State<ListChat> createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  List<Member> listMember =  [];
  Message? lastMessage = Message();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Text(
                  "แชทกับลูกค้า",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            backgroundColor: COLOR_CYAN,
            automaticallyImplyLeading: false,
            //elevation: 0,
          ),
          backgroundColor: Color(0xFFF3F5F7),
          body: Container(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: sidePadding,
                          child: ListView.builder(
                            itemCount:  2,//listMember.length,
                            itemBuilder: (BuildContext context, int index) {
                             // final Message chat = lastMessage!;
                              return GestureDetector(
                                onTap: ()  {},
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0, ),
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                       Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 35.0,
                                            backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fuser.png?alt=media&token=5842fcab-a485-4e4a-936a-f157dd0da815"),
                                          ),
                                          SizedBox(width: 10.0),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'chat.sender.name',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5.0),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.45,
                                                child: Text(
                                                  "chat.text",
                                                  style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "chat.time",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )),


        ));
  }
}
