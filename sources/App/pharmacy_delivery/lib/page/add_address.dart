import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmacy_delivery/api/address_api.dart';

import '../class/Address.dart';
import '../class/Drugstore.dart';
import '../class/Member.dart';
import '../costom/rounded_dropdown.dart';
import '../costom/rounded_input_field.dart';
import '../costom/rounded_phone_field.dart';
import '../utils/constants.dart';
import '../utils/custom_functions.dart';
import '../utils/user_secure_storage.dart';
import '../utils/widget_functions.dart';
import 'list_address.dart';

class AddAddress extends StatefulWidget {
  final Drugstore drugstore;
  const AddAddress({Key? key, required this.drugstore}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  Member member = Member();
  Address address = Address();

  TextEditingController name_ctl = TextEditingController();
  TextEditingController phone_ctl = TextEditingController();
  TextEditingController address_ctl = TextEditingController();
  TextEditingController subdistrict_ctl = TextEditingController();
  TextEditingController district_ctl = TextEditingController();
  TextEditingController province_ctl = TextEditingController();
  TextEditingController zipcode_ctl = TextEditingController();

  Future getMember() async {
    Member member = await UserSecureStorage.getMember();
    setState(() {
      this.member = member;
    });

  }

  @override
  void initState() {
    super.initState();
    getMember();
    setState(() {
      address.member = member;
    });

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding,vertical: 5);
    name_ctl.text = name_ctl.text==''? member.MemberName?? '' : name_ctl.text;
    phone_ctl.text = phone_ctl.text==""? formatPhone(member.MemberTel??"") :phone_ctl.text;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "?????????????????????????????????",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: COLOR_CYAN,
      ),
      backgroundColor: Color(0xFFF3F5F7),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addVerticalSpace(10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child:   Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RoundedInputField(
                                errorMessage:
                                "???????????????????????????????????????-???????????????????????????????????????????????????",
                                formatRexExp: RegExp(r'[a-zA-Z???-???\s]'),
                                rexExp:
                                r'^[A-Za-z???-???\s]{2,30}[\s]{1}[A-Za-z???-???\s]{2,30}$',
                                keyboardType: TextInputType.name,
                                maxlength: 100,
                                hintText: "????????????-?????????????????????",
                                icon: Icons.person,
                                controller: name_ctl,
                              ),

                              RoundedPhoneField(
                                controller: phone_ctl,
                                onChanged: (String value) {
                                  String tel = fromFormatPhone(value);
                                  address.tel = tel;
                                },
                              ),

                              RoundedInputField(
                                errorMessage:
                                "????????????????????????????????????????????????????????????????????????????????????????????????????????????",
                                formatRexExp: RegExp(r'[\w\W\d\.\-\_]'),
                                rexExp:
                                r'^[\w\W\d\.\-\_]{2,70}$',
                                maxlength: 70,
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                hintText: "???????????????????????????????????????????????????",
                                icon: Icons.home,
                                controller: address_ctl,
                              ),

                              RoundedInputField(
                                errorMessage:
                                "?????????????????????????????????????????????????????????????????????",
                                formatRexExp: RegExp(r'[a-zA-Z???-???]'),
                                rexExp:
                                r'^[A-Za-z???-???]{2,50}$',
                                maxlength: 50,
                                keyboardType: TextInputType.text,
                                hintText: "????????????",
                                icon: Icons.location_city,
                                controller: subdistrict_ctl,
                              ),
                              RoundedInputField(
                                errorMessage:
                                "????????????????????????????????????????????????????????????????????????",
                                formatRexExp: RegExp(r'[a-zA-Z???-???]'),
                                rexExp:
                                r'^[A-Za-z???-???]{2,50}$',
                                maxlength: 50,
                                keyboardType: TextInputType.text,
                                hintText: "???????????????",
                                icon: Icons.location_city,
                                controller: district_ctl,
                              ),
                              RoundedInputField(
                                errorMessage:
                                "??????????????????????????????????????????????????????????????????????????????",
                                formatRexExp: RegExp(r'[a-zA-Z???-???]'),
                                rexExp:
                                r'^[A-Za-z???-???]{2,50}$',
                                maxlength: 50,
                                keyboardType: TextInputType.text,
                                hintText: "?????????????????????",
                                icon: Icons.location_city,
                                controller: province_ctl,
                              ),
                              RoundedInputField(
                                errorMessage:
                                "?????????????????????????????????????????????????????????????????????????????????????????????",
                                formatRexExp: RegExp(r'[0-9]'),
                                rexExp: r'^[0-9]{5}$',
                                maxlength: 5,
                                keyboardType: TextInputType.number,
                                hintText: "????????????????????????????????????",
                                icon: Icons.location_pin,
                                controller: zipcode_ctl,
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
                                      if (_formKey.currentState!.validate()){
                                        address.addressDetail = address_ctl.text +" ???." + subdistrict_ctl.text+ " ???." + district_ctl.text+" ???." + province_ctl.text + " " + zipcode_ctl.text ;
                                        address.member = member;
                                        address.name = name_ctl.text;
                                        address.tel = fromFormatPhone(phone_ctl.text);

                                        EasyLoading.show();
                                        final addAddress = await AddressApi.addAddress(address);
                                        EasyLoading.dismiss();

                                        if(addAddress!=0){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListAddress(drugstore: widget.drugstore ,)));
                                          buildToast("??????????????????????????????????????????????????????",Colors.green);
                                        }else{
                                          buildToast("?????????????????????????????????????????? ????????????????????????????????????????????????????????????",Colors.red);
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
                                      '????????????????????????????????????',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        )),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
