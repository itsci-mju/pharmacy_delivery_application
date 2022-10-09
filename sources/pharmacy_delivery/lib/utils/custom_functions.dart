import 'package:intl/intl.dart';

String formatCurrency(num amount,{int decimalCount = 0}){
  final formatCurrency = new NumberFormat.currency(decimalDigits: decimalCount,symbol:'฿'  );
  return formatCurrency.format(amount);
}

String formatPhone(String phoneNum){
  String num1 = phoneNum.substring(0,3);
  String num2 = phoneNum.substring(3,6);
  String num3 = phoneNum.substring(6);

  final formatPhone = "${num1}-${num2}-${num3}";
  return formatPhone;
}

String fromFormatPhone(String phoneNum){
  var tel = phoneNum.split("-");

  String fromFormatPhone="";
  for(var t in  tel){
    fromFormatPhone+= t;
  }

 // final fromFormatPhone = "${tel[0]}${tel[1]}${tel[2]}";
  return fromFormatPhone;
}