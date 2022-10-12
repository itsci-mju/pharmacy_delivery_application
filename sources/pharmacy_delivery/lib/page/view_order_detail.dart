import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/orders_api.dart';
import 'package:pharmacy_delivery/api/review_api.dart';
import 'package:pharmacy_delivery/page/change_delivery_status.dart';
import 'package:pharmacy_delivery/page/list_order.dart';
import 'package:pharmacy_delivery/page/list_payment.dart';
import 'package:pharmacy_delivery/page/main_page_member.dart';
import 'package:pharmacy_delivery/page/pharmacist_home_page.dart';
import 'package:pharmacy_delivery/page/view_drugstore.dart';
import 'package:pharmacy_delivery/page/view_receipt.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../api/orderDetail_api.dart';
import '../class/Advice.dart';
import '../class/Member.dart';
import '../class/OrderDetail.dart';
import '../class/Orders.dart';
import '../class/Review.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/payment_widget.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';

class ViewOrderDetail extends StatefulWidget {
  final Advice advice;
  final int tab_index;
  final String backPage;
  const ViewOrderDetail({Key? key, required this.advice, required this.tab_index, required this.backPage}) : super(key: key);

  @override
  State<ViewOrderDetail> createState() => _ViewOrderDetailState();
}

class _ViewOrderDetailState extends State<ViewOrderDetail> {
  int score = 0;
  String comment ="";
  //bool test_btn = false;
  TextEditingController review_ctl = TextEditingController();
  List<OrderDetail>? listOrderDetail;
  Member? member = Member();

  Map<String, dynamic>? paymentIntentData;

  Future getListOrderDetail() async {
    final listOrderDetail = await OrderDetailApi.listOrderDetail(widget.advice.orders!.orderId!);
    setState(() {
      this.listOrderDetail = listOrderDetail ;
    });
  }

  Future getMember() async {
    final member = await UserSecureStorage.getMember() ;
    setState(() {
      this.member = member;
    });
  }

  @override
  void initState() {
    super.initState();
    getMember();
    getListOrderDetail();
    review_ctl.text=="";
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding,vertical: 5);
    Advice advice = widget.advice;
    Orders orders = advice.orders!;

    var dateNow = DateTime(DateTime.now().year+543, DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,DateTime.now().second,DateTime.now().millisecond);

