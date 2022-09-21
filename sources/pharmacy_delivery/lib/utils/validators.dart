
import 'package:flutter/cupertino.dart';

class Validators{
 static validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }

  static FormFieldValidator<String> email(String errorMessage) {
    return (value) {
      if (value!.isEmpty)
        return null;
      else {
        final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (emailRegex.hasMatch(value))
          return null;
        else
          return errorMessage;
      }
    };
  }

  static patternRegExp(String value, RegExp pattern, String errorMessage) {

      if (value.isEmpty) return "null";

      if (pattern.hasMatch(value))
        return "null";
      else
        return errorMessage;

  }

}