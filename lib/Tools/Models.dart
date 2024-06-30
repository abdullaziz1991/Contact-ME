// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyDataModle {
  final String Email;
  final String Password;
  final String MyID;
  MyDataModle({
    required this.Email,
    required this.Password,
    required this.MyID,
  });
}

class UsersInformationModel {
  final String Email;
  final String Username;
  final String Image;
  final String City;
  final String Gender;
  final String Age;
  final String UserId;
  final String Token;
  final String Online;
  final String Country;
  final String Status;
  final String Firstname;
  final String Lastname;
  final String Birth_Date;
  final String Interested_in;
  final String Look_For;
  final String Eye_Color;
  final String Hair_Color;
  final String Height;
  final String Relationship;
  final String Document_Id;
  final String ImageId;
  UsersInformationModel({
    required this.Email,
    required this.Username,
    required this.Image,
    required this.City,
    required this.Gender,
    required this.Age,
    required this.UserId,
    required this.Token,
    required this.Online,
    required this.Country,
    required this.Status,
    required this.Firstname,
    required this.Lastname,
    required this.Birth_Date,
    required this.Interested_in,
    required this.Look_For,
    required this.Eye_Color,
    required this.Hair_Color,
    required this.Height,
    required this.Relationship,
    required this.Document_Id,
    required this.ImageId,
  });
  factory UsersInformationModel.fromJson(Map<String, dynamic> json) {
    return UsersInformationModel(
      Email: json['Email'],
      Username: json['Username'],
      Image: json['Image'],
      City: json['City'],
      Gender: json['Gender'],
      Age: json['Age'],
      UserId: json['UserId'],
      Token: json['Token'],
      Online: json['Online'],
      Country: json['Country'],
      Status: json['Status'],
      Firstname: json['Firstname'],
      Lastname: json['Lastname'],
      Birth_Date: json['Birth_Date'],
      Interested_in: json['Interested_in'],
      Look_For: json['Look_For'],
      Eye_Color: json['Eye_Color'],
      Hair_Color: json['Hair_Color'],
      Height: json['Height'],
      Relationship: json['Relationship'],
      Document_Id: json['Document_Id'],
      ImageId: json['ImageId'],
    );
  }
}

class Message {
  final String TextMessage;
  final String Sender;
  final String Receiver;
  final String Deliverd;
  final String TimeMessage;
  final String Fulltime;
  Message(
      {required this.TextMessage,
      required this.Sender,
      required this.Receiver,
      required this.Deliverd,
      required this.Fulltime,
      required this.TimeMessage});
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        TextMessage: json['TextMessage'],
        Sender: json['Sender'],
        Receiver: json['Receiver'],
        Deliverd: json['Deliverd'],
        TimeMessage: json['TimeMessage'],
        Fulltime: json['Fulltime']);
  }
}

class AllMyImage {
  final String imageurl;
  final String Image_DocumentId;
  AllMyImage({required this.imageurl, required this.Image_DocumentId});
  factory AllMyImage.fromJson(Map<String, dynamic> json) {
    return AllMyImage(
        imageurl: json['Image'], Image_DocumentId: json['Image_DocumentId']);
  }
}

class GetALLMessages {
  final String Confirmed;
  final String Sender;
  final String Receiver;
  final String the_final_message;
  final String the_final_date_i_message;
  final String SenderImage;
  final String ReceiverUsername;
  final String ReceiverImage;
  final String SenderUsername;
  final String MyToken;
  final String onlineStatus;
  final String time;
  GetALLMessages({
    required this.Confirmed,
    required this.Sender,
    required this.Receiver,
    required this.the_final_message,
    required this.the_final_date_i_message,
    required this.SenderImage,
    required this.ReceiverUsername,
    required this.ReceiverImage,
    required this.SenderUsername,
    required this.MyToken,
    required this.onlineStatus,
    required this.time,
  });
  factory GetALLMessages.fromJson(Map<String, dynamic> json) {
    return GetALLMessages(
      Confirmed: json['Confirmed'],
      Sender: json['Sender'],
      Receiver: json['Receiver'],
      the_final_message: json['the_final_message'],
      the_final_date_i_message: json['the_final_date_i_message'],
      SenderImage: json['SenderImage'],
      ReceiverUsername: json['ReceiverUsername'],
      ReceiverImage: json['ReceiverImage'],
      SenderUsername: json['SenderUsername'],
      MyToken: json['MyToken'],
      onlineStatus: json['onlineStatus'],
      time: json['time'],
    );
  }
}

class GetALLNotifications {
  final String Sender;
  final String Receiver;
  final String SenderUsername;
  final String SenderImage;
  final String Action;
  final String time;
  final String Fulltime;
  GetALLNotifications({
    required this.Sender,
    required this.Receiver,
    required this.SenderUsername,
    required this.SenderImage,
    required this.Action,
    required this.time,
    required this.Fulltime,
  });
  factory GetALLNotifications.fromJson(Map<String, dynamic> json) {
    return GetALLNotifications(
      Sender: json['Sender'],
      Receiver: json['Receiver'],
      SenderUsername: json['SenderUsername'],
      SenderImage: json['SenderImage'],
      Action: json['Action'],
      time: json['Time'],
      Fulltime: json['Fulltime'],
    );
  }
}

class VisitorsModel {
  final String Sender;
  final String Receiver;
  final String SenderUsername;
  final String SenderImage;
  VisitorsModel({
    required this.Sender,
    required this.Receiver,
    required this.SenderUsername,
    required this.SenderImage,
  });
  factory VisitorsModel.fromJson(Map<String, dynamic> json) {
    return VisitorsModel(
      Sender: json['Sender'],
      Receiver: json['Receiver'],
      SenderUsername: json['SenderUsername'],
      SenderImage: json['SenderImage'],
    );
  }
}

class ALLMyFriends {
  final String Confirmed;
  final String Receiver;
  final String ReceiverImage;
  final String Sender;
  final String SenderImage;
  final String SenderUsername;
  ALLMyFriends({
    required this.Confirmed,
    required this.Receiver,
    required this.ReceiverImage,
    required this.Sender,
    required this.SenderImage,
    required this.SenderUsername,
  });
  factory ALLMyFriends.fromJson(Map<String, dynamic> json) {
    return ALLMyFriends(
      Sender: json['Sender'],
      Receiver: json['Receiver'],
      SenderUsername: json['SenderUsername'],
      SenderImage: json['SenderImage'],
      Confirmed: json['Confirmed'],
      ReceiverImage: json['ReceiverImage'],
    );
  }
}

class PushNotification {
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
  PushNotification({
    required this.title,
    required this.body,
    required this.dataTitle,
    required this.dataBody,
  });
}
