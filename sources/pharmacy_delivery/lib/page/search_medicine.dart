import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/medicine_api.dart';
import 'package:pharmacy_delivery/api/stock_api.dart';
import 'package:pharmacy_delivery/class/Medicine.dart';
import 'package:pharmacy_delivery/class/Pharmacist.dart';
import 'package:pharmacy_delivery/page/cart_screen.dart';
import 'package:pharmacy_delivery/page/chat_screen.dart';
import 'package:pharmacy_delivery/page/search_drugstore.dart';
import 'package:pharmacy_delivery/page/view_medicine.dart';

import '../api/drugstores_api.dart';
import '../class/Address.dart';
import '../class/Advice.dart';
import '../class/Cart.dart';
import '../class/Drugstore.dart';
import '../class/Stock.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/storage_image.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';
import '../widget/search_widget.dart';

class SearchMedicine extends StatefulWidget {
  final Advice advice;
  final List<Cart>? cart;
  final String shipping;
  final String recipient;
  final Address? address;

  const SearchMedicine(
      {Key? key,
      required this.advice,
      this.cart,
      required this.shipping,
      required this.recipient, this.address})
      : super(key: key);

  @override
  State<SearchMedicine> createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  String query = "";
  Pharmacist pharmacist = Pharmacist();
  Future<List<Stock>>? futureStock;
  //Future<List<String>>? medImg_Future;

  List<Cart>? cart = [];

  int sumQTY = 0;
  String shipping = "";


  Future getPharmacist() async {
    final pharmacist = await UserSecureStorage.getPharmacist();
    setState(() {
      this.pharmacist = pharmacist;
    });
  }

