import 'package:intl/intl.dart';

String formatCurrency(num amount,{int decimalCount = 0}){
  final formatCurrency = new NumberFormat.currency(decimalDigits: decimalCount,symbol:'฿'  );
  return formatCurrency.format(amount);
}