import 'package:flutter/material.dart';
import 'package:pharmacy_delivery/utils/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  // TextFieldContainer();

  const TextFieldContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: size.width * 0.8,
      /*decoration: BoxDecoration(
        color: Color(0x2F00BCD4),
        borderRadius: BorderRadius.circular(29),
      ),*/
      child: child,
    );
  }
}
