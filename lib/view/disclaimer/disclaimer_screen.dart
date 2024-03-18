import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/color_constants.dart';
import 'package:nebula/utils/widgets/rounded_buttons.dart';

import '../../routes/app_pages.dart';
import '../../utils/image_constants.dart';
import '../../utils/preferences_helper.dart';
import '../../utils/storage.dart';
import '../../utils/strings.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/png_image/blank_screen.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset(ImageConstants.ShieldWarning,color: Colors.black,),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset(ImageConstants.disclaimer_text),
            ),

            /*Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                Strings.Disclaimer_msg,
                style: const TextStyle(fontSize: 16,color:Colors.black,fontWeight: FontWeight.w700),
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              child: Text(
                Strings.Disclaimer_tc_msg,
                style: const TextStyle(fontSize: 16,color:Colors.black,fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),*/
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(30,10,30,10),
              child: RoundedButton(text: Strings.Continue.toUpperCase(),
                color: ColorConstants.saveFeedbackButton,onPressed: () async {
                await PreferencesHelper.setBool(
                    StorageConstants.disclaimerRead,true);
                Get.offNamed(Routes.home);
              },),
            ),
          ],
        ),
      ),
    );
  }
}
