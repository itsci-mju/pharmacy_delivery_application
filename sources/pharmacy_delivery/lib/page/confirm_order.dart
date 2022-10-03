import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pharmacy_delivery/api/address_api.dart';
import 'package:pharmacy_delivery/api/advice_api.dart';
import 'package:pharmacy_delivery/api/coupon_api.dart';
import 'package:pharmacy_delivery/api/drugstores_api.dart';
import 'package:pharmacy_delivery/api/orders_api.dart';
import 'package:pharmacy_delivery/class/Advice.dart';
import 'package:pharmacy_delivery/class/OrderDetail.dart';
import 'package:pharmacy_delivery/page/add_address.dart';
import 'package:pharmacy_delivery/page/list_address.dart';
import 'package:pharmacy_delivery/page/search_drugstore.dart';
import 'package:pharmacy_delivery/page/view_receipt.dart';
import 'package:pharmacy_delivery/utils/custom_functions.dart';
import 'package:pharmacy_delivery/utils/widget_functions.dart';

import '../api/orderDetail_api.dart';
import '../class/Address.dart';
import '../class/Coupon.dart';
import '../class/Drugstore.dart';
import '../class/Orders.dart';
import '../utils/constants.dart';
import '../utils/payment_widget.dart';
import 'chat_screen.dart';

class ConfirmOrder extends StatefulWidget {
  final List<OrderDetail>? listOrderdetail;
  final Advice advice;
  final String? messageId;
  final String? ordersId;


  const ConfirmOrder({Key? key,  this.listOrderdetail,  required this.advice, this.messageId, this.ordersId, }) : super(key: key);

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  String? couponName ;
  TextEditingController coupon_ctl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final db =FirebaseFirestore.instance;

  double discount = 0;
  double total = 0;

  double limitprice=0;

  Orders? orders;
  Advice? advice;

  Map<String, dynamic>? paymentIntentData;

