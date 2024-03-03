import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleWithIconWidget extends StatelessWidget {

  final double height,width,opacity;
  final Color fillColor;
  String assetName;

  CircleWithIconWidget({required this.assetName,this.height = 45.0,this.width = 45.0,
    this.opacity = 1, this.fillColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
      ),
      child: Opacity(
          opacity: opacity,
          child: SvgPicture.asset(assetName)),
    );
  }
}
