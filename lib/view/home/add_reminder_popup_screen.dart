import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/models/reminder_model.dart';
import 'package:nebula/utils/color_constants.dart';
import 'package:nebula/utils/global_utils.dart';
import 'package:nebula/utils/strings.dart';
import 'package:nebula/utils/widgets/rounded_buttons.dart';

import '../../utils/image_constants.dart';
import '../../utils/widgets/circler_widget.dart';

class AddReminderPopUpScreen extends StatelessWidget {
  Reminders reminders;
  final VoidCallback onPressed;
  AddReminderPopUpScreen({Key? key,required this.reminders,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              // width:size.width ,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child:networkImage(reminders.imageUrl)
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: (){
                  Get.back(closeOverlays: true);
                },
                child: CircleWithIconWidget(assetName: ImageConstants.close,fillColor: ColorConstants.camItemsBack,height: 30,width: 30,)),)
          ],
        ),
        Visibility(
          visible: reminders.name!=null,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(Strings.event,style: TextStyle(
                color: ColorConstants.white50per,
                fontWeight: FontWeight.w700,fontSize: 16),
            ),
          ),
        ),
        Visibility(
          visible: reminders.name!=null,
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 10),
            child: Text(reminders.name ?? "",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        Visibility(
          visible: reminders.description!=null,
          child: Container(
            padding: EdgeInsets.only(top: 15),
            child: Text(Strings.description,style: TextStyle(
                color: ColorConstants.white50per,
                fontWeight: FontWeight.w700,fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Visibility(
          visible: reminders.description!=null,
          child: Container(

            padding: EdgeInsets.only(top: 10),
            child: Text(reminders.description ?? "",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        Visibility(
          visible: reminders.startDate!=null && reminders.location!=null,
          child: Container(
            padding: EdgeInsets.only(top: 15),
            child: Text(Strings.timDateVenue,style: TextStyle(
                color: ColorConstants.white50per,
                fontWeight: FontWeight.w700,fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Visibility(
          visible: reminders.startDate!=null,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(GlobalUtils.getDateMonthYearString(reminders.startDate),style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        Visibility(
          visible: reminders.location!=null,
          child: Container(
            padding: EdgeInsets.only(top: 15),
            child: Text(Strings.location,style: TextStyle(
                color: ColorConstants.white50per,
                fontWeight: FontWeight.w700,fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        Visibility(
          visible: reminders.location!=null,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(reminders.location ?? "",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child:RoundedButton(text: Strings.add_to_reminder, textColor: ColorConstants.back_black,color: ColorConstants.addReminder,onPressed: onPressed,),
        ),

      ],
    );
  }

  Image networkImage(String? imageUrl){
    return Image.network(
      // "https://guru-ai-event-bucket.s3.amazonaws.com/upload/eventList1.jpg",
      imageUrl ?? "",
      fit: BoxFit.fill,
      // When image is loading from the server it takes some time
      // So we will show progress indicator while loading
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      // When dealing with networks it completes with two states,
      // complete with a value or completed with an error,
      // So handling errors is very important otherwise it will crash the app screen.
      // I showed dummy images from assets when there is an error, you can show some texts or anything you want.
      errorBuilder: (context, exception, stackTrace) {
        return const Icon(Icons.error);
      },
    );

  }
}
