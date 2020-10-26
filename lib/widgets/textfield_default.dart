import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';

class TextFieldDefault extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyBoardType;
  TextFieldDefault(this.size, this.controller, this.obscureText, {this.keyBoardType});





  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
        margin:
            EdgeInsets.only(left: size.width * .02, right: size.width * .02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        //margin: EdgeInsets.only(left: size.width * .02, right: size.width * .02),
        child: TextField(
          minLines: obscureText == true ? 1 : 1,
          maxLines: obscureText == true ? 1 : 15,
          keyboardType: keyBoardType != null ? keyBoardType : null,
          obscureText: obscureText,
          controller: controller,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.defaultBlue,
            fontSize: 20.0,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ));
  }
}
