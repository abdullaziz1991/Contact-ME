import 'package:cloud_firestore/cloud_firestore.dart';
import '/Auth_And_Tools/AppBar.dart';
import '/Screens/Drawer/Drawer.dart';
import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/bloc/data_base_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Friends/Chat.dart';

class Messages extends StatefulWidget {
  static const String Route = "Messages";
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late bool Validation;
  late var ContactUser;
  late UsersInformationModel My_Data, UsersData;
  late MyDataModle MyData;
  Future<bool> _onWillPop() async {
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => MyFriends(MyData: MyData)));
    return (true);
  }

  @override
  void didChangeDependencies() {
    routeArgument =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    My_Data = routeArgument['My_Data'];
    MyData = routeArgument['MyData'];
    BlocProvider.of<DataBaseBloc>(context)
        .add(GetALLMessagesEvent(MyEmail: MyData.Email));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          drawer: CustomDrawer(context),
          appBar: CustomAppBar('Messages'),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              topImageMethod(0.6),
              bottomImageMethod(0.6, Height),
              BlocBuilder<DataBaseBloc, DataBaseState>(
                builder: (context, state) {
                  if (state is GetALLMessagesState) {
                    return ListView.builder(
                        itemCount: state.AllMessages.length,
                        itemBuilder: (context, index) {
                          Validation =
                              MyData.Email == state.AllMessages[index].Sender;
                          ContactUser = Validation
                              ? state.AllMessages[index].ReceiverUsername
                              : state.AllMessages[index].SenderUsername;
                          print(ContactUser);
                          print("+++++++++++++++++++++ContactUser");
                          return InkWell(
                              onTap: () async {
                                var user = await FirebaseFirestore.instance
                                    .collection('Users')
                                    .get();
                                for (var doc in user.docs) {
                                  if (doc['Username'] == ContactUser) {
                                    UsersData = UsersInformationModel.fromJson(
                                        doc.data());
                                  }
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chat(
                                            My_Data: My_Data,
                                            UsersData: UsersData,
                                            MyData: MyData)));
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
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: Colors.black),
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.network(
                                                          Validation
                                                              ? state
                                                                  .AllMessages[
                                                                      index]
                                                                  .ReceiverImage
                                                              : state
                                                                  .AllMessages[
                                                                      index]
                                                                  .SenderImage,
                                                          height: 70,
                                                          width: 70,
                                                          fit: BoxFit.fill)))
                                            ]))),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(ContactUser,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "${state.AllMessages[index].the_final_message}",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 17))
                                            ])),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${state.AllMessages[index].the_final_date_i_message}",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 35, 141, 39),
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                  "${state.AllMessages[index].time}",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 150, 15, 10),
                                                      fontSize: 15))
                                            ]))
                                  ])));
                        });
                  }
                  // return WaitingMethod();
                  return SizedBox();
                },
              ),
            ],
          ),
        ));
  }
}
