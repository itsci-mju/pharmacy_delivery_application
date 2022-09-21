
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pharmacy_delivery/page/login_page.dart';

import '../class/Member.dart';
import '../utils/constants.dart';
import '../utils/user_secure_storage.dart';
import 'list_order.dart';
import 'search_drugstore.dart';

class MainPageMember extends StatefulWidget {
  Member? member;
  int? index;
  int? tab_index;

  MainPageMember({Key? key, this.member,this.index, this.tab_index}) : super(key: key);

  @override
  State<MainPageMember> createState() => _MainPageMemberState();
}

class _MainPageMemberState extends State<MainPageMember> {
  int index = 1;
   List<StatefulWidget> screens = [SearchDrugstorePage(), ListOrderPage(), LoginPage()];

  @override
  void initState() {
    super.initState();
    index=widget.index?? 1;
    setState(() {
      screens = [SearchDrugstorePage(), ListOrderPage(tab_index: widget.tab_index,), LoginPage()];

    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //SystemNavigator.pop(); //ออกจากApp
          return Future.value(false);

        },
        child: index != 2
            ? Scaffold(
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
                        icon: Icon(Icons.logout),
                        label: "ออกจากระบบ",),
                  ],
                  onTap: (index) =>{ setState(() {
                    this.index = index;
                    if(index==2){
                      UserSecureStorage.setMember(Member());
                    }else if(index==1){

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPageMember()));
                    }
                  })
                  },
                ),
              )
            : Scaffold(
                body: screens[index],
              ),
 );
  }
}


