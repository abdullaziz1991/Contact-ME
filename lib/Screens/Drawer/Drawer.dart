// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/SignIn.dart';
import '/Auth_And_Tools/Values.dart';
import '/Screens/Drawer/Messages.dart';
import '/Screens/Drawer/Notifications.dart';
import '/Screens/Drawer/Set_Profile_Image.dart';
import '/Screens/Drawer/Visitors.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/bloc/data_base_bloc.dart';

Drawer CustomDrawer(BuildContext context) {
  return Drawer(child:
      BlocBuilder<OfflineDataBloc, OfflineDataState>(builder: (context, state) {
    if (state is DataState) {
      return Column(children: [
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, SetProfileImage.Route);
            },
            child: UserAccountsDrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 11, 8, 59)),
                currentAccountPicture: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: const Color(0xFF778899),
                    backgroundImage: NetworkImage(state.My_Data.Image)),
                accountEmail: Container(
                    child: Text(
                  state.My_Data.Email,
                  style: TextStyle(color: Colors.white),
                )),
                accountName: Container(
                    child: Text(state.My_Data.Username,
                        style: TextStyle(color: Colors.white))))),
        drawerItem(Icons.person_add, "My Friends", context, MyFriends.Route,
            state.My_Data, state.MyData),
        drawerItem(Icons.message, "Messages", context, Messages.Route,
            state.My_Data, state.MyData),
        drawerItem(Icons.account_circle, "Visitors", context, Visitors.Route,
            state.My_Data, state.MyData),
        drawerItem(Icons.local_fire_department, "Notifications", context,
            Notifications.Route, state.My_Data, state.MyData),
        ListTile(
            onTap: () {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(state.My_Data.UserId)
                  .update({"Online": "Offline"});
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, SignIn.Route);
            },
            leading: Icon(Icons.close, color: titleRed),
            title: Text("Sign out"))
      ]);
    }
    return SizedBox();
  }));
}

// ListTile DrawerItem(BuildContext context, DataState state,IconData iconItem, String title,  Function  root ) {
//   return ListTile(
//           onTap: () {
//             Navigator.pushReplacement(
//               context,
//               CupertinoPageRoute(
//                   builder: (context) =>
//                       MyFriends(Email: state.My_Data.Email)),
//             );
//           },
//           leading: Icon(iconItem, color: titleRed),
//           title: Text(title));
// }

ListTile drawerItem(IconData iconItem, String title, BuildContext context,
    String root, UsersInformationModel My_Data, MyDataModle MyData) {
  return ListTile(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(root,
            arguments: {'My_Data': My_Data, "MyData": MyData});
      },
      leading: Icon(iconItem, color: titleRed),
      title: Text("$title"));
}

// class DrawerItem extends StatelessWidget {
//   String title;
//   final Function onPressed;
//   IconData iconItem;

//   DrawerItem({
//     Key? key,
//     required this.title,
//     required this.onPressed,
//     required this.iconItem,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         onTap: () {
//           onPressed;
//         },
//         leading: Icon(iconItem, color: titleRed),
//         title: Text(title));
//   }
// }
