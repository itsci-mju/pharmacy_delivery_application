import 'package:flutter/material.dart';
import 'package:pharmacy_delivery/utils/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final press;
  final Color color, textColor;
 //final GlobalKey<FormState> formKey;

  const RoundedButton({
    required this.text,
    required this.press,
    this.color = COLOR_CYAN,
    this.textColor = Colors.white,
   // required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontSize: 17, fontWeight: FontWeight.w600),
      ),
      onPressed: press, //formKey.currentState!.validate()? press :(){},
      style: ElevatedButton.styleFrom(
          primary: color,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}
