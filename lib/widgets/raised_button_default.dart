import 'package:flutter/material.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';

class RaisedButtonDefault extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Size size;
  final bool isEnabled;

  RaisedButtonDefault(this.text, this.onPressed, this.size,
      {this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.all(10.0),
      buttonColor: Colors.white,
      child: Container(
        margin: EdgeInsets.only(
          bottom: size.height * .01,
          left: size.height * .01,
          right: size.height * .01,
        ),
        width: size.width * .9,
        child: RaisedButton(
          child: Text(
            text,
            style: TextStyle(
                color: MyColors.defaultBlue,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          onPressed: isEnabled ? onPressed : () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );
  }
}
