import 'dart:async';

import 'package:notifications/Auth_And_Tools/Push_Notification_FireBase.dart';

import '/Auth_And_Tools/Values.dart';
import '/Screens/Drawer/Drawer.dart';
import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Friends/Chat.dart';
import '/Screens/Friends/User_Account.dart';
import '/bloc/data_base_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var usertoken, myId, We_Have_Internet = false;

class FindFriends extends StatefulWidget {
  MyDataModle MyData;
  FindFriends({required this.MyData});
  static const String Route = 'Find_Friend';
  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  // didChangeAppLifecycleState منشان  with WidgetsBindingObserver كلمة

  late String Email;
  late MyDataModle MyData;
  @override
  void initState() {
    Email = widget.MyData.Email;
    MyData = widget.MyData;
    BlocProvider.of<DataBaseBloc>(context).add(GetUsersDataEvent(Email: Email));
    // Timer.periodic(Duration(seconds: 3), (Timer timer) async {
    //   BlocProvider.of<DataBaseBloc>(context).add(UpdateStateMessagesEvent(
    //       MyEmail: MyData.Email, UsersEmail: "", CurrentPage: 'Find_Friend'));
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

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: CustomDrawer(context),
        body: Stack(children: [
          topImageMethod(0.6),
          bottomImageMethod(0.6, Height),
          BlocBuilder<DataBaseBloc, DataBaseState>(builder: (context, state) {
            if (state is DataBaseLoaded) {
              List<UsersInformationModel> UsersData = state.UserData;
              BlocProvider.of<OfflineDataBloc>(context)
                  .add(MyDataEvent(My_Data: state.My_Data, MyData: MyData));

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: UsersData.length,
                  padding: EdgeInsets.only(top: 5),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(children: [
                      ItemBackgroundMethod(UsersData, index, state.My_Data),
                      ButtonMethod(UsersData, index, context, state.My_Data)
                    ]);
                  });
            } else if (state is ConnectionError) {
              Center(child: CircularProgressIndicator());
            }
            return WaitingMethod();
          })
        ]));
  }

  Container ItemBackgroundMethod(List<UsersInformationModel> UsersData,
      int index, UsersInformationModel MyData) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Row(children: [
          Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black)),
              child: Stack(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: We_Have_Internet
                        ? Image.asset(
                            UsersData[index].Gender == "Male"
                                ? "assets/images/Male_Image.jpg"
                                : "assets/images/Female_Image.jpg",
                            height: 130,
                            width: 130,
                            fit: BoxFit.fill)
                        : Image.network("${UsersData[index].Image}",
                            height: 130, width: 130, fit: BoxFit.fill)),
                Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Icon(Icons.circle,
                        size: 20,
                        color: UsersData[index].Online == "Online"
                            ? Colors.green
                            : Color.fromARGB(255, 194, 195, 209)))
              ])),
          Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${UsersData[index].Username}",
                        style: TextStyle(
                            color: titleRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Icon(Icons.location_on,
                          size: 20, color: Color.fromARGB(255, 150, 15, 10)),
                      SizedBox(width: 2),
                      Text(
                        "${UsersData[index].Country} , ${UsersData[index].City}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      )
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      UsersData[index].Gender == "Male"
                          ? Icon(Icons.male,
                              size: 22, color: Color.fromARGB(255, 150, 15, 10))
                          : Icon(Icons.female,
                              size: 22,
                              color: Color.fromARGB(255, 150, 15, 10)),
                      SizedBox(width: 2),
                      Text(
                          "${UsersData[index].Gender} , ${UsersData[index].Age}",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true)
                    ])
                  ]))
        ]));
  }

  Container ButtonMethod(List<UsersInformationModel> UsersData, int index,
      BuildContext context, UsersInformationModel My_Data) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        height: 170,
        width: double.infinity,
        alignment: Alignment.bottomLeft,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          InkWell(
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25)),
                  child: Icon(Icons.favorite,
                      size: 25, color: Color.fromARGB(255, 150, 15, 10))),
              onTap: () async {
                BlocProvider.of<DataBaseBloc>(context).add(AddNotificationEvent(
                    MyData: My_Data,
                    UsersData: UsersData[index],
                    TextMessage: "Visited your profile"));
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UserAccount(
                            My_Data: My_Data,
                            UsersData: UsersData[index],
                            MyData: MyData)));
                Send_FCM_Message(UsersData[index].Token, "Notifcation",
                    "${My_Data.Username} has visited your profile");
              }),
          SizedBox(width: 5),
          InkWell(
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25)),
                  child: Icon(Icons.chat,
                      size: 25, color: Color.fromARGB(255, 150, 15, 10))),
              onTap: () async {
                usertoken = UsersData[index].Token;
                // await sendNotification("attached",
                //     "$usernameSender Visited your profile", usertoken);
                BlocProvider.of<DataBaseBloc>(context).add(AddNotificationEvent(
                    MyData: My_Data,
                    UsersData: UsersData[index],
                    TextMessage: "Visited your profile"));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                            My_Data: My_Data,
                            UsersData: UsersData[index],
                            MyData: MyData)));
              })
        ]));
  }
}
