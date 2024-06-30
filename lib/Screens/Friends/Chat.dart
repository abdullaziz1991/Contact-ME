// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Auth_And_Tools/Push_Notification_FireBase.dart';
import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Values.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/Screens/Friends/User_Account.dart';
import '/bloc/data_base_bloc.dart';

var theSender,
    receiver,
    routeArgument,
    IBlocktheUsersId,
    Id_Of_The_User_Who_Block_Me,
    Am_I_Block_The_User = false,
    isTheUserBlockMe = false,
    userBlockedId,
    userState;

// class logic {
//   void isUserBlocked(
//       {required String blockedUserId, required String currentUserId}) async {
//     var querySnapshots5 =
//         await FirebaseFirestore.instance.collection('blockedUsers').get();
//     for (var doc in querySnapshots5.docs) {
//       if (doc['user'] == theSender && doc['blockedUser'] == receiver) {
//         IBlocktheUsersId = doc.id;
//         //  setState(() {
//         Am_I_Block_The_User = true;

//         //    });
//         break;
//       } else if (doc['user'] == receiver && doc['blockedUser'] == theSender) {
//         //   setState(() {
//         Id_Of_The_User_Who_Block_Me = doc.id;
//         isTheUserBlockMe = true;

//         //   });
//       }
//     }
//   }
// }

class Chat extends StatefulWidget {
  UsersInformationModel My_Data;
  UsersInformationModel UsersData;
  MyDataModle MyData;
  Chat({
    Key? key,
    required this.My_Data,
    required this.UsersData,
    required this.MyData,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // final logic ani = new logic();
  final messageText = TextEditingController();

  Future<bool> _onWillPop() async {
    Navigator.popAndPushNamed(context, MyFriends.Route);
    return (true);
  }

  late UsersInformationModel My_Data;
  late MyDataModle MyData;
  @override
  void initState() {
    My_Data = widget.My_Data;
    MyData = widget.MyData;
    Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      //  if (ModalRoute.of(context)?.settings.name == Chat) {
      BlocProvider.of<DataBaseBloc>(context).add(UpdateStateMessagesEvent(
          MyEmail: widget.My_Data.Email,
          UsersEmail: widget.UsersData.Email,
          CurrentPage: 'Chat'));
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final logic ani = new logic();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Chat",
            style: TextStyle(
                color: titleRed, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserAccount(
                            MyData: MyData,
                            UsersData: widget.UsersData,
                            My_Data: My_Data)));
              },
              child: Container(
                height: 50,
                width: 50,
                child: Icon(
                    size: 30,
                    Icons.account_circle,
                    color: Color.fromARGB(255, 90, 90, 90)),
              ),
            ),
            PopupMenuButton<int>(
              icon:
                  Icon(Icons.more_vert, color: Color.fromARGB(255, 90, 90, 90)),
              color: Colors.black38,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                        Am_I_Block_The_User ? "UnBlock User" : "Block User",
                        style: TextStyle(color: Colors.white))),
                PopupMenuItem<int>(
                    value: 1,
                    child: Text("Report User",
                        style: TextStyle(color: Colors.white))),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilderMethod(),
              MessageMethod(),
            ],
          ),
        ),
      ),
    );
  }

  Container MessageMethod() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.5),
            width: 2,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: messageText,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                hintText: 'Send Message...',
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
              child: Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromARGB(255, 90, 90, 90),
                  border: Border.all(color: Colors.black),
                ),
              ),
              onTap: () async {
                Send_FCM_Message(widget.UsersData.Token, "Notifcation",
                    "${My_Data.Username} has send a message to you");
                // ani.isUserBlocked(
                //     blockedUserId: theSender, currentUserId: receiver);
                Am_I_Block_The_User || isTheUserBlockMe
                    ? userState = "blocked"
                    : userState = "Send";
                BlocProvider.of<DataBaseBloc>(context).add(AddMessageEvent(
                    MyData: widget.My_Data,
                    UsersData: widget.UsersData,
                    TextMessage: messageText.text.toString(),
                    UserState: userState));
                BlocProvider.of<DataBaseBloc>(context).add(
                    LastUpdateMessageEvent(
                        MyData: widget.My_Data,
                        UsersData: widget.UsersData,
                        TextMessage: messageText.text.toString()));
                messageText.clear();
                BlocProvider.of<DataBaseBloc>(context).add(AddNotificationEvent(
                    MyData: widget.My_Data,
                    UsersData: widget.UsersData,
                    TextMessage: "Send message to you"));
              })
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> StreamBuilderMethod() {
    CollectionReference mymessages =
        FirebaseFirestore.instance.collection("Messages");
    return StreamBuilder<QuerySnapshot>(
        stream: mymessages.orderBy("Timestamp").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return WaitingMethod();
          }
          List<MessageLine> messages = [];
          var currentMessage;

          snapshot.data!.docs.reversed.forEach((element) {
            // ani.isUserBlocked(
            //   blockedUserId: theSender, currentUserId: receiver);
            currentMessage = element.data();
            if ((currentMessage["Deliverd"] != "blocked") &&
                    (currentMessage["Sender"] == widget.MyData.Email &&
                        currentMessage["Receiver"] == widget.UsersData.Email) ||
                (currentMessage["Sender"] == widget.UsersData.Email &&
                    currentMessage["Receiver"] == widget.MyData.Email)) {
              final message = MessageLine(
                message: Message.fromJson(currentMessage),
                isMe: currentMessage["Sender"] == widget.MyData.Email,
              );
              messages.add(message);
            }
          });

          return Expanded(
              child: ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: messages));
        });
  }
}

void SelectedItem(BuildContext context, item) {
  //شلون بتستخدم ميثود من غير محل

  void blockUser({required String User, required String blockedUser}) async {
    if (Am_I_Block_The_User) {
      await FirebaseFirestore.instance
          .collection('blockedUsers')
          .doc(IBlocktheUsersId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("unblocked"),
      ));
      Am_I_Block_The_User = false;
    } else {
      await FirebaseFirestore.instance
          .collection('blockedUsers')
          .add({'user': User, 'blockedUser': blockedUser}).then((value) async {
        IBlocktheUsersId = value.id;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("user has blocked"),
        ));
      });
      Am_I_Block_The_User = true;
    }
  }

  switch (item) {
    case 0:
      blockUser(User: theSender, blockedUser: receiver);
      break;
    case 1:
      print("case 1");
      break;
    case 2:
      print("case 2");

      break;
  }
}
