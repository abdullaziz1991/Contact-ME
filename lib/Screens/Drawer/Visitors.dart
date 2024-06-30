import '/Auth_And_Tools/AppBar.dart';
import '/Auth_And_Tools/Models.dart';
import '/Screens/Drawer/Drawer.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/bloc/data_base_bloc.dart';
import '/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Visitors extends StatefulWidget {
  static const String Route = 'Visitors';

  @override
  State<Visitors> createState() => _VisitorsState();
}

class _VisitorsState extends State<Visitors> {
  late UsersInformationModel My_Data;
  @override
  void didChangeDependencies() {
    var routeArgument =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    My_Data = routeArgument['My_Data'];
    BlocProvider.of<DataBaseBloc>(context)
        .add(GetVisitorsEvent(MyEmail: My_Data.Email));
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //         builder: (context) => MyFriends(Email: MyData.Email)));
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => MyApp()),
    );
    return (true);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var Height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            drawer: CustomDrawer(context),
            appBar: CustomAppBar('Visitors'),
            extendBodyBehindAppBar: true,
            body: Stack(children: [
              topImageMethod(0.6),
              bottomImageMethod(0.6, Height),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: BlocBuilder<DataBaseBloc, DataBaseState>(
                      builder: (context, state) {
                    if (state is GetVisitorsState) {
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: state.AllVisitors.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 6 / 9,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.black)),
                                child: Column(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          state.AllVisitors[index].SenderImage,
                                          fit: BoxFit.fill,
                                          width: width / 2 - 10,
                                          height: width / 2 - 10)),
                                  Text(
                                      "${state.AllVisitors[index].SenderUsername}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                  SizedBox(height: 10),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(
                                              255, 174, 226, 63)),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                                child: Text(
                                                    "${state.RepeatingNumbers[index]}", //
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18))),
                                            Text("  Views ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18)),
                                          ]))
                                ]));
                          });
                    }
                    return WaitingMethod();
                  }))
            ])));
  }
}
