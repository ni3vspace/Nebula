import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/global_utils.dart';

import '../../../utils/color_constants.dart';
import '../../../utils/strings.dart';
import '../../../utils/ui_status.dart';
import '../../../utils/widgets/empty_placeholder.dart';
import '../../../utils/widgets/list_error_placeholder.dart';
import '../../models/reminder_model.dart';
import '../../utils/widgets/common_widgets.dart';
import '../home/add_reminder_popup_screen.dart';
import 'all_events_controller.dart';
import 'package:nebula/utils/global_utils.dart';

class AllEventsScreen extends StatelessWidget {
  const AllEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    AllEventsController controller=Get.find();
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: ColorConstants.back_black,
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        physics: AlwaysScrollableScrollPhysics(), // Ensure scrolling is always enabled
        child: Container(
          height: size.height,
          // color: ColorConstants.back_black,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/png_image/blank_screen.png"),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(top:10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const BackButtonIcon(),
                      color: Colors.white,
                      // iconSize: ,
                      onPressed: () {
                        Get.back();
                      },
                    ),

                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          Strings.all_reminders.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () => Future.sync(
                            () => controller.fetchLeadChatList(),
                      ),
                      child:Obx(() => controller
                          .eventsUIStatus.value.status ==
                          Result.SUCCESS
                          ? controller.allEventsList.isNotEmpty
                          ? ListView.separated(
                          itemCount: controller.allEventsList.length,
                          separatorBuilder: (context, index) =>  Divider(
                            thickness: 1.5,
                            color: ColorConstants.divider_line,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return eventItemWidget(
                                controller.allEventsList[index]);
                          })
                          : ListView(
                        children: [
                          EmptyListPlaceHolder(
                              message: Strings.no_reminder),
                        ],
                      )
                          : controller.eventsUIStatus.value.status ==
                          Result.LOADING
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListErrorPlaceHolder(
                        message: controller
                            .eventsUIStatus.value.message
                            .toString(),
                        onPressed: () {
                          controller.fetchLeadChatList();
                        },
                      )))),
            ],
          ),
        ),
      ),
    );
  }

  Widget eventItemWidget(Reminders event) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        roundedDialog(AddReminderPopUpScreen(reminders: event,fromListPage:true,onPressed: () async {

        },));
      },
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: ColorConstants.pinOnCamera,
          ),
          child: Column(
            children: [
              Text(
                (GlobalUtils.getDateAndMonthOnly(event.startDate,false)?.length==1?"0":"")+
                    (GlobalUtils.getDateAndMonthOnly(event.startDate,false) ?? ""),
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900,color: Colors.black),
              ),
              Text(
                GlobalUtils.getDateAndMonthOnly(event.startDate,true)?.toUpperCase() ?? "",
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,color: Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    event.name ?? "",
                    style: const TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          event.location ?? "",
                        style: TextStyle(fontSize: 16.0, color: ColorConstants.gray_text),
                      ),
                      const Visibility(
                        visible: false,
                        child: Text(
                           "" ,//remining time
                          style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    ),);

  }


  // _searchWidget(){
  //   Expanded(
  //     child: TextFormField(
  //       controller: controller.searchHereLeadText,
  //       autofocus: false,
  //       onFieldSubmitted: (value) {
  //         FocusManager.instance.primaryFocus?.unfocus();
  //         controller.searchLeadChats(value);
  //       },
  //       inputFormatters: [
  //         LengthLimitingTextInputFormatter(50),
  //       ],
  //       onChanged: (text) {
  //         controller.searchLeadChats(text);
  //       },
  //       decoration: InputDecoration(
  //         suffixIcon: IconButton(
  //           onPressed: () {
  //             FocusManager.instance.primaryFocus?.unfocus();
  //             controller.searchLeadChats(
  //                 controller.searchHereLeadText.text);
  //           },
  //           icon: Icon(
  //             Icons.search,
  //             color: Colors.grey,
  //           ),
  //         ),
  //         border: InputBorder.none,
  //         hintText: Strings.searchHere,
  //       ),
  //     ),
  //   ),
  // }
}
