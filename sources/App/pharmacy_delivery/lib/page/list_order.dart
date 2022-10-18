
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/orders_api.dart';
import 'package:pharmacy_delivery/page/view_order_detail.dart';

import '../class/Advice.dart';
import '../class/Member.dart';
import '../class/Orders.dart';
import '../utils/constants.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';

class ListOrderPage extends StatefulWidget {
  final int? tab_index;
  const ListOrderPage({Key? key, this.tab_index}) : super(key: key);

  @override
  State<ListOrderPage> createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage> {
  int? index = 0;

  Member? member = Member();
  Future<List<Advice>>? listAdvice_cf ;

  Future getMember() async {
    final member = await UserSecureStorage.getMember() ;
    setState(() {
      this.member = member;
    });
  }

  TabBar get _tabBar => TabBar(
    labelStyle:  TextStyle(fontSize: 16),
    isScrollable: true,
   indicatorColor: Color(0xFD00BCD4),
    tabs: [
      Tab(text :"ที่ต้องชำระเงิน"), //cf
      Tab(text :"ที่ต้องรับที่ร้าน"), //store
      Tab(text :"รอการจัดส่ง"),  //wt
      Tab(text :"จัดส่งแล้ว"),   //T
      Tab(text :"ที่ยกเลิก"),   // C
      Tab(text :"ที่หมดอายุชำระเงิน"),
    ],
  );

  @override
  void initState() {
    super.initState();
    getMember();
    index= widget.tab_index?? 0;

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding,vertical: 5);


    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
        //return Future.value(true);
      },
      child: DefaultTabController(
        length: 6,
        initialIndex: index?? 0,
        child: Scaffold(
            appBar: AppBar(
              title:  Text(
                "คำสั่งซื้อของฉัน",
                style: TextStyle(fontSize: 18),
              ),
              bottom:     PreferredSize(
                preferredSize: _tabBar.preferredSize,
                child: ColoredBox(
                  color: Colors.white,
                  child: _tabBar ,
                ),
              ),
              backgroundColor: COLOR_CYAN,
              automaticallyImplyLeading: false,
            ),

          backgroundColor: Color(0xFFF3F5F7),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
/*----------------- ที่ต้องชำระเงิน -------------------------*/
                    Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          FutureBuilder<List<Advice>>(
                              future:  OrdersApi.listOrders_status("cf",member!.MemberUsername?? ""),
                              builder: (context, snapShot) {
                                if (snapShot.connectionState == ConnectionState.waiting) {
                                  return forLoad_Data(  Theme.of(context));
                                } else if (snapShot.hasError) {
                                  return forLoad_Error(snapShot,  Theme.of(context));
                                } else if (snapShot.hasData && snapShot.data!.isNotEmpty && snapShot.connectionState == ConnectionState.done) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      // reverse: true,
                                      padding: EdgeInsets.only(top: 5),
                                      itemCount: snapShot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Advice advice = snapShot.data![index];
                                        Orders orders = advice.orders!;
                                        return GestureDetector(
                                          onTap:() {
                                            Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice, tab_index: 0,backPage: "ListOrder",))
                                            );
                                          },
                                          child: Padding(
                                            padding:EdgeInsets.symmetric(horizontal: 5),
                                            child:  Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.all(5),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color : Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),

                                              child: Padding(
                                                padding: sidePadding,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                        Text(
                                                          "ที่ต้องชำระเงิน ",
                                                          style: TextStyle(
                                                            color: COLOR_CYAN,fontSize: 14.0,),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                      thickness: 1,
                                                    ),
                                                    Text(
                                                      orders.address==null? "รูปแบบการจัดส่ง : รับที่ร้าน" : "รูปแบบการจัดส่ง : ทางไปรษณีย์ ",
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
                                                    addVerticalSpace(5),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[

                                                        Text(
                                                          "ชำระเงินภายใน ${DateFormat('dd-MM-yyyy HH:mm').format( orders.orderDate!.add(Duration(hours: 24)))}",
                                                          style: TextStyle(
                                                            color: Colors.grey,fontSize: 14.0,),
                                                        ),
                                                        /*
                                                        Container(
                                                          width: size.width * 0.25,
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              shape:
                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                              primary: Colors.white,
                                                              backgroundColor: COLOR_CYAN,
                                                            ),
                                                            onPressed:() async {},
                                                            child: Text(
                                                              "ชำระเงิน",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                         */
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                } else {
                                  return for_NoOrders( Theme.of(context));
                                }


                            }
                          )
                        ],
                      ),
                    ),

