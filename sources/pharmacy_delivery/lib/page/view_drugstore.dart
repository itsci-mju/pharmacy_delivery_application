import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_delivery/api/advice_api.dart';
import 'package:pharmacy_delivery/api/pharmacist_api.dart';
import 'package:pharmacy_delivery/class/Drugstore.dart';
import 'package:pharmacy_delivery/class/Pharmacist.dart';
import 'package:pharmacy_delivery/costom/BorderIcon.dart';
import 'package:pharmacy_delivery/utils/constants.dart';
import 'package:pharmacy_delivery/utils/widget_functions.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:pharmacy_delivery/utils/storage_image.dart';


import '../api/coupon_api.dart';
import '../api/review_api.dart';
import '../class/Coupon.dart';
import '../class/Date.dart';
import '../class/Member.dart';
import '../class/Message.dart';
import '../class/Review.dart';
import '../costom/OptionButton.dart';
import '../main.dart';
import '../utils/user_secure_storage.dart';
import 'chat_screen.dart';
import 'list_address.dart';
import 'login_page.dart';
import 'main_page_member.dart';

class ViewDrugstore extends StatefulWidget {
  final Drugstore drugstore;
  final List<Coupon>? listCoupons;
  final List<Review>? listReview;
  final String? backpage;

  ViewDrugstore(
      {Key? key, required this.drugstore, this.listCoupons, this.listReview, this.backpage})
      : super(key: key);

  @override
  State<ViewDrugstore> createState() => _ViewDrugstoreState();
}

class _ViewDrugstoreState extends State<ViewDrugstore> {
  List<Coupon>? listCoupons;
  List<Review>? listReview;
  List<Member>? listMember;
  Member? member = Member();

  List<Pharmacist>? listPharmacist;
  int test = 0;
  late Future futureData;

  final db= FirebaseFirestore.instance;

  //String? drugstoreImg ;

  Future init() async {
    final listCoupons = await CouponApi.listCoupon(widget.drugstore);
    final listReview = await ReviewApi.fetchReview(widget.drugstore);
    final listMember = await ReviewApi.fetchMember_Review(listReview);
    final listPharmacist = await PharmacistApi.checkPharmacistOnline(widget.drugstore.drugstoreID.toString());
   // final  drugstoreImg = await StorageImage().downloadeURL("drugstore",widget.drugstore.drugstoreImg?? 'drugstore.jpg');

   // final   member = await UserSecureStorage.getMember() ;
    if (test == 0) {
      setState(() {
        this.listCoupons = listCoupons;
        this.listReview = listReview;
        this.listMember = listMember;
        this.listPharmacist = listPharmacist;
       // this.drugstoreImg=drugstoreImg;
     //   this.member = member;
        test = 1;
      });
    }
  }

  Future getMember() async {
    final   member = await UserSecureStorage.getMember() ;
    setState(() => this.member = member);
  }

