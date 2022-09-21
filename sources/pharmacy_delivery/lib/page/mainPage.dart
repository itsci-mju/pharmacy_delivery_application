/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:pharmacy_delivery/page/login_page.dart';
import '../class/Member.dart';
import '../utils/constants.dart';
import '../utils/user_secure_storage.dart';
import 'list_order.dart';
import 'search_drugstore.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final screens =  [SearchDrugstorePage(), ListOrderPage(), LoginPage()];

  Member? member =Member();
  Future getMember() async {
    final member = await UserSecureStorage.getMember();
    setState(() {
      this.member =member;
      if(this.member!.MemberUsername!=null){
        index=1;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMember();
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: index != 2
            ? Scaffold(
          appBar: AppBar(
            title: Text(
              "Pharma Health Mate",
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: COLOR_CYAN,
            automaticallyImplyLeading: false,
          ),
          body: IndexedStack(
            index: index,
            children: screens,
          ),
          //extendBody: true,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: index,
            selectedItemColor: Colors.cyan,
            unselectedItemColor: Colors.grey.withOpacity(0.5),
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "หน้าแรก",),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: "คำสั่งซื้อ",),
              BottomNavigationBarItem(
                  icon: member!.MemberUsername!=null? Icon(Icons.logout) :Icon(Icons.login),
                  label: member!.MemberUsername!=null?  "ออกจากระบบ" : "เข้าสู่ระบบ",),
            ],
            onTap: (index) => setState(() {
              this.index = index;
              if(index==2){
                UserSecureStorage.setMember(Member());
              }else if(index==1 && member!.MemberUsername==null){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            }),
          ),
        )
            : Scaffold(
          body: screens[index],
        ),
      );

  }
}
*/
