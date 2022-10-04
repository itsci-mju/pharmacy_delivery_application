import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/address_api.dart';
import 'package:pharmacy_delivery/class/Medicine.dart';
import 'package:pharmacy_delivery/class/OrderDetail.dart';
import 'package:pharmacy_delivery/page/main_page_member.dart';
import 'package:pharmacy_delivery/page/pharmacist_home_page.dart';
import 'package:pharmacy_delivery/page/search_medicine.dart';
import '../api/advice_api.dart';
import '../class/Address.dart';
import '../class/Advice.dart';
import '../class/Cart.dart';
import '../class/Date.dart';
import '../class/Member.dart';
import '../class/Message.dart';
import '../class/Orders.dart';
import '../class/Pharmacist.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';
import 'confirm_order.dart';
import 'dart:developer';

class ChatScreen extends StatefulWidget {
  final Advice advice;
  final List<Cart>? cart;
  final String? shipping ;

  const ChatScreen({Key? key, required this.advice, this.cart,  this.shipping, })
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? curentUser_id ;
  Pharmacist pharmacist = Pharmacist();
  Member member = Member();
  TextEditingController message_ctl = TextEditingController();
  ScrollController scrollController = ScrollController();
  Message message = Message();
  Advice? advice;
  Address? address;
  final db =FirebaseFirestore.instance;
  bool hasOrder= false;
  bool memEndChat = false;

  List<Cart>? cart=[];
  int sumQTY=0;
  String shipping = "";

  final adviceTitle = TextEditingController();
  final adviceDetail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future getMember() async {
    Member member = await UserSecureStorage.getMember();
    setState(() {
      this.member = member;
      if(member.MemberUsername!=null) {
        curentUser_id = member.MemberUsername!;
        message.sender= curentUser_id;
        message.recipient = widget.advice.pharmacist!.pharmacistID;
      }
    });

  }
  Future getPharmacist() async {
    final pharmacist = await UserSecureStorage.getPharmacist();
    setState(() {
      this.pharmacist = pharmacist;
      if(pharmacist.pharmacistID!=null) {
        curentUser_id = pharmacist.pharmacistID! ;
        message.sender= curentUser_id;
        message.recipient = widget.advice.member!.MemberUsername!;
      }
    });
  }

  Future getAddress() async {
    String addressId = await  db.collection('${widget.advice.pharmacist!.pharmacistID}').doc('${widget.advice.member!.MemberUsername}').get().then((doc) => doc.get("addressId"));
    final address = await AddressApi.fetchAddress(addressId) ;
    setState(() {
      this.address = address;
    });

  }


  @override
  void initState() {
    super.initState();
    getPharmacist();
    getMember();
    getAddress();


    setState(()  {

      advice= widget.advice;

      shipping =widget.shipping?? "";
      cart=widget.cart;
      cart ??= [];

      for(Cart c in cart!){
        sumQTY+= c.quantity!;
      }


    });

  }


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    Size size = MediaQuery.of(context).size;



    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(curentUser_id == advice!.pharmacist!.pharmacistID)
                    BackButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PharmacistHomePage(index: 1,)));
                      },
                    ),
                  SizedBox(
                    width: 40,
                    child: TextButton(
                      child:  Text(
                        'End',
                      ),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(
                            fontSize: 14,
                          )),
                      onPressed: () async {
                        curentUser_id == advice!.pharmacist!.pharmacistID
                            ? showDialog<String>(context: context, builder: (BuildContext context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10) ,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  child: SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: RaisedButton(
                                            color: COLOR_CYAN,
                                            child: Text('บันทึก', style: TextStyle(color: Colors.white),),
                                            onPressed: () async {

                                                final endAdvice = await AdviceApi.endAdvice(advice!);
                                                if(endAdvice==1){

                                                 await  db.collection('${advice!.pharmacist!.pharmacistID}')
                                                      .doc("${advice!.member!.MemberUsername}").delete().then((value)  async {
                                                   var snapshotmessage = await db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").get();
                                                   for (var doc in snapshotmessage.docs) {

                                                     var snapShotOrders = await doc.reference.collection("Orders").get();
                                                     for (var doc in snapShotOrders.docs) {
                                                       var snapShotOrdersDetail = await doc.reference.collection("OrderDetail").get();
                                                       for (var doc in snapShotOrdersDetail.docs) {
                                                         await doc.reference.delete();
                                                       }
                                                        await doc.reference.delete();
                                                     }

                                                     await doc.reference.delete();
                                                   }

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => PharmacistHomePage(index: 1,)));
                                                    buildToast("บันทึกการสนทนาสำเร็จ",Colors.green);
                                                  });


                                                }else{
                                                  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                                                }


                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            )
                        ),)
                            : memEndAdvice( advice!);

                      },
                    ),
                  ),
                ],
              ),

              curentUser_id == advice!.pharmacist!.pharmacistID
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage( advice!.member!.MemberImg ?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fuser.png?alt=media&token=5842fcab-a485-4e4a-936a-f157dd0da815')),


                  SizedBox(width: 20 * 0.75),

                  Text(
                    advice!.member!.MemberUsername!,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
                  :  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.store,size: 30,),
                      addHorizontalSpace(5),
                      Text( advice!.pharmacist!.drugstore!.drugstoreName!,
                        style:  TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Text(
                    advice!.pharmacist!.pharmacistName!,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              if(curentUser_id == advice!.member!.MemberUsername)
                addHorizontalSpace(30)
              else
                if (memEndChat==false )
                  cart!.length>0
                      ? Badge(
                    badgeColor: Colors.red,
                    toAnimate: true,
                    badgeContent: Text(
                      sumQTY.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchMedicine(
                                  advice: advice!, cart: cart, shipping: shipping, recipient: message.recipient!, address: address ,
                                )));
                      },
                      child: Icon(
                        CupertinoIcons.cart_fill,
                        size: 30,
                      ),
                    ),
                  )
                      : IconButton(
                    onPressed: () {
                      if(hasOrder==false ){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => SearchMedicine(
                                  advice: advice!, shipping: shipping, recipient: message.recipient!, address: address ,
                                )));
                      }else{
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            title:  Text('แจ้งเตือน' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red), ),
                            content:  Text( 'มีการเพิ่มรายการยาเรียบร้อยแล้ว', style: TextStyle( fontSize: 16),),
                            actions: <Widget>[
                              RaisedButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                color: COLOR_CYAN,
                                child: Text('ตกลง', style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                        );
                      }

                    },
                    icon: Icon(
                      Icons.medical_services,
                      size: 30,
                    ),
                  )
                else
                  addHorizontalSpace(30),


            ],
          ),
          bottom:  curentUser_id == advice!.pharmacist!.pharmacistID?
          PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                width: size.width,
                color: Colors.white,
                //height: 30.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(Icons.location_pin,size: 20,),
                          addHorizontalSpace(5),
                          Expanded(
                            child: Text(
                              address!=null ? "ที่อยู่ : ${address!.addressDetail!}" : "รับยาที่ร้าน" ,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                )

            ),
          )
              : PreferredSize(child: SizedBox(), preferredSize: Size.fromHeight(0),),

          backgroundColor: COLOR_CYAN,
          //elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(//color: Colors.grey[50],
                  ),
                  child: ClipRRect(
                      child: StreamBuilder(
                          stream: db.collection('${advice!.pharmacist!.pharmacistID}')
                              .doc("${advice!.member!.MemberUsername}").collection("Message")
                              .orderBy("time")
                              .snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot>  snapShot) {
                            if( snapShot.hasData && snapShot.data!.docs.isNotEmpty ) {
                              if(memEndChat==false){
                                SchedulerBinding.instance!.addPostFrameCallback((_){
                                  if(scrollController.hasClients){
                                    scrollController.animateTo(
                                        scrollController.position.maxScrollExtent,
                                        duration: const Duration(milliseconds: 100),
                                        curve: Curves.ease);
                                  }
                                });
                              }


                              db.collection('${advice!.pharmacist!.pharmacistID}')
                                  .where('adviceId',isEqualTo: advice!.adviceId)
                                  .snapshots().listen((event) {
                                if( curentUser_id == advice!.pharmacist!.pharmacistID  && event.docs.first['isEnd']  == "memberEnd"){
                                    memEndChat = true;
                                }
                                print("mmmmmmmmmmmmm");

                              });

                              return ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  // reverse: true,
                                  padding: EdgeInsets.only(top: 15),
                                  itemCount: snapShot.data!.docs.length,
                                  itemBuilder: (BuildContext context, int index) {

                                    final Message msg = Message.fromDocument(snapShot.data!.docs[index]); //List.from(listMessage.reversed)[index];
                                    bool isMe = msg.sender == curentUser_id;

                                    if(memEndChat==true &&  index==snapShot.data!.docs.length-1 ) {
                                      return  _buildMessage(msg, isMe,true);

                                    }else{

                                      return  _buildMessage(msg, isMe,false);
                                    }



                                  }
                              );
                            }
                            else if (snapShot.hasError) {
                              return forLoad_Error(snapShot, themeData);
                            } else if (snapShot.data!=null && snapShot.data!.docs.isEmpty && curentUser_id== advice!.member!.MemberUsername )  {
                              SchedulerBinding.instance?.addPostFrameCallback((_) {
                                print("hhhhhhhhhhhhhhh");
                                showDialog<String>(
                                  context: context,
                                  barrierColor: Color(0x2F000000),
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10)
                                        ),
                                        title: const Text('แจ้งเตือน',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.red),),
                                        content: const Text(
                                          'ขณะนี้การสนทนาได้จบลงแล้ว',
                                          style: TextStyle(fontSize: 16),),
                                        actions: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPageMember()),
                                              );
                                            },
                                            color: COLOR_CYAN,
                                            child: Text('ตกลง',
                                              style: TextStyle(
                                                  color: Colors.white),),
                                          ),

                                        ],
                                      ),
                                );
                              });

                              return  SizedBox();
                            } else {
                              return SizedBox();
                            }


                          }
                      )

                  )),
            ),
            if( memEndChat == false)
              _buildMessageComposer(),
          ],
        ),

      ),
    );
  }

  _buildMessage(Message msg, bool isMe,bool isLast)   {
    final ThemeData themeData = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                curentUser_id == advice!.pharmacist!.pharmacistID?
                CircleAvatar(backgroundImage:
                NetworkImage( advice!.member!.MemberImg?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fuser.png?alt=media&token=5842fcab-a485-4e4a-936a-f157dd0da815'),
                  radius: 18,)
                    :
                CircleAvatar(backgroundImage: NetworkImage( advice!.pharmacist!.pharmacistImg?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fuser.png?alt=media&token=5842fcab-a485-4e4a-936a-f157dd0da815'),
                  radius: 18,),
              SizedBox(
                width: 10,
              ),
              msg.messageType =="text"?
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                decoration: BoxDecoration(
                    color: isMe ? COLOR_CYAN : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 12 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 12),
                    )),
                child: Text(
                  msg.text.toString(),
                  style: bodyTextMessage.copyWith(
                      color: isMe ? Colors.white : Colors.grey[800]),
                ),
              )
                  :
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                decoration: BoxDecoration(
                    border: Border.all(color: isMe ? COLOR_CYAN : Colors.grey),
                    color:  Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 12 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 12),
                    )),
                child:Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                            stream: db.collection('${advice!.pharmacist!.pharmacistID}')
                                .doc("${advice!.member!.MemberUsername}").collection("Message")
                                .doc("${msg.messageId}").collection("Orders")
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot>  streamSnapshot) {
                              if ( (streamSnapshot.hasData && streamSnapshot.data!.docs.isNotEmpty)  && (streamSnapshot.connectionState != ConnectionState.waiting) ){
                                Orders orders = Orders.fromDocument(streamSnapshot.data!.docs.first);
                                orders.address = address;
                                return StreamBuilder(
                                    stream: db.collection('${advice!.pharmacist!.pharmacistID}')
                                        .doc("${advice!.member!.MemberUsername}").collection("Message")
                                        .doc("${msg.messageId}").collection("Orders")
                                        .doc("${streamSnapshot.data!.docs.first.id}").collection("OrderDetail")
                                        .orderBy("timeAdd")
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot>  snapShot) {
                                      if ( (snapShot.hasData && snapShot.data!.docs.isNotEmpty)  && (snapShot.connectionState != ConnectionState.waiting) ){
                                        List<OrderDetail> listOrderdetail = [];

                                        DateTime now = DateTime(DateTime.now().year+543, DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,DateTime.now().second,DateTime.now().millisecond);

                                        DateTime limitTime = orders.orderDate!.add(Duration(minutes: 10));

                                        if( (now.isBefore(limitTime) && orders.orderStatus=="wcf") ||(orders.orderStatus=="cf" ) ||(orders.orderStatus=="store" ) ||(orders.orderStatus=="wt" ) ) {
                                          hasOrder =true;
                                        }else{
                                          hasOrder =false;
                                        }

                                        bool isEndTime=false;
                                        SchedulerBinding.instance!.addPostFrameCallback((_){
                                          if(scrollController.hasClients){
                                            scrollController.animateTo(
                                                scrollController.position.maxScrollExtent,
                                                duration: const Duration(milliseconds: 100),
                                                curve: Curves.ease);
                                          }

                                        });

                                        return Container(
                                          decoration:  orders.orderStatus == "pc" ||  (now.isAfter(limitTime) && orders.orderStatus=="wcf") || (memEndChat==true && orders.orderStatus=="wcf") ?
                                          BoxDecoration(
                                              image: DecorationImage(
                                                image:AssetImage("assets/images/cancelled_stamp.png")  ,
                                                fit: BoxFit.fitWidth,
                                              )
                                          ) :
                                          orders.orderStatus == "cf"   ?
                                          BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/images/confirm_stamp.png") ,
                                                fit: BoxFit.fitWidth,
                                              )
                                          )
                                          :
                                          orders.orderStatus == "store" || orders.orderStatus == "wt" ?
                                          BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/images/paid_stamp.jpg") ,
                                                fit: BoxFit.fitWidth,
                                              )
                                          )
                                              : BoxDecoration(),

                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: BouncingScrollPhysics(),
                                                  itemCount:snapShot.data!.docs.isNotEmpty ? snapShot.data!.docs.length : 0 ,
                                                  itemBuilder: (context, index) {
                                                    final docSnap = snapShot.data!.docs[index];

                                                    OrderDetail od = OrderDetail (orders:orders, medicine:Medicine(medName:docSnap["medName"], medId:docSnap["medId"] ,medImg:docSnap["medImg"]), quantity:docSnap["quantity"], sumprice: docSnap["sumprice"], note: docSnap["note"] );
                                                    listOrderdetail.add(od);

                                                    return  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        if(index==0)
                                                          Column(children: [
                                                            Align(
                                                              alignment: Alignment.centerRight,
                                                              child: ( now.isBefore(limitTime) && orders.orderStatus=="wcf" &&  memEndChat==false ) ?
                                                              TweenAnimationBuilder<Duration>(
                                                                  duration: limitTime.difference(now),
                                                                  tween: Tween(begin: limitTime.difference(now), end: Duration.zero),
                                                                  onEnd: () {
                                                                    print('Timer ended');
                                                                    setState(() {
                                                                      isEndTime=true;
                                                                    });
                                                                  },
                                                                  builder: (BuildContext context, Duration value, Widget? child) {
                                                                    final minutes = value.inMinutes;
                                                                    final seconds = value.inSeconds % 60;
                                                                    return Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                                                        child: Text('${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                color: Colors.red,fontSize: 16)));
                                                                  })
                                                                  : SizedBox(),

                                                            ),
                                                            Center(
                                                              child: Text("รายการยาที่แนะนำ", style:themeData.textTheme.headline5,),
                                                            ),
                                                          ],),

                                                        Text(
                                                          od.medicine!.medName!,
                                                          style: themeData.textTheme.titleMedium ,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        (od.note != null ) ?
                                                        Text(
                                                          od.note!,
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ):
                                                        SizedBox(),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text.rich(
                                                                TextSpan(
                                                                  text: formatCurrency(od.sumprice!/od.quantity!),
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w600, color: Colors.black54),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: " x${od.quantity}",
                                                                        style: Theme.of(context).textTheme.bodyText1),
                                                                  ],
                                                                ),
                                                              ),
                                                              Text(
                                                                formatCurrency(od.sumprice!),
                                                                style: Theme.of(context).textTheme.bodyText1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    );

                                                  }),
                                              Column(
                                                children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text("รวม",
                                                          style: Theme.of(context).textTheme.bodyText1,
                                                        ),
                                                        Text(formatCurrency(orders.subtotalPrice! ),
                                                          style: Theme.of(context).textTheme.bodyText1,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text("ค่าจัดส่ง",
                                                          style: Theme.of(context).textTheme.bodyText1,
                                                        ),
                                                        Text(formatCurrency(orders.shippingCost! ),
                                                          style: Theme.of(context).textTheme.bodyText1,
                                                        ),
                                                      ],
                                                    ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text( "ส่วนลด",
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                      Text(formatCurrency(orders.discount! ),
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text("รวมทั้งหมด",
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                      Text(formatCurrency(orders.totalPrice! ),
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                    ],
                                                  ),

                                                  addVerticalSpace(5),

                                                  if( orders.orderStatus == "wcf" &&  now.isBefore(limitTime) && memEndChat==false )
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        curentUser_id == advice!.member!.MemberUsername ?
                                                        ElevatedButton(
                                                            style:  ElevatedButton.styleFrom(
                                                              primary: Colors.red, // Background color
                                                            ),
                                                            onPressed:()   {
                                                              showDialog<String>(
                                                                context: context,
                                                                builder: (BuildContext context) => AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  ),
                                                                  title:  Text('แจ้งเตือน' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red), ),
                                                                  content:  Text('ไม่ต้องการรับรายการยานี้ใช่หรือไม่', style: TextStyle( fontSize: 16),),
                                                                  actions: <Widget>[
                                                                    RaisedButton(
                                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                                      color: Colors.red,
                                                                      child: Text('ไม่ใช่', style: TextStyle(color: Colors.white),),
                                                                    ),
                                                                    RaisedButton(
                                                                      onPressed: () async {
                                                                        db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").doc(msg.messageId).collection("Orders").doc("${streamSnapshot.data!.docs.first.id}").update({"orderStatus": "pc" }).then((value) {
                                                                          Navigator.pop(context, 'OK');
                                                                          SchedulerBinding.instance!.addPostFrameCallback((_){
                                                                            if(scrollController.hasClients){
                                                                              scrollController.animateTo(
                                                                                  scrollController.position.maxScrollExtent,
                                                                                  duration: const Duration(milliseconds: 100),
                                                                                  curve: Curves.ease);
                                                                            }

                                                                          });

                                                                        }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));

                                                                      },
                                                                      color: COLOR_CYAN,
                                                                      child: Text('ใช่', style: TextStyle(color: Colors.white),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );

                                                            },
                                                            child:  Text( "ไม่ยืนยัน" ,)
                                                        )
                                                            :
                                                        ElevatedButton(
                                                            style:  ElevatedButton.styleFrom(
                                                              primary: Colors.red, // Background color
                                                            ),
                                                            onPressed:()  async {
                                                              showDialog<String>(
                                                                context: context,
                                                                builder: (BuildContext context) => AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  ),
                                                                  title:  Text('แจ้งเตือน' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red), ),
                                                                  content:  Text('ต้องการยกเลิกรายการยาใช่หรือไม่', style: TextStyle( fontSize: 16),),
                                                                  actions: <Widget>[
                                                                    RaisedButton(
                                                                      onPressed: () => Navigator.pop(context, 'OK'),
                                                                      color: Colors.red,
                                                                      child: Text('ไม่ใช่', style: TextStyle(color: Colors.white),),
                                                                    ),
                                                                    RaisedButton(
                                                                      onPressed: () async {
                                                                        db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").doc(msg.messageId).collection("Orders").doc("${streamSnapshot.data!.docs.first.id}").update({"orderStatus": "pc" }).then((value) {
                                                                          Navigator.pop(context, 'OK');
                                                                          SchedulerBinding.instance!.addPostFrameCallback((_){
                                                                            if(scrollController.hasClients){
                                                                              scrollController.animateTo(
                                                                                  scrollController.position.maxScrollExtent,
                                                                                  duration: const Duration(milliseconds: 100),
                                                                                  curve: Curves.ease);
                                                                            }

                                                                          });

                                                                        }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));
                                                                      },
                                                                      color: COLOR_CYAN,
                                                                      child: Text('ใช่', style: TextStyle(color: Colors.white),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );


                                                            },
                                                            child:  Text( "ยกเลิก" ,)
                                                        ),

                                                        addHorizontalSpace(10),

                                                        Visibility(
                                                          child:  ElevatedButton(
                                                            style:  ElevatedButton.styleFrom(
                                                              primary: Colors.green, // Background color
                                                            ),
                                                            child: Text('ยืนยัน'),
                                                            onPressed:() async {

                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => ConfirmOrder(listOrderdetail: listOrderdetail,advice:advice!, messageId: msg.messageId, ordersId: streamSnapshot.data!.docs.first.id,) ));

                                                            },
                                                          ),
                                                          visible:curentUser_id == advice!.member!.MemberUsername? true : false,
                                                        ),


                                                      ],
                                                    )
                                                ],
                                              )


                                            ],
                                          ),
                                        );

                                      }else{
                                        return SizedBox();
                                      }


                                    }
                                );


                              } else if (streamSnapshot.hasError) {
                                return forLoad_Error(streamSnapshot, themeData);
                              } else {
                                return SizedBox();
                              }
                            }),

                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe)
                  SizedBox(
                    width: 40,
                  ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat('HH:mm').format(msg.time!),
                  style: bodyTextTime,
                )
              ],
            ),
          ),
          if(isLast==true)
            Center(child: Column(
              children: [
                addVerticalSpace(20),
                Text("${advice!.member!.MemberUsername} จบการสนทนา",style: TextStyle(fontSize: 16),),
                addVerticalSpace(10),
              ],
            ))
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Color(0xFFF3F5F7), //Colors.white,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(255),
                  ],
                  controller: message_ctl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Aa',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    focusColor: Colors.cyan,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: COLOR_CYAN,
              onPressed: () async {
                if (message_ctl.text.isNotEmpty && message_ctl.text.trim() != "") {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    message.text = message_ctl.text;
                    message.messageType = "text";
                    message.time = DateTime.now();
                  });

                  db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").add(message.toDocument()).then((documentSnapshot) {
                    print("Added message with ID: ${documentSnapshot.id}");
                    db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").update({"lastTime": DateTimetoString(message.time!) });
                    setState(() {
                      message.text = "";
                      message_ctl.text = "";
                    });

                    SchedulerBinding.instance!.addPostFrameCallback((_){
                      // scrollController.jumpTo(scrollController.position.maxScrollExtent+70);
                      if(scrollController.hasClients){
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.ease);
                      }
                    });
                  }).catchError((error) {
                    print("Failed to add Message: $error");
                    buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                  });



                }else{
                  buildToast("กรุณากรอกข้อความ",Colors.red);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  memEndAdvice(Advice advice)  {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        title: const Text('แจ้งเตือน' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red), ),
        content: const Text('คุณต้องการจบการสนทนาใช่หรือไม่', style: TextStyle( fontSize: 16),),
        actions: <Widget>[
          RaisedButton(
            onPressed: ()  { Navigator.pop(context, );},
            color: Colors.red,
            child: Text('ไม่ใช่', style: TextStyle(color: Colors.white),),
          ),
          RaisedButton(
            onPressed: ()  {
              db.collection('${advice.pharmacist!.pharmacistID}').doc("${advice.member!.MemberUsername}").update({"isEnd": "memberEnd" }).then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPageMember()),
                );
                buildToast("จบการสนทนา",Colors.green);

              }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));

            },
            color: COLOR_CYAN,
            child: Text('ใช่', style: TextStyle(color: Colors.white),),
          ),

        ],
      ),
    );
  }

  showMemEndAdvice(){
    db.collection('${advice!.pharmacist!.pharmacistID}').where("isEnd",isEqualTo: "memberEnd").where('adviceId',isEqualTo: advice!.adviceId).snapshots().listen(
          (event) {
        print("${event.docs}");
        if( curentUser_id == advice!.pharmacist!.pharmacistID){
          showDialog<String>(
            barrierColor: Color(0x1F000000),
            context: context,
            builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              title: const Text('แจ้งเตือน' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red), ),
              content: const Text('ลูกค้าออกจากการสนทนาแล้ว กรุณาบันทึกข้อมูลคำปรึกษา', style: TextStyle( fontSize: 16),),
              actions: <Widget>[
                RaisedButton(
                  onPressed: ()  {Navigator.pop(context);  },
                  color: COLOR_CYAN,
                  child: Text('ตกลง', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          );
        }
        print("Listen pass: ");
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }
}
