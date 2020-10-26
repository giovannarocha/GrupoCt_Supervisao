import 'package:flutter/material.dart';

Future push(context, page, {replace}) {
  if (replace == true) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  } else {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }
}
