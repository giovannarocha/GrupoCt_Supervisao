import 'package:flutter/material.dart';

class TextSubtitleDefault extends StatelessWidget {
  final String text;

  TextSubtitleDefault(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        
      ),
    );
  }
}
