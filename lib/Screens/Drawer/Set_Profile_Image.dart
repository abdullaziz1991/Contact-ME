// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';
import '/Auth_And_Tools/Values.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Friends/All_My_Informations.dart';
import '/Screens/Friends/MY_Friends.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import '/bloc/data_base_bloc.dart';

class SetProfileImage extends StatefulWidget {
  static const String Route = 'SetProfileImage';
  @override
  State<SetProfileImage> createState() => _SetProfileImageState();
}

class _SetProfileImageState extends State<SetProfileImage> {
  // @override
  // void initState() {
  //   BlocProvider.of<DataBaseBloc>(context).add(GetMyInfoEvent());
  //   super.initState();
  // }

  Future<bool> _onWillPop() async {
    Navigator.popAndPushNamed(context, MyFriends.Route);
    return (true);
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<DataBaseBloc>(context).add(GetMyInfoEvent());
    super.didChangeDependencies();
  }

  @override
  build(BuildContext context) {
    var widthImage = MediaQuery.of(context).size.width;
    var heightImage = MediaQuery.of(context).size.height;
    return Scaffold(
        body: WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: BlocBuilder<DataBaseBloc, DataBaseState>(
          builder: (context, state) {
            if (state is MyInformationState) {
              return SingleChildScrollView(
                child: Column(children: [
                  Container(
                      height: heightImage / 13,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.arrow_back),
                                SizedBox(width: 10),
                                Text('My Profile',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: titleRed)),
                                Expanded(child: SizedBox()),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: titleRed,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AllMyInformations(
                                                        MyInfo: state.MyInfo)));
                                      },
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                                ),
                              ]))),
                  Stack(children: [
                    Container(
                        //  height: heightImage / 1.5,
                        height: widthImage,
                        width: widthImage,
                        child: Image.network(state.MyInfo.Image,
                            fit: BoxFit.cover, width: double.infinity)),
                    Container(
                        height: widthImage,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(10),
                                  color: Colors.black45,
                                  width: widthImage,
                                  child: Text(state.MyInfo.Status,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)))
                            ])),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                        alignment: Alignment.bottomRight,
                        height: widthImage,
                        child: InkWell(
                            onTap: () {
                              UpdateImage(context, 1, 1, state.MyUserId)
                                  .then((value) => setState(() {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacementNamed(
                                            context, SetProfileImage.Route);
                                      }));
                            },
                            child: Container(
                                child: Icon(Icons.menu, color: Colors.white),
                                padding: EdgeInsets.all(17),
                                decoration: BoxDecoration(
                                    color: titleRed,
                                    borderRadius: BorderRadius.circular(100)))))
                  ]),
                  Container(
                      height: heightImage / 16,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Text('Photos(${state.MyImagesNumber})')),
                  Container(
                      height: 80,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.MyImagesNumber,
                          itemBuilder: (context, i) {
                            return SmallImage(
                              ImageSelected: state.MyImages[i].imageurl,
                              Image_DocumentId:
                                  state.MyImages[i].Image_DocumentId,
                              MyUserId: state.MyUserId,
                              MyImagesNumber: state.MyImagesNumber,
                              MyImage: state.MyInfo.Image,
                              Gender: state.MyInfo.Gender,
                            );
                          })),
                  Card(
                      child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Column(children: [
                            const Row(children: [
                              Icon(Icons.check_circle,
                                  size: 25, color: Colors.blue),
                              SizedBox(width: 10),
                              Text("Profile Verification",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ]),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: ListTile(
                                  leading: Image.asset(
                                      "assets/images/google.jpg",
                                      width: 20,
                                      height: 20),
                                  title: Text("Google",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  subtitle: Text("Verified",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ))
                          ]))),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                          child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Basic Information",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    googleMethod(
                                        widthImage,
                                        Icons.account_circle,
                                        "Full Name",
                                        "${state.MyInfo.Firstname} ${state.MyInfo.Lastname}"),
                                    SizedBox(height: 10),
                                    GenderMethod(
                                        widthImage,
                                        state.MyInfo.Gender == "Male"
                                            ? Icons.male
                                            : Icons.female,
                                        28,
                                        "Gender",
                                        state.MyInfo.Gender,
                                        "Age",
                                        state.MyInfo.Age),
                                    SizedBox(height: 10),
                                    GenderMethod(
                                        widthImage,
                                        Icons.place,
                                        24,
                                        "Lives In",
                                        state.MyInfo.City,
                                        "Interest in",
                                        state.MyInfo.Interested_in),
                                  ]))))
                ]),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ));
  }

  Row GenderMethod(double widthImage, IconData icon, double iconsize,
      String First, String FirstLabel, String Second, String SecondLabel) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(width: widthImage / 7, child: Icon(icon, size: iconsize)),
      Container(
        alignment: Alignment.centerLeft,
        width: 3 * widthImage / 7 - 17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(First, style: TextStyle(color: Colors.black, fontSize: 15)),
            Text(FirstLabel, style: TextStyle(color: Colors.grey, fontSize: 15))
          ],
        ),
      ),
      Container(
          alignment: Alignment.centerLeft,
          width: 3 * widthImage / 7 - 17,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(Second, style: TextStyle(color: Colors.black, fontSize: 15)),
            Text(SecondLabel,
                style: TextStyle(color: Colors.grey, fontSize: 15))
          ]))
    ]);
  }

  Future<dynamic> DialogMethod(BuildContext context, MyInformationState state) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text("Choose your photo ..."), actions: [
            Column(children: [
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        // setState(() async {
                        //   await uploadimage(
                        //       context, ImageSource.camera, state.MyUserId);
                        //   Navigator.pushReplacementNamed(
                        //       context, SetProfileImage.Route);
                        // });
                      },
                      child: Text("Camera"))),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        ///  setState(() {
                        BlocProvider.of<DataBaseBloc>(context).add(
                            AddImageEvent(
                                MyUserId: state.MyUserId,
                                imageway: ImageSource.gallery,
                                context: context));
                        BlocProvider.of<DataBaseBloc>(context)
                            .add(GetMyInfoEvent());
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, SetProfileImage.Route);
                        print(
                            "Navigator.pushReplacementNamed(context, SetProfileImage.Route);");
                        //    });
                      },
                      child: Text("Gallery")))
            ])
          ]);
        });
  }

  // Future<void> uploadimage(
  //     BuildContext context, ImageSource imageway, String MyUserId) async {
  //   var picked = await ImagePicker().pickImage(source: imageway);
  //   if (picked != null) {
  //     File file = File(picked.path);
  //     var rand = Random().nextInt(100000);
  //     var imagename = "$rand" + Path.basename(picked.path);
  //     Reference ref =
  //         FirebaseStorage.instance.ref("images").child("$imagename");
  //     BlocProvider.of<DataBaseBloc>(context)
  //         .add(AddImageEvent(ref: ref, file: file, MyUserId: MyUserId));
  //     Navigator.of(context).pop();
  //     // Navigator.of(context).pop();
  //     // Navigator.pushNamed(context, SetProfileImage.Route);
  //     Navigator.pushReplacement(
  //       context,
  //       CupertinoPageRoute(builder: (context) => SetProfileImage()),
  //     );
  //   }
  // }

  Row googleMethod(
    double widthImage,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(children: [
      Container(width: widthImage / 7, child: Icon(icon, size: 28)),
      Container(
          alignment: Alignment.centerLeft,
          width: 6 * widthImage / 7 - 34,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: Colors.black, fontSize: 15)),
            Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 15))
          ]))
    ]);
  }
}
