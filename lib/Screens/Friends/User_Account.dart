// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Values.dart';
import '/Screens/Friends/Chat.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/bloc/data_base_bloc.dart';

var serverToken =
    "AAAA375hhtg:APA91bHZ7rKHsBsywhfJnVPm_xZxLjeDdyRQX2TSxGiNJuszKzyBX2OywJPejO3IdJBYSJo1TpvtseVh5ZlRm2gU9zhmyRmAtrZeeBL05ksrvQsMpOY_B5Elm912cLY6NVEq0xFUK8A6";

class UserAccount extends StatefulWidget {
  static const String Route = 'UserAccount';
  UsersInformationModel My_Data;
  UsersInformationModel UsersData;
  MyDataModle MyData;
  UserAccount({
    Key? key,
    required this.My_Data,
    required this.UsersData,
    required this.MyData,
  }) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  bool isConfirmed = false, isMyFriend = false, isMyFavorite = false;
  Future<bool> _onWillPop() async {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => MyFriends(MyData: widget.MyData)));
    return (true);
  }

  // @override
  // initState() {
  //   BlocProvider.of<DataBaseBloc>(context).add(DidIAddTheFriendEvent(
  //       MyData: widget.MyData, UsersData: widget.UsersData));
  //   super.initState();
  // }

  @override
  Future<void> didChangeDependencies() async {
    final People_I_Contact_with =
        FirebaseFirestore.instance.collection("People_I_Contact_with");
    var addFriends = await People_I_Contact_with.get();
    final MyFavorite =
        await FirebaseFirestore.instance.collection("MyFavorite");
    var addFavorite = await MyFavorite.get();
    DidIAddTheFriendMethod(
            addFriends, addFavorite, widget.My_Data, widget.UsersData)
        .then((value) => {
              setState(() {
                isConfirmed = value[0];
                isMyFriend = value[1];
                isMyFavorite = value[2];
              })
            });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(children: [
            ListView(children: [
              Stack(children: [
                Container(
                    width: width,
                    height: 2.5 / 4 * height,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(widget.UsersData.Image,
                            fit: BoxFit.cover,
                            width: width,
                            height: 2.5 / 4 * height))),
                Container(
                    alignment: Alignment.bottomCenter,
                    width: width,
                    height: 2.5 / 4 * height,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(20),
                        height: 1 / 8 * height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: TextShadowMethod()))
              ]),
              SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //SizedBox(width: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextMethod(Colors.black, 18,
                                  "${widget.UsersData.Username}   ${widget.UsersData.Lastname}"),
                              TextMethod(Colors.black54, 15,
                                  "${widget.UsersData.Gender} , ${widget.UsersData.Country}")
                            ])
                      ])),
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextMethod(Colors.black, 18, "Bio")),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      "Stress is the result of working hard for something we don’t care about.",
                      style: TextStyle(fontSize: 16)))
            ]),
            TwoButtonsMethod(context, widget.My_Data, widget.UsersData)
          ])),
    );
  }

  Container TextMethod(Color color, double size, String text) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Text(text,
            style: TextStyle(
                fontSize: size, color: color, fontWeight: FontWeight.bold)));
  }

  Row TextShadowMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Stack(children: <Widget>[
            Text("  ${widget.UsersData.Firstname}  ",
                style: TextStyle(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = Colors.black!)),
            Text("  ${widget.UsersData.Firstname}  ",
                style: TextStyle(
                    // fontSize: 40,
                    color: Colors.white))
          ]),
          Icon(Icons.whatshot, color: titleRed)
        ]),
        InkWell(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: titleRed),
              child: Text("Chat",
                  style: TextStyle(fontSize: 16, color: Colors.white))),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                        My_Data: widget.My_Data,
                        UsersData: widget.UsersData,
                        MyData: widget.MyData)));

            // var querySnapshots7 = await FirebaseFirestore.instance
            //     .collection('messages')
            //     .get();
            // for (var doc in querySnapshots7.docs) {
            //   if (doc['sender'] == UsersData.Email &&
            //       doc['receiver'] == MyEmail &&
            //       doc['deliverd'] == "getIt") {
            //     FirebaseFirestore.instance
            //         .collection('messages')
            //         .doc(doc.id)
            //         .update({
            //       'deliverd': "recieved",
            //     });
            //   }
            // }
          },
        )
      ],
    );
  }

  TwoButtonsMethod(BuildContext context, UsersInformationModel MyData,
      UsersInformationModel UsersData) {
    // bool isMyFriend = false, isConfirmed = false, isMyFavorite = false;
    return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 60,
            width: double.infinity,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Button 1
                  InkWell(
                      onTap: () async {
                        final People_I_Contact_with = FirebaseFirestore.instance
                            .collection("People_I_Contact_with");
                        var addFriends = await People_I_Contact_with.get();

                        if (isMyFriend == false && isConfirmed == false) {
                          // await sendNotification(
                          //     "attached", "$MyEmail Send you friend request");
                          await AddFriendMethod(People_I_Contact_with,
                              addFriends, MyData, UsersData);
                          setState(() {
                            isMyFriend = true;
                            isConfirmed == false;
                          });
                          print("1");
                        } else if (isMyFriend == true && isConfirmed == false) {
                          DeleteAddFriendMethod(People_I_Contact_with,
                              addFriends, MyData, UsersData);
                          setState(() {
                            isMyFriend = false;
                            isConfirmed == false;
                          });
                          print("2");
                        } else if (isConfirmed == true) {
                          ShowDialogMethod(context, People_I_Contact_with,
                                  addFriends, MyData, UsersData)
                              .then((value) => setState(() {
                                    isMyFriend = false;
                                    isConfirmed = false;
                                  }));
                          print("3");
                        }
                      },
                      child: isConfirmed
                          ? Icon(Icons.people, color: titleRed, size: 40)
                          : (isMyFriend
                              ? Icon(Icons.person_add,
                                  color: titleRed, size: 40)
                              : Icon(
                                  color: Colors.grey,
                                  Icons.person_add,
                                  size: 40,
                                ))),
                  //Button 2
                  InkWell(
                      onTap: () async {
                        if (isMyFavorite == false) {
                          await FirebaseFirestore.instance
                              .collection("MyFavorite")
                              .add({
                            "Sender": MyData.Email,
                            "I_Like": UsersData.Email
                          });
                          setState(() {
                            isMyFavorite = true;
                          });
                        } else if (isMyFavorite == true) {
                          final MyFavorite = await FirebaseFirestore.instance
                              .collection("MyFavorite");
                          var documents = await MyFavorite.get();
                          for (var doc in documents.docs) {
                            if (doc['Sender'] == MyData.Email &&
                                doc['I_Like'] == UsersData.Email) {
                              await MyFavorite.doc(doc.id).delete();
                            }
                          }
                          setState(() {
                            isMyFavorite = false;
                          });
                        }
                      },
                      child: isMyFavorite
                          ? Icon(Icons.grade, color: titleRed, size: 40)
                          : Icon(
                              color: Colors.grey,
                              Icons.grade,
                              size: 40,
                            ))
                ])));
  }
}

