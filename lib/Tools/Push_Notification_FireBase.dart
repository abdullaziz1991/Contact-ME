import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

Future<List<String>> getAccessToken() async {
  // Your client ID and client secret obtained from Google Cloud Console
  final serviceAccountJson = {};

  List<String> scopes = [
    //  "https://www.googleapis.com/auth/userinfo.email",
    //  "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
  ];

  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

  // Obtain the access token
  auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);
  String project_id = serviceAccountJson["project_id"]!;
  print(serviceAccountJson["project_id"]);
  print("serviceAccountJson[project_id] ---------------------------");
  // Close the HTTP client
  client.close();

  // Return the access token
  return [credentials.accessToken.data, project_id];
}

Future<void> Send_FCM_Message(
    String RecieverFCMToken, String Title, String Body) async {
  //final String serverKey = await getAccessToken(); // Your FCM server key
  String serverKey = "", project_id = "";
  await getAccessToken().then((value) =>
      {serverKey = value[0], project_id = value[1]}); // Your FCM server key
  final String fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/$project_id/messages:send';
  final currentFCMToken = await FirebaseMessaging.instance.getToken();
  // final RecieverFCMToken =
  //     "fys0QbEAShqp9373E8Hf_Y:APA91bHlHGOoCPcifdWzTB5DVy93amBQOmznPn1Q3uM4oYOqC4BdvIJUOcvNazK7OuZ6UJycdizOIxGexEE5u7MDUtaj8Pe-P5vAix04kghjRr_-nUwRajqqVw1WO70s_t-UBCxkxYUY";

  // print("fcmkey : $currentFCMToken");
  // print("serverKey : $serverKey");

  final Map<String, dynamic> message = {
    'message': {
      'token': RecieverFCMToken,
      // Token of the device you want to send the message to
      'notification': {
        // 'body': 'This is an FCM notification message!',
        // 'title': 'FCM Message'
        'title': Title,
        'body': Body
      },
      'data': {
        'current_user_fcm_token': currentFCMToken,
        // Include the current user's FCM token in data payload
      },
    }
  };

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('FCM message sent successfully');
  } else {
    print('Failed to send FCM message: ${response.statusCode}');
  }
}

void _handleSignOut(BuildContext context) async {
  try {
    FirebaseAuth.instance.signOut();
    // await _googleSignIn.signOut();
    // After sign out, navigate to the login or home screen
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             LoginPage())); // Replace '/login' with your desired route
  } catch (error) {
    print("Error signing out: $error");
  }
}
