import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_delivery/costom/text_field_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final String rexExp;
  final RegExp formatRexExp;
  final TextInputType? keyboardType;
  final String errorMessage;
  final int? maxlength;
  final TextEditingController? controller;
  final List<String>? allUsername  ;
  final int? maxLines;
  final String? initialValue;

  //final FormFieldValidator<String> validator;

  const RoundedInputField({
    required this.hintText,
    this.icon = FontAwesomeIcons.userDoctor,
    // required this.onChanged,
    this.maxlength,
    required this.rexExp,
    this.controller,
    required this.errorMessage,
    required this.formatRexExp,
    this.keyboardType,
    this.onChanged, this.allUsername, this.maxLines, this.initialValue,
  });

  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: TextFormField(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (rexExp == "email") {
              if (EmailValidator.validate(value)) {
                return null;
              } else {
                return "กรุณากรอกอีเมล์ให้ถูกต้อง";
              }
            }
            else {
              String pattern = rexExp;
              RegExp regex = RegExp(pattern);
              if(hintText=="ชื่อผู้ใช้" && (value != null && value.trim().isNotEmpty && regex.hasMatch(value))){
                for(String a in allUsername!){
                  if(a==value){
                    return "* ชื่อผู้ใช้ซ้ำ";
                  }
                }
                 return null;
              }
              else if (value == null ||
                  value.trim().isEmpty ||
                  !regex.hasMatch(value))
                return errorMessage;

              else
                return null;
            }
          },
          initialValue: initialValue,
          inputFormatters: [
            FilteringTextInputFormatter.allow(formatRexExp),
             LengthLimitingTextInputFormatter(maxlength)
          ],
          keyboardType: keyboardType,
          maxLines : maxLines,
          minLines : 1,
          //style: TextStyle(fontSize: 16),
          controller: controller,
          onChanged: onChanged,
          cursorColor: COLOR_CYAN,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: COLOR_CYAN),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(29),
            ),
            fillColor: Color(0x2F00BCD4),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CYAN),
              borderRadius: BorderRadius.circular(29),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(29),
            ),
            errorBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(29),
            ),
            focusedErrorBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CYAN),
              borderRadius: BorderRadius.circular(29),
            ),
          )),
    );
  }
}
