import '/Auth_And_Tools/AppBar.dart';
import '/Screens/Drawer/Drawer.dart';
import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/bloc/data_base_bloc.dart';
import '/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Notifications extends StatefulWidget {
  static const String Route = 'Notifications';

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late UsersInformationModel My_Data;

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => MyApp()),
    );
    return (true);
  }

  @override
  void didChangeDependencies() {
    var routeArgument =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    My_Data = routeArgument['My_Data'];
    BlocProvider.of<DataBaseBloc>(context)
        .add(GetALLNotificationsEvent(MyEmail: My_Data.Email));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            drawer: CustomDrawer(context),
            appBar: CustomAppBar('Notifications'),
            body: Stack(children: [
              topImageMethod(0.6),
              bottomImageMethod(0.6, Height),
              BlocBuilder<DataBaseBloc, DataBaseState>(
                  builder: (context, state) {
                if (state is GetALLNotificationsState) {
                  return ListView.builder(
                      itemCount: state.AllNotifications.length,
                      itemBuilder: (context, index) {
                        return Container(
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
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                    state
                                                        .AllNotifications[index]
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
                                        Text(
                                            state.AllNotifications[index]
                                                .SenderUsername,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "${state.AllNotifications[index].Action}",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16))
                                      ])),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${state.AllNotifications[index].Fulltime}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 35, 141, 39),
                                              fontSize: 15),
                                        ),
                                        Text(
                                            "${state.AllNotifications[index].time}",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 150, 15, 10),
                                                fontSize: 15))
                                      ]))
                            ]));
                      });
                }
                //return WaitingMethod();
                return SizedBox();
              })
            ])));
  }
}
