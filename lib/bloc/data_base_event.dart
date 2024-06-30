// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'data_base_bloc.dart';

@immutable
abstract class InternetEvent {}

class ConnectedEvent extends InternetEvent {}

class NotConnectedEvent extends InternetEvent {}

@immutable
sealed class DataBaseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUsersDataEvent extends DataBaseEvent {
  final String? Email;
  GetUsersDataEvent({required this.Email});
}

class GetMyDataEvent extends DataBaseEvent {
  final UsersInformationModel My_Data;
  GetMyDataEvent({required this.My_Data});
}

class GetMyInfoEvent extends DataBaseEvent {}

// class AddImageEvent extends DataBaseEvent {
//   final Reference ref;
//   final File file;
//   String MyUserId;
//   AddImageEvent(
//       {required this.ref, required this.file, required this.MyUserId});
// }
class AddImageEvent extends DataBaseEvent {
  ImageSource imageway;
  String MyUserId;
  BuildContext context;

  AddImageEvent({
    required this.imageway,
    required this.MyUserId,
    required this.context,
  });
}

class DidIAddTheFriendEvent extends DataBaseEvent {
  UsersInformationModel MyData;
  UsersInformationModel UsersData;
  DidIAddTheFriendEvent({required this.MyData, required this.UsersData});
}

class AddFriendEvent extends DataBaseEvent {
  UsersInformationModel MyData;
  UsersInformationModel UsersData;
  AddFriendEvent({required this.MyData, required this.UsersData});
}

class DeleteAddFriendEvent extends DataBaseEvent {
  String MyEmail;
  String UserEmail;
  DeleteAddFriendEvent({required this.MyEmail, required this.UserEmail});
}

class AddFavoriteEvent extends DataBaseEvent {
  String MyEmail;
  String UserEmail;
  AddFavoriteEvent({required this.MyEmail, required this.UserEmail});
}

class DeleteFavoriteEvent extends DataBaseEvent {
  String MyEmail;
  String UserEmail;
  DeleteFavoriteEvent({required this.MyEmail, required this.UserEmail});
}

class AddMessageEvent extends DataBaseEvent {
  UsersInformationModel MyData;
  UsersInformationModel UsersData;
  String TextMessage;
  String UserState;
  AddMessageEvent(
      {required this.MyData,
      required this.UsersData,
      required this.TextMessage,
      required this.UserState});
}

class LastUpdateMessageEvent extends DataBaseEvent {
  UsersInformationModel MyData;
  UsersInformationModel UsersData;
  String TextMessage;

  LastUpdateMessageEvent(
      {required this.MyData,
      required this.UsersData,
      required this.TextMessage});
}

class AddNotificationEvent extends DataBaseEvent {
  UsersInformationModel MyData;
  UsersInformationModel UsersData;
  String TextMessage;

  AddNotificationEvent(
      {required this.MyData,
      required this.UsersData,
      required this.TextMessage});
}

class UpdateStateMessagesEvent extends DataBaseEvent {
  String MyEmail;
  String UsersEmail;
  String CurrentPage;

  UpdateStateMessagesEvent({
    required this.MyEmail,
    required this.UsersEmail,
    required this.CurrentPage,
  });
}

class GetALLMessagesEvent extends DataBaseEvent {
  String MyEmail;
  GetALLMessagesEvent({required this.MyEmail});
}

class GetALLNotificationsEvent extends DataBaseEvent {
  String MyEmail;
  GetALLNotificationsEvent({required this.MyEmail});
}

class ALLMyFriendsEvent extends DataBaseEvent {
  String? MyEmail;
  ALLMyFriendsEvent({required this.MyEmail});
}

class GetVisitorsEvent extends DataBaseEvent {
  String MyEmail;
  GetVisitorsEvent({required this.MyEmail});
}

class GetRequestEvent extends DataBaseEvent {
  String MyEmail;
  GetRequestEvent({required this.MyEmail});
}

class AcceptFriendEvent extends DataBaseEvent {
  String MyEmail;
  String SenderEmail;
  AcceptFriendEvent({required this.MyEmail, required this.SenderEmail});
}

class SignUpEvent extends DataBaseEvent {
  String Username;
  String Email;
  String Password;
  String UserType;
  BuildContext context;
  SignUpEvent(
      {required this.Username,
      required this.Email,
      required this.Password,
      required this.UserType,
      required this.context});
}

class SignInEvent extends DataBaseEvent {
  String Email;
  String Password;
  BuildContext context;

  SignInEvent(
      {required this.Email, required this.Password, required this.context});
}

class UpdateMyInfomationEvent extends DataBaseEvent {
  final String Email;
  final String Status;
  final String Firstname;
  final String Lastname;
  final String Gender;
  final String Date_of_Birth;
  final String Interested_in;
  final String Look_For;
  final String Eye_Color;
  final String Hair_Color;
  final String Height;
  final String Relationship;
  final String City;
  final String Age;
  final String UserId;
  UpdateMyInfomationEvent({
    required this.Email,
    required this.Status,
    required this.Firstname,
    required this.Lastname,
    required this.Gender,
    required this.Date_of_Birth,
    required this.Interested_in,
    required this.Look_For,
    required this.Eye_Color,
    required this.Hair_Color,
    required this.Height,
    required this.Relationship,
    required this.City,
    required this.Age,
    required this.UserId,
  });
}

@immutable
abstract class OfflineDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MyDataEvent extends OfflineDataEvent {
  final UsersInformationModel My_Data;
  MyDataModle MyData;
  MyDataEvent({
    required this.My_Data,
    required this.MyData,
  });
}
