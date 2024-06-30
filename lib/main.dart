import 'package:notifications/firebase_options.dart';
import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/bloc/data_base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/Drawer/Set_Profile_Image.dart';
import 'Screens/Drawer/Messages.dart';
import 'Screens/Drawer/Notifications.dart';
import 'Screens/Drawer/Visitors.dart';
import 'Auth_And_Tools/SignIn.dart';
import 'Auth_And_Tools/Sign_Up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Screens/Friends/MY_Friends.dart';

bool userauth = false;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  ///await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print("${message.notification!.body}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs().init();
  requestNotificationPermission();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.notification?.title}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (user == null) {
  //     userauth = false;
  //   } else {
  //     userauth = true;
  //   }
  //   print("login $userauth =================");
  // });
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  runApp(MyApp());
}

Future<void> requestNotificationPermission() async {
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
  print('Notification permission granted: ${settings.authorizationStatus}');
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyDataModle MyData = MyDataModle(
      Email: SharedPrefs().Email,
      Password: SharedPrefs().Password,
      MyID: SharedPrefs().MyID);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DataBaseBloc()),
          BlocProvider(create: (_) => OfflineDataBloc()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MyData.Email == "" ? SignIn() : MyFriends(MyData: MyData),
            theme: ThemeData(
                primaryColor: Colors.blue,
                textTheme: TextTheme(
                    headline6: TextStyle(fontSize: 20, color: Colors.white),
                    headline5: TextStyle(fontSize: 30, color: Colors.blue),
                    bodyText2: TextStyle(fontSize: 20, color: Colors.black))),
            routes: {
              // findFriends.Route: (context) => findFriends(),
              SignIn.Route: (context) => SignIn(),
              SignUp.Route: (context) => SignUp(),
              Messages.Route: (context) => Messages(),
              Visitors.Route: (context) => Visitors(),
              Notifications.Route: (context) => Notifications(),
              MyFriends.Route: (context) => MyFriends(MyData: MyData),
              SetProfileImage.Route: (context) => SetProfileImage()
            }));
  }
}
