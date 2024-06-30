// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:io";
import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "/Screens/Drawer/SpecificT_Image.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import 'package:path/path.dart' as Path;
import "/Auth_And_Tools/Models.dart";
import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import "package:shared_preferences/shared_preferences.dart";

class MessageLine extends StatelessWidget {
  Message message;
  bool isMe;
  MessageLine({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: isMe
                    ? Color.fromARGB(255, 90, 90, 90)
                    : //Color.fromARGB(255, 201, 106, 106),
                    Color.fromARGB(255, 199, 218, 157),
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0))
                    : BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(10))),
            child: IntrinsicWidth(
                child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                  Icon(
                      message.Deliverd == "blocked"
                          ? Icons.circle
                          : message.Deliverd == "Send"
                              ? Icons.done
                              : Icons.done_all,
                      color: message.Deliverd == "blocked"
                          ? Colors.red
                          : message.Deliverd == "Send"
                              ? isMe
                                  ? Colors.amber
                                  : Color.fromARGB(255, 0, 0, 0)
                              : (message.Deliverd == "GetIt"
                                  ? Colors.amber
                                  : isMe
                                      ? Colors.blue
                                      : Color.fromARGB(255, 0, 0, 0)),
                      size: 20),
                  //Icons.done_all, color: Colors.blue,
                  SizedBox(width: 5),
                  Text(message.TimeMessage,
                      style: TextStyle(
                          fontSize: 13,
                          color: isMe
                              ? Color.fromARGB(255, 221, 211, 211)
                              : Color.fromARGB(255, 20, 2, 2))),
                  SizedBox(width: 12),
                  Text(message.TextMessage,
                      style: TextStyle(
                          fontSize: 13,
                          color: isMe
                              ? Color.fromARGB(255, 221, 211, 211)
                              : Color.fromARGB(255, 20, 2, 2))),
                ]))));
  }
}

class SmallImage extends StatelessWidget {
  String ImageSelected;
  String Image_DocumentId;
  String MyUserId;
  int MyImagesNumber;
  String MyImage;
  String Gender;
  SmallImage({
    Key? key,
    required this.ImageSelected,
    required this.Image_DocumentId,
    required this.MyUserId,
    required this.MyImagesNumber,
    required this.MyImage,
    required this.Gender,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SpecificTImage(
                    ImageSelected,
                    Image_DocumentId,
                    MyUserId,
                    MyImagesNumber,
                    MyImage,
                    Gender)));
      },
      child: Image.network(ImageSelected, fit: BoxFit.fill, width: 80),
    ));
  }
}

// showLoading(context) {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Please Wait"),
//           content: Container(
//               height: 50, child: Center(child: CircularProgressIndicator())),
//         );
//       });
// }

void SnackBarMethod(BuildContext context, String Message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(Message),
      backgroundColor: Colors.red,
    ),
  );
}

Container GoToSignMethod(
  BuildContext context,
  String Message,
  String Root,
) {
  return Container(
      margin: EdgeInsets.all(10),
      child: Row(children: [
        Text(Message, style: TextStyle(fontSize: 17)),
        InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Root);
            },
            child: Text("Click Here",
                style: TextStyle(color: Colors.blue, fontSize: 17)))
      ]));
}

Container SignButtonMethod(String title) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.orange,
      ),
      child: Text(title, style: TextStyle(color: Colors.white)));
}

Container WaitingMethod() {
  return Container(
      child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text("Please Wait ......"),
    SizedBox(height: 10),
    CircularProgressIndicator(),
  ])));
}

Opacity topImageMethod(double opacity) {
  return Opacity(
      opacity: opacity,
      child: Container(
          alignment: Alignment.topRight,
          child: Image.asset(
            "assets/images/background_top.png",
            width: double.infinity,
          )));
}

Opacity bottomImageMethod(double opacity, double height) {
  return Opacity(
      opacity: opacity,
      child: Container(
          alignment: Alignment.bottomLeft,
          height: height,
          width: double.infinity,
          child: Image.asset(
            "assets/images/background_bottom.png",
            width: double.infinity,
          )));
}

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;
  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  SharedPrefs._internal();
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get Email => _sharedPrefs.getString("Email") ?? "";
  set Email(String value) {
    _sharedPrefs.setString("Email", value);
  }

  String get Password => _sharedPrefs.getString("Password") ?? "";
  set Password(String value) {
    _sharedPrefs.setString("Password", value);
  }

  String get MyID => _sharedPrefs.getString("MyID") ?? "";
  set MyID(String value) {
    _sharedPrefs.setString("MyID", value);
  }
}

