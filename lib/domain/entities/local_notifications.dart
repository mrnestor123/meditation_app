
// NOTIFICACIONES DE MENSAJES DE FIREBASE !!!

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:meditation_app/presentation/pages/welcome/loading_widget.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';



const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'TenStages Notifications  ', // title
  description: 'Important notifications from my server.', // description
  importance: Importance.high,
);


// PARA LAS NOTIFICACIONES EN BACKGROUND DE IOS !!!
void onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  print({'title':title, 'what is going on': 'whaat'});


  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: navigatorKey.currentContext,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Loading(),
              ),
            );
          },
        )
      ],
    ),
  );
}




class LocalNotifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static dynamic function;

  static bool hasFunction;



  static Future init() async {

    
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,iOS:initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async{
        print({'selected notification', function != null});
        if(function != null){
          function();
          function = null;
        }
        if(payload != null){
          print(payload);
        }
      },
    );

    

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // HECHO PARA ANDROID Y NO IOS
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    //showMessage(duration: Duration(seconds: 10));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{ 
      RemoteNotification notification = message.notification;
      showMessage(
        id:notification.hashCode,
        title: notification.title,
        body: notification.body
      );
  });
  }



  /// Define a top-level named handler which background/terminated messages will
  /// call.
  ///
  static Future<void>  _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');  
    showMessage(title: message.notification.title,body: message.notification.body, id: 12345);

  }


  void testShow(){



  }
  


  static showMessage({String title = 'test', String body = 'prueba',int id = 1, Duration duration, dynamic onFinished}) async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id, channel.name,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher'
    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    
    var platformChannelSpecifics = NotificationDetails(
      android:androidPlatformChannelSpecifics, iOS:iOSChannelSpecifics
    );


    if(duration != null){
      function = onFinished;
      hasFunction = true;
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(duration),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime
      );
    }else {
      await flutterLocalNotificationsPlugin.show(
        id, 
        title, 
        body, 
        platformChannelSpecifics, 
        payload: 'test'
      );
    }
  }




  static cancelNotification({int id}){
    flutterLocalNotificationsPlugin.cancel(id);
  }
}