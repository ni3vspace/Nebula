import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/utils/image_constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final String? imageName;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double iconHeight;
  final double iconWidth;
  final double fontSize;
  final EdgeInsetsGeometry padding;

   const RoundedButton({super.key,
    this.imageName,
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.iconHeight = 30,
    this.iconWidth = 30,
    this.fontSize = 16,
     EdgeInsetsGeometry? padding,
  }): padding = padding ?? const EdgeInsets.all(20.0);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0), // Adjust as desired
        ),
        backgroundColor: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: imageName!=null,
              child: SvgPicture.asset(imageName ?? "",height: iconHeight,width: iconWidth,)),
          Visibility(
              visible: imageName!=null,
              child: SizedBox(width: 10,)),
          Text(text,style: TextStyle(color: textColor,fontSize:fontSize),),
        ],
      ),
    );
  }
}