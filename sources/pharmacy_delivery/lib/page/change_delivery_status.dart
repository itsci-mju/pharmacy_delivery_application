import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/orders_api.dart';
import 'package:pharmacy_delivery/page/pharmacist_home_page.dart';

import '../class/Advice.dart';
import '../class/Orders.dart';
import '../utils/constants.dart';
import '../utils/widget_functions.dart';

class ChangeDeliveryStatus extends StatefulWidget {
  final Advice advice;
  const ChangeDeliveryStatus({Key? key, required this.advice}) : super(key: key);

  @override
  State<ChangeDeliveryStatus> createState() => _ChangeDeliveryStatusState();
}

class _ChangeDeliveryStatusState extends State<ChangeDeliveryStatus> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController shipDate_ctl = TextEditingController();
  String shippingCompany="" ;
  TextEditingController trackingNumber_ctl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 20;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    Advice advice = widget.advice;
    Orders orders = advice.orders!;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "เพิ่มเลขพัสดุ",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: COLOR_CYAN,
      ),
      backgroundColor: Color(0xFFF3F5F7),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
              width: size.width,
             // height: size.height,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(5),
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
                      Padding(
                        padding:EdgeInsets.symmetric(horizontal: 5,),
                        child:  Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                                /*---------วันที่จัดส่ง-------------- */
                                Row(
                                  children: [
                                    Icon(Icons.date_range,),
                                    addHorizontalSpace(5),
                                    Text(  "วันที่จัดส่ง" , style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                addVerticalSpace(5),
                                TextFormField(
                                  controller: shipDate_ctl,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกวันที่จัดส่ง';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "yyyy-MM-dd HH:mm:ss",
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                  onTap: () async{
                                    DateTime? date = DateTime.now();
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    date = await showDatePicker(
                                        context: context,
                                       // locale:  Locale("th","TH"),
                                        initialDate:date,
                                        firstDate:  DateTime(date.year,date.month,date.day-9,date.minute,date.second,date.millisecond),
                                        lastDate:  date,
                                    );

                                    if(date != null){
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      TimeOfDay? time = await  showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                    if(time != null){
                                      setState(() {
                                        shipDate_ctl.text = DateFormat('yyyy-MM-dd HH:mm:ss').format( DateTime(date!.year+543,date.month,date.day, time.hour, time.minute,));
                                      });
                                    }




                                    }
                                  },

                                ),
                                addVerticalSpace(10),

                                /*---------บริษัทขนส่ง-------------- */
                                Row(
                                  children: [
                                    Icon(Icons.local_shipping,),
                                    addHorizontalSpace(5),
                                    Text(  "บริษัทขนส่ง" , style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                addVerticalSpace(5),
                                DropdownButtonFormField(
                                    hint: Text("กรุณาเลือกบริษัทขนส่ง"),
                                    validator: (value){
                                      if (value == null ) {
                                        return 'กรุณาเลือกบริษัทขนส่ง';
                                      }
                                      return null;
                                    },
                                    // value: dropdownValue,
                                    items: ['ไปรษณีย์ไทย', 'KERRY EXPRESS', 'BEST EXPRESS', 'NINJA VAN', 'J&T EXPRESS','FLASH EXPRESS', 'SCG EXPRESS','DHL EXPRESS',  ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  onChanged: (String? newValue) {
                                      setState(() {
                                        shippingCompany = newValue!;
                                      });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "บริษัทขนส่ง",
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                addVerticalSpace(10),

                                /*---------เลขพัสดุ-------------- */
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.cube_box_fill,),
                                    addHorizontalSpace(5),
                                    Text(  "เลขพัสดุ" , style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                addVerticalSpace(5),
                                TextFormField(
                                  controller: trackingNumber_ctl,
                                  validator: (value) {
                                    String pattern = r'^[0-9a-zA-Z]{10,15}$';
                                    RegExp regex = RegExp(pattern);
                                    if (value == null || value.trim().isEmpty || !regex.hasMatch(value) ) {
                                      return 'กรุณากรอกเลขพัสดุ';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "เลขพัสดุ",
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
                                    LengthLimitingTextInputFormatter(15),
                                  ],

                                ),

                                /*---------ปุ่ม-------------- */
                                addVerticalSpace(10),
                                Center(
                                  child: RaisedButton(
                                      color: COLOR_CYAN,
                                      child: Text('เพิ่มเลขพัสดุ', style: TextStyle(color: Colors.white,fontSize: 16),),
                                      onPressed:
                                          () async {
                                            if (_formKey.currentState!.validate()) {
                                              EasyLoading.show();

                                              final addShipping = await OrdersApi.addShipping(orders.orderId!, shipDate_ctl.text, shippingCompany, trackingNumber_ctl.text) ;
                                              EasyLoading.dismiss();

                                              if(addShipping==1){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => PharmacistHomePage(tab_index: 2)));
                                                buildToast("เพิ่มเลขพัสดุสำเร็จ",Colors.green);
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
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),

    );
  }
}
