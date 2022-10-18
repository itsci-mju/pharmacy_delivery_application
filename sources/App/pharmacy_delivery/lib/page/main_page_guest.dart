
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_delivery/page/login_page.dart';

import '../utils/constants.dart';
import 'search_drugstore.dart';

class MainPageGuest extends StatefulWidget {
  @override
  State<MainPageGuest> createState() => _MainPageGuestState();
}

class _MainPageGuestState extends State<MainPageGuest> {
  int index = 0;
  final screens = [SearchDrugstorePage(), LoginPage()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: index != screens.length-1
            ? Scaffold(
          /*
                appBar: AppBar(
                  title: Text(
                    "Pharma Health Mate",
                    style: TextStyle(fontSize: 18),
                  ),
                  backgroundColor: COLOR_CYAN,
                  automaticallyImplyLeading: false,
                ),
           */
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
                        icon: Icon(Icons.login),
                        label: "เข้าสู่ระบบ",),
                  ],
                  onTap: (index) => setState(() {
                    this.index = index;
                  }),
                ),
              )
            : Scaffold(
                body: screens[index],
              ));
  }
}