    return  WillPopScope(
      onWillPop: () {
        return Future.value(false);
        //return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
            "รายละเอียดคำสั่งซื้อ",
            style: TextStyle(fontSize: 18),
          ),
          leading: BackButton(
            onPressed: () {
              if(widget.backPage=="ListPayment"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PharmacistHomePage(tab_index:widget.tab_index)));
              }else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MainPageMember(tab_index:widget.tab_index)));
              }

            },
          ),
          backgroundColor: member!.MemberUsername==null? COLOR_ORANGE: COLOR_CYAN,
         // automaticallyImplyLeading: false,
        ),
        backgroundColor: Color(0xFFF3F5F7),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
            width: size.width,
           // height: size.height,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color : Colors.amberAccent.withOpacity(0.5),
                      ),
                      child: Padding(
                          padding: sidePadding,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if(orders.orderStatus=="cf" && dateNow.isBefore(orders.orderDate!.add(Duration(hours: 24))) )
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "สถานะ : รอการชำระเงิน",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                        member!.MemberUsername!=null?
                                      "กรุณาชำระเงินภายใน ${DateFormat('dd-MM-yyyy HH:mm').format( orders.orderDate!.add(Duration(hours: 24)))}"
                                      : "หมดเวลาการชำระเงิน ${DateFormat('dd-MM-yyyy HH:mm').format( orders.orderDate!.add(Duration(hours: 24)))}",

                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                )
                                else if(orders.orderStatus=="store")
                                  Row(
                                    children: [
                                      Text(
                                        "สถานะ : รอมารับที่ร้านขายยา",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                else if(orders.orderStatus=="wt")
                                  Row(
                                      children: [
                                        Text(
                                          "สถานะ : กำลังเตรียมการจัดส่ง",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                else if(orders.orderStatus=="T" )
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "สถานะ : จัดส่งแล้ว",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if( orders.address!=null)
                                      Text(
                                        "เลขพัสดุ :${orders.trackingNumber} (${orders.shippingCompany}) ",
                                        style: TextStyle(
                                          color: Colors.black54,),
                                      ),

                                    ],
                                  )

                                else if(orders.orderStatus=="C"  )
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "สถานะ : ถูกยกเลิก",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                      ],
                                    )
                                else if((orders.orderStatus=="cf" && dateNow.isAfter(orders.orderDate!.add(Duration(hours: 24)))))
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "สถานะ : คำสั่งซื้อหมดอายุชำระเงิน",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                      ],
                                    )
                          ]
                          )
                      ),
                    ),
                    addVerticalSpace(5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child:  Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        //height: size.height *0.3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: sidePadding,
                          child:  orders.address !=null ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(Icons.location_pin,size: 25,),
                                  addHorizontalSpace(5),
                                  Text(
                                    "ที่อยู่ในการจัดส่ง",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              Text(
                                orders.address!.name!,
                                style: TextStyle(
                                  color: Colors.black54,fontSize: 14.0,),
                              ),
                              Text(
                                formatPhone(orders.address!.tel!),
                                style: TextStyle(
                                  color: Colors.black54,fontSize: 14.0,),
                              ),
                              Text(
                                orders.address!.addressDetail!,
                                style: TextStyle(
                                  color: Colors.black54,fontSize: 14.0,),
                              ),


                            ],
                          )
                              :
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Icon(Icons.location_pin,size: 25,),
                                    addHorizontalSpace(5),
                                    Text(
                                      "รับยาที่ร้าน",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.symmetric(horizontal: 5),
                      child:  Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: sidePadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(Icons.store,size: 25,),
                                  addHorizontalSpace(5),
                                  Text(
                                    advice.pharmacist!.drugstore!.drugstoreName!,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:listOrderDetail!=null? listOrderDetail!.length :0,
                                  itemBuilder: (context, index) {
                                    OrderDetail od = listOrderDetail![index];
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 88,
                                              child: AspectRatio(
                                                aspectRatio: 0.88,
                                                child: Container(
                                                  //padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white ,//Color(0xFFF5F6F9),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child:  Image.network(od.medicine!.medImg?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fno_img.jpg?alt=media&token=588042db-f5cd-4706-abb5-30370a9e8ae0'
                                                    ,height: 250,width: size.width,),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 240,
                                                    child: Text(
                                                      od.medicine!.medName!,
                                                      style: Theme.of(context).textTheme.bodyText1,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),

                                                  if (od.note != null)
                                                    Text(
                                                      od.note.toString(),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),

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
                                                          style: TextStyle(
                                                              color: COLOR_CYAN,
                                                              fontSize: 16
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        if (od != listOrderDetail![listOrderDetail!.length-1])
                                          Divider(
                                            color: Colors.grey,
                                            thickness: 0.5,
                                          ) ,
                                      ],
                                    );
                                  }),

//////////////////////////////////////////////////////////////////////////////////////////////////////
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child:  Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        //height: size.height *0.3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding:  sidePadding,
                          child:  Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("รวม",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    formatCurrency(orders.subtotalPrice! ),
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
                                  Text(
                                    formatCurrency(orders.shippingCost! ),
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("ส่วนลด",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text( formatCurrency(orders.coupon==null? 0 : orders.coupon!.discount! ) ,
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
                                  Text(
                                    formatCurrency(orders.totalPrice! ),
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),

                              addVerticalSpace(5),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child:  Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding:  sidePadding,
                          child:  Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("หมายเลขคำสั่งซื้อ",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    orders.orderId!,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("วันที่สั่งซื้อ",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                  Text(
                                    DateFormat('dd-MM-yyyy HH:mm').format(orders.orderDate!),
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),

                              if(orders.payDate!=null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("วันที่ชำระเงิน",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                  Text( DateFormat('dd-MM-yyyy HH:mm').format(orders.payDate!) ,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),

                              if(orders.shippingDate!=null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(  "วันที่จัดส่ง" ,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    Text( DateFormat('dd-MM-yyyy HH:mm').format(orders.shippingDate!) ,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child:  Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        width: double.infinity,
                        child: Padding(
                          padding:  sidePadding,
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if(orders.orderStatus=="cf" && dateNow.isBefore(orders.orderDate!.add(Duration(hours: 24))) && member!.MemberUsername!=null  )
                              Container(
                                width: size.width *0.4,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    primary: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed:()  {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        title:  Text('แจ้งเตือน' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red), ),
                                        content:  Text('ต้องการยกเลิกคำสั่งซื้อใช่หรือไม่', style: TextStyle( fontSize: 16),),
                                        actions: <Widget>[
                                          RaisedButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            color: Colors.red,
                                            child: Text('ไม่ใช่', style: TextStyle(color: Colors.white),),
                                          ),
                                          RaisedButton(
                                            onPressed: () async {
                                              final cancelOrder = await OrdersApi.cancelOrder_member(orders, advice.pharmacist!.drugstore!.drugstoreID!);
                                              if(cancelOrder==1){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => MainPageMember(tab_index: 4)));
                                                buildToast("ยกเลิกคำสั่งซื้อสำเร็จ",Colors.green);
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
                                  child: Text(
                                    "ยกเลิกคำสั่งซื้อ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              if(orders.payDate!=null)
                              Container(
                                  width: size.width *0.4,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape:
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                      primary: Colors.white,
                                      backgroundColor: COLOR_CYAN,
                                    ),
                                    onPressed:()  {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewReceipt(advice: advice,back: 1, backPage: widget.backPage,tab_index: widget.tab_index,)));

                                    },
                                    child: Text(
                                      "ใบเสร็จ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        bottomNavigationBar:
        orders.orderStatus=="cf" && dateNow.isBefore(orders.orderDate!.add(Duration(hours: 24))) && member!.MemberUsername!=null ? // ชำระเงิน
        Container(
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
                  width: size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      primary: Colors.white,
                      backgroundColor: COLOR_CYAN,
                    ),
                    onPressed:()  async {
                      print(advice.orders!.totalPrice!.toInt());
                      await makePayment(advice.orders!.totalPrice!.toInt().toString());
                      },
                    child: Text(
                      "ชำระเงิน",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        : (orders.orderStatus=="T" && orders.review==null && member!.MemberUsername!=null)? //รีวิว
        Container(
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
                  width: size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      primary: Colors.white,
                      backgroundColor: COLOR_CYAN,
                    ),
                    onPressed:()  {
                      setState(() {
                        score=0;
                        comment ="";
                        review_ctl.text="";
                        //test_btn=false;
                      });
                      showDialog<String>(context: context, builder: (BuildContext context) => Dialog(
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
                                      Row(
                                        children: [
                                          Icon(Icons.store,size: 25,),
                                          addHorizontalSpace(5),
                                          Text(
                                            advice.pharmacist!.drugstore!.drugstoreName!,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Divider(
                                          color: Colors.black87,
                                          thickness: 1,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                           "คะแนนรีวิว",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          addHorizontalSpace(5),
                                          SmoothStarRating(
                                            isReadOnly: false,
                                            allowHalfRating: false,
                                            onRated: (value) {
                                              setState(() {
                                                score = value.toInt();
                                              });

                                            },
                                            starCount: 5,
                                            rating: 0,
                                            size: 20,
                                            color: Colors.orange,
                                            borderColor: Colors.orange,
                                          ),
                                          addHorizontalSpace(10),
                                        ],
                                      ),
                                      addVerticalSpace(5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          addVerticalSpace(5),
                                          TextFormField(
                                            validator: (value) {},
                                            keyboardType: TextInputType.text,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(255),
                                            ],
                                            onChanged: (value){
                                              setState(() {
                                                comment=value;
                                              });
                                            },
                                            maxLines: 5,
                                            controller: review_ctl,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                              hintText: "เขียนรีวิว",
                                              border: OutlineInputBorder(),
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
                                          child: Text('รีวิวร้านขายยา', style: TextStyle(color: Colors.white),),
                                          onPressed:
                                           () async {
                                              if(score==0 || comment.trim()=="" || comment== null ){
                                                 buildToast("กรุณากรอกข้อมูลรีวิวให้ครบ", Colors.red);
                                              }else{
                                                EasyLoading.show();
                                                Review review = Review(score: score,comment: comment );
                                                final addReview = await ReviewApi.addReview(orders.orderId!, review);
                                                EasyLoading.dismiss();
                                                if(addReview==1){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ViewDrugstore(drugstore: advice.pharmacist!.drugstore!,backpage: "ListOrder",) ));
                                                  buildToast("รีวิวร้านขายยาสำเร็จ",Colors.green);
                                                }else{
                                                  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                                                }
                                              }
                                              }

                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          )
                      ),);

                    },
                    child: Text(
                      "รีวิวร้านขายยา",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        : ( orders.payDate!=null && orders.orderStatus=="store" && member!.MemberUsername==null )?  //รับยาที่ร้านเรียบร้อย
        Container(
          padding: EdgeInsets.all(10),
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
                  width: size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      primary: Colors.white,
                      backgroundColor: COLOR_CYAN,
                    ),
                    onPressed:()  {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          title:  Text('แจ้งเตือน' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red), ),
                          content:  Text('ลูกค้ามารับยาที่ร้านแล้วใช่หรือไม่', style: TextStyle( fontSize: 16),),
                          actions: <Widget>[
                            RaisedButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              color: Colors.red,
                              child: Text('ไม่ใช่', style: TextStyle(color: Colors.white),),
                            ),
                            RaisedButton(
                              onPressed: () async {
                                final successOrder = await OrdersApi.successStoreOrder(orders.orderId!);
                                if(successOrder!=0){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PharmacistHomePage(tab_index: 3)));
                                  buildToast("จัดส่งยาให้ลูกค้าสำเร็จ",Colors.green);

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
                    child: Text(
                      "รับยาที่ร้านเรียบร้อย",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        : ( orders.payDate!=null && orders.orderStatus=="wt" && member!.MemberUsername==null )? //เพิ่มเลขพัสดุ
        Container(
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
                  width: size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      primary: Colors.white,
                      backgroundColor: COLOR_CYAN,
                    ),
                    onPressed:()  {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeDeliveryStatus(advice: advice,)));
                    },
                    child: Text(
                      "เพิ่มเลขพัสดุ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        :
        SizedBox()

      ),
    );
  }


  Future<void> makePayment(String amount) async {
    try {
      paymentIntentData = await PaymentWidget.createPaymentIntent(amount, 'THB');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              testEnv: true,
              style: ThemeMode.light,
              merchantCountryCode: 'TH',
              merchantDisplayName: 'Pharmacy Health Mate')).then((value){
      });

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue) async {

        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());

        String receiptId = paymentIntentData!['created'].toString();

        Advice new_advice =await OrdersApi.payOrders(widget.advice, receiptId);
        if(new_advice!=0){

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewReceipt(advice: new_advice,back: 1, backPage: widget.backPage, tab_index: widget.tab_index,)));

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green,),
              Text("ชำระเงินสำเร็จ",style: TextStyle(fontSize: 16),),
            ],
          ),));


        }else{
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children:  [
                        Icon(Icons.error_rounded, color: Colors.red,size: 20,),
                        addHorizontalSpace(10),
                        Text("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  ],
                ),
              ));
        }

        paymentIntentData = null;


      }).onError((error, stackTrace){
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

}
