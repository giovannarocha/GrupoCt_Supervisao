import 'package:flutter/material.dart';
import 'package:grupoct_supervisao/utils/my_colors.dart';

class ListTileDefault extends StatelessWidget {
  final Size size;
  final String text;
  final Function onTap;

  ListTileDefault(this.size, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.width * .03),
      margin: EdgeInsets.only(top: size.width * .02, right: size.width * .02, left: size.width * .02),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(80.0),
              bottomRight: Radius.circular(80.0)),
          gradient: LinearGradient(colors: [Colors.white, Colors.white38])),
      child: ListTile(
        onTap: () => onTap(),
        title: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.height * .03,
                color: MyColors.defaultBlue,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
