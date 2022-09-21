import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/page/search_medicine.dart';

import '../class/Address.dart';
import '../class/Advice.dart';
import '../class/Cart.dart';
import '../class/Drugstore.dart';
import '../class/Medicine.dart';
import '../class/Pharmacist.dart';
import '../class/Stock.dart';
import '../costom/BorderIcon.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/storage_image.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';
import 'cart_screen.dart';

class ViewMedicine extends StatefulWidget {
  final Advice advice;
  final Stock stock;
  final List<Cart>? cart;
  final String shipping ;
  final String recipient;
  final Address? address;

  const ViewMedicine(
      {Key? key,
        required this.stock,
        this.cart,
        required this.advice, required this.shipping, required this.recipient, this.address})
      : super(key: key);

  @override
  State<ViewMedicine> createState() => _ViewMedicineState();
}

class _ViewMedicineState extends State<ViewMedicine> {
  int numOfItems = 1;
  final note_controller = TextEditingController();
  Future<String>? medImg_Future ;

  //String note="";

  Stock? stock;
  Medicine? medicine;

  List<Cart>? cart;

  int sumQTY = 0;
  bool isAdd = false;
  String shipping = "";

  @override
  void initState() {
    super.initState();
    medImg_Future =  StorageImage().downloadeURL("medicine",widget.stock.medicine!.medImg?? 'no_img.jpg');

    setState(() {
      stock=widget.stock;
      medicine = stock!.medicine;
      shipping =widget.shipping;
      cart = widget.cart;
      cart ??= []; // if(cart==null){cart=[];}

      for (Cart c in cart!) {
        sumQTY += c.quantity!;
        if (c.medicine!.medId == medicine!.medId) {
          isAdd = true;
          note_controller.text = c.note ?? "";
          numOfItems = c.quantity!;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    Advice advice = widget.advice;

    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54, fontSize: 15);
    final style = note_controller.text.isEmpty ? styleHint : styleActive;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, //Color(0xFFF3F5F7),
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(children: [
                      Image.network(medicine!.medImg?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fno_img.jpg?alt=media&token=588042db-f5cd-4706-abb5-30370a9e8ae0'),

                      Positioned(
                        width: size.width,
                        top: padding,
                        child: Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const BorderIcon(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.keyboard_backspace,
                                    color: COLOR_BLACK,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    Container(
                      margin: EdgeInsets.only(bottom: 100),
                      padding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      width: double.infinity,
                      //height:size.height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: -1,
                              blurRadius: 10,
                              offset:
                              Offset(0, -10), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  medicine!.medName!,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  medicine!.medDetail!,
                                  style: themeData.textTheme.bodyText2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Exp : " +
                                      DateFormat('dd-MM-yy')
                                          .format(stock!.expirationDate!),
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      formatCurrency(stock!.medPrice!),
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: COLOR_CYAN,
                                      ),
                                    ),
                                  ),
                                  //**** CartCounter ******//
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 40,
                                        height: 32,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: (numOfItems > 1 ||
                                                isAdd) &&
                                                numOfItems != 0
                                                ? COLOR_CYAN
                                                : Colors.grey.withOpacity(0.7),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                            ),
                                          ),
                                          onPressed:
                                          (numOfItems > 1 || isAdd) &&
                                              numOfItems != 0
                                              ? () {
                                            setState(() {
                                              numOfItems--;
                                            });
                                          }
                                              : null,
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          // if our item is less  then 10 then  it shows 01 02 like that
                                          numOfItems.toString(),
                                          //.padLeft(2, "0"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        height: 32,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:  (numOfItems < stock!.medQuantity!)? COLOR_CYAN : Colors.grey.withOpacity(0.7),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                            ),
                                          ),
                                          onPressed:
                                          (numOfItems < stock!.medQuantity!)
                                              ? () {
                                            setState(() {
                                              numOfItems++;
                                            });
                                          }
                                              : null,
                                          child: Icon(
                                            Icons.add,
                                            color:  Colors.white ,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "รายละเอียดเพิ่มเติม",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: TextField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(255)
                                      ],
                                      controller: note_controller,
                                      decoration: InputDecoration(
                                        suffixIcon:
                                        note_controller.text.isNotEmpty
                                            ? GestureDetector(
                                          child: Icon(Icons.close,
                                              color: style.color),
                                          onTap: () {
                                            note_controller.clear();
                                            FocusScope.of(context)
                                                .requestFocus(
                                                FocusNode());
                                          },
                                        )
                                            : null,
                                        hintText: "รายละเอียดเพิ่มเติม",
                                        hintStyle: style,
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              numOfItems == 0
                  ? Positioned(
                bottom: 10,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.6,
                      child: RaisedButton(
                          color: Colors.red,
                          splashColor: Colors.white.withAlpha(55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < cart!.length; i++) {
                                if (cart![i].medicine!.medId ==
                                    medicine!.medId) {
                                  cart!.removeAt(i);
                                }
                              }
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchMedicine(
                                      advice: advice,
                                      cart: cart,
                                      shipping: shipping,
                                      recipient: widget.recipient,
                                      address: widget.address,
                                    )));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.delete,
                                color: COLOR_WHITE,
                              ),
                              addHorizontalSpace(10),
                              Text(
                                "ลบออกจากตะกร้า",
                                style: TextStyle(
                                    color: COLOR_WHITE, fontSize: 18),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              )
                  : Positioned(
                bottom: 10,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.5,
                      child: RaisedButton(
                          color: COLOR_CYAN,
                          splashColor: Colors.white.withAlpha(55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          onPressed: () {
                            setState(() {
                              int test = 0;
                              for (Cart lc in cart!) {
                                if (lc.medicine!.medId ==
                                    medicine!.medId) {
                                  sumQTY += numOfItems;
                                  lc.quantity = numOfItems;
                                  lc.sumprice = lc.medPrice! * lc.quantity!;
                                  lc.note = note_controller.text.trim()==""? null : note_controller.text.trim();
                                  test = 1;
                                  break;
                                }
                              }
                              if (test == 0) {
                                sumQTY += numOfItems;
                                cart?.add(Cart(
                                    medicine: medicine,
                                    quantity: numOfItems,
                                    medPrice: stock!.medPrice,
                                    sumprice: stock!.medPrice! * numOfItems,
                                    note: note_controller.text.trim()==""? null : note_controller.text.trim()));
                              }
                            });
                            isAdd?
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen(
                                    advice: advice,
                                    cart: cart!,
                                    shipping: shipping,
                                    recipient: widget.recipient,
                                    address: widget.address,
                                  )),)
                            :
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchMedicine(
                                      advice: advice,
                                      cart: cart,
                                      shipping: shipping,
                                      recipient: widget.recipient,
                                      address: widget.address,
                                    )));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isAdd
                                    ? Icons.edit
                                    : CupertinoIcons.cart_fill_badge_plus,
                                color: COLOR_WHITE,
                              ),
                              addHorizontalSpace(10),
                              Text(
                                isAdd ? "แก้ไขตะกร้า" : "เพิ่มลงตะกร้า",
                                style: TextStyle(
                                    color: COLOR_WHITE, fontSize: 18),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
