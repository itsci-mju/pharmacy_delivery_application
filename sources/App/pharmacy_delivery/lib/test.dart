import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_delivery/class/Drugstore.dart';
import 'package:pharmacy_delivery/class/Owner.dart';

class test1 extends StatefulWidget {
  const test1({Key? key}) : super(key: key);

  @override
  State<test1> createState() => _test1State();
}

class _test1State extends State<test1> {
  List? list;
  //Map? mapResponse;
  late Future futureAlbum;

  Future fetchAlbum() async {
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/owner/list'));
    final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/drugstore/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/medicine_type/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/medicine/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/stock/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/pharmacist/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/coupon/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/member/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/address/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/review/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/orders/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/advice/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/order_detail/list'));
    //final response = await http.post(Uri.parse('http://192.168.1.111:8081/PharmacyDelivery/message/list'));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["result"];

      /*************************/
      print(map);
      print(data);
      for (dynamic d in data) {
        //print("TEST!!"+d.toString());
      }
      /*************************/
      /*
      setState(() {
        mapResponse = json.decode(response.body);
        list = mapResponse!['result'];
      });
    */

      print("===============================");

      List<Drugstore> d = [];
      for(dynamic l in data ){
        d.add(Drugstore.fromJson(l));
      }

      return  d;
    /*
      setState(() {
        List<Drugstore> d = [];
        for(dynamic l in data ){
          d.add(Drugstore.fromJson(l));
        }
        list = d;
      });
    */

    } else {
      throw Exception();
    }
  }

  Future init() async {
    final List? drugstores = await fetchAlbum();
    setState(() => this.list = drugstores);
  }

  @override
  void initState() {
    super.initState();
    //futureAlbum = fetchAlbum();
    init();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ค้นหาร้านขายยา"),
        ),
        body: list!=null?

        Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: list?.length,
                    itemBuilder: (context, index) {
                      final drugstore = list![index];
                      return buildDrugstore(drugstore);
                    }))
          ],
        )
    : Column(
          children: const [
            Text("Wait..")
          ],
        ));


  }

  Widget buildDrugstore(Drugstore drugstore) =>
      ListTile(
        leading: Image.network(
          "https://cdn-icons-png.flaticon.com/512/172/172835.png",
          fit: BoxFit.cover,
          width: 50, height: 50,),
        title: Text(""),
        subtitle: Text(""),

      );
}
