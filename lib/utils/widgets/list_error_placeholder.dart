import 'package:flutter/material.dart';

import '../strings.dart';


class ListErrorPlaceHolder extends StatelessWidget {
  const ListErrorPlaceHolder(
      {Key? key, required this.message, required this.onPressed,this.fontColor=Colors.white})
      : super(key: key);
  final String message;
  final Color fontColor;

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color:Colors.white),
                    textAlign: TextAlign.center,

                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: onPressed, child: Text(Strings.retry))
          ],
        ),
      ),
    );
  }
}