  @override
  void initState() {
    super.initState();
    futureStock =  StockApi.searchStock(widget.advice.pharmacist!.drugstore!.drugstoreID!, query);
    //medImg_Future =  StorageImage().downloadeURL_listMed("medicine", futureStock!);
    getPharmacist();
    setState(() {
      shipping = widget.shipping;
      cart = widget.cart;
      cart ??= []; // if(cart==null){cart=[];}

      for (Cart c in cart!) {
        sumQTY += c.quantity!;
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    Drugstore drugstore = widget.advice.pharmacist!.drugstore!;

    Advice advice = widget.advice;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          advice: advice,
                          cart: cart,
                          shipping: shipping,
                        )));
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "จัดยาให้ลูกค้า",
              style: TextStyle(fontSize: 18),
            ),
            cart!.length > 0
                ? Badge(
                    badgeColor: Colors.red,
                    toAnimate: true,
                    //padding: EdgeInsets.all(5),
                    badgeContent: Text(
                      sumQTY.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen(
                                    advice: advice,
                                    cart: cart!,
                                    shipping: shipping,
                                    recipient: widget.recipient,
                                    address: widget.address,
                                  )),
                        );
                      },
                      child: Icon(
                        CupertinoIcons.cart_fill,
                        size: 30,
                      ),
                    ),
                  )
                : Icon(
                    CupertinoIcons.cart_fill,
                    size: 26,
                  )
          ],
        ),
        backgroundColor: COLOR_CYAN,
      ),
      backgroundColor: Color(0xFFF3F5F7),
      body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildSearch(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: sidePadding,
                      child: FutureBuilder<List<Stock>>(
                          future: futureStock,
                          builder: (context, snapShot_stock) {
                            if (snapShot_stock.connectionState ==
                                ConnectionState.waiting) {
                              return forLoad_Data( themeData);
                            } else if (snapShot_stock.hasError) {
                              return forLoad_Error(snapShot_stock, themeData);
                            } else {
                              if (snapShot_stock.hasData && snapShot_stock.data!.isNotEmpty) {
                                return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapShot_stock.data?.length,
                                    itemBuilder: (context, index)  {
                                      Medicine medicine = snapShot_stock.data![index].medicine!;
                                      Stock stock = snapShot_stock.data![index];
                                      bool isAdd = false;
                                      int numOfItems = 1;
                                      for (Cart lc in cart!) {
                                        if (lc.medicine!.medId ==
                                            medicine.medId) {
                                          isAdd = true;
                                          numOfItems = lc.quantity!;
                                        }
                                      }
                                     // Future<String>? medImg_Future =  StorageImage().downloadeURL("medicine",medicine.medImg?? 'no_img.jpg');

                                      return GestureDetector(
                                          onTap: stock.medQuantity! > 0
                                              ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewMedicine(
                                                        stock: stock,
                                                        advice: advice,
                                                        cart: cart,
                                                        shipping: shipping,
                                                        recipient: widget.recipient,
                                                        address: widget.address,
                                                      )),
                                            );
                                          }
                                              : null,
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0.0, 5.0, 0.0, 5.0),
                                                // height: 170.0,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: stock.medQuantity! > 0
                                                      ? Colors.white
                                                      : Colors.grey
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      130.0, 20.0, 20.0, 10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: <Widget>[
                                                          Container(
                                                            width: 180.0,
                                                            child: Text(
                                                              medicine.medName!,
                                                              style: TextStyle(
                                                                color: Colors.black87,
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        medicine.medDetail!,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      Text(
                                                        "Exp : " +
                                                            DateFormat('dd-MM-yy')
                                                                .format(stock
                                                                .expirationDate!),
                                                        style: TextStyle(
                                                          color: Colors.blueGrey,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      //SizedBox(height: 10.0),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            formatCurrency(stock.medPrice!),
                                                            style: TextStyle(fontSize: 16, color: COLOR_CYAN, fontWeight: FontWeight.bold),
                                                          ),
                                                          stock.medQuantity! > 0
                                                              ? IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                int test = 0;
                                                                for (Cart lc in cart!) {
                                                                  if (lc.medicine!.medId == medicine.medId) {
                                                                    sumQTY += 1;
                                                                    lc.quantity = lc.quantity! + 1;
                                                                    lc.sumprice = lc.medPrice! * lc.quantity!;
                                                                    test = 1;
                                                                    break;
                                                                  }
                                                                }
                                                                if (test == 0) {
                                                                  sumQTY += 1;
                                                                  cart?.add(Cart(medicine: medicine, quantity: 1, medPrice: stock.medPrice, sumprice: stock.medPrice));
                                                                }
                                                              });
                                                            },
                                                            icon: Icon(
                                                              CupertinoIcons.cart_badge_plus,
                                                              color: COLOR_CYAN,
                                                              size: 26,
                                                            ),
                                                          )
                                                              : Text(
                                                            "หมด",
                                                            style: TextStyle(fontSize: 16, color: Colors.black54,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              isAdd
                                                  ? Positioned(
                                                top: 15,
                                                right: 0,
                                                child: Padding(
                                                  padding: sidePadding,
                                                  child: Row(
                                                    children: [
                                                      Badge(
                                                        badgeColor:
                                                        Colors.red,
                                                        toAnimate: true,
                                                        padding:
                                                        EdgeInsets.all(
                                                            6),
                                                        badgeContent: Text(
                                                          numOfItems
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                                  : SizedBox(),
                                              Positioned(
                                                left: 15.0,
                                                top: 15.0,
                                                bottom: 15.0,
                                                child: ClipRRect(
                                                  child: Image(
                                                    height: 240.0,
                                                    width:  100,
                                                    image: NetworkImage(medicine.medImg?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fno_img.jpg?alt=media&token=588042db-f5cd-4706-abb5-30370a9e8ae0'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

  /*                                            FutureBuilder<String>(
                                                  future: medImg_Future ,
                                                  builder: (context, snapShot) {
                                                    if ( (snapShot.connectionState == ConnectionState.done ) && snapShot.hasData) {
                                                      return  Positioned(
                                                        left: 15.0,
                                                        top: 15.0,
                                                        bottom: 15.0,
                                                        child: ClipRRect(
                                                          child: Image(
                                                            height: 240.0,
                                                            width:  100,
                                                            image: NetworkImage(snapShot.data!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    }else{
                                                      return Positioned(
                                                        left: 15.0,
                                                        top: 15.0,
                                                        bottom: 15.0,
                                                        child: ClipRRect(
                                                          child: Image(
                                                            height: 240.0,
                                                            width:  100,
                                                            image:  AssetImage("assets/images/no_img.jpg",),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                              ),
*/

                                            ],
                                          ));
                                    });
                              }else {
                                return for_NodataFound( themeData,"ไม่พบผลการค้นหา");
                              }

                            }
                          }),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: "ค้นหายา",
        onChanged: searchMedicine,
      );

  Future searchMedicine(String query) async {
    final stocks = StockApi.searchStock(widget.advice.pharmacist!.drugstore!.drugstoreID!, query);
   // final   medImg_Future =  StorageImage().downloadeURL_listMed("medicine", futureStock!);
    if (!mounted) return;

    setState(() {
      this.query = query;
      futureStock=stocks;
     // this.medImg_Future = medImg_Future;

    });
  }
}

/*
class MedicineItem extends StatelessWidget {
  final Medicine medicine;
  final Stock stock;

  const MedicineItem({required this.medicine, required this.stock});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewMedicine(medicine:medicine,stock:stock)),
          );

        },
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              // height: 170.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(130.0, 20.0, 20.0, 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 120.0,
                          child: Text(
                            medicine.medName!,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      medicine.medDetail!,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "Exp : "+ DateFormat('dd-MM-yy').format(stock.expirationDate!),
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    //SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          formatCurrency(stock.medPrice!),
                          style: TextStyle(
                              fontSize: 16,
                              color: COLOR_CYAN,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                          },
                          icon:  Icon(
                            CupertinoIcons.cart_badge_plus,
                            color: COLOR_CYAN,
                            size: 26,
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              top: 15.0,
              bottom: 15.0,
              child: ClipRRect(
                child: Image(
                  width: 100.0,
                  image: AssetImage(
                    "assets/images/" + medicine.medImg!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ));
  }
}
 */

/*
class MedicineItem2 extends StatelessWidget {
  final Medicine medicine;

  const MedicineItem2({required this.medicine});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/" + medicine.medImg!),
                        width: 120,
                        height: 120,
                      ),
                      Container(
                        width: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              medicine.medName!,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              medicine.medDetail!,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              "฿1111",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: COLOR_CYAN,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0,),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              CupertinoIcons.cart_badge_plus,
                              color: COLOR_CYAN,
                              size: 26,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
*/
