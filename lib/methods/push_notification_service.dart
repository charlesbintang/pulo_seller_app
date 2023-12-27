import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../appInfo/app_info.dart';
import '../global/global_var.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static sendNotificationToSelectedDriver(
      String deviceToken, BuildContext context, String tripID) async {
    String dropOffDestinationAddress =
        Provider.of<AppInfo>(context, listen: false)
            .dropOffLocation!
            .placeName
            .toString();
    String pickUpAddress = Provider.of<AppInfo>(context, listen: false)
        .pickUpLocation!
        .placeName
        .toString();

    Map<String, String> headerNotificationMap = {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $serverKeyFCM',
    };

    Map titleBodyNotificationMap = {
      "title": "NET TRIP REQUEST from $userName",
      "body":
          "PickUp Location: $pickUpAddress \nDropOff Location: $dropOffDestinationAddress",
    };

    Map dataMapNotification = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "tripID": tripID,
    };

    Map bodyNotificationMap = {
      "notification": titleBodyNotificationMap,
      "data": dataMapNotification,
      "priority": "high",
      "to": deviceToken,
    };

    // await http.post(
    //   Uri.parse("https://fcm.googleapis.com/fcm/send"),
    //   headers: headerNotificationMap,
    //   body: jsonEncode(bodyNotificationMap),

    // );
    // print("FCM Response: ${response.statusCode}");
    // print("FCM Body: ${response.body}");

    http.Response response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotificationMap,
      body: jsonEncode(bodyNotificationMap),
    );

    print("FCM Response: ${response.statusCode}");
    print("FCM Body: ${response.body}");
  }
}
