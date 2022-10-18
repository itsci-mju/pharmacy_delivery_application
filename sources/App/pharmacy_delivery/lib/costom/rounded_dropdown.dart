import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_delivery/costom/text_field_container.dart';

import '../utils/constants.dart';

class RoundedDropdown extends StatelessWidget {
  final List<String> items;
  final  onChanged;
  final String dropdownValue ;
  final IconData icon;
  final String hintText;
  final String errorMessage;


  const  RoundedDropdown({required this.items, this.onChanged, required this.dropdownValue, required this.icon, required this.hintText, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: DropdownButtonFormField(
          hint: Text(hintText),
           validator: (value){
             if (value == null){
               return errorMessage;
             }
           },
           // value: dropdownValue,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon:   Icon(icon, color: COLOR_CYAN),
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
            )
        )
    );
  }
}