  Future checkShowCoupon(String drugstoreId) async {
    final minPrice= await CouponApi.minCoupon(drugstoreId);
    if( widget.listOrderdetail![0].orders!.subtotalPrice! >= minPrice){
      setState(() {
        limitprice= minPrice;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkShowCoupon(widget.advice.pharmacist!.drugstore!.drugstoreID!);
    setState(() {
      total =  widget.listOrderdetail![0].orders!.totalPrice! - discount;
       orders =  widget.listOrderdetail![0].orders;
       advice = widget.advice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding,vertical: 5);
    List<OrderDetail> listOrderDetail = widget.listOrderdetail!;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
        //return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ยืนยันคำสั่งซื้อ",
            style: TextStyle(fontSize: 18),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(advice: advice!,shipping: "")));
            },
          ),
          backgroundColor: COLOR_CYAN,
        ),
        backgroundColor: Color(0xFFF3F5F7),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      child:
                      widget.listOrderdetail![0].orders!.address !=null ?
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.listOrderdetail![0].orders!.address!.name!,
                                style: TextStyle(
                                  color: Colors.black54,fontSize: 14.0,),
                              ),
                              Text(
                                widget.listOrderdetail![0].orders!.address!.tel!,
                                style: TextStyle(
                                  color: Colors.black54,fontSize: 14.0,),
                              ),
                              Text(
                                widget.listOrderdetail![0].orders!.address!.addressDetail! ,
                                style: TextStyle(
                                  color: Colors.black54,fontSize: 14.0,),
                              ),
                            ],
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
                              advice!.pharmacist!.drugstore!.drugstoreName!,
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
                            itemCount:listOrderDetail.length ,
                            itemBuilder: (context, index) {
                              OrderDetail od = listOrderDetail[index];
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
                                              //padding: EdgeInsets.only(right: 15),
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
                                  if (od != listOrderDetail[listOrderDetail.length-1])
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ) ,
                                ],
                              );
                            }),



                      ],
                    ),
                  ),
                ),
              ),

              if(limitprice!=0)
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
                      padding: sidePadding,
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "โค้ดส่วนลด",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            addHorizontalSpace(40),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  RegExp regex = RegExp(r'^[A-Za-z0-9]{1,10}$');
                                  if ( !regex.hasMatch(value!) && value.trim()!="" )
                                    return  "* กรุณากรอกโค้ดส่วนลดให้ถูกต้อง";
                                  else
                                    return null;
                                },
                                onChanged: (value){
                                  setState(() {
                                    couponName = value;
                                  });
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]'),),
                                ],
                                controller: coupon_ctl,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(height: 1),
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  hintText: "กรอกโค้ดส่วนลด",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: COLOR_CYAN),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  errorBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                style: TextStyle( fontSize: 14,color: Colors.black),
                              ),
                            ),
                            addHorizontalSpace(10),
                            ElevatedButton(
                              style:  ElevatedButton.styleFrom(
                                primary: COLOR_CYAN, // Background color
                              ),
                              onPressed:
                              couponName=="" ||couponName ==null ?
                              null
                                  :
                                  () async {
                                if (_formKey.currentState!.validate()){
                                  FocusScope.of(context).unfocus();
                                  final coupon = await CouponApi.checkCoupon(advice!.pharmacist!.drugstore!.drugstoreID!, coupon_ctl.text);
                                  if(coupon!=null){
                                    if( orders!.subtotalPrice! >= coupon.minimumPrice){
                                      setState(() {
                                        orders!.coupon = coupon;

                                        discount = coupon.discount!;
                                        total = orders!.totalPrice! - discount;
                                        // orders!.totalPrice =  orders.totalPrice! - discount;
                                        coupon_ctl.text="";
                                        couponName="";

                                        buildToast("ใช้โค้ดส่วนลดสำเร็จ", Colors.green);
                                      });
                                    }else{
                                      buildToast("ไม่สามารถใช้โค้ดส่วนลดได้", Colors.orange);
                                    }

                                  }else{
                                    buildToast("โค้ดไม่ถูกต้อง หรือโค้ดถูกใช้ครบแล้ว", Colors.red);
                                  }
                                }
                              },
                              child: Text('ใช้โค้ด'),
                            )


                          ],
                        ),
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
                    child:   Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("รวม",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(formatCurrency(orders!.subtotalPrice! ),
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
                            Text(formatCurrency(orders!.shippingCost! ),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),

                        if(limitprice!=0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(  orders!.coupon!=null? "ส่วนลด ( ${orders!.coupon!.couponName!} )" : "ส่วนลด",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(formatCurrency(discount ),
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
                            Text(formatCurrency(total),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "รวมทั้งหมด : ",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: formatCurrency(total ),
                            style: TextStyle(fontSize: 16, color: COLOR_CYAN),
                          ),
                        ],
                      ),
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
                          double? totalPrice = total==0? orders!.totalPrice : total ;
                          String? couponName = orders!.coupon!=null? orders!.coupon!.couponName : "";
                          orders!.totalPrice = totalPrice!;

                          final confirmOrder = await OrdersApi.confirmOrder(orders!, couponName!);
                          if(confirmOrder!=0){
                            setState(() {
                              orders = confirmOrder;
                              advice!.orders= confirmOrder;
                            });
                            await AdviceApi.updateOrderId( advice!,  confirmOrder!);
                            final addOrdetail = await OrderDetailApi.addOrderDetail(listOrderDetail, orders!, advice!.pharmacist!.drugstore!.drugstoreID!);
                            if(addOrdetail!=0){
                              db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").doc(widget.messageId).collection("Orders").doc("${widget.ordersId}").update({"orderStatus": "cf","totalPrice":totalPrice,"discount": discount}).then((value) async {
                                showDialog<String>(context: context,barrierDismissible: false, builder: (BuildContext context) => WillPopScope(
                                  onWillPop: () {
                                    return Future.value(false);
                                  },
                                  child: Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Stack(
                                        overflow: Overflow.visible,
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: size.height * 0.4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.check_circle, color: Colors.green, size: 80,),
                                                addVerticalSpace(10),
                                                Text('ยืนยันคำสั่งซื้อสำเร็จ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                                addVerticalSpace(20),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    RaisedButton.icon(
                                                      color: Colors.orange,
                                                      icon: Icon(Icons.arrow_back, color: Colors.white,),
                                                      label: Text('กลับหน้าแชท', style: TextStyle(color: Colors.white),),
                                                      onPressed: () async {
                                                        print("oddddd ${advice!.orders!.orderId}");
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ChatScreen(advice: advice!,shipping: "")));

                                                      },
                                                    ),
                                                    RaisedButton.icon(
                                                      color: Colors.cyan,
                                                      icon: Icon(Icons.payment, color: Colors.white,),
                                                      label: Text('ชำระเงิน', style: TextStyle(color: Colors.white),),
                                                      onPressed: ()  async {
                                                        await makePayment(total.toInt().toString());
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      )
                                  ),
                                ));
                              }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));
                            }else{
                              buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);
                            }

                          }else{
                            buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red);

                          }



                        },
                        child: Text(
                          "ยืนยันคำสั่งซื้อ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ) ,
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

        Advice new_advice = await OrdersApi.payOrders(advice!, receiptId);
        if(new_advice!=0){
          db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").doc(widget.messageId).collection("Orders").doc("${widget.ordersId}").update({"orderStatus": new_advice.orders!.orderStatus }).then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewReceipt(advice: new_advice,back: 0, )));

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green,),
                Text("ชำระเงินสำเร็จ",style: TextStyle(fontSize: 16),),
              ],
            ),));
          }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));


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