/*----------------- ที่ต้องรับที่ร้าน -------------------------*/
                    Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          FutureBuilder<List<Advice>>(
                              future:  OrdersApi.listOrders_status("store",member!.MemberUsername?? ""),
                              builder: (context, snapShot) {
                                if (snapShot.connectionState == ConnectionState.waiting) {
                                  return forLoad_Data(  Theme.of(context));
                                } else if (snapShot.hasError) {
                                  return forLoad_Error(snapShot,  Theme.of(context));
                                } else if (snapShot.hasData && snapShot.data!.isNotEmpty && snapShot.connectionState == ConnectionState.done) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      // reverse: true,
                                      padding: EdgeInsets.only(top: 5),
                                      itemCount: snapShot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Advice advice = snapShot.data![index];
                                        Orders orders = advice.orders!;
                                        return GestureDetector(
                                          onTap:() {
                                            Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice, tab_index:1,backPage: "ListOrder",))
                                            );
                                          },
                                          child: Padding(
                                            padding:EdgeInsets.symmetric(horizontal: 5),
                                            child:  Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.all(5),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color : Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),

                                              child: Padding(
                                                padding: sidePadding,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                        Text(
                                                          "ที่ต้องรับที่ร้าน",
                                                          style: TextStyle(
                                                            color: COLOR_CYAN,fontSize: 14.0,),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                      thickness: 1,
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
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                } else {
                                  return for_NoOrders( Theme.of(context));
                                }


                              }
                          )
                        ],
                      ),
                    ),

/*----------------- รอการจัดส่ง -------------------------*/
                    Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          FutureBuilder<List<Advice>>(
                              future:  OrdersApi.listOrders_status("wt",member!.MemberUsername?? ""),
                              builder: (context, snapShot) {
                                if (snapShot.connectionState == ConnectionState.waiting) {
                                  return forLoad_Data(  Theme.of(context));
                                } else if (snapShot.hasError) {
                                  return forLoad_Error(snapShot,  Theme.of(context));
                                } else if (snapShot.hasData && snapShot.data!.isNotEmpty && snapShot.connectionState == ConnectionState.done) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      // reverse: true,
                                      padding: EdgeInsets.only(top: 5),
                                      itemCount: snapShot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Advice advice = snapShot.data![index];
                                        Orders orders = advice.orders!;
                                        return GestureDetector(
                                          onTap:() {
                                            Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice, tab_index:2,backPage: "ListOrder"))
                                            );
                                          },
                                          child: Padding(
                                            padding:EdgeInsets.symmetric(horizontal: 5),
                                            child:  Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.all(5),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color : Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: sidePadding,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                        Text(
                                                          "รอการจัดส่ง",
                                                          style: TextStyle(
                                                            color: COLOR_CYAN,fontSize: 14.0,),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                      thickness: 1,
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
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                } else {
                                  return for_NoOrders( Theme.of(context));
                                }


                              }
                          )
                        ],
                      ),
                    ),

