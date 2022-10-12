import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/page/view_order_detail.dart';

import '../api/orderDetail_api.dart';
import '../class/Advice.dart';
import '../class/Member.dart';
import '../class/OrderDetail.dart';
import '../class/Orders.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';
import 'chat_screen.dart';

class ViewReceipt extends StatefulWidget {
  final Advice advice;
  final int back;
  final String? backPage;
  final int? tab_index;
  const ViewReceipt({Key? key, required this.advice,required this.back,  this.backPage, this.tab_index}) : super(key: key);

  @override
  State<ViewReceipt> createState() => _ViewReceiptState();
}

class _ViewReceiptState extends State<ViewReceipt> {
  List<OrderDetail>? listOrderDetail;
  Member? member = Member();

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
    getListOrderDetail();
    getMember();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding,vertical: 5);

    Orders orders = widget.advice.orders!;


    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
        //return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
            "ใบเสร็จ",
            style: TextStyle(fontSize: 18),
          ),
          leading: BackButton(
            onPressed: () {
              if(widget.back==0){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(advice: widget.advice,shipping: "")));
              }else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewOrderDetail(advice: widget.advice, backPage: widget.backPage!, tab_index: widget.tab_index?? 0, )

                    ));
              }

            },
          ),
          backgroundColor: member!.MemberUsername==null? COLOR_ORANGE: COLOR_CYAN,
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  addVerticalSpace(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.store,size: 25,),
                                      addHorizontalSpace(5),
                                      Text(
                                        widget.advice.pharmacist!.drugstore!.drugstoreName!,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  addVerticalSpace(10),

                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [

                                        Text(
                                          "เลขที่ใบเสร็จ : ${orders.receiptId}",
                                          style: TextStyle(
                                            color: Colors.black54,fontSize: 14.0,),
                                        ),
                                        Text(
                                          "หมายเลขคำสั่งซื้อ : ${orders.orderId}",
                                          style: TextStyle(
                                            color: Colors.black54,fontSize: 14.0,),
                                        ),
                                        Text(
                                          "วันที่สั่งซื้อ : ${DateFormat('dd-MM-yyyy HH:mm').format(orders.orderDate!)} ",
                                          style: TextStyle(
                                            color: Colors.black54,fontSize: 14.0,),
                                        ),
                                        Text(
                                          "วันที่ชำระเงิน : ${DateFormat('dd-MM-yyyy HH:mm').format(orders.payDate!)} ",
                                          style: TextStyle(
                                            color: Colors.black54,fontSize: 14.0,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child:  orders.address !=null ?
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[

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
                                          Text(
                                            "รับยาที่ร้าน",
                                            style: TextStyle(
                                              color: Colors.black54,fontSize: 14.0,),
                                          ),

                                        ]
                                    ),
                                  ),

                                  addVerticalSpace(20),
                                  Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "รายการ",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                      Text(
                                        "รวม",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ],
                                  ),

                                  Divider(
                                    color: Colors.black54,
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
                                                    //  padding: EdgeInsets.all(5),
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
                                                              style:Theme.of(context).textTheme.bodyText1,
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

                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),

                                  Column(
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
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 1,
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

                                  addVerticalSpace(5),


                                ]
                            )
                        ),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
