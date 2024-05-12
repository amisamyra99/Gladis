

import 'package:flutter/material.dart';

class CustomButtonBig extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final double? padding;
  const CustomButtonBig({super.key, required this.text, required this.onPressed,  this.color,  this.textColor,  this.borderRadius,  this.padding});


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return    GestureDetector(
      onTap: onPressed,
      child: Container(
        height:50,
        width: size.width*0.5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius!),

        ),
        child: Center(child: Text(text,style:  TextStyle(fontWeight: FontWeight.bold,color: textColor!),)),
      ),
    );
  }
}
