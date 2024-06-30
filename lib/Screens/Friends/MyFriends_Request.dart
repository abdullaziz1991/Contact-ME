import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/bloc/data_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class MyFriends_Request extends StatefulWidget {
  String MyEmail;
  MyFriends_Request({required this.MyEmail});

  @override
  State<MyFriends_Request> createState() => _MyFriends_RequestState();
}

class _MyFriends_RequestState extends State<MyFriends_Request> {
  var Validation = false;
  late UsersInformationModel UsersData;
  @override
  void didChangeDependencies() {
    BlocProvider.of<DataBaseBloc>(context)
        .add(GetRequestEvent(MyEmail: widget.MyEmail));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      topImageMethod(0.6),
      bottomImageMethod(0.6, Height),
      BlocBuilder<DataBaseBloc, DataBaseState>(builder: (context, state) {
        if (state is ALLRequestState) {
          return ListView.builder(
              itemCount: state.AllMessages.length,
              itemBuilder: (BuildContext context, int index) {
                Validation = widget.MyEmail == state.AllMessages[index].Sender;
                return Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(children: [
                      SizedBox(width: 10),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(color: Colors.black54),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: Image.network(
                                  Validation
                                      ? state.AllMessages[index].ReceiverImage
                                      : state.AllMessages[index].SenderImage,
                                  fit: BoxFit.fill,
                                  height: 80,
                                  width: 80))),
                      Expanded(
                          flex: 3,
                          child: Column(children: [
                            Container(
                                child: Text(Validation
                                    ? state.AllMessages[index].ReceiverUsername
                                    : state.AllMessages[index].SenderUsername)),
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            BlocProvider.of<DataBaseBloc>(
                                                    context)
                                                .add(AcceptFriendEvent(
                                                    MyEmail: widget.MyEmail,
                                                    SenderEmail: state
                                                        .AllMessages[index]
                                                        .Sender)); ////
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    MyFriends.Route);
                                          },
                                          child: Text("Confirm")),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {},
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.white)))
                                    ]))
                          ]))
                    ]));
              });
        }
        return WaitingMethod();
      })
    ]));
  }
}