  @override
  void initState() {
    super.initState();
    getMember();
    setState(() {
      test = 0;
      futureData = init();
    });

    // init();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final double paddingCoupon1 = listCoupons?.length == 0 ? 0 : 25;
    final double paddingCoupon2 = listCoupons?.length == 0 ? 0 : 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    final Drugstore drugstore = widget.drugstore;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
        //return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: COLOR_WHITE,
          body: Container(
            width: size.width,
            height: size.height,
            child: FutureBuilder(
                future: futureData,
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return forLoad_Data( themeData);
                  } else {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Image.network(drugstore.drugstoreImg ??'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/drugstore%2Fdrugstore.jpg?alt=media&token=c73901ea-84ef-4424-9c6c-23c3d1002091'
                                      ,fit: BoxFit.cover,height: 250.0,width: size.width),
                                  Positioned(
                                    width: size.width,
                                    top: padding,
                                    child: Padding(
                                      padding: sidePadding,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if(widget.backpage == "ListOrder"){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => MainPageMember(tab_index:3 ,)));
                                              }else{
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => MyHomePage(index: 0,)));
                                              }

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
                                ],
                              ),
                              addVerticalSpace(padding),
                              Padding(
                                padding: sidePadding,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          drugstore.drugstoreName.toString(),
                                          style: themeData.textTheme.headline2,
                                        ),
                                        addVerticalSpace(5),
                                        Text(
                                          drugstore.drugstoreAddress.toString(),
                                          style: themeData.textTheme.bodyText2,
                                        ),
                                        addVerticalSpace(5),
                                        Text(
                                          drugstore.drugstoreTel.toString(),
                                          style: themeData.textTheme.bodyText2,
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Icon(Icons.circle,
                                          color: listPharmacist!.length == 0
                                              ? Colors.red
                                              : Colors.green),
                                      Text(
                                        listPharmacist!.length == 0
                                            ? "Offline"
                                            : "Online",
                                        style: TextStyle(
                                            color: listPharmacist!.length == 0
                                                ? Colors.red
                                                : Colors.green),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                              addVerticalSpace(paddingCoupon1),
                              Padding(
                                padding: sidePadding,
                                child: listCoupons!.length == 0
                                    ? SizedBox()
                                    : Text(
                                        "คูปอง",
                                        style: themeData.textTheme.headline4,
                                      ),
                              ),
                              addVerticalSpace(paddingCoupon2),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                child: listCoupons!.length == 0
                                    ? SizedBox()
                                    : Row(
                                        children: listCoupons!
                                            .map((e) =>
                                                InformationTile_Coupon(coupon: e))
                                            .toList(),
                                      ),
                              ),

                              addVerticalSpace(padding),
                              Padding(
                                padding: sidePadding,
                                child: Text(
                                  "รีวิว",
                                  textAlign: TextAlign.justify,
                                  style: themeData.textTheme.headline4,
                                ),
                              ),
                              addVerticalSpace(10),
                              //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/
                              Column(
                                children: [
                                  listReview!.length == 0
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Text(
                                            "ยังไม่มีรีวิว",
                                            style: themeData.textTheme.bodyText2,
                                          ),
                                        )
                                      : ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          //reverse: true,
                                          itemCount: listReview?.length,
                                          itemBuilder: (context, index) {
                                            return information_Review(
                                                listReview![index],
                                                listMember![index],
                                                context);
                                          }),
                                ],
                              ),

                              //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ /

                              addVerticalSpace(100),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          width: size.width,
                          child: listPharmacist!.length == 0
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: size.width * 0.5,
                                      child: RaisedButton(
                                          color: COLOR_CYAN,
                                          splashColor: Colors.white.withAlpha(55),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          onPressed: () async {
                                            if(member!.MemberUsername!=null){
                                              //List<Pharmacist> listPharmacist = await PharmacistApi.checkPharmacistOnline(widget.drugstore.drugstoreID.toString());
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
                                                              Center(
                                                                child: Text(
                                                                  "กรุณาเลือกรูปแบบการจัดส่ง",
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

                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  RaisedButton.icon(
                                                                    color: Colors.orange,
                                                                    icon: Icon(Icons.store, color: Colors.white,),
                                                                    label: Text('รับที่ร้าน', style: TextStyle(color: Colors.white),),
                                                                    onPressed: () async {
                                                                      EasyLoading.show();
                                                                      List<Pharmacist> listPharmacist = await PharmacistApi.checkPharmacistOnline(widget.drugstore.drugstoreID.toString());
                                                                      final _random = new Random();
                                                                      var pharmacist = listPharmacist[_random.nextInt(listPharmacist.length)];

                                                                      final advice = await AdviceApi.addAdvice(member!.MemberUsername.toString(), pharmacist.pharmacistID!);
                                                                      EasyLoading.dismiss();
                                                                      if(advice!=0){

                                                                        Message message = Message(messageType: "text",recipient: member!.MemberUsername,sender:pharmacist.pharmacistID,text: "${pharmacist.drugstore!.drugstoreName} ยินดีให้บริการ", time: DateTime.now() );
                                                                      db.collection('${advice!.pharmacist!.pharmacistID}').doc("${advice!.member!.MemberUsername}").collection("Message").add(message.toDocument()).then((value) {
                                                                         db.collection('${advice!.pharmacist!.pharmacistID}').doc(member!.MemberUsername).set({
                                                                          "MemberImg": member!.MemberImg,
                                                                          "adviceId": advice.adviceId ,
                                                                           "addressId": "" ,
                                                                          "isEnd": "",
                                                                          "lastTime" : DateTimetoString(DateTime.now())
                                                                        }).then((value) {

                                                                           Navigator.push(
                                                                               context,
                                                                               MaterialPageRoute(
                                                                                   builder: (context) =>
                                                                                       ChatScreen(advice: advice,shipping: "",)));
                                                                         }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));

                                                                      }).catchError((error) =>  buildToast("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง",Colors.red));
                                                                      }


                                                                    },
                                                                  ),
                                                                  RaisedButton.icon(
                                                                    color: Colors.lightBlue,
                                                                    icon: Icon(Icons.local_post_office, color: Colors.white,),
                                                                    label: Text('ทางไปรษณีย์', style: TextStyle(color: Colors.white),),
                                                                    onPressed: () async {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  ListAddress(drugstore: widget.drugstore)));
                                                                    },
                                                                  ),
                                                                ],
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  )
                                              ));
                                            }else{
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => LoginPage()));
                                            }
                                          },

                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.wechat,
                                                color: COLOR_WHITE,
                                              ),
                                              addHorizontalSpace(10),
                                              Text(
                                                "ปรึกษาเภสัชกร",
                                                style: TextStyle(
                                                    color: COLOR_WHITE,
                                                    fontSize: 18),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                        )
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}



Widget information_Review(Review review, Member member, BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  //Future<String>? membereImg_Future ;
 // membereImg_Future = StorageImage().downloadeURL("member",member.MemberImg?? 'user.png');


  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 45.0,
              width: 45.0,
              margin: EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(member.MemberImg?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fuser.png?alt=media&token=5842fcab-a485-4e4a-936a-f157dd0da815'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(44.0),
              ),
            ),
            /*
            FutureBuilder<String>(
                future: membereImg_Future ,
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.done && snapShot.hasData) {
                    return Container(
                      height: 45.0,
                      width: 45.0,
                      margin: EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapShot.data!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                    );
                  }else{
                    return Container(
                      height: 45.0,
                      width: 45.0,
                      margin: EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/user.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                    );
                  }

              }
            ),
            */
            Expanded(
              child: Text(
                member.MemberUsername.toString(),
                style: themeData.textTheme.headline4,
              ),
            ),
            /* IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.more_vert),
            ), */
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            SmoothStarRating(
              isReadOnly: true,
              starCount: 5,
              rating: review.score!.toDouble(),
              size: 20,
              color: Colors.orange,
              borderColor: Colors.orange,
            ),
            addHorizontalSpace(10),
            Text(
              DateFormat('dd-MM-yy').format(review.reviewDate!),
              style: themeData.textTheme.bodyText2,
            ),
          ],
        ),
        SizedBox(height: 8.0),
        GestureDetector(
            child: Text(
          review.comment!,
          style: themeData.textTheme.bodyText1,
        )),
        Padding(
          padding: EdgeInsets.only(),
          child: const Divider(
            thickness: 1.0,
            color: Colors.black26,
          ),
        ),
      ],
    ),
  );
}

class InformationTile_Coupon extends StatelessWidget {
  final Coupon coupon;

  const InformationTile_Coupon({required this.coupon});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final double tileSize = size.width * 0.20;
    return Container(
      margin: const EdgeInsets.only(left: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BorderIcon(
            child: Text.rich(
              TextSpan(
                // style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                      text: coupon.couponName! + "\n",
                      style: themeData.textTheme.bodyText1),
                  TextSpan(
                      text: "ส่วนลด ฿" +
                          coupon.discount.toString() +
                          "\nขั้นต่ำ ฿" +
                          coupon.minimumPrice.toString() +
                          "\nหมดอายุ " +
                          DateFormat('dd-MM-yy').format(coupon.endDate!),
                      style: themeData.textTheme.bodyText2)
                ],
              ),
            ),
          ),
/*
            Text(
              "ส่วนลด ฿" +
                  coupon.discount.toString() +
                  "\n ขั้นต่ำ ฿" +
                  coupon.minimumPrice.toString() +
                  "\n หมดอายุ " +
                  coupon.endDate,
              style: themeData.textTheme.bodyText1,
            ),
          ),
          addVerticalSpace(10),
          Text(
            coupon.couponName,
            style: themeData.textTheme.headline6,
          )*/
        ],
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(242),
        height: getProportionateScreenWidth(100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                "assets/images/drugstore.jpg",
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF343434).withOpacity(0.4),
                      Color(0xFF343434).withOpacity(0.15),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15.0),
                  vertical: getProportionateScreenWidth(10),
                ),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "$coupon\n",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "$numOfBrands Brands")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
*/

}

//DateFormat.yMMMEd().format(DateTime.now())
