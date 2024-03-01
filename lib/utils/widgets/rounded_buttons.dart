import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/utils/image_constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final String imageName;
  final VoidCallback onPressed;
  final Color color;

  const RoundedButton({
    required this.imageName,
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imageName,height: 30,width: 30,),
          SizedBox(width: 10,),
          Text(text,style: TextStyle(color: Colors.black,fontSize:16),),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0), // Adjust as desired
        ),
        backgroundColor: color,
      ),
    );
  }
}