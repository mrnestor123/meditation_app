
// NOTIFICACIONES DE MENSAJES DE FIREBASE !!!

import 'dart:io';

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


// HABRÁ QUE CREAR OTRO CANAL PARA LAS NOTIFICACIONES DE FIREBASE !!!!
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'meditation_channel', // id
  'Meditation Notifications  ', // title
  description: 'Notifications when meditation has ended',
  sound: RawResourceAndroidNotificationSound('gong'),
  playSound: true, // description
  importance: Importance.max,
  enableVibration: true,
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

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

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
          print('we have a dynamic function');
          function();
          function = null;
        }
        if(payload != null){
          print(payload);
        }
      },
    );
    
    // HECHO PARA ANDROID Y NO IOS PORQUE ????
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    
    //INICIALIZACIÓN DE FIREBASE MESSAGING
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );  

    if(Platform.isIOS){
      final bool result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
      );
    }


    //TO DO : COMPROBAR SI EL USUARIO TIENE PERMISOS PARA RECIBIR NOTIFICACIONES
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }

    
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


   // showMessage(duration: Duration(seconds: 10), playSound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{ 
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      RemoteNotification notification = message.notification;
      showMessage(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body
      );
    });
  }


  static Future<void>  _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
   // await Firebase.initializeApp();
  //  print('Handling a background message ${message.messageId}');  
    showMessage(title: message.notification.title,body: message.notification.body, id: 12345);

  }

  void testShow(){



  }

  static showMessage({String title = 'test', String body = 'prueba',bool playSound = false,  int id = 1, Duration duration, dynamic onFinished}) async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id, channel.name,
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound("gong"),
      playSound: playSound,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      icon: '@mipmap/ic_launcher'
    );

    var iOSChannelSpecifics = IOSNotificationDetails(
      sound: 'gong.aiff',
      presentSound: playSound
    );
    
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, 
      iOS: iOSChannelSpecifics
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

  static cancelAll(){
    flutterLocalNotificationsPlugin.cancelAll();
  }

  static cancelNotification({int id}){
    flutterLocalNotificationsPlugin.cancel(id);
  }

  static askForPermissions(){

  }

  static setReminder({TimeOfDay reminder})async{

    DateTime now = DateTime.now();
    TimeOfDay time = reminder;
    DateTime date = DateTime(now.year, now.month, now.day, time.hour, time.minute, 0);

    var androidChannel = AndroidNotificationDetails(
      channel.id, channel.name, 
      importance: Importance.high,
      priority: Priority.defaultPriority,
      playSound: false
    );

    var iosChannel = IOSNotificationDetails(
      presentSound: false
    );

    var platformChannel = NotificationDetails(android:androidChannel , iOS: iosChannel);

    // CANCELAMOS LA  ANTERIOR Y PONEMOS LA NUEVA
    flutterLocalNotificationsPlugin.cancel(10);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      10, 
      'Meditation Reminder',
      "It's time to meditate!",
      tz.TZDateTime.from(date, tz.local),
      platformChannel,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }


  static cancelReminder() async{
    await flutterLocalNotificationsPlugin.cancel(10);
  }

}