import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:pharmacy_delivery/costom/text_field_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';

class RoundedPhoneField extends StatelessWidget {

  final ValueChanged<String>? onChanged;
  final TextEditingController? controller ;

  //final FormFieldValidator<String> validator;

  const RoundedPhoneField({
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: TextFormField(
          validator: (value) {
           String pattern = r'^[0][6|9|8]{1}[0-9]{1}-[0-9]{3}-[0-9]{4}$';
            RegExp regex = RegExp(pattern);
             if (value == null ||
                value.trim().isEmpty ||
                !regex.hasMatch(value))
              return  "กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง";

            else
              return null;

          },
          inputFormatters: [
            MaskedInputFormatter('###-###-####',allowedCharMatcher: RegExp(r'[0-9]'))
          ],
          //initialValue: "0",
          keyboardType: TextInputType.number,
          //style: TextStyle(fontSize: 16),
          controller: controller,
          onChanged: onChanged,
          cursorColor: COLOR_CYAN,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone, color: COLOR_CYAN),
            hintText: "เบอร์โทรศัพท์",
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
