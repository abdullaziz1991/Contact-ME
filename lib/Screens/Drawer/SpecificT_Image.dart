import 'package:cloud_firestore/cloud_firestore.dart';
import '/Screens/Drawer/Set_Profile_Image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SpecificTImage extends StatefulWidget {
  String ImageSelected;
  String Image_DocumentId;
  String MyUserId;
  int MyImagesNumber;
  String MyImage;
  String Gender;
  SpecificTImage(this.ImageSelected, this.Image_DocumentId, this.MyUserId,
      this.MyImagesNumber, this.MyImage, this.Gender);

  @override
  State<SpecificTImage> createState() => _SpecificTImageState();
}

class _SpecificTImageState extends State<SpecificTImage> {
  @override
  Widget build(BuildContext context) {
    var heightImage = MediaQuery.of(context).size.height;
    var widthImage = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(toolbarHeight: 50, title: Text("My Photos"), actions: [
          IconButton(
              onPressed: () async {
                var querySnapshots = await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.MyUserId)
                    .collection("all_Images")
                    .get();
                for (var doc in querySnapshots.docs) {
                  if (doc['Image'] == widget.ImageSelected) {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(widget.MyUserId)
                        .update({
                      "Image": widget.ImageSelected,
                      "ImageId": widget.Image_DocumentId
                    });
                  }
                }

                Navigator.pushReplacementNamed(context, SetProfileImage.Route);
              },
              icon: Icon(Icons.assignment_ind)),
          IconButton(
              onPressed: () async {
                await FirebaseStorage.instance
                    .refFromURL(widget.ImageSelected)
                    .delete();
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.MyUserId)
                    .collection("all_Images")
                    .doc(widget.Image_DocumentId)
                    .delete();
                if (widget.MyImage == widget.ImageSelected &&
                    widget.MyImagesNumber > 1) {
                  var querySnapshots = await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(widget.MyUserId)
                      .collection("all_Images")
                      .get();
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(widget.MyUserId)
                      .update({
                    "Image": querySnapshots.docs[0]['Image'],
                    "ImageId": widget.Image_DocumentId
                  });
                } else if (widget.MyImage == widget.ImageSelected &&
                    widget.MyImagesNumber == 1) {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(widget.MyUserId)
                      .update({
                    "ImageId": "",
                    "Image": widget.Gender == "Male"
                        ? "https://firebasestorage.googleapis.com/v0/b/contact-me-cca7a.appspot.com/o/images%2FMale_Image.jpg?alt=media&token=38c6e000-1ba8-4d06-aa1a-234a100ce324"
                        : "https://firebasestorage.googleapis.com/v0/b/contact-me-cca7a.appspot.com/o/images%2FFemale_Image.jpg?alt=media&token=76cf2b15-42b6-4ef0-b105-6fb348e0c7ad",
                  });
                }
                Navigator.pushReplacementNamed(context, SetProfileImage.Route);
              },
              icon: Icon(Icons.delete))
        ]),
        body: Column(children: [
          Container(
              height: ((heightImage - widthImage) / 2) - 50,
              width: widthImage,
              color: Colors.black),
          Container(
              height: widthImage,
              width: widthImage,
              color: Colors.amber,
              child: Image.network("${widget.ImageSelected}",
                  fit: BoxFit.fill, width: 80)),
          Container(
            height: ((heightImage - widthImage) / 2) - 50,
            width: widthImage,
            color: Colors.black,
          )
        ]));
  }
}
