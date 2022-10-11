import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/advice_api.dart';

import '../class/Member.dart';
import '../class/Message.dart';
import '../class/Pharmacist.dart';
import '../utils/constants.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';
import 'chat_screen.dart';

class ListChat extends StatefulWidget {
  const ListChat({Key? key}) : super(key: key);

  @override
  State<ListChat> createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  List<Member> listMember =  [];
  Message? lastMessage = Message();
  final db =FirebaseFirestore.instance;
  Message? chat;
  Pharmacist? pharmacist = Pharmacist();

  Future getPharmacist() async {
    final pharmacist = await UserSecureStorage.getPharmacist();
    setState(() {
      this.pharmacist = pharmacist;
    });
  }

  Future getLastMessage(String pharmacistId , String customerId) async{
   final chat =  await db.collection('$pharmacistId').doc("$customerId").collection("Message").get().then((value) => value.docs.last) ;
   setState(() {
     this.chat =  Message.fromDocument( chat);
   });
  }

  @override
  void initState() {
    super.initState();
    getPharmacist();
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
                          child:
                     StreamBuilder(
                            stream: db.collection('${pharmacist!.pharmacistID}')
                               .where("lastTime",isNotEqualTo: "")
                               .orderBy("lastTime",descending: true)
                                //.where("adviceId",isEqualTo: "200")
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.connectionState == ConnectionState.waiting  ) {
                                return forLoad_Data( themeData);
                              }else if (streamSnapshot.hasData && streamSnapshot.data!.docs.isNotEmpty ){
                                return  ListView.builder(
                                  itemCount:  streamSnapshot.data!.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final docSnap = streamSnapshot.data!.docs[index];
                                    //print(docSnap.data()); //{adviceId: 306, MemberImg:"dddd"}
                                   // print(docSnap.reference.id); //manee123

                                    String customerId = docSnap.reference.id;

                                    return StreamBuilder(
                                        stream: db.collection('${pharmacist!.pharmacistID}').doc("$customerId").collection("Message").orderBy("time").snapshots(),

                                        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                                          if (streamSnapshot.connectionState == ConnectionState.waiting ) {
                                            return SizedBox();
                                          }
                                          Message? chat;
                                          if(streamSnapshot.data!.docs.isNotEmpty){
                                            chat =  Message.fromDocument( streamSnapshot.data!.docs.last);
                                          }

                                          return GestureDetector(
                                            onTap: ()  async {
                                              final advice = await AdviceApi.getAdvice(docSnap['adviceId']);
                                              if(advice!=0){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(advice: advice,shipping: "",)));
                                              }else{
                                                buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                                              }

                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 5.0, bottom: 5.0, ),
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.15),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        radius: 30.0,
                                                        backgroundImage: NetworkImage(docSnap['MemberImg']!=""&& docSnap['MemberImg']!=null ? docSnap['MemberImg'] : 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fuser.png?alt=media&token=5842fcab-a485-4e4a-936a-f157dd0da815'),
                                                      ),

                                                      SizedBox(width: 10.0),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            "${customerId}",
                                                            style: TextStyle(fontSize: 16,color: Colors.black87),
                                                          ),
                                                          SizedBox(height: 5.0),
                                                          if(chat!=null)
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.45,
                                                            child: chat.text!=null?
                                                            Text(
                                                              chat.sender=="${pharmacist!.pharmacistID}"?
                                                                "คุณ : ${chat.text}"
                                                                  : "${chat.text}"
                                                              ,
                                                              style: TextStyle(
                                                                color: Colors.blueGrey,
                                                                fontSize: 15.0,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ) :
                                                            Text(
                                                              chat.sender=="${pharmacist!.pharmacistID}"?
                                                              "คุณ : รายการยาที่แนะนำ"
                                                                  : "รายการยาที่แนะนำ"
                                                              ,
                                                              style: TextStyle(
                                                                color: Colors.blueGrey,
                                                                fontSize: 15.0,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  Column(
                                                    children: <Widget>[
                                                      if(chat!=null)
                                                      Text(
                                                        DateFormat('HH:mm').format(chat.time!),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.0),
                                                      Text(""),
                                                    ],
                                                  )
                                                   ,
                                                ],
                                              ),
                                            ),
                                          );

                                        }
                                    );


                                  },
                                );
                              }else{
                                return for_NodataFound( themeData,"ยังไม่มีแชทกับลูกค้า");
                              }

                            },
                          )

                        ),
                      )
                    ],
                  ),
                ],
              )),


        ));
  }
}
