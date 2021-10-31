import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class BackGroundMediaHandler with ChangeNotifier {
  final _notifications = AwesomeNotifications();
  
  BackGroundMediaHandler() {
    initHandler();
  }

  Future<void> initHandler() async {
    _notifications.initialize(null, [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.orange,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        locked: true,
        playSound: true,
      )
    ]).then((value) {
      listner();
    }).catchError((err) {
      debugPrint(err.toString());
    });
  }

  listner() {
    _notifications.actionStream.listen((event) {
      debugPrint(event.toString());
    });
  }

  createHandler() {
    _notifications
        .createNotification(
            content: NotificationContent(
                displayOnBackground: true,
                displayOnForeground: true,
                autoDismissable: false,
                backgroundColor: Colors.orange,
                title: "Demo notification"))
        .then((value) {
      if (value) {
        debugPrint("Created");
      } else {
        debugPrint("unable to create!!");
      }
    });
  }
}
