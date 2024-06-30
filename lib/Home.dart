// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:http/http.dart' as http;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

// class HomePage extends StatelessWidget {
//   HomePage({super.key});
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<List<String>> getAccessToken() async {
//     // Your client ID and client secret obtained from Google Cloud Console
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "contact-with-me-e90d0",
//       "private_key_id": "dd16573acfcb1b9849b4f825d6e00c9a5792f891",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCvLxW1pMM5Hm8m\n3QTuEVLNmhx4KqWZ+XJGA9zDh+HAvtM/iP78ANN3nUBuwsicvhsfIIFYzKudSmck\nu9NG1CmX4VcpmHwMbskGYvpVagR2BZKmsaT4BkuRNRFedrDwoxtUtKItrCKdFpAK\nEUtsSNL5Ll44E+/OloV/uMhLGpnlC/m6FemryAo/E8R5P3R+yw6TdgFT0VqewJ+/\nQpUQyadbhSa1aflYWGMc/ICxeWCvR70FLdWB9tPZUIajFlHaRbMjWVdgv57qwkJK\nvAvA6LVqnJ8mTnl/Uq258h/3j3gTUtoNSRumRMaFkArzBNZig0J0s74XEXsak9So\nlQjWq6P5AgMBAAECggEAF2p7xGPZlHD0+oTge9Hk94Z597X7nLEzDRjHEXvAOTtI\nkV2Gd7jEi2CBlEyE9C6VAXwezffNmKCxWL+iZf1F8f8032J6ck78n9XrEC+zmPL1\nv0JPgreUsjwdrjq/O+sRZCkg5Gn11nmFl1Loefjh+lywS16e10ZXYdMZMrDDkVHn\n2aKgqQ16O6CRtFGbBumIR2NJL1I8RMTLfv7bBN+v7aSGgwt7JwwtPaeCUEiPKn0v\n/oVuPQIQ5nNrQ1uPjjnqA46tFWv5DOdeW0/YLzIR3N3QuVmK2e8EGTMnk7NIVitr\n9fYGstTbORu+hu8skGqGBk64jy/oOcFme9jT+GWL4QKBgQDV3flkFadeeSdcKVhr\n6R2AhRNZx6jR+OPkx9wyqYVtVjnmZV6BP2Id35ON9YUmA8LDQAj6iwlvA00i9iTm\naUoOXk4unukCPGeOIfd4wBg2U9HYOlrzio+ZkY7rM+ZBFJqe6fdg8hTPVmwEW8v2\nzNJEhptbaL19/O9lJDJ/CJVfswKBgQDRsjDLYdAmtuEHnTCyTRHf2xTJIxYxeS1h\nUGe6bucJtEXArQjzOx1r/tlm7xHvxKQ7H3ZPFj8MNujrxu2YCwHy7e/JfCNW/G2L\noqAANg18FLKIhi+34rSkKoNySNZzvOozJhERLlsKLjxZvd1b+RQqF5I5IKNCvJJt\nQnnsMd73owKBgEDzE60YgmbHhnOPvuGuvx3rzC+k2hlCa/tr0uyz3OiSmizlNiks\nVaDa6FXhbVlZJQnk5ZUpKmlDaGaouBYdfbcVXsr7yam7LHvWxvAt7mx5Ui5Hsp1p\nxCiQMwYtEc1L85U1WsJfYoCBL3a3Zh8CnwzekEnXakzbxtxBfPBla+/PAoGAbK0p\n5q35v6a190k7DJ0ur1KOcjOR8+/2WeHe8Fs7t+bK47GJ2uz/MZIxv8wVAqtp5g5H\nNXO1FzJ6An/lcQ/7YZh41nZUpmdKqryMqa9Zy726TVEl9+oxbodt+lPPeMomon2P\nCNV6b0tJEcV5rInpLmtq59qHYjXyuVdjcsrh4HsCgYAkDvW3nT1/bcnEHs/FdWsa\nakQOAH4Ph+AdSFir/ZyLsITmXkuVjX1BulrcvsQLTJrLyGrkQF8cbPuPKPUKfTfw\nBgP3Gq7kTEvQbJCCFrskkRlBhiRanzmrNwPpkxkuGH7wWWkiYQKcHQuFDUw+V+0F\nDjVlxodWaozldlSuH72tJA==\n-----END PRIVATE KEY-----\n",
//       "client_email":
//           "notification-services@contact-with-me-e90d0.iam.gserviceaccount.com",
//       "client_id": "111296786323277194057",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/notification-services%40contact-with-me-e90d0.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };

//     List<String> scopes = [
//       //  "https://www.googleapis.com/auth/userinfo.email",
//       //  "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];

//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );

//     // Obtain the access token
//     auth.AccessCredentials credentials =
//         await auth.obtainAccessCredentialsViaServiceAccount(
//             auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//             scopes,
//             client);
//     String project_id = serviceAccountJson["project_id"]!;
//     print(serviceAccountJson["project_id"]);
//     print("serviceAccountJson[project_id] ---------------------------");
//     // Close the HTTP client
//     client.close();

//     // Return the access token
//     return [credentials.accessToken.data, project_id];
//   }

//   Future<void> sendFCMMessage() async {
//     //final String serverKey = await getAccessToken(); // Your FCM server key
//     String serverKey = "", project_id = "";
//     await getAccessToken().then((value) =>
//         {serverKey = value[0], project_id = value[1]}); // Your FCM server key
//     final String fcmEndpoint =
//         'https://fcm.googleapis.com/v1/projects/$project_id/messages:send';
//     final currentFCMToken = await FirebaseMessaging.instance.getToken();
//     final RecieverFCMToken =
//         "fys0QbEAShqp9373E8Hf_Y:APA91bHlHGOoCPcifdWzTB5DVy93amBQOmznPn1Q3uM4oYOqC4BdvIJUOcvNazK7OuZ6UJycdizOIxGexEE5u7MDUtaj8Pe-P5vAix04kghjRr_-nUwRajqqVw1WO70s_t-UBCxkxYUY";

//     // final RecieverFCMToken =
//     //     "emgCA-LHTTe-uIUwU9dmHt:APA91bGkQfwPfHgu3ny4vkSYiXA7RKnb5MPQTmIp6IgWe4JjgHLUyRYHElLrdvja2hdDFCA1kG-acB7ZS89SyvgMNr1w8Uak7xYL7sAQ_E7gOskWNUoz20ED5iwMLNCo0FFH0bkOsFQn";

//     print("fcmkey : $currentFCMToken");
//     print("serverKey : $serverKey");

//     final Map<String, dynamic> message = {
//       'message': {
//         'token':
//             RecieverFCMToken, // Token of the device you want to send the message to
//         'notification': {
//           'body': 'This is an FCM notification message!',
//           'title': 'FCM Message'
//         },
//         'data': {
//           'current_user_fcm_token':
//               currentFCMToken, // Include the current user's FCM token in data payload
//         },
//       }
//     };

//     final http.Response response = await http.post(
//       Uri.parse(fcmEndpoint),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $serverKey',
//       },
//       body: jsonEncode(message),
//     );

//     if (response.statusCode == 200) {
//       print('FCM message sent successfully');
//     } else {
//       print('Failed to send FCM message: ${response.statusCode}');
//     }
//   }

//   void _handleSignOut(BuildContext context) async {
//     try {
//       FirebaseAuth.instance.signOut();
//       await _googleSignIn.signOut();
//       // After sign out, navigate to the login or home screen
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) =>
//       //             LoginPage())); // Replace '/login' with your desired route
//     } catch (error) {
//       print("Error signing out: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Page"),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         titleTextStyle: TextStyle(
//             color: Colors.lightBlue[200],
//             fontWeight: FontWeight.w800,
//             fontSize: 28),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(left: 160),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 sendFCMMessage();
//               },
//               style: ButtonStyle(
//                 backgroundColor:
//                     MaterialStateProperty.all(Colors.lightBlue[100]),
//                 foregroundColor: MaterialStatePropertyAll(Colors.white),
//               ),
//               child: const Text("send"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _handleSignOut(context);
//               },
//               style: ButtonStyle(
//                 backgroundColor:
//                     MaterialStateProperty.all(Colors.lightBlue[100]),
//                 foregroundColor: MaterialStatePropertyAll(Colors.white),
//               ),
//               child: const Text("LogOut"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//           // <intent-filter>
//           //       <action android:name="FLUTTER_NOTIFICATION_CLICK"/>
//           //       <category android:name="android.intent.category.DEFAULT"/>
//           //   </intent-filter>