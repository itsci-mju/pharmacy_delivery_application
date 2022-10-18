import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_delivery/api/review_api.dart';
import 'package:pharmacy_delivery/class/Drugstore.dart';
import 'package:pharmacy_delivery/class/Member.dart';
import 'package:pharmacy_delivery/costom/BorderIcon.dart';
import 'package:pharmacy_delivery/page/view_drugstore.dart';
import 'package:pharmacy_delivery/utils/constants.dart';
import 'package:pharmacy_delivery/utils/storage_image.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:pharmacy_delivery/utils/widget_functions.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../api/drugstores_api.dart';
import '../utils/user_secure_storage.dart';
import '../widget/search_widget.dart';
import 'login_page.dart';

class SearchDrugstorePage extends StatefulWidget {
  Member? member;

  SearchDrugstorePage({Key? key, this.member}) : super(key: key);

  @override
  State<SearchDrugstorePage> createState() => _SearchDrugstorePageState();
}

class _SearchDrugstorePageState extends State<SearchDrugstorePage> {
  String query = "";
  List<Drugstore>? listDrugstore;
  Future<List<Drugstore>>? futureDrugstore;
  Member? member = Member();

/*
  Future init() async {
    final List<Drugstore>? drugstores = await DrugstoreApi.fetchSearchDrugstore(query);
    setState(() => this.listDrugstore = drugstores);
  }
*/

  Future getMember() async {
    final   member = await UserSecureStorage.getMember() ;
    setState(() => this.member = member);
  }

  @override
  void initState() {
    super.initState();
    futureDrugstore =  DrugstoreApi.searchDrugstore(query);
    getMember();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    //Member? member = widget.member;


    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[ member!.MemberUsername!=null
              ? Text(
            "สวัสดี " + member!.MemberUsername.toString(),
              style: TextStyle(fontSize: 18),
          )
              : Text(
            "ยินดีต้อนรับ",
            style: TextStyle(fontSize: 18),
          ),
            Image.asset("assets/images/logo/logo_icon.png",width: 45,),

    ]
        ),
        backgroundColor: COLOR_CYAN,
        automaticallyImplyLeading: false,
        //elevation: 0,
      ),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
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

                  //addVerticalSpace(10),
                  Padding(
                    padding: sidePadding,
                    child: Text(
                      "ร้านขายยา",
                      style: themeData.textTheme.headline1,
                    ),
                  ),
                  Padding(
                    padding: sidePadding,
                    child: const Divider(
                      color: COLOR_GREY,
                    ),
                  ),
                  addVerticalSpace(10),
                  Expanded(
                    child: Padding(
                      padding: sidePadding,
                      child: FutureBuilder<List<Drugstore>>(
                          future: futureDrugstore,
                          builder: (context, snapShot) {
                               if (snapShot.connectionState ==
                                ConnectionState.waiting) {
                              return forLoad_Data( themeData);
                            } else if (snapShot.hasError) {
                              return forLoad_Error(snapShot, themeData);
                            } else {
                              if (snapShot.hasData &&
                                  snapShot.data!.isNotEmpty) {
                                return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapShot.data?.length,
                                    itemBuilder: (context, index) {
                                      return RealEstateItem(
                                          drugstore: snapShot.data![index]);
                                    });
                              } else {
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
        hintText: "ค้นหาชื่อหรือที่อยู่ร้านขายยา",
        onChanged: searchDrugstore,
      );

  Future searchDrugstore(String query) async {
    final drugstores =   DrugstoreApi.searchDrugstore(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      futureDrugstore = drugstores;
     // this.listDrugstore = drugstore;
    });
  }
}

class RealEstateItem extends StatefulWidget {
  final Drugstore drugstore;

  RealEstateItem(
      {Key? key, required this.drugstore, })
      : super(key: key);


  @override
  State<RealEstateItem> createState() => _RealEstateItemState();
}

class _RealEstateItemState extends State<RealEstateItem> {
  double avg_score=0.0 ;

  Future calAvg() async{
    final avg_score = await ReviewApi.avg_score_Review(widget.drugstore);
    setState(() {
      this.avg_score= avg_score;
    });
  }

  @override
  void initState() {
    super.initState();
    calAvg();

  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewDrugstore(drugstore: widget.drugstore)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(height: 250.0, width:  size.width, image: NetworkImage(widget.drugstore.drugstoreImg ?? 'https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/drugstore%2Fdrugstore.jpg?alt=media&token=c73901ea-84ef-4424-9c6c-23c3d1002091',), fit: BoxFit.cover,),
                )
              ],
            ),
            addVerticalSpace(5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.drugstore.drugstoreName!,
                  style: themeData.textTheme.headline3,
                ),
                if(avg_score>0)
                Row(
                  children: [
                    SmoothStarRating(
                      isReadOnly: true,
                      starCount: 5,
                      rating:avg_score,
                      size: 20,
                      color: Colors.orange,
                      borderColor: Colors.orange,
                    ),
                    addHorizontalSpace(10),
                    Text(
                      avg_score.toString(),
                      style: themeData.textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  widget.drugstore.drugstoreAddress!,
                  style: themeData.textTheme.bodyText2,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

