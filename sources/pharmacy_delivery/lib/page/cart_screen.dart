import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:pharmacy_delivery/api/advice_api.dart';
import 'package:pharmacy_delivery/api/message_api.dart';
import 'package:pharmacy_delivery/api/orderDetail_api.dart';
import 'package:pharmacy_delivery/api/orders_api.dart';
import 'package:pharmacy_delivery/api/stock_api.dart';
import 'package:pharmacy_delivery/page/search_medicine.dart';
import 'package:pharmacy_delivery/page/view_medicine.dart';

import '../class/Address.dart';
import '../class/Advice.dart';
import '../class/Cart.dart';
import '../class/Date.dart';
import '../class/Message.dart';
import '../class/OrderDetail.dart';
import '../class/Orders.dart';
import '../class/Stock.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/storage_image.dart';
import '../utils/widget_functions.dart';
import 'chat_screen.dart';

class CartScreen extends StatefulWidget {
  final Advice advice;
  final List<Cart> cart;
  final String shipping ;
  final String recipient;
  final Address? address;


  const CartScreen({Key? key, required this.advice, required this.cart, required this.shipping, required this.recipient, this.address})
      : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Advice? advice;
  List<Cart>? cart;
  final db =FirebaseFirestore.instance;


  int sumQuantity =0;
  double subtotalPrice =0;
  //double totalPrice =0;
  double shippingCost = 0;

