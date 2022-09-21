import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_delivery/costom/text_field_container.dart';

import '../utils/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? pwd;

  const RoundedPasswordField({
     this.onChanged,
     this.controller,
     this.pwd,
  });

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (value) {
          if(widget.pwd ==""){
            String pattern = r'^[0-9a-zA-Z!#_]{8,16}$';
            RegExp regex = RegExp(pattern);
            if (value == null || value.isEmpty || !regex.hasMatch(value))
              return 'กรุณากรอกรหัสผ่านให้ถูกต้อง';
            else
              return null;
          }else{
            if(value!=widget.pwd){
              return 'ยืนยันรหัสผ่านต้องตรงกับรหัสผ่าน';
            }else {
              return null;
            }
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z!#_]')),
          LengthLimitingTextInputFormatter(16)
        ],
        //style: TextStyle(fontSize: 16),
        obscureText: !_passwordVisible,
        controller: widget.controller,
        onChanged: widget.onChanged,
        cursorColor: COLOR_CYAN,
        //maxLength: 16,
        decoration: InputDecoration(
          hintText: widget.pwd == "" ?"รหัสผ่าน":"ยืนยันรหัสผ่าน",
          prefixIcon: const Icon(Icons.lock, color: COLOR_CYAN),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: COLOR_CYAN,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
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
            borderRadius: BorderRadius.circular(29), ),
          focusedErrorBorder: new OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CYAN),
            borderRadius: BorderRadius.circular(29), ),
        ),
      ),
    );
  }
}
