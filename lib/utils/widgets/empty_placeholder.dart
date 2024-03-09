import 'package:flutter/material.dart';

class EmptyListPlaceHolder extends StatelessWidget {
  const EmptyListPlaceHolder({Key? key, required this.message, this.fontSize=20,this.fontColor=Colors.white,
    this.fontWeight=FontWeight.w400,this.margin})
      : super(key: key);
  final String message;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:margin ?? EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                child: Text(
                  message,
                  style: TextStyle(fontSize: fontSize, fontWeight: fontWeight,color:Colors.white ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}