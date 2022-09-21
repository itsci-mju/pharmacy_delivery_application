import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmacy_delivery/api/member_api.dart';
import 'package:pharmacy_delivery/api/pharmacist_api.dart';
import 'package:pharmacy_delivery/class/Pharmacist.dart';
import 'package:pharmacy_delivery/page/main_page_guest.dart';
import 'package:pharmacy_delivery/page/main_page_member.dart';
import 'package:pharmacy_delivery/page/pharmacist_home_page.dart';
import 'package:pharmacy_delivery/page/register_page.dart';
import 'package:pharmacy_delivery/utils/constants.dart';
import 'package:pharmacy_delivery/utils/validators.dart';
import 'package:pharmacy_delivery/utils/widget_functions.dart';
import '../class/Member.dart';
import '../costom/rounded_button.dart';
import '../costom/rounded_input_field.dart';
import '../costom/rounded_password_field.dart';
import '../costom/text_field_container.dart';
import '../utils/user_secure_storage.dart';
import 'mainPage.dart';
import 'search_drugstore.dart';

class LoginPage extends StatefulWidget {
  int? result_regis = 0;

  LoginPage({Key? key, this.result_regis}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List tabs = ["สมาชิก", "เภสัชกร"];
  int selectIndex = 0;
  Member? member = Member(); // .login("", "");
  Pharmacist? pharmacist = Pharmacist();

  TextEditingController usernameMem = TextEditingController();
  TextEditingController passwordMem = TextEditingController();

  TextEditingController usernamePhar = TextEditingController();
  TextEditingController passwordPhar = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
   // UserSecureStorage.setMember(Member());
   // UserSecureStorage.setPharmacist(Pharmacist());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
        body: Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPageGuest()));
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //  Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 24, color: Colors.black)),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  child: Image.asset(
                    "assets/images/logo/logo.png",
                    height: size.height * 0.25,
                    width: size.width * 0.85,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32.0),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      tabs.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectIndex != index) {
                              usernameMem.clear();
                              usernamePhar.clear();
                              passwordMem.clear();
                              passwordPhar.clear();
                            }
                            selectIndex = index;
                          });
                        },
                        child: Container(
                          height: 48,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              color: selectIndex == index
                                  ? COLOR_CYAN
                                  : Colors.grey,
                              width: 3.0,
                            )),
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: selectIndex == index
                                  ? Color(0xFF04A5BA)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
////=========================================================================================///
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  // width: size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Column(
                          children: [
                            RoundedInputField(
                              errorMessage: "กรุณากรอกชื่อผู้ใช้ให้ถูกต้อง",
                              formatRexExp: selectIndex == 0
                                  ? RegExp(r'[0-9a-zA-Z]')
                                  : RegExp(r'[0-9]'),
                              rexExp: selectIndex == 0
                                  ? r'^[0-9a-zA-Z]{4,8}$'
                                  : r'^[0-9]{5}$',
                              maxlength: selectIndex == 0 ? 8 : 5,
                              hintText: "Username",
                              icon: selectIndex == 0
                                  ? Icons.person
                                  : FontAwesomeIcons.userDoctor,
                              controller:
                                  selectIndex == 0 ? usernameMem : usernamePhar,
                            ),
                            RoundedPasswordField(
                              controller:
                                  selectIndex == 0 ? passwordMem : passwordPhar,
                              pwd: "",
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: size.width * 0.7,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (selectIndex == 0) {
                                        setState(() {
                                          member?.MemberUsername =
                                              usernameMem.text;
                                          member?.MemberPassword =
                                              passwordMem.text;
                                        });
                                        final resultMem =
                                            await MemberApi.doLogin(member!);
                                        if (resultMem != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainPageMember()),
                                          );

                                        } else {
                                          buildToast(
                                              "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง",Colors.red);
                                          setState(() {
                                            passwordMem.clear();
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          pharmacist?.pharmacistID =
                                              usernamePhar.text;
                                          pharmacist?.pharmacistPassword =
                                              passwordPhar.text;
                                        });

                                        final resultPhar =
                                            await PharmacistApi.doLogin(
                                                pharmacist!);
                                        if (resultPhar != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PharmacistHomePage()),
                                          );
                                        } else {
                                          buildToast(
                                              "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง",Colors.red);
                                          setState(() {
                                            passwordPhar.clear();
                                          });
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 15, 40, 15),
                                    primary: COLOR_CYAN,
                                  ),
                                  child: const Text(
                                    'เข้าสู่ระบบ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            addVerticalSpace(5),
                            Visibility(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('ยังไม่มีไม่มีบัญชีใช่ไหม?',
                                      style: TextStyle(
                                        color: COLOR_GREY,
                                        fontSize: 16,
                                      )),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: const Text('สมัครสมาชิก',
                                        style: TextStyle(
                                          color: COLOR_CYAN,
                                          fontSize: 16,
                                        )),
                                  ),
                                ],
                              ),
                              visible: selectIndex == 0 ? true : false,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ))
    );
  }


}