  final shipping_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      advice = widget.advice;
      shipping_controller.text = widget.shipping;
      cart = widget.cart;
    });
    for (Cart c in cart!) {
      subtotalPrice=subtotalPrice+ c.sumprice!;
      sumQuantity = sumQuantity +c.quantity!;
    }
    //shippingCost = double.parse( widget.shipping ) ;
    //totalPrice =

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 20;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchMedicine(
                      advice: advice!,
                      cart: cart,
                      shipping: shipping_controller.text,
                      recipient: widget.recipient,
                      address: widget.address,
                    )));
          },
        ),
        title: Column(
          children: [
            Text(
              "ตะกร้า",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        bottom:      PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            width: size.width,
            color: Colors.white,
            //height: 30.0,
            child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.location_pin,size: 20,),
                      addHorizontalSpace(5),
                      Expanded(
                        child: Text(
                          widget.address!=null ? "ที่อยู่ : ${widget.address!.addressDetail!}" : "รับยาที่ร้าน" ,
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
        ),
        backgroundColor: COLOR_CYAN,
      ),
      backgroundColor: Color(0xFFF3F5F7),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          //physics: NeverScrollableScrollPhysics(),
                          //shrinkWrap: true,
                            itemCount: cart!.length,
                            itemBuilder: (context, index) {
                              //Future<String>? medImg_Future=  StorageImage().downloadeURL("medicine",cart![index].medicine!.medImg?? 'no_img.jpg');

                              return Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Dismissible(
                                    key: Key(cart![index].medicine!.medId.toString()),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      setState(() {
                                        subtotalPrice = subtotalPrice - cart![index].sumprice! ;
                                        sumQuantity = sumQuantity - cart![index].quantity!;
                                        cart!.removeAt(index);
                                        if(cart!.length==0){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SearchMedicine(
                                                    advice: advice!,
                                                    cart: cart,
                                                    shipping: "",
                                                    recipient: widget.recipient,
                                                    address: widget.address,
                                                  )));
                                        }
                                      });
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
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 88,
                                          child: AspectRatio(
                                            aspectRatio: 0.88,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.white ,//Color(0xFFF5F6F9),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child:  Image.network(cart![index].medicine!.medImg ?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fno_img.jpg?alt=media&token=588042db-f5cd-4706-abb5-30370a9e8ae0'
                                                ,height: 250,width: size.width,),
                                              /*FutureBuilder<String>(
                                              future: medImg_Future ,
                                              builder: (context, snapShot) {
                                                if (snapShot.connectionState == ConnectionState.done && snapShot.hasData) {
                                                  return Image.network(snapShot.data!,height: 250,width: size.width,);
                                                }else{
                                                  return  Image.asset("assets/images/no_img.jpg",height: 250,width: size.width, );
                                                }
                                              }
                                          ),
                                       */

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
                                                  cart![index].medicine!.medName!,
                                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              (cart![index].note != null ) ?
                                              Text(
                                                cart![index].note.toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ):
                                              SizedBox(),

                                              Container(
                                                padding: EdgeInsets.only(right: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        text: formatCurrency(cart![index].medPrice!),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600, color: Colors.black54),
                                                        children: [
                                                          TextSpan(
                                                              text: " x${cart![index].quantity}",
                                                              style: Theme.of(context).textTheme.bodyText1),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      formatCurrency(cart![index].sumprice!),
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
                                              InkWell(
                                                  onTap: () async {
                                                    final stock =  await StockApi.fetchStock(advice!.pharmacist!.drugstore!.drugstoreID!, cart![index].medicine!.medId!);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewMedicine(
                                                                stock: stock, // cart ให้มี stock ข้างใน ??
                                                                advice: advice!,
                                                                cart: cart,
                                                                shipping: shipping_controller.text,
                                                                recipient: widget.recipient,
                                                                address: widget.address,
                                                              )),
                                                    );
                                                  },
                                                  child: Text("แก้ไข", style: TextStyle(color: Colors.blueGrey,),)
                                              ),


                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                    if (widget.address!=null) Container(
                      margin: EdgeInsets.all(10) ,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      // height: 174,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEFCFF),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("รวม",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,),
                                ),
                                Text(formatCurrency(subtotalPrice.toInt()),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("ค่าจัดส่ง",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  width: 70,
                                  child: TextFormField(
                                    validator: (value) {
                                      String pattern = r'^([1-9]{1}[0-9]{1,2})$';
                                      String pattern2 = r'^([0-9]{1})$';

                                      RegExp regex = RegExp(pattern);
                                      RegExp regex2 = RegExp(pattern2);
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          !(regex.hasMatch(value) || regex2.hasMatch(value) )
                                      )
                                        return  "* ค่าจัดส่ง";
                                      else
                                        return null;

                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textAlign: TextAlign.end,
                                    controller: shipping_controller,
                                    onEditingComplete: (){
                                      setState(() {
                                        shipping_controller.text==""?
                                        shippingCost=0 :
                                        shippingCost = double.parse(shipping_controller.text);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 1),
                                      isDense: true,
                                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      hintText: "ค่าจัดส่ง",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: COLOR_CYAN),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      errorBorder: new OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    style: TextStyle( fontSize: 14,color: Colors.black),
                                  ),
                                ),

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("รวมทั้งหมด",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,),
                                ),
                                Text(formatCurrency(subtotalPrice.toInt()+int.parse(shipping_controller.text==""? "0" :shipping_controller.text)),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: COLOR_CYAN),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ) ,
                  ],
                ),
              ],
            )),
      ),

      bottomNavigationBar:Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
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
                          text: formatCurrency(subtotalPrice.toInt()+int.parse(shipping_controller.text==""? "0" :shipping_controller.text)),
                          style: TextStyle(fontSize: 16, color: COLOR_CYAN),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (150),
                    child:
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          primary: Colors.white,
                          backgroundColor: COLOR_CYAN,
                        ),
                        onPressed:() async {
                          if (_formKey.currentState!.validate() || widget.address ==null) {
                            bool testResult = false;

                            Message message = Message(time: DateTime.now(),sender:'${advice!.pharmacist!.pharmacistID}',recipient:"${advice!.member!.MemberUsername}", messageType:"orders");
                            db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").add(message.toDocument()).then((messageSnapshot) {
                              print("Added message with ID: ${messageSnapshot.id}");

                              db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").update({"lastTime": DateTimetoString(message.time!) });

                              Orders orders = Orders(orderDate:DateTime.now(),sumQuantity:sumQuantity,subtotalPrice: subtotalPrice,totalPrice:subtotalPrice+double.parse(shipping_controller.text==""? "0" :shipping_controller.text),orderStatus:"wcf",shippingCost:double.parse(shipping_controller.text==""? "0" :shipping_controller.text),address: widget.address,discount: 0  );
                              db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").doc(messageSnapshot.id).collection("Orders").add(orders.toDocument()).then((ordersSnapshot) {
                              print("Added orders with ID: ${ordersSnapshot.id}");

                              for(Cart c in cart!) {
                                Map<String, dynamic> orderDetail = {
                                  "medName": c.medicine!.medName,
                                  "medId": c.medicine!.medId,
                                  "medImg": c.medicine!.medImg,
                                  "quantity": c.quantity,
                                  "sumprice": c.sumprice,
                                  "note": c.note,
                                  "timeAdd" : DateTimetoString(DateTime.now())
                                } ;

                                db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").doc(messageSnapshot.id).collection("Orders").doc(ordersSnapshot.id).collection("OrderDetail").add(orderDetail).then((value) {
                                  print("Added orderDetail with ID: ${value.id}");
                                  setState(() {
                                    testResult = true;
                                  });

                                });
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        advice: advice!,
                                      )));


                              } ).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));
                            } ).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));

                          }
                        },
                        child: Text(
                          "ยืนยัน",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
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
    );
  }
}
