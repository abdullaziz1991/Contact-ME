// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Auth_And_Tools/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Auth_And_Tools/Models.dart';
import '/Screens/Friends/Chat.dart';
import '/bloc/data_base_bloc.dart';

// ignore: must_be_immutable
class MyFriends_Confirmed extends StatefulWidget {
  MyDataModle MyData;
  MyFriends_Confirmed({required this.MyData});
  @override
  State<MyFriends_Confirmed> createState() => _MyFriends_ConfirmedState();
}

class _MyFriends_ConfirmedState extends State<MyFriends_Confirmed> {
  var ContactUser, EmailUser, Validation = false;
  late UsersInformationModel My_Data, UsersData;
  late MyDataModle MyData;
  @override
  void didChangeDependencies() {
    MyData = widget.MyData;
    BlocProvider.of<DataBaseBloc>(context)
        .add(ALLMyFriendsEvent(MyEmail: widget.MyData.Email));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    return Scaffold(body: SafeArea(child:
        BlocBuilder<DataBaseBloc, DataBaseState>(builder: (context, state) {
      if (state is GetALLMessagesState) {
        return Scaffold(
            body: Stack(children: [
          topImageMethod(0.6),
          bottomImageMethod(0.6, Height),
          ListView.builder(
              itemCount: state.AllMessages.length,
              itemBuilder: (context, index) {
                Validation = state.MyEmail == state.AllMessages[index].Sender;
                return InkWell(
                    onTap: () async {
                      var user = await FirebaseFirestore.instance
                          .collection('users')
                          .get();
                      EmailUser = Validation
                          ? state.AllMessages[index].Receiver
                          : state.AllMessages[index].Sender;
                      for (var doc in user.docs) {
                        if (doc['email'] == EmailUser) {
                          UsersData =
                              UsersInformationModel.fromJson(doc.data());
                        } else if (doc['email'] == widget.MyData.Email) {
                          My_Data = UsersInformationModel.fromJson(doc.data());
                        }
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                    My_Data: My_Data,
                                    UsersData: UsersData,
                                    MyData: MyData,
                                  )));
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.1)),
                            color: Colors.white.withOpacity(0.8)),
                        child: Row(children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  height: 75,
                                  width: 75,
                                  child: Stack(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                                Validation
                                                    ? state.AllMessages[index]
                                                        .ReceiverImage
                                                    : state.AllMessages[index]
                                                        .SenderImage,
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fill)))
                                  ]))),
                          Expanded(
                              flex: 2,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        Validation
                                            ? state.AllMessages[index]
                                                .ReceiverUsername
                                            : state.AllMessages[index]
                                                .SenderUsername,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "${state.AllMessages[index].the_final_message}",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16))
                                  ])),
                          Expanded(
                              flex: 1,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${state.AllMessages[index].the_final_date_i_message}",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 35, 141, 39),
                                            fontSize: 15)),
                                    Text("${state.AllMessages[index].time}",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 150, 15, 10),
                                            fontSize: 15))
                                  ]))
                        ])));
              })
        ]));
      }
      return WaitingMethod();
    })));
  }
}