/*----------------- จัดส่งแล้ว -------------------------*/
                    Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: size.height,
                            child: Stack(
                              children: [
                                FutureBuilder<List<Advice>>(
                                    future:  OrdersApi.listOrders_status("T",member!.MemberUsername?? ""),
                                    builder: (context, snapShot) {
                                      if (snapShot.connectionState == ConnectionState.waiting) {
                                        return forLoad_Data(  Theme.of(context));
                                      } else if (snapShot.hasError) {
                                        return forLoad_Error(snapShot,  Theme.of(context));
                                      } else if (snapShot.hasData && snapShot.data!.isNotEmpty && snapShot.connectionState == ConnectionState.done) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            // reverse: true,
                                            padding: EdgeInsets.only(top: 5),
                                            itemCount: snapShot.data!.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              Advice advice = snapShot.data![index];
                                              Orders orders = advice.orders!;
                                              return GestureDetector(
                                                onTap:() {
                                                  Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice, tab_index:3,backPage: "ListOrder"))
                                                  );
                                                },
                                                child: Padding(
                                                  padding:EdgeInsets.symmetric(horizontal: 5),
                                                  child:  Container(
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.all(5),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color : Colors.white,
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.3),
                                                          spreadRadius: 5,
                                                          blurRadius: 10,
                                                          offset: Offset(0, 3), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: sidePadding,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              Text(
                                                                "จัดส่งแล้ว",
                                                                style: TextStyle(
                                                                  color: COLOR_CYAN,fontSize: 14.0,),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors.grey,
                                                            thickness: 1,
                                                          ),
                                                          Text(
                                                            orders.address==null? "รูปแบบการจัดส่ง : รับที่ร้าน" : "รูปแบบการจัดส่ง : ทางไปรษณีย์ ",
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
                                                          Text(
                                                            "วันที่จัดส่ง : ${DateFormat('dd-MM-yyyy HH:mm').format(orders.shippingDate!)} ",
                                                            style: TextStyle(
                                                              color: Colors.black54,fontSize: 14.0,),
                                                          ),
                                                          if(orders.address!=null)
                                                          Text(
                                                            "เลขพัสดุ :${orders.trackingNumber} (${orders.shippingCompany}) ",
                                                            style: TextStyle(
                                                              color: Colors.black54,fontSize: 14.0,),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      } else {
                                        return for_NoOrders( Theme.of(context));
                                      }


                                    }
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

/*----------------- ยกเลิก -------------------------*/
                    Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          FutureBuilder<List<Advice>>(
                              future:  OrdersApi.listOrders_status("C",member!.MemberUsername?? ""),
                              builder: (context, snapShot) {
                                if (snapShot.connectionState == ConnectionState.waiting) {
                                  return forLoad_Data(  Theme.of(context));
                                } else if (snapShot.hasError) {
                                  return forLoad_Error(snapShot,  Theme.of(context));
                                } else if (snapShot.hasData && snapShot.data!.isNotEmpty && snapShot.connectionState == ConnectionState.done) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      // reverse: true,
                                      padding: EdgeInsets.only(top: 5),
                                      itemCount: snapShot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Advice advice = snapShot.data![index];
                                        Orders orders = advice.orders!;
                                        return GestureDetector(
                                          onTap:() {
                                            Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice, tab_index:4,backPage: "ListOrder"))
                                            );
                                          },
                                          child: Padding(
                                            padding:EdgeInsets.symmetric(horizontal: 5),
                                            child:  Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.all(5),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color : Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: sidePadding,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                        Text(
                                                          "ยกเลิก",
                                                          style: TextStyle(
                                                            color: Colors.red,fontSize: 14.0,),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                      thickness: 1,
                                                    ),
                                                    Text(
                                                      orders.address==null? "รูปแบบการจัดส่ง : รับที่ร้าน" : "รูปแบบการจัดส่ง : ทางไปรษณีย์ ",
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

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                } else {
                                  return for_NoOrders( Theme.of(context));
                                }


                              }
                          )
                        ],
                      ),
                    ),

/*----------------- ที่หมดอายุชำระเงิน -------------------------*/
                    Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          FutureBuilder<List<Advice>>(
                              future:  OrdersApi.listOrders_status("expir",member!.MemberUsername?? ""),
                              builder: (context, snapShot) {
                                if (snapShot.connectionState == ConnectionState.waiting) {
                                  return forLoad_Data(  Theme.of(context));
                                } else if (snapShot.hasError) {
                                  return forLoad_Error(snapShot,  Theme.of(context));
                                } else if (snapShot.hasData && snapShot.data!.isNotEmpty && snapShot.connectionState == ConnectionState.done) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      // reverse: true,
                                      padding: EdgeInsets.only(top: 5),
                                      itemCount: snapShot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Advice advice = snapShot.data![index];
                                        Orders orders = advice.orders!;
                                        return GestureDetector(
                                          onTap:() {
                                            Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice, tab_index:5,backPage: "ListOrder"))
                                            );
                                          },
                                          child: Padding(
                                            padding:EdgeInsets.symmetric(horizontal: 5),
                                            child:  Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.all(5),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color : Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: sidePadding,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                        Text(
                                                          "ที่หมดอายุชำระเงิน",
                                                          style: TextStyle(
                                                            color: Colors.red,fontSize: 14.0,),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                      thickness: 1,
                                                    ),
                                                    Text(
                                                      orders.address==null? "รูปแบบการจัดส่ง : รับที่ร้าน" : "รูปแบบการจัดส่ง : ทางไปรษณีย์ ",
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

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                } else {
                                  return for_NoOrders( Theme.of(context));
                                }


                              }
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
