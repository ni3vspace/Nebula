import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../api/repository/all_events_repo.dart';
import '../../../api/responses/api_response.dart';
import '../../../models/reminder_model.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/log_utils.dart';
import '../../../utils/ui_status.dart';
class AllEventsController extends GetxController{
  AllEventsRepo allEventsRepo;
  AllEventsController({required this.allEventsRepo});
  Rx<UIStatus> eventsUIStatus = UIStatus.loading().obs;
  RxList<Reminders> allEventsList = RxList<Reminders>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      fetchLeadChatList();
    });

  }

  /*Future<void> fetchLeadChatList() async {
    eventsUIStatus.value = UIStatus.loading();
    DateTime dateTime1=DateTime.now().add(Duration(minutes: 2));
    DateTime dateTime2=dateTime1.add(Duration(minutes: 3));
    String startDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime1);
    String endDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime2);
    LogUtils.debugLog("StartDate= $startDate Enddate=$endDate");
    allEventsList.add(Reminders(id: "10001",name: "Manual added",startDate: startDate,endDate: endDate));

      eventsUIStatus.value = UIStatus.success();
  }*/
  Future<void> fetchLeadChatList() async {
    try {
      eventsUIStatus.value = UIStatus.loading();
      ApiResponse response = await allEventsRepo.getAllEvents();
      switch (response.status) {
        case Status.SUCCESS:
          {
            // var responseData = json.decode(response.data);
            List<Reminders> remindersList = (response.data as List).map((json) => Reminders.fromJson(json)).toList();
            LogUtils.debugLog(remindersList.first.toJson().toString());

            allEventsList.value =  List<Reminders>.from(remindersList);
            eventsUIStatus.value = UIStatus.success();
            // if(searchHereLeadText.value.text.isNotEmpty)
            //   searchLeadChats(searchHereLeadText.value.text);
          }
          break;
        case Status.ERROR:
          {
            eventsUIStatus.value =
                UIStatus.error(AppUtils.getApiError(response));
          }
          break;
      }
    } catch (e) {
      eventsUIStatus.value = UIStatus.error(e.toString());
    }
  }
}