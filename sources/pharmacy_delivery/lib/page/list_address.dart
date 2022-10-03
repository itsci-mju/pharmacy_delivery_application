import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_delivery/page/add_address.dart';
import 'package:pharmacy_delivery/page/confirm_order.dart';
import 'package:pharmacy_delivery/page/view_drugstore.dart';

import '../api/address_api.dart';
import '../api/advice_api.dart';
import '../api/pharmacist_api.dart';
import '../class/Address.dart';
import '../class/Date.dart';
import '../class/Drugstore.dart';
import '../class/Member.dart';
import '../class/Message.dart';
import '../class/Pharmacist.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';
import 'chat_screen.dart';

class ListAddress extends StatefulWidget {
  final Drugstore drugstore;
  const ListAddress({Key? key, required this.drugstore}) : super(key: key);

  @override
  State<ListAddress> createState() => _ListAddressState();
}

class _ListAddressState extends State<ListAddress> {
  Member member = Member();

  List<Address>? listAddress;
  final db= FirebaseFirestore.instance;


  Future getMember() async {
    Member member = await UserSecureStorage.getMember();
    setState(() {
      this.member = member;
    });
    getListAddress(member.MemberUsername!);

  }
  Future getListAddress(String MemberUsername) async {
    final listAddress = await AddressApi.listAddress(MemberUsername);
    setState(() {
      this.listAddress=listAddress;
    });

  }

  @override
  void initState() {
    super.initState();
    getMember();
    //getListAddress(member.MemberUsername!);
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding,vertical: 5);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewDrugstore(drugstore: widget.drugstore,)  ));
          },
        ),
        title: Text(
          "เลือกที่อยู่",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: COLOR_CYAN,
      ),
      backgroundColor: Color(0xFFF3F5F7),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: size.width,
         // height: size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addVerticalSpace(5),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount:listAddress!=null? listAddress!.length : 0,
                      itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          List<Pharmacist> listPharmacist = await PharmacistApi.checkPharmacistOnline(widget.drugstore.drugstoreID.toString());
                          final _random = new Random();
                          var pharmacist = listPharmacist[_random.nextInt(listPharmacist.length)];

                            final advice = await AdviceApi.addAdvice(member.MemberUsername.toString(), pharmacist.pharmacistID!,listAddress![index].addressId!);
                            if(advice!=0){
                              Message message = Message(messageType: "text",recipient: member.MemberUsername,sender:pharmacist.pharmacistID,text: "${pharmacist.drugstore!.drugstoreName} ยินดีให้บริการ", time: DateTime.now() );
                              db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").add(message.toDocument()).then((value) {
                                db.collection('${advice!.pharmacist!.pharmacistID}').doc(member.MemberUsername).set({
                                  "MemberImg": member.MemberImg,
                                  "adviceId": advice.adviceId ,
                                  "isEnd": "",
                                  "lastTime" : DateTimetoString(DateTime.now())
                                }).then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(advice: advice,shipping: "")));
                                }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));

                              }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(advice: advice,shipping: "")));
                            }else{
                              buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                            }

                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child:  Dismissible(
                            key: Key(listAddress![index].addressId!),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                                final removeAddress = await AddressApi.removeAddress(listAddress![index].addressId!, member.MemberUsername!);
                                if(removeAddress!=0){
                                  listAddress!.removeAt(index);
                                  buildToast("ลบที่อยู่สำเร็จ",Colors.green);
                                }else{
                                  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                                }
                            },
                            background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFE6E6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Icon(
                                    CupertinoIcons.trash_fill,
                                    color: Colors.red,
                                    size: 26,
                                  )
                                ],
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: sidePadding,
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listAddress![index].name!,
                                      style: TextStyle(
                                        color: Colors.black54,fontSize: 14.0,),
                                    ),
                                    Text(
                                      listAddress![index].tel!,
                                      style: TextStyle(
                                        color: Colors.black54,fontSize: 14.0,),
                                    ),
                                    Text(
                                      listAddress![index].addressDetail! ,
                                      style: TextStyle(
                                        color: Colors.black54,fontSize: 14.0,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),


                        ),
                      );
                    }
                  ),
                  Container(
                    width: 200,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        primary: Colors.white,
                        backgroundColor: COLOR_CYAN,
                      ),
                      onPressed:() async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddAddress(drugstore: widget.drugstore,)));
                      },
                      child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: COLOR_WHITE,
                          ),
                          addHorizontalSpace(10),
                          Text (
                            "เพิ่มที่อยู่จัดส่งใหม่",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    /* bottomNavigationBar:Container(
        padding: EdgeInsets.all(10),
        // height: 174,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    primary: Colors.white,
                    backgroundColor: COLOR_CYAN,
                  ),
                  onPressed:() async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddAddress()));
                  },
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: COLOR_WHITE,
                      ),
                      addHorizontalSpace(10),
                      Text (
                        "เพิ่มที่อยุู่จัดส่งใหม่",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ) ,
      */
    );
  }
}

