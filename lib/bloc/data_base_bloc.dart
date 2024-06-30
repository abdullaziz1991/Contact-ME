import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Auth_And_Tools/Models.dart';
import '/Auth_And_Tools/Widgets.dart';
import '/Screens/Drawer/Set_Profile_Image.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/main.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';
part 'data_base_event.dart';
part 'data_base_state.dart';

class DataBaseBloc extends Bloc<DataBaseEvent, DataBaseState> {
  DataBaseBloc() : super(DataBaseInitial()) {
    on<SignUpEvent>((event, emit) async {
      late UserCredential userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.Email, password: event.Password);
        if (userCredential != null) {
          //saveUserInformation(event.Email, event.Password);
          await FirebaseFirestore.instance.collection("Users").add({
            "Username": event.Username,
            "Email": event.Email,
            "Image": event.UserType == "Male"
                ? "https://firebasestorage.googleapis.com/v0/b/contact-me-cca7a.appspot.com/o/images%2FMale_Image.jpg?alt=media&token=38c6e000-1ba8-4d06-aa1a-234a100ce324"
                : "https://firebasestorage.googleapis.com/v0/b/contact-me-cca7a.appspot.com/o/images%2FFemale_Image.jpg?alt=media&token=76cf2b15-42b6-4ef0-b105-6fb348e0c7ad",
            "Age": "24",
            "Country": "Syria",
            "Gender": event.UserType,
            "Token": await FirebaseMessaging.instance.getToken(),
            "City": "Aleppo",
            "Online": "Online",
            "Status": "Status",
            "Firstname": event.Username,
            "Lastname": "",
            "Birth_Date": "2000-01-01",
            "Interested_in": "N/A",
            "Look_For": "N/A",
            "Eye_Color": "N/A",
            "Hair_Color": "N/A",
            "Height": "N/A",
            "Relationship": "N/A",
            "Document_Id": "",
            "ImageId": ""
          }).then((value) async {
            SharedPrefs _sharedPrefs = SharedPrefs();
            _sharedPrefs.Email = event.Email.toString();
            _sharedPrefs.Password = event.Password.toString();
            _sharedPrefs.MyID = value.id.toString();
            MyDataModle MyData = MyDataModle(
                Email: event.Email.toString(),
                Password: event.Password.toString(),
                MyID: value.id.toString());
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(value.id)
                .update({"UserId": value.id, "Online": "Online"});

            Navigator.push(
                event.context,
                MaterialPageRoute(
                    builder: (context) => MyFriends(MyData: MyData)));
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          SnackBarMethod(event.context, "Password is to weak");
        } else if (e.code == 'email-already-in-use') {
          SnackBarMethod(
              event.context, "The account already exists for that email");
        }
      } catch (e) {
        print(e);
      }
    });

    on<SignInEvent>((event, emit) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.Email, password: event.Password);
        final user = await FirebaseFirestore.instance.collection('Users').get();
        var userSelected, MyID;
        user.docs.forEach((element) {
          userSelected = element.data();
          if (userSelected['Email'] == event.Email) {
            MyID = userSelected['UserId'];
          }
        });
        // if (MyID != null) {
        if (userCredential != null) {
          SharedPrefs _sharedPrefs = SharedPrefs();
          _sharedPrefs.Email = event.Email.toString();
          _sharedPrefs.Password = event.Password.toString();
          _sharedPrefs.MyID = MyID.toString();
          MyDataModle MyData = MyDataModle(
              Email: event.Email, Password: event.Password, MyID: MyID);
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(MyID)
              .update({"Online": "Online"});
          Navigator.pushReplacement(
              event.context,
              CupertinoPageRoute(
                  builder: (context) => MyFriends(MyData: MyData)));
        } else {
          SnackBarMethod(event.context, "No user found for that email");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(event.context).pop();
          // showLoading(context) منشان اخلص من دائرة الانتظار والدائرة موجودة ب
          SnackBarMethod(event.context, "No user found for that email");
        } else if (e.code == 'wrong-password') {
          Navigator.of(event.context).pop();
          SnackBarMethod(
              event.context, "Wrong password provided for that user");
        }
      }
    });

    on<GetUsersDataEvent>((event, emit) async {
      try {
        var userSelected;
        List<UsersInformationModel> UserData = [];
        late UsersInformationModel My_Data;
        final user = await FirebaseFirestore.instance.collection('Users').get();
        user.docs.forEach((element) {
          userSelected = element.data();
          if (userSelected['Email'] != event.Email) {
            return UserData.add(UsersInformationModel.fromJson(userSelected));
          } else {
            My_Data = UsersInformationModel.fromJson(userSelected);
          }
        });
        emit(DataBaseLoaded(UserData: UserData, My_Data: My_Data));
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<GetMyInfoEvent>((event, emit) async {
      try {
        final me = await FirebaseAuth.instance.currentUser?.email;
        final allUsersInfo =
            await FirebaseFirestore.instance.collection("Users").get();
        var userSelected, MyUserId, Image;
        late UsersInformationModel MyInfo;
        allUsersInfo.docs.forEach((element) {
          userSelected = element.data();
          if (userSelected['Email'] == me) {
            MyInfo = UsersInformationModel.fromJson(userSelected);
            MyUserId = userSelected['UserId'];
          }
        });
        final AllImages = await FirebaseFirestore.instance
            .collection("Users")
            .doc(MyUserId)
            .collection("all_Images")
            .get();
        List<AllMyImage> MyImages = [];
        AllImages.docs.forEach((element) {
          Image = element.data();
          MyImages.add(AllMyImage.fromJson(Image));
        });
        emit(MyInformationState(
            MyInfo: MyInfo,
            MyImagesNumber: AllImages.docs.length,
            MyImages: MyImages,
            MyUserId: MyUserId));
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<AddImageEvent>((event, emit) async {
      try {
        print("+++++++++++++++++++++++++++++++++++++++");
        var pickedImage = await ImagePicker().pickImage(source: event.imageway);
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
              .doc(event.MyUserId)
              .collection("all_Images")
              .add({"Image": imageurl}).then((value) async {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(event.MyUserId)
                .collection("all_Images")
                .doc(value.id)
                .update({"Image_DocumentId": value.id});
            FirebaseFirestore.instance
                .collection("Users")
                .doc(event.MyUserId)
                .update({"Image": imageurl, "ImageId": value.id});
          }).catchError((e) {
            print("$e");
          });
        }
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    // on<DidIAddTheFriendEvent>((event, emit) async {
    //   final MyFavorite =
    //       await FirebaseFirestore.instance.collection("MyFavorite");
    //   final People_I_Contact_with =
    //       FirebaseFirestore.instance.collection("People_I_Contact_with");

    //   bool isMyFriend = false, isConfirmed = false, isMyFavorite = false;
    //   try {
    //     var addFriends = await People_I_Contact_with.get();

    //     for (var doc in addFriends.docs) {
    //       if ((doc['Sender'] == event.MyData.Email &&
    //               doc['Receiver'] == event.UsersData.Email) ||
    //           (doc['Receiver'] == event.MyData.Email &&
    //               doc['Sender'] == event.UsersData.Email)) {
    //         if (doc['Confirmed'] == "Yes") {
    //           isConfirmed = true;
    //           break;
    //         }
    //         if (doc['Confirmed'] == "Requested") {
    //           isMyFriend = true;
    //           break;
    //         }
    //       }
    //     }

    //     var addFavorite = await MyFavorite.get();
    //     for (var doc in addFavorite.docs) {
    //       if (doc['Sender'] == event.MyData.Email &&
    //           doc['I_Like'] == event.UsersData.Email) {
    //         isMyFavorite = true;
    //         break;
    //       }
    //     }
    //     print("${isMyFriend} 5555777 isMyFriend++++++++++");
    //     print("${isConfirmed} 555777 isConfirmed++++++++++");
    //     print("${isMyFavorite} 555777 isMyFavorite+++++++++");
    //     emit(DidIAddTheFriendState(
    //         isMyFriend: isMyFriend,
    //         isConfirmed: isConfirmed,
    //         isMyFavorite: isMyFavorite));
    //   } on FirebaseException catch (e) {
    //     emit(ConnectionError(message: "Connection Error"));
    //   }
    // });

    on<AddFriendEvent>((event, emit) async {
      try {
        await FirebaseFirestore.instance
            .collection("People_I_Contact_with")
            .add({
          "Confirmed": "Requested",
          "Sender": event.MyData.Email,
          "SenderUsername": event.MyData.Username,
          "SenderImage": event.MyData.Image,
          "Receiver": event.UsersData.Email,
          "ReceiverImage": event.UsersData.Image,
          'the_final_message': "",
          'the_final_date_i_message':
              DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'ReceiverUsername': event.UsersData.Username,
          "MyToken": event.MyData.Token,
          "onlineStatus": event.MyData.Online,
          "time": DateFormat('hh:mm a').format(DateTime.now()),
        });
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<DeleteAddFriendEvent>((event, emit) async {
      try {
        final People_I_Contact_with =
            FirebaseFirestore.instance.collection("People_I_Contact_with");
        var querySnapshots4 = await People_I_Contact_with.get();
        for (var doc in querySnapshots4.docs) {
          if ((doc['Sender'] == event.MyEmail &&
                  doc['Receiver'] == event.UserEmail) ||
              (doc['Receiver'] == event.MyEmail &&
                  doc['Sender'] == event.UserEmail)) {
            //&& doc['Confirmed'] == "Yes"
            await People_I_Contact_with.doc(doc.id).delete();
          }
        }
        print("DeleteAddFriendEvent ----------=========---");
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<AddFavoriteEvent>((event, emit) async {
      try {
        await FirebaseFirestore.instance
            .collection("MyFavorite")
            .add({"Sender": event.MyEmail, "I_Like": event.UserEmail});
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<DeleteFavoriteEvent>((event, emit) async {
      CollectionReference MyFavorite =
          FirebaseFirestore.instance.collection("MyFavorite");
      try {
        var documents = await MyFavorite.get();
        for (var doc in documents.docs) {
          if (doc['Sender'] == event.MyEmail &&
              doc['I_Like'] == event.UserEmail) {
            await MyFavorite.doc(doc.id).delete();
          }
        }
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<AddMessageEvent>((event, emit) {
      CollectionReference MyMessages =
          FirebaseFirestore.instance.collection("Messages");
      try {
        MyMessages.add({
          'TextMessage': event.TextMessage,
          'Sender': event.MyData.Email,
          'Receiver': event.UsersData.Email,
          'Fulltime': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "TimeMessage": DateFormat('hh:mm a').format(DateTime.now()),
          'Timestamp': FieldValue.serverTimestamp(),
          "Deliverd": event.UserState,
        });
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<LastUpdateMessageEvent>((event, emit) async {
      CollectionReference People_I_Contact_with =
          FirebaseFirestore.instance.collection("People_I_Contact_with");
      bool isThereAreAMessage = false;
      try {
        var querySnapshots1 = await People_I_Contact_with.get();
        for (var doc in querySnapshots1.docs) {
          if (doc['Sender'] == event.MyData.Email &&
                  doc['Receiver'] == event.UsersData.Email ||
              doc['Sender'] == event.UsersData.Email &&
                  doc['Receiver'] == event.MyData.Email) {
            People_I_Contact_with.doc(doc.id).update({
              'Sender': event.MyData.Email,
              'Receiver': event.UsersData.Email,
              'the_final_message': event.TextMessage,
              'the_final_date_i_message':
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'SenderImage': event.MyData.Image,
              'ReceiverUsername': event.UsersData.Username,
              "ReceiverImage": event.UsersData.Image,
              'SenderUsername': event.MyData.Username,
              "MyToken": event.MyData.Token,
              "onlineStatus": event.MyData.Online,
              "time": DateFormat('hh:mm a').format(DateTime.now()),
            });

            isThereAreAMessage = true;
          }
        }
        if (isThereAreAMessage == false) {
          People_I_Contact_with.add({
            'Confirmed': "Not_Requested",
            'Sender': event.MyData.Email,
            'Receiver': event.UsersData.Email,
            'the_final_message': event.TextMessage,
            'the_final_date_i_message':
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'SenderImage': event.MyData.Image,
            'ReceiverUsername': event.UsersData.Username,
            "ReceiverImage": event.UsersData.Image,
            'SenderUsername': event.MyData.Username,
            "MyToken": event.MyData.Token,
            "onlineStatus": event.MyData.Online,
            "time": DateFormat('hh:mm a').format(DateTime.now()),
          });
          isThereAreAMessage = true;
        }
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<AddNotificationEvent>((event, emit) {
      CollectionReference Notification =
          FirebaseFirestore.instance.collection("Notification");
      try {
        Notification.add({
          "Receiver": event.UsersData.Email,
          "Sender": event.MyData.Email,
          "SenderUsername": event.MyData.Username,
          "SenderImage": event.MyData.Image,
          "Action": event.TextMessage,
          "Time": DateFormat('hh:mm a').format(DateTime.now()),
          'Timestamp': FieldValue.serverTimestamp(),
          'Fulltime': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        });
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<UpdateStateMessagesEvent>((event, emit) async {
      CollectionReference MyMessages =
          FirebaseFirestore.instance.collection("Messages");
      try {
        var querySnapshots8 = await MyMessages.get();
        for (var doc in querySnapshots8.docs) {
          if (doc['Receiver'] == event.MyEmail &&
              doc['Sender'] == event.UsersEmail &&
              event.CurrentPage == "Chat") {
            //&& doc['Deliverd'] == "getIt"
            MyMessages.doc(doc.id).update({'Deliverd': "Received"});
          } else if (doc['Receiver'] == event.MyEmail &&
              event.CurrentPage == "Find_Friend" &&
              doc['Deliverd'] == "Send") {
            MyMessages.doc(doc.id).update({'Deliverd': "GetIt"});
          }
        }
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<GetALLMessagesEvent>((event, emit) async {
      final People_I_Contact_with = await FirebaseFirestore.instance
          .collection("People_I_Contact_with")
          .get();
      List<GetALLMessages> AllMessages = [];
      var Message;
      try {
        People_I_Contact_with.docs.forEach((element) {
          Message = element.data();
          if (event.MyEmail == Message["Sender"] ||
              event.MyEmail == Message["Receiver"])
            AllMessages.add(GetALLMessages.fromJson(Message));
        });
        emit(GetALLMessagesState(
            AllMessages: AllMessages, MyEmail: event.MyEmail));
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<GetALLNotificationsEvent>((event, emit) async {
      final Notification = await FirebaseFirestore.instance
          .collection("Notification")
          .orderBy("Timestamp")
          .get();
      List<GetALLNotifications> AllNotifications = [];
      var item;
      try {
        Notification.docs.forEach((element) {
          item = element.data();
          if (event.MyEmail == item["Receiver"])
            AllNotifications.add(GetALLNotifications.fromJson(item));

          emit(GetALLNotificationsState(AllNotifications: AllNotifications));
        });
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<GetVisitorsEvent>((event, emit) async {
      final Notification = await FirebaseFirestore.instance
          .collection("Notification")
          .orderBy("Timestamp")
          .get();
      try {
        var item, number = 0, repeatingNumber = 1;
        List<VisitorsModel> AllVisitors = [], AllVisitorsNot = [];
        List<int> RepeatingNumbers = [];
        Notification.docs.forEach((element) {
          item = element.data();
          if (item['Receiver'] == event.MyEmail) {
            AllVisitors.add(VisitorsModel.fromJson(item));
          }
        });
        for (int i = 0; i < AllVisitors.length; i++) {
          if (i == 0) {
            AllVisitorsNot.add(AllVisitors[i]);
            RepeatingNumbers.add(repeatingNumber);
          } else if (AllVisitors[i].Sender == AllVisitorsNot[number].Sender) {
            RepeatingNumbers.removeLast();
            repeatingNumber = repeatingNumber + 1;
            RepeatingNumbers.add(repeatingNumber);
          } else if (AllVisitors[i].Sender != AllVisitorsNot[number].Sender) {
            repeatingNumber = 1;
            RepeatingNumbers.add(repeatingNumber);
            AllVisitorsNot.add(AllVisitors[i]);
            number = number + 1;
          }
        }
        emit(GetVisitorsState(
            AllVisitors: AllVisitorsNot, RepeatingNumbers: RepeatingNumbers));
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<ALLMyFriendsEvent>((event, emit) async {
      final People_I_Contact_with = await FirebaseFirestore.instance
          .collection("People_I_Contact_with")
          .get();
      List<GetALLMessages> AllFriends = [];
      var item;
      try {
        People_I_Contact_with.docs.forEach((element) {
          item = element.data();
          if ((event.MyEmail == item["Sender"] ||
                  event.MyEmail == item["Receiver"]) &&
              item["Confirmed"] == "Yes") {
            print(GetALLMessages.fromJson(item).Receiver);
            print("GetALLMessages.fromJson(item).Receiver ++++++++++++++");
            AllFriends.add(GetALLMessages.fromJson(item));
          }
        });
        emit(GetALLMessagesState(
            AllMessages: AllFriends, MyEmail: event.MyEmail));
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<GetRequestEvent>((event, emit) async {
      final People_I_Contact_with = await FirebaseFirestore.instance
          .collection("People_I_Contact_with")
          .get();
      List<GetALLMessages> AllRequest = [];
      try {
        var querySnapshots2 = await People_I_Contact_with;
        for (var doc in querySnapshots2.docs) {
          if (doc['Receiver'] == event.MyEmail &&
              doc['Confirmed'] == "Requested") {
            AllRequest.add(GetALLMessages.fromJson(doc.data()));
          }
        }
        emit(ALLRequestState(AllMessages: AllRequest));
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<AcceptFriendEvent>((event, emit) async {
      final People_I_Contact_with =
          await FirebaseFirestore.instance.collection("People_I_Contact_with");
      try {
        var querySnapshots2 = await People_I_Contact_with.get();
        for (var doc in querySnapshots2.docs) {
          if (doc['Sender'] == event.SenderEmail &&
              doc['Receiver'] == event.MyEmail) {
            await People_I_Contact_with.doc(doc.id).update({
              "Confirmed": "Yes",
            });
          }
        }
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });

    on<UpdateMyInfomationEvent>((event, emit) async {
      final User = await FirebaseFirestore.instance.collection('Users');
      try {
        await User.doc(event.UserId).update({
          "Status": event.Status,
          "Firstname": event.Firstname,
          "Lastname": event.Lastname,
          "Gender": event.Gender,
          "Birth_Date": event.Date_of_Birth,
          "Interested_in": event.Interested_in,
          "Look_For": event.Look_For,
          "Eye_Color": event.Eye_Color,
          "Hair_Color": event.Hair_Color,
          "Height": event.Height,
          "Relationship": event.Relationship,
          "City": event.City,
          "Age": event.Age,
        });
      } on FirebaseException catch (e) {
        emit(ConnectionError(message: "Connection Error"));
      }
    });
  }
}

class OfflineDataBloc extends Bloc<OfflineDataEvent, OfflineDataState> {
  OfflineDataBloc() : super(OfflineDataInitial()) {
    on<MyDataEvent>((event, emit) async {
      emit(DataState(My_Data: event.My_Data, MyData: event.MyData));
    });
  }
}

// class InternetBloc extends Bloc<InternetEvent, InternetState> {
//   StreamSubscription? _subscription;
//   InternetBloc() : super(InternetInitial()) {
//     on<InternetEvent>((event, emit) {
//       if (event is ConnectedEvent) {
//         emit(ConnectedState(message: "Connected"));
//       } else if (event is NotConnectedEvent) {
//         emit(NotConnectedState(message: "Not Connected"));
//       }
//     });

//     _subscription = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.wifi ||
//           result == ConnectivityResult.mobile) {
//         add(ConnectedEvent());
//       } else {
//         add(NotConnectedEvent());
//       }
//     });
//   }
//   @override
//   Future<void> close() {
//     _subscription!.cancel();
//     return super.close();
//   }
// }