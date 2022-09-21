import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/address_api.dart';
import 'package:pharmacy_delivery/api/message_api.dart';
import 'package:pharmacy_delivery/api/orderDetail_api.dart';
import 'package:pharmacy_delivery/api/orders_api.dart';
import 'package:pharmacy_delivery/class/OrderDetail.dart';
import 'package:pharmacy_delivery/page/confirm_order.dart';
import 'package:pharmacy_delivery/page/list_order.dart';
import 'package:pharmacy_delivery/page/main_page_member.dart';
import 'package:pharmacy_delivery/page/search_medicine.dart';
import 'package:pharmacy_delivery/page/view_drugstore.dart';

import '../api/advice_api.dart';
import '../class/Address.dart';
import '../class/Advice.dart';
import '../class/Cart.dart';
import '../class/Member.dart';
import '../class/Message.dart';
import '../class/Pharmacist.dart';
import '../class/Stock.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/storage_image.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';

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
  String curentUser_id = "60001";
  //String curentUser_id = "manee123";
  Pharmacist pharmacist = Pharmacist();
  Member member = Member();
  List<Message> listMessage = [];
  Future<List<Message>>? message_Future ;
  //List<OrderDetail> listOrderdetail =[];
  Future<List<OrderDetail>>? listOderdetail_Future ;
  TextEditingController message_ctl = TextEditingController();
  ScrollController scrollController = ScrollController();
  Message message = Message();
  Advice? advice;
  Address? address;
  //Future<String>? membereImg_Future ;
  //Future<String>? pharmacistImg_Futute;

  List<Cart>? cart=[];
  int sumQTY=0;
  String shipping = "";

  final adviceTitle = TextEditingController();
  final adviceDetail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

//  StreamController<List<Message>> chatController =new StreamController();
  Future getMember() async {
    Member member = await UserSecureStorage.getMember();
    setState(() {
      this.member = member;
    });

  }
  Future getPharmacist() async {
    final pharmacist = await UserSecureStorage.getPharmacist();
    setState(() {
      this.pharmacist = pharmacist;
    });
  }

  Future getAddress(String addressId) async {
    final address = await AddressApi.fetchAddress(addressId) ;
      setState(() {
        this.address = address;
      });

  }


  @override
  void initState() {
    super.initState();
   //chatController = new StreamController();
  // Timer.periodic(Duration(seconds: 1), (_) => loadChat());
   // message_Future=MessageApi.getListMessage(widget.advice.adviceId.toString());
    getPharmacist();
    //getMember();
    getAddress(widget.advice.adviceDetail!);

    setState(()  {
      shipping =widget.shipping?? "";
      cart=widget.cart;
      cart ??= [];

      for(Cart c in cart!){
        sumQTY+= c.quantity!;
      }

    });
    //membereImg_Future = StorageImage().downloadeURL("member",widget.advice.member!.MemberImg?? 'user.png');
    //pharmacistImg_Futute = StorageImage().downloadeURL("pharmacist",widget.advice.pharmacist!.pharmacistImg?? 'user.png');

  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    setState(() {
      //curentUser_id = "manee123";
      curentUser_id = "60001";

      advice = widget.advice;
      message.advice = advice;
      message.sender = curentUser_id;
      if (curentUser_id == advice!.member!.MemberUsername) {
        message.recipient = advice!.pharmacist!.pharmacistID;
      } else {
        message.recipient = advice!.member!.MemberUsername;
      }
    });

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
        //return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child:  Text(
                  'End',
                ),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                      fontSize: 16,
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
                            Form(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              key: _formKey,
                              child: Container(
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
                                        child: Text(
                                          "สิ้นสุดการสนทนา",
                                          style:TextStyle( fontSize: 18, color: Colors.black),textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Divider(
                                          color: Colors.black87,
                                          thickness: 1,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("หัวข้อคำปรึกษา",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,),
                                          ),
                                          addVerticalSpace(5),
                                          TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty )
                                                return  "* กรุณากรอกหัวข้อคำปรึกษา";
                                              else
                                                return null;
                                            },
                                            keyboardType: TextInputType.text,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(50),
                                            ],
                                            controller: adviceTitle,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                              hintText: "หัวข้อคำปรึกษา",
                                              border: OutlineInputBorder(
                                                //borderRadius: BorderRadius.circular(12),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: COLOR_CYAN),
                                              ),
                                              errorBorder: new OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red),
                                              ),
                                            ),
                                            style: TextStyle( fontSize: 16,color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      addVerticalSpace(10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("รายละเอียดคำปรึกษา",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,),
                                          ),
                                          addVerticalSpace(5),
                                          TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty )
                                                return  "* กรุณากรอกรายละเอียดคำปรึกษา";
                                              else
                                                return null;
                                            },
                                            keyboardType: TextInputType.text,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(255),
                                            ],
                                            controller: adviceDetail,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                              hintText: "รายละเอียดคำปรึกษา",
                                              border: OutlineInputBorder(
                                                //borderRadius: BorderRadius.circular(12),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: COLOR_CYAN),
                                              ),
                                              errorBorder: new OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red),
                                              ),
                                            ),
                                            style: TextStyle( fontSize: 16,color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      addVerticalSpace(10),
                                      Center(
                                        child: RaisedButton(
                                          color: COLOR_CYAN,
                                          child: Text('บันทึก', style: TextStyle(color: Colors.white),),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              advice!.adviceTitle = adviceTitle.text;
                                              advice!.adviceDetail = adviceDetail.text;

                                              final endAdvice = await AdviceApi.endAdvice(advice!);
                                              if(endAdvice==1){
                                                buildToast("บันทึกสำเร็จ แล้วกลับไปหน้า Home ของเภสัช",Colors.pinkAccent);
                                              }else{
                                                buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                                              }
                                            }

                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )
                    ),)
                      : endAdvice( advice!);

                },
              ),

              curentUser_id == advice!.pharmacist!.pharmacistID
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage( advice!.member!.MemberImg ?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fuser.png?alt=media&token=5842fcab-a485-4e4a-936a-f157dd0da815')),


                  SizedBox(width: 20 * 0.75),

                  Text(
                    advice!.member!.MemberName!,
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
              curentUser_id == advice!.member!.MemberUsername
                  ? addHorizontalSpace(30)
                  : cart!.length>0
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
                  if(advice!.orders==null ){
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => SearchMedicine(
                              advice: advice!, shipping: shipping, recipient: message.recipient!, address: address ,
                            )));
                  }else{
                    DateTime now = DateTime(DateTime.now().year+543, DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,DateTime.now().second,DateTime.now().millisecond);
                    DateTime limitTime = advice!.orders!.orderDate!.add(Duration(minutes: 10));
                    if((now.isAfter(limitTime) && advice!.orders!.orderStatus=="wcf")){
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
                          content:  Text(advice!.orders!.orderStatus=="cf"? 'ลูกค้ายืนยันรายการยาเรียบร้อยแล้ว' : 'กรุณายกเลิกรายการยาล่าสุดก่อนเพิ่มรายการยาใหม่', style: TextStyle( fontSize: 16),),
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

                  }

                },
                icon: Icon(
                  Icons.medical_services,
                  size: 30,
                ),
              ),
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
                      child: FutureBuilder<List<Message>>(
                          future:MessageApi.getListMessage(advice!.adviceId.toString()),  //chatController.stream, // MessageApi.chat(advice!.adviceId.toString()),//  message_Future,
                          builder: (context, snapShot) {
                            if( (snapShot.hasData && snapShot.data!.isNotEmpty) || (snapShot.connectionState == ConnectionState.waiting) ){
                              if (snapShot.hasData && snapShot.data!.isNotEmpty) {
                                listMessage = snapShot.data!;
/*
                                SchedulerBinding.instance!.addPostFrameCallback((_){
                                  // scrollController.jumpTo(scrollController.position.maxScrollExtent+70);
                                  if(scrollController.hasClients){
                                    scrollController.animateTo(
                                        scrollController.position.maxScrollExtent,
                                        duration: const Duration(milliseconds: 100),
                                        curve: Curves.ease);
                                  }
                                });

 */
                              }

                              return ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  // reverse: true,
                                  padding: EdgeInsets.only(top: 15),
                                  itemCount: listMessage.length,
                                  itemBuilder: (BuildContext context, int index) {

                                    final Message msg = listMessage[index]; //List.from(listMessage.reversed)[index];
                                    bool isMe = msg.sender == curentUser_id;
                                    return  _buildMessage(msg, isMe);
                                  }
                              );
                            }
                            else if (snapShot.hasError) {
                              return forLoad_Error(snapShot, themeData);
                            } else {
                              return SizedBox();
                            }


                          }
                      )

                  )),
            ),
            _buildMessageComposer(),
          ],
        ),

      ),
    );
  }

  _buildMessage(Message msg, bool isMe,)   {
    final ThemeData themeData = Theme.of(context);
    if(msg.messageType!="text"){
      listOderdetail_Future = OrderDetailApi.listOrderDetail(msg.messageType.toString());
    }


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
                        FutureBuilder<List<OrderDetail>>(
                            future:  listOderdetail_Future ,// OrderDetailApi.listOrderDetail(msg.messageType!),
                            builder: (context, snapShot) {
                              if ( (snapShot.hasData && snapShot.data!.isNotEmpty)  && (snapShot.connectionState != ConnectionState.waiting) ){
                               /* if (snapShot.hasData && snapShot.data!.isNotEmpty && snapShot.data != null){
                                  listOrderdetail = snapShot.data?? [];
                                }
                                */
                                List<OrderDetail> listOrderdetail =snapShot.data!;

                                DateTime now = DateTime(DateTime.now().year+543, DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,DateTime.now().second,DateTime.now().millisecond);

                                DateTime limitTime = listOrderdetail[0].orders!.orderDate!.add(Duration(minutes: 10));
                                print("222222222");
                                print(limitTime.difference(now));

                                return Container(
                                  decoration:  listOrderdetail[0].orders!.orderStatus == "pc" ||  (now.isAfter(limitTime) && listOrderdetail[0].orders!.orderStatus=="wcf") ?
                                  BoxDecoration(
                                      image: DecorationImage(
                                        image:AssetImage("assets/images/cancelled_stamp.png")  ,
                                        fit: BoxFit.fitWidth,
                                      )
                                  ) :
                                    listOrderdetail[0].orders!.orderStatus == "cf" || listOrderdetail[0].orders!.orderStatus == "store" || listOrderdetail[0].orders!.orderStatus == "wt" ?
                                    BoxDecoration(
                                      image: DecorationImage(
                                      image: AssetImage("assets/images/confirm_stamp.png") ,
                                      fit: BoxFit.fitWidth,
                                      )
                                    )
                                      : BoxDecoration(),

                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemCount:snapShot.data!.isNotEmpty ? snapShot.data!.length : 0 ,
                                          itemBuilder: (context, index) {
                                              OrderDetail od = OrderDetail();
                                              od= snapShot.data![index];

                                              return  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if(index==0)
                                                    Column(children: [
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child:  now.isBefore(limitTime) && od.orders!.orderStatus=="wcf"?
                                                        TweenAnimationBuilder<Duration>(
                                                            duration: limitTime.difference(now),
                                                            tween: Tween(begin: limitTime.difference(now), end: Duration.zero),
                                                            onEnd: () {
                                                              print('Timer ended');
                                                            },
                                                            builder: (BuildContext context, Duration value, Widget? child) {
                                                              final minutes = value.inMinutes;
                                                              final seconds = value.inSeconds % 60;
                                                              return Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                                  child: Text( now.isBefore(limitTime) && od.orders!.orderStatus=="wcf"?
                                                                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
                                                                  :
                                                                      'หมดอายุ',
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
                                      if (listOrderdetail.isNotEmpty ) Column(
                                        children: [
                                          if(listOrderdetail[0].orders!.address!=null)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("รวม",
                                                style: Theme.of(context).textTheme.bodyText1,
                                              ),
                                              Text(formatCurrency(listOrderdetail[0].orders!.subtotalPrice! ),
                                                style: Theme.of(context).textTheme.bodyText1,
                                              ),
                                            ],
                                          ),
                                          if(listOrderdetail[0].orders!.address!=null)
                                            Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("ค่าจัดส่ง",
                                                style: Theme.of(context).textTheme.bodyText1,
                                              ),
                                              Text(formatCurrency(listOrderdetail[0].orders!.shippingCost! ),
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
                                              Text(formatCurrency(listOrderdetail[0].orders!.totalPrice! ),
                                                style: Theme.of(context).textTheme.bodyText1,
                                              ),
                                            ],
                                          ),

                                          addVerticalSpace(5),

                                         if( listOrderdetail[0].orders!.orderStatus == "wcf" &&  now.isBefore(limitTime) )
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
                                                            final pCancelOrder = await OrdersApi.pCancelOrder(msg.messageType!,advice!);
                                                            if(pCancelOrder!=0){
                                                              setState(() {
                                                                advice!.orders=null;
                                                                //listMessage=listMessage;
                                                              });
                                                              Navigator.pop(context, 'OK');
                                                              SchedulerBinding.instance!.addPostFrameCallback((_){
                                                                // scrollController.jumpTo(scrollController.position.maxScrollExtent+70);
                                                                if(scrollController.hasClients){
                                                                  scrollController.animateTo(
                                                                      scrollController.position.maxScrollExtent,
                                                                      duration: const Duration(milliseconds: 100),
                                                                      curve: Curves.ease);
                                                                }

                                                              });

                                                            }else{
                                                              buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                                                            }
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
                                                              final pCancelOrder = await OrdersApi.pCancelOrder(msg.messageType!,advice!);
                                                              if(pCancelOrder!=0){
                                                                buildToast("ยกเลิกรายการยาสำเร็จ",Colors.green);
                                                                setState(() {
                                                                  advice!.orders=null;
                                                                 // listMessage=listMessage;
                                                                });
                                                                Navigator.pop(context, 'OK');
                                                                SchedulerBinding.instance!.addPostFrameCallback((_){
                                                                  // scrollController.jumpTo(scrollController.position.maxScrollExtent+70);
                                                                  if(scrollController.hasClients){
                                                                    scrollController.animateTo(
                                                                        scrollController.position.maxScrollExtent,
                                                                        duration: const Duration(milliseconds: 100),
                                                                        curve: Curves.ease);
                                                                  }

                                                                });

                                                              }else{
                                                                buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                                                              }
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
                                                            builder: (context) => ConfirmOrder(listOrderdetail: listOrderdetail,advice:advice!) ));
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
                              } else if (snapShot.hasError) {
                                return forLoad_Error(snapShot, themeData);
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
          )
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
                  });
                  final resultMessage = await MessageApi.addMessage(message);
                  if (resultMessage != 0) {
                    // getListMessage();
                   // message_Future= MessageApi.getListMessage(widget.advice.adviceId.toString());
                    //message_ctl.clear();
                    setState(() {
                      message_ctl.text = "";
                      // listMessage.add(resultMessage);
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


                  } else {
                    buildToast("ส่งข้อความไม่สำเร็จ กรุณาลองใหม่อีกครั้ง",Colors.red);
                  }
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

  endAdvice(Advice advice)  {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPageMember()),
                );
            },
            color: COLOR_CYAN,
            child: Text('ใช่', style: TextStyle(color: Colors.white),),
          ),

        ],
      ),
    );



  }
}
