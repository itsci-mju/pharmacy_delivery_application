import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_delivery/api/pharmacist_api.dart';
import 'package:pharmacy_delivery/class/Pharmacist.dart';
import 'package:pharmacy_delivery/page/list_chat.dart';

import '../costom/BorderIcon.dart';
import '../utils/constants.dart';
import '../utils/user_secure_storage.dart';
import 'list_payment.dart';
import 'login_page.dart';

class PharmacistHomePage extends StatefulWidget {
   Pharmacist? pharmacist;
  int? index;
   int? tab_index;

   PharmacistHomePage({
    Key? key,
    this.pharmacist,
     this.index,
     this.tab_index,
  }) : super(key: key);

  @override
  State<PharmacistHomePage> createState() => _PharmacistHomePageState();
}

class _PharmacistHomePageState extends State<PharmacistHomePage> {
  int index = 0;
  List<StatefulWidget>  screens = [ListPaymentPage(), ListChat(),  LoginPage()];

  Pharmacist? pharmacist = Pharmacist();

  Future getPharmacist() async {
    final pharmacist = await UserSecureStorage.getPharmacist();
    setState(() {
      this.pharmacist = pharmacist;
    });
  }

  @override
  void initState() {
    super.initState();
   getPharmacist();
    index=widget.index?? 0;
    setState(() {
      screens = [ListPaymentPage(tab_index: widget.tab_index??0), ListChat(),  LoginPage()];

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: index != screens.length - 1
          ? Scaffold(
              body: IndexedStack(
                index: index,
                children: screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  currentIndex: index,
                  selectedItemColor: Colors.cyan,
                  unselectedItemColor: Colors.grey.withOpacity(0.5),
                  elevation: 0,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.list_alt),
                        label: "คำสั่งซื้อ",),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      label: "แชท",),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.logout),
                        label: "ออกจากระบบ",),
                  ],
                  onTap: (index) async {
                     if (index == screens.length - 1) {
                       await PharmacistApi.doLogout(pharmacist!);
                       setState(() {
                         this.index = index;
                         UserSecureStorage.setPharmacist(Pharmacist());
                       });
                     }else{
                       setState(() {
                         this.index = index;
                       });
                       if(index==0){
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) => PharmacistHomePage()));
                       }
                     }

                  }),
            )
          : Scaffold(
              body: screens[index],
            ),
    );
  }
}
