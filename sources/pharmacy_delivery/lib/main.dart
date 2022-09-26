import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_delivery/class/Pharmacist.dart';
import 'package:pharmacy_delivery/page/chat_screen.dart';
import 'package:pharmacy_delivery/page/confirm_order.dart';
import 'package:pharmacy_delivery/page/list_chat.dart';
import 'package:pharmacy_delivery/page/mainPage.dart';
import 'package:pharmacy_delivery/page/main_page_guest.dart';
import 'package:pharmacy_delivery/page/main_page_member.dart';
import 'package:pharmacy_delivery/page/payment_test.dart';
import 'package:pharmacy_delivery/page/pharmacist_home_page.dart';
import 'package:pharmacy_delivery/test2.dart';
import 'package:pharmacy_delivery/page/login_page.dart';
import 'package:pharmacy_delivery/page/search_drugstore.dart';
import 'package:pharmacy_delivery/utils/constants.dart';
import 'package:pharmacy_delivery/utils/user_secure_storage.dart';
import 'package:pharmacy_delivery/utils/widget_functions.dart';

import 'class/Member.dart';
import 'test.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

//สั่ง Run App
void main() async {
  var app = MyApp();
  configLoading();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51LjKn8BLgvIrSWmqS6Z61GMhm2jYeodCby5wfNPvuGhcDKws1LSYS5l5L9keFjkAPWjcQT8QIx2YkaIyUTTpI6SH00uNLQnqOq';
  await Firebase.initializeApp();

  runApp(app);
  print("***** runApp ******");
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 55.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.cyan
    ..textColor = Colors.black
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
   // ..customAnimation = CustomAnimation()
  ;
}


// สร้าง widget
class MyApp extends StatelessWidget {
  double screenWidth = window.physicalSize.width;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      debugShowCheckedModeBanner: false,
      home: MyHomePage(), //HomePage(),
      theme: ThemeData(
          primaryColor: COLOR_CYAN,
        colorScheme: ColorScheme.light(primary:  COLOR_CYAN),
          accentColor: Color(0x2F00BCD4),
          textTheme: screenWidth < 500 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT,
          fontFamily: "Kanit",
          //scaffoldBackgroundColor: COLOR_CYAN //Color(0xFFF3F5F7)
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('th','TH'),
        const Locale('en', 'US')
      ],
      builder: EasyLoading.init(),

    );
  }
}


class MyHomePage extends StatefulWidget {
  int? index;
  MyHomePage({Key? key, this.index}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Member member = Member();

  Future getMember() async {
    final member = await UserSecureStorage.getMember();
    setState(() {
      this.member = member;
    });
  }

  Pharmacist pharmacist = Pharmacist();

  Future getPharmacist() async {
    final pharmacist = await UserSecureStorage.getPharmacist();
    setState(() {
      this.pharmacist = pharmacist;
    });
  }

  @override
  void initState() {
    super.initState();
    //UserSecureStorage.setPharmacist(Pharmacist());
    getMember();
    getPharmacist();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pharmacist>(
        future: UserSecureStorage.getPharmacist(),
        builder: (context, snapShot){
         if((snapShot.hasData && pharmacist.pharmacistID != null)){
              return PharmacistHomePage();
          }else if(member.MemberUsername!=null){
            return MainPageMember(index:widget.index ,); //ConfirmOrder();
          }else{
            return MainPageGuest();
          }

        }

    );

  }
}