Future<List<bool>> ShowDialogMethod(
    BuildContext context,
    CollectionReference<Map<String, dynamic>> People_I_Contact_with,
    QuerySnapshot<Map<String, dynamic>> addFriends,
    UsersInformationModel MyData,
    UsersInformationModel UsersData) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Text("Do you want to Cancel Friend Relationship"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  DeleteAddFriendMethod(
                      People_I_Contact_with, addFriends, MyData, UsersData);

                  // setState(() {
                  //   isConfirmed = false;
                  //   isMyFriend = false;
                  // });
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ]);
      });
  return [false, false];
}

AddFriendMethod(
    CollectionReference<Map<String, dynamic>> People_I_Contact_with,
    QuerySnapshot<Map<String, dynamic>> addFriends,
    UsersInformationModel MyData,
    UsersInformationModel UsersData) async {
  bool isExisted = false;
  for (var doc in addFriends.docs) {
    if ((doc['Sender'] == MyData.Email && doc['Receiver'] == UsersData.Email) ||
        (doc['Receiver'] == MyData.Email && doc['Sender'] == UsersData.Email)) {
      isExisted = true;
      await People_I_Contact_with.doc(doc.id)
          .update({"Confirmed": "Requested"});
    }
  }
  if (isExisted == false) {
    People_I_Contact_with.add({
      "Confirmed": "Requested",
      "Sender": MyData.Email,
      "SenderUsername": MyData.Username,
      "SenderImage": MyData.Image,
      "Receiver": UsersData.Email,
      "ReceiverImage": UsersData.Image,
      'the_final_message': "",
      'the_final_date_i_message':
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'ReceiverUsername': UsersData.Username,
      "MyToken": MyData.Token,
      "onlineStatus": MyData.Online,
      "time": DateFormat('hh:mm a').format(DateTime.now())
    });
  }
}

