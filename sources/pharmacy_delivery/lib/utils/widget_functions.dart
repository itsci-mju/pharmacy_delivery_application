import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

Widget forLoad_Error(AsyncSnapshot snapShot, ThemeData themeData) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Error: ${snapShot.error}',
              style: themeData.textTheme.headline4),
        )
      ],
    ),
  );
}

Widget forLoad_Data(ThemeData themeData) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            color: COLOR_CYAN,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Loading...', style: themeData.textTheme.headline4),
        )
      ],
    ),
  );
}


Widget for_NodataFound( ThemeData themeData) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.highlight_off,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text("ไม่พบผลการค้นหา",
              style: themeData.textTheme.headline4),
        )
      ],
    ),
  );
}

Widget for_NoOrders( ThemeData themeData) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.highlight_off,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text("ยังไม่มีการสั่งซื้อ",
              style: themeData.textTheme.headline4),
        )
      ],
    ),
  );
}

buildToast(String msg,Color backgroundColor) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0);