Container TextFormFieldMethod(
    String value,
    String validator1,
    String validator2,
    IconData icon,
    String label,
    // bool isDark,
    TextInputType textInputType,
    int maxLenght,
    TextEditingController controllers) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: TextFormField(
      controller: controllers,
      // style: TextStyle(color: isDark ? Colors.white : Colors.black),
      validator: (val) {
        if (val!.length > 100) {
          return validator1;
        }
        if (val.length < 2) {
          return validator2;
        }
        return null;
      },

      keyboardType: textInputType,
      //  obscureText: true,
      maxLines: value == "Product Details" ? 10 : 1,
      minLines: 1,
      // maxLines: 10,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLenght),
      ],
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.orange,
          ),
          //hintText: value,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(width: 1, color: Colors.black),
          )),
    ),
  );
}

Future<String> UpdateImage(
    BuildContext context, double ratioX, double ratioY, String MyUserId) async {
  String NewImage = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text("Choose an image",
                style: TextStyle(), textAlign: TextAlign.center),
            content: Container(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(children: [
                  ElevatedButton(
                      onPressed: () async {
                        await getImage(
                                ImageSource.gallery, ratioX, ratioY, MyUserId)
                            .then((value) => Navigator.pop(context, value));
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 10),
                            Text("From the gallery")
                          ])),
                  ElevatedButton(
                      onPressed: () async {
                        await getImage(
                                ImageSource.camera, ratioX, ratioY, MyUserId)
                            .then((value) => Navigator.pop(context, value));
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.camera),
                            SizedBox(width: 10),
                            Text("From the camera"),
                          ]))
                ])));
      });
  return NewImage;
}

Future<String> getImage(
    ImageSource media, double ratioX, double ratioY, String MyUserId) async {
  String imagename = "";
  var pickedImage = await ImagePicker().pickImage(source: media);
  if (pickedImage != null) {
    File image = File(pickedImage!.path);

    // final CroppedImage = await ImageCropper().cropImage(
    //   sourcePath: image.path,
    //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    //   uiSettings: [
    //     AndroidUiSettings(
    //       toolbarTitle: 'Crop Image',
    //       toolbarColor: Colors.deepOrange,
    //       toolbarWidgetColor: Colors.white,
    //       initAspectRatio: CropAspectRatioPreset.square,
    //       lockAspectRatio: true,
    //     ),
    //     IOSUiSettings(
    //       title: 'Crop Image',
    //     ),
    //   ],
    // );

    var rand = Random().nextInt(100000);
    var imagename = "$rand" + Path.basename(pickedImage.path);
    Reference reference =
        FirebaseStorage.instance.ref("images").child("$imagename");
    await reference.putFile(image);
    var imageurl = await reference.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(MyUserId)
        .collection("all_Images")
        .add({"Image": imageurl}).then((value) async {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(MyUserId)
          .collection("all_Images")
          .doc(value.id)
          .update({"Image_DocumentId": value.id});
      FirebaseFirestore.instance
          .collection("Users")
          .doc(MyUserId)
          .update({"Image": imageurl, "ImageId": value.id});
    }).catchError((e) {
      print("$e");
    });
  }
  return imagename.toString();
}

Future<void> uploadNewImage(
    BuildContext context, ImageSource imageway, String MyUserId) async {
  var pickedImage = await ImagePicker().pickImage(source: imageway);
  await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    File image = File(pickedImage!.path);
    var rand = Random().nextInt(100000);
    var imagename = "$rand" + Path.basename(pickedImage.path);
    Reference reference =
        FirebaseStorage.instance.ref("images").child("$imagename");
    await reference.putFile(image);
    var imageurl = await reference.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(MyUserId)
        .collection("all_Images")
        .add({"Image": imageurl}).then((value) async {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(MyUserId)
          .collection("all_Images")
          .doc(value.id)
          .update({"Image_DocumentId": value.id});
      FirebaseFirestore.instance
          .collection("Users")
          .doc(MyUserId)
          .update({"Image": imageurl, "ImageId": value.id});
    }).catchError((e) {
      print("$e");
    });
  }
}
//  googleapis: ^13.1.0
//   googleapis_auth: ^1.6.0