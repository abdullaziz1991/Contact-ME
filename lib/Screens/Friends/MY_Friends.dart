// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications/Home.dart';
import '/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Values.dart';
import '/Screens/Drawer/Drawer.dart';
import '/Screens/Friends/Find_Frinds.dart';
import '/Screens/Friends/MyFriends_Confirmed.dart';
import '/bloc/data_base_bloc.dart';

import 'MyFriends_Request.dart';

class MyFriends extends StatefulWidget {
  static const String Route = 'MyFriends';
  // MyDataModle MyData;
  MyDataModle MyData;
  MyFriends({
    Key? key,
    required this.MyData,
  }) : super(key: key);

  @override
  State<MyFriends> createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> with WidgetsBindingObserver {
  late final FirebaseMessaging _fireBaseMessaging;

  late FirebaseMessaging _messaging;
//  late int _totalNotifications;
  //  late PushNotification _notificationInfo;

//   void registerNotification() async {
//     await Firebase.initializeApp();
//     _messaging = FirebaseMessaging.instance;

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');

//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print(
//           'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data},',
//         );

//         // Parse the message received
//         PushNotification notification = PushNotification(
//           title: message.notification?.title,
//           body: message.notification?.body,
//           dataTitle: message.data['title'],
//           dataBody: message.data['body'],
//         );

//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });

//         if (_notificationInfo != null) {
//           // For displaying the notification as an overlay
//           showSimpleNotification(
//             Text(_notificationInfo.title!),
//             subtitle: Text(_notificationInfo.body!),
//             background: Colors.cyan.shade700,
//             duration: Duration(seconds: 2),
//           );
//         }
//       });
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

// // For handling notification when the app is in terminated state
//   checkForInitialMessage() async {
//     await Firebase.initializeApp();
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {
//       PushNotification notification = PushNotification(
//         title: initialMessage.notification?.title,
//         body: initialMessage.notification?.body,
//         dataTitle: initialMessage.data['title'],
//         dataBody: initialMessage.data['body'],
//       );

//       setState(() {
//         _notificationInfo = notification;
//         _totalNotifications++;
//       });
//     }
//   }

  late String Email, MyID;
  late MyDataModle MyData;

  @override
  void initState() {
    MyData = widget.MyData;
    Email = widget.MyData.Email;
    MyID = widget.MyData.MyID;
    WidgetsBinding.instance.addObserver(this);
    //getMessage();
    // _totalNotifications = 0;
    // registerNotification();
    // checkForInitialMessage();

    // // For handling notification when the app is in background
    // // but not terminated
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   PushNotification notification = PushNotification(
    //     title: message.notification?.title,
    //     body: message.notification?.body,
    //     dataTitle: message.data['title'],
    //     dataBody: message.data['body'],
    //   );

    //   setState(() {
    //     _notificationInfo = notification;
    //     _totalNotifications++;
    //   });
    // });

    super.initState();
  }

  // getMessage() {
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     print(event.notification?.title);
  //     print(event.notification?.body);
  //     print(event.data['name']);
  //     print(event.data['token']);
  //     Navigator.pushReplacementNamed(context, "find_friend");
  //   });
  // }

  // getMessage() {
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     print(event.notification?.title);
  //     print(event.notification?.body);
  //     print(event.data['name']);
  //     print(event.data['token']);
  //     Navigator.pushReplacementNamed(context, "find_friend");
  //   });
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final _firestore = FirebaseFirestore.instance.collection('Users');
    // فقط تعمل هذه عند ضغط زر القائمة
    if (state == AppLifecycleState.resumed) {
      print("resumed @@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      _firestore.doc(MyID).update({"Online": "Online"});
      // user returned to our app
      // المستخدم كبس زر القائمة وعاد الى تطبينا
    } else if (state == AppLifecycleState.inactive) {
      print("inactive @@@@@@@@@@@@@@@@@@@@@@@@@@@@");

      // app is inactive
      // المستخدم ضغط زر القائمة وطلع من التطبيق
      // pause ايقاف عمل التطبيق والانتقال الى
    } else if (state == AppLifecycleState.paused) {
      print("paused @@@@@@@@@@@@@@@@@@@@@@@@@@@@");

      _firestore.doc(MyID).update({"Online": "Offline"});
      // user is about quit our app temporally
      //inactive  ينتقل الى هذه الحالة بعد ال
    } else if (state == AppLifecycleState.detached) {
      print("detached @@@@@@@@@@@@@@@@@@@@@@@@@@@@");

      // app suspended (not used in iOS)
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    // NotificationSettings settings = await _messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   provisional: false,
    //   sound: true,
    // );
    // Future<void> requestNotificationPermissions() async {
    //   final PermissionStatus status = await Permission.notification.request();
    //   if (status.isGranted) {
    //     print("status.isGranted =====================");
    //     // Notification permissions granted
    //   } else if (status.isDenied) {
    //     // Notification permissions denied
    //     print("status.isDenied =====================");
    //   } else if (status.isPermanentlyDenied) {
    //     // Notification permissions permanently denied, open app settings
    //     print("status.isPermanentlyDenied =====================");
    //     await openAppSettings();
    //   }
    // }

    // requestNotificationPermissions();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground! 1111111111111111');
    //   print('Message data: ${message.notification?.title}');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
    // @pragma('vm:entry-point')
    // Future<void> _firebaseMessagingBackgroundHandler(
    //     RemoteMessage message) async {
    //   // If you're going to use other Firebase services in the background, such as Firestore,
    //   // make sure you call `initializeApp` before using other Firebase services.
    //   ///await Firebase.initializeApp();

    //   print("Handling a background message: ${message.messageId}");
    //   print("${message.notification!.body}");
    // }

    // getMessage() {
    //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //     print(event.notification?.title);
    //     print(event.notification?.body);
    //     print(event.data['name']);
    //     print(event.data['token']);
    //     Navigator.pushReplacementNamed(context, "find_friend");
    //   });
    // }

    var Height = MediaQuery.of(context).size.height;
    final _pageController = PageController(
      initialPage: 0,

      // viewportFraction: 0.8,
    );
    setState(() {
      if (_pageController == 0) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => MyApp()),
        );
      }
    });
    int pageIndex = 0;
    return BlocBuilder<DataBaseBloc, DataBaseState>(builder: (context, state) {
      // if (state is DataBaseLoaded) {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: CustomDrawer(context),
            appBar: AppBar(
                title: Text('Find New Friends',
                    style: TextStyle(
                        color: titleRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                bottom: TabBar(tabs: [
                  Tab(text: "Find Friends"),
                  Tab(text: "My Friends"),
                  Tab(text: "Friend Requests"),
                ])),
            body: TabBarView(children: [
              FindFriends(MyData: MyData),
              MyFriends_Confirmed(MyData: MyData),
              MyFriends_Request(MyEmail: Email)
              // HomePage()
            ]),
          ));
    });
  }
}