Future<List<bool>> DidIAddTheFriendMethod(
    QuerySnapshot<Map<String, dynamic>> addFriends,
    QuerySnapshot<Map<String, dynamic>> addFavorite,
    UsersInformationModel MyData,
    UsersInformationModel UsersData) async {
  bool isConfirmed = false, isMyFriend = false, isMyFavorite = false;
  for (var doc in addFriends.docs) {
    if ((doc['Sender'] == MyData.Email && doc['Receiver'] == UsersData.Email) ||
        (doc['Receiver'] == MyData.Email && doc['Sender'] == UsersData.Email)) {
      if (doc['Confirmed'] == "Yes") {
        isConfirmed = true;
        break;
      }
      if (doc['Confirmed'] == "Requested") {
        isMyFriend = true;
        break;
      }
    }
  }

  for (var doc in addFavorite.docs) {
    if (doc['Sender'] == MyData.Email && doc['I_Like'] == UsersData.Email) {
      isMyFavorite = true;
      break;
    }
  }
  return [isConfirmed, isMyFriend, isMyFavorite];
}

DeleteAddFriendMethod(
    CollectionReference<Map<String, dynamic>> People_I_Contact_with,
    QuerySnapshot<Map<String, dynamic>> friends,
    UsersInformationModel MyData,
    UsersInformationModel UsersData) async {
  for (var doc in friends.docs) {
    if ((doc['Sender'] == MyData.Email && doc['Receiver'] == UsersData.Email) ||
        (doc['Receiver'] == MyData.Email && doc['Sender'] == UsersData.Email)) {
      //&& doc['Confirmed'] == "Yes"
      await People_I_Contact_with.doc(doc.id).delete();
    }
  }
}

    // return Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     alignment: Alignment.bottomCenter,
    //     child: Container(
    //         height: 60,
    //         width: double.infinity,
    //         child: BlocBuilder<DataBaseBloc, DataBaseState>(
    //             builder: (context, state) {
    //           if (state is DidIAddTheFriendState) {
    //             isMyFriend = state.isMyFriend;
    //             isConfirmed = state.isConfirmed;
    //             isMyFavorite = state.isMyFavorite;
    //             print("$isMyFriend isMyFriend++++++++++++++");
    //             print("$isConfirmed isConfirmed++++++++++++++");
    //             print("$isMyFavorite isMyFavorite++++++++++++++");
    //             return Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   //Button 1
    //                   InkWell(
    //                       onTap: () async {
    //                         setState(() {
    //                           if (state.isMyFriend == false &&
    //                               state.isConfirmed == false) {
    //                             // await sendNotification(
    //                             //     "attached", "$MyEmail Send you friend request");
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 AddFriendEvent(
    //                                     MyData: widget.MyData,
    //                                     UsersData: widget.UsersData));
    //                             print("1");
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 DidIAddTheFriendEvent(
    //                                     MyData: widget.MyData,
    //                                     UsersData: widget.UsersData));
    //                             print(
    //                                 "${state.isMyFriend} 777 isMyFriend++++++++++++++");
    //                             print(
    //                                 "${state.isConfirmed} 777 isConfirmed++++++++++++++");
    //                             print(
    //                                 "${state.isMyFavorite} 777 isMyFavorite++++++++++++++");

    //                             // setState(() {
    //                             //   isMyFriend = true;
    //                             //   isConfirmed == false;
    //                             // });
    //                           } else if (state.isMyFriend == true &&
    //                               state.isConfirmed == false) {
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 DeleteAddFriendEvent(
    //                                     MyEmail: widget.MyData.Email,
    //                                     UserEmail: widget.UsersData.Email));
    //                             //Future.delayed(Duration(seconds: 3));
    //                             // context.watch<DataBaseBloc>().state;
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 DidIAddTheFriendEvent(
    //                                     MyData: widget.MyData,
    //                                     UsersData: widget.UsersData));
    //                             print("2");
    //                             // print(
    //                             //     "${state.isMyFriend} 777 isMyFriend++++++++++");
    //                             // print(
    //                             //     "${state.isConfirmed} 777 isConfirmed++++++++++");
    //                             // print(
    //                             //     "${state.isMyFavorite} 777 isMyFavorite+++++++++");
    //                             // setState(() {
    //                             //   isMyFriend = false;
    //                             //   isConfirmed == false;
    //                             // });
    //                           } else if (state.isConfirmed == true) {
    //                             showDialog(
    //                                 context: context,
    //                                 builder: (context) {
    //                                   return AlertDialog(
    //                                       content: Text(
    //                                           "Do you want to Cancel Friend Relationship"),
    //                                       actions: [
    //                                         ElevatedButton(
    //                                           onPressed: () async {
    //                                             BlocProvider.of<DataBaseBloc>(
    //                                                     context)
    //                                                 .add(DeleteAddFriendEvent(
    //                                                     MyEmail:
    //                                                         widget.MyData.Email,
    //                                                     UserEmail: widget
    //                                                         .UsersData.Email));

    //                                             // setState(() {
    //                                             //   isConfirmed = false;
    //                                             //   isMyFriend = false;
    //                                             // });
    //                                             // print(
    //                                             //     "$isConfirmed isConfirmed ----------------------");
    //                                             Navigator.pop(context);
    //                                           },
    //                                           child: Text("Ok"),
    //                                         ),
    //                                         ElevatedButton(
    //                                             onPressed: () {
    //                                               Navigator.pop(context);
    //                                             },
    //                                             child: Text("Cancel"))
    //                                       ]);
    //                                 });
    //                             print("3");
    //                           }
    //                           // BlocProvider.of<DataBaseBloc>(context).add(
    //                           //     DidIAddTheFriendEvent(
    //                           //         MyData: widget.MyData,
    //                           //         UsersData: widget.UsersData));
    //                           // BlocProvider.of<DataBaseBloc>(context).add(
    //                           //     DeleteAddFriendEvent(
    //                           //         MyEmail: widget.MyData.Email,
    //                           //         UserEmail: widget.UsersData.Email));
    //                           //setState(() {});
    //                           // print("$isMyFriend is999MyFriend++++++++++++++");
    //                           // print("$isConfirmed isC999onfirmed++++++++++++++");
    //                           // print("$isMyFavorite isC999isMyFavorite++++++++++");
    //                         });
    //                       },
    //                       child: state.isConfirmed
    //                           ? Icon(Icons.people, color: titleRed, size: 40)
    //                           : (state.isMyFriend
    //                               ? Icon(Icons.person_add,
    //                                   color: titleRed, size: 40)
    //                               : Icon(
    //                                   color: Colors.grey,
    //                                   Icons.person_add,
    //                                   size: 40,
    //                                 ))),
    //                   //Button 2
    //                   InkWell(
    //                       onTap: () async {
    //                         setState(() async {
    //                           if (state.isMyFavorite == false) {
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 AddFavoriteEvent(
    //                                     MyEmail: widget.MyData.Email,
    //                                     UserEmail: widget.UsersData.Email));
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 DidIAddTheFriendEvent(
    //                                     MyData: widget.MyData,
    //                                     UsersData: widget.UsersData));
    //                             //isMyFavorite = false;
    //                           }
    //                           if (state.isMyFavorite == true) {
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 DeleteFavoriteEvent(
    //                                     MyEmail: widget.MyData.Email,
    //                                     UserEmail: widget.UsersData.Email));
    //                             BlocProvider.of<DataBaseBloc>(context).add(
    //                                 DidIAddTheFriendEvent(
    //                                     MyData: widget.MyData,
    //                                     UsersData: widget.UsersData));
    //                             //isMyFavorite = true;
    //                           }
    //                         });
    //                       },
    //                       child: state.isMyFavorite
    //                           ? Icon(Icons.grade, color: titleRed, size: 40)
    //                           : Icon(
    //                               color: Colors.grey,
    //                               Icons.grade,
    //                               size: 40,
    //                             ))
    //                 ]);
    //           }
    //           return SizedBox();
    //         })));