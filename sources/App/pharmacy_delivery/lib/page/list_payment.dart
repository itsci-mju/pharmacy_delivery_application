import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/page/view_order_detail.dart';

import '../api/orders_api.dart';
import '../class/Advice.dart';
import '../class/Orders.dart';
import '../class/Pharmacist.dart';
import '../utils/constants.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';

class ListPaymentPage extends StatefulWidget {
  final int? tab_index;
  const ListPaymentPage({Key? key, this.tab_index}) : super(key: key);

  @override
  State<ListPaymentPage> createState() => _ListPaymentPageState();
}

class _ListPaymentPageState extends State<ListPaymentPage> {
  int? index = 0;

  Pharmacist? pharmacist = Pharmacist();

  Future getPharmacist() async {
    final pharmacist = await UserSecureStorage.getPharmacist();
    setState(() {
      this.pharmacist = pharmacist;
    });
  }

  TabBar get _tabBar => TabBar(
        labelStyle: TextStyle(fontSize: 16),
        isScrollable: true,
        indicatorColor: Color(0xFFFCBF49),
        tabs: [
          Tab(text :"รอชำระเงิน"),
          Tab(text: "รับที่ร้าน"), //store
          Tab(text: "ที่ต้องจัดส่ง"), //wt
          Tab(text: "จัดส่งแล้ว"), //T
        ],
      );

  @override
  void initState() {
    super.initState();
    getPharmacist();
    index= widget.tab_index?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding, vertical: 5);

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
        //return Future.value(true);
      },
      child: DefaultTabController(
        length: 4,
        initialIndex: index ?? 0,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "รายการคำสั่งซื้อ",
                  style: TextStyle(fontSize: 18),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store,size: 20,),
                        addHorizontalSpace(5),
                        Text( pharmacist!.drugstore!.drugstoreName!,
                          style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    Text(
                      pharmacist!.pharmacistName!.split(" ").first,
                      style: TextStyle(fontSize: 14),
                    ),

                  ],
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Colors.white,
                child: _tabBar,
              ),
            ),
            backgroundColor: COLOR_ORANGE ,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: Color(0xFFF3F5F7),
          body: Column(
            children: [
              Expanded(
                  child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
/*----------------- รอชำระเงิน -------------------------*/
                  Container(
                    width: size.width,
                    height: size.height,
                    child: Stack(
                      children: [
                        FutureBuilder<List<Advice>>(
                            future:  OrdersApi.phar_listOrders_status("cf",pharmacist!.pharmacistID?? ""),
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
                                          Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice,tab_index: 0,backPage: "ListPayment"))
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
                                                          Icon(Icons.person,size: 25,),
                                                          addHorizontalSpace(5),
                                                          Text(
                                                            advice.member!.MemberUsername!,
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "รอชำระเงิน",
                                                        style: TextStyle(
                                                          color: COLOR_CYAN ,fontSize: 14.0,),
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

/*----------------- รับที่ร้าน -------------------------*/
                  Container(
                    width: size.width,
                    height: size.height,
                    child: Stack(
                      children: [
                        FutureBuilder<List<Advice>>(
                            future:  OrdersApi.phar_listOrders_status("store",pharmacist!.pharmacistID?? ""),
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
                                          Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice,tab_index: 1,backPage: "ListPayment"))
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
                                                          Icon(Icons.person,size: 25,),
                                                          addHorizontalSpace(5),
                                                          Text(
                                                            advice.member!.MemberUsername!,
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "รับที่ร้าน",
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

/*----------------- ที่ต้องจัดส่ง -------------------------*/
                  Container(
                    width: size.width,
                    height: size.height,
                    child: Stack(
                      children: [
                        FutureBuilder<List<Advice>>(
                            future:  OrdersApi.phar_listOrders_status("wt",pharmacist!.pharmacistID?? ""),
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
                                          Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice,tab_index: 2,backPage: "ListPayment"))
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
                                                          Icon(Icons.person,size: 25,),
                                                          addHorizontalSpace(5),
                                                          Text(
                                                            advice.member!.MemberUsername!,
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "ที่ต้องจัดส่ง",
                                                        style: TextStyle(
                                                          color: COLOR_CYAN ,fontSize: 14.0,),
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
                                  future:  OrdersApi.phar_listOrders_status("T",pharmacist!.pharmacistID?? ""),
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
                                                Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrderDetail(advice: advice,tab_index: 3,backPage: "ListPayment"))
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
                                                                Icon(Icons.person,size: 25,),
                                                                addHorizontalSpace(5),
                                                                Text(
                                                                  advice.member!.MemberUsername!,
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
                                                                color: COLOR_CYAN ,fontSize: 14.0,),
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

                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
