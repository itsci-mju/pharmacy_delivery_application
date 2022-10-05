import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_delivery/costom/rounded_button.dart';
import 'package:pharmacy_delivery/costom/rounded_dropdown.dart';
import 'package:pharmacy_delivery/utils/storage_image.dart';

import '../api/member_api.dart';
import '../class/Member.dart';
import '../costom/rounded_input_field.dart';
import '../costom/rounded_password_field.dart';
import '../costom/rounded_phone_field.dart';
import '../costom/text_field_container.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../utils/widget_functions.dart';
import 'main_page_guest.dart';
import 'search_drugstore.dart';
import 'login_page.dart';
import 'package:path/path.dart'as path;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  Member member = Member();
  String dropdownValue = "เพศชาย";
  String password = "";
  List<String>? allUsername;

  UploadTask? task;
  File? image_file;
  Future chooseImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery) as File?;
    setState(() {
      image_file = image;
    });
  }
  Future uploadFile() async {
    if (image_file == null) return;

    final fileName = path.basename(image_file!.path);
    final file_extension = fileName.split(".").last;
    final name = member.MemberUsername!+"."+file_extension;
    final destination = 'member/ $name';

    task = StorageImage.uploadFile(destination, image_file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      member.MemberImg =urlDownload;
    });

  }

  Future init() async {
    final   allUsername = await MemberApi.allUsername();
    setState(() => this.allUsername = allUsername);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: size.width * 0.35,
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
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("สมัครสมาชิก",
                          style: TextStyle(fontSize: 24, color: Colors.black)),
                      SizedBox(height: size.height * 0.02),
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child:  CircleAvatar(
                              radius: 80,
                              backgroundColor:COLOR_CYAN,
                              child: ClipOval(
                                child: new SizedBox(
                                  width: 150.0,
                                  height: 150.0,
                                  child: (image_file!=null)?Image.file(
                                    image_file!,
                                    fit: BoxFit.fill,
                                  ):Image.asset(
                                    "assets/images/uploade_file.jpg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            onTap: chooseImage,
                          ),
                          addVerticalSpace(10),
                          Text("รูปประจำตัว", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Form(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.only(
                                                left: 15, bottom: 5, top: 10),
                                            width: size.width * 0.8,
                                            child:
                                                const Text("ข้อมูลส่วนตัว",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left)),
                                        RoundedInputField(
                                          errorMessage:
                                              "กรุณากรอกชื่อ-นามสกุลให้ถูกต้อง",
                                          formatRexExp: RegExp(r'[a-zA-Zก-์\s]'),
                                          rexExp:
                                              r'^[A-Za-zก-์\s]{2,30}[\s]{1}[A-Za-zก-์\s]{2,30}$',
                                          keyboardType: TextInputType.name,
                                          maxlength: 100,
                                          hintText: "ชื่อ-นามสกุล",
                                          icon: Icons.person,
                                          onChanged: (String value) {
                                            member.MemberName =  value;
                                          },
                                        ),
                                        RoundedDropdown(
                                            items: ['เพศชาย', 'เพศหญิง'],
                                            onChanged: (String? newValue) {
                                              if( newValue=="เพศชาย"){
                                                member.MemberGender="M";
                                              }else{
                                                member.MemberGender="FM";
                                              }
                                            },
                                            dropdownValue: dropdownValue,
                                            icon: Icons.male,
                                            hintText: 'เพศ',
                                            errorMessage: "กรุณาเลือกเพศ",
                                        ),
                                        RoundedPhoneField(
                                          onChanged: (String value) {
                                            member.MemberTel = value;
                                          },
                                        ),
                                        RoundedInputField(
                                          errorMessage:
                                              "กรุณากรอกอีเมล์ให้ถูกต้อง",
                                          formatRexExp: RegExp(
                                              r'[a-zA-Z0-9.a-zA-Z0-9.!#$%&@*+-/=?^_`{|}~]'),
                                          rexExp: "email",
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          maxlength: 253,
                                          hintText: "อีเมล์",
                                          icon: Icons.mail,
                                          onChanged: (String value) {
                                            member.MemberEmail = value;
                                          },
                                        ),
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.only(
                                                left: 15, bottom: 5, top: 10),
                                            width: size.width * 0.8,
                                            child: const Text("ข้อมูลการเข้าสู่ระบบ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.left)),


                                        RoundedInputField(
                                          errorMessage: "กรุณากรอกชื่อผู้ใช้ให้ถูกต้อง" ,
                                          formatRexExp: RegExp(r'[0-9a-zA-Z]'),
                                          rexExp: r'^[0-9a-zA-Z]{4,8}$',
                                          keyboardType: TextInputType.text,
                                          maxlength: 8,
                                          hintText: "ชื่อผู้ใช้",
                                          icon: Icons.account_circle,
                                          onChanged: (String value)  {
                                            member.MemberUsername = value;
                                          },
                                          allUsername: allUsername,
                                        ),

                                        RoundedPasswordField(
                                          onChanged: (String value) {
                                            member.MemberPassword = value;
                                            setState(() {
                                              password = value;
                                            });
                                          },
                                          pwd: "",
                                        ),
                                        RoundedPasswordField(
                                          pwd: password,
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 10),
                                          width: size.width * 0.7,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(29),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!.validate()) {
                                                  EasyLoading.show();

                                                  await uploadFile();
                                                    final resultMem = await MemberApi.doRegister(member);
                                                  EasyLoading.dismiss();
                                                    if (resultMem != 0) {
                                                      showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                            child: Stack(
                                                              overflow: Overflow.visible,
                                                              alignment: Alignment.topCenter,
                                                              children: [
                                                                Container(
                                                                  height: size.height * 0.35,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                                                    child: Column(
                                                                      children: [
                                                                        Text('ยินดีด้วย', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                                                        SizedBox(height: 5,),
                                                                        Text('คุณสมัครสมาชิกสำเร็จ', style: TextStyle(fontSize: 20),),
                                                                        SizedBox(height: 20,),
                                                                        RaisedButton(onPressed: () {
                                                                          Navigator.push(context, MaterialPageRoute(
                                                                              builder: (context) => LoginPage()),
                                                                          );
                                                                        },
                                                                          color: COLOR_CYAN,
                                                                          child: Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white),),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    top: -60,
                                                                    child: CircleAvatar(
                                                                      backgroundColor: COLOR_CYAN,
                                                                      radius: 60,
                                                                      child: Icon(Icons.celebration, color: Colors.white, size: 70,),
                                                                    )
                                                                ),
                                                              ],
                                                            )
                                                        );
                                                      });


                                                    } else {
                                                      buildToast("สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง",Colors.red);

                                                    }



                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        40, 15, 40, 15),
                                                primary: COLOR_CYAN,
                                              ),
                                              child: const Text(
                                                'สมัครสมาชิก',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        addVerticalSpace(5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text('มีบัญชีแล้วใช่หรือไหม?',
                                                style: TextStyle(
                                                  color: COLOR_GREY,
                                                  fontSize: 16,
                                                )),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                  ),
                                                );
                                              },
                                              child: const Text('เข้าสู่ระบบ',
                                                  style: TextStyle(
                                                    color: COLOR_CYAN,
                                                    fontSize: 16,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ]))
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }




}
