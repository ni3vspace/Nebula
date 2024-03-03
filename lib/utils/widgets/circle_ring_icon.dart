import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleRingIcon extends StatelessWidget {
  final double size;
  final Color borderColor;

  CircleRingIcon({this.size = 48.0, this.borderColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 5.0, // Adjust the width as needed
        ),
        color: Colors.transparent,
      ),
    );
  }
}