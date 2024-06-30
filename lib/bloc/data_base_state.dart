// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'data_base_bloc.dart';

@immutable
abstract class InternetState {}

class InternetInitial extends InternetState {}

class ConnectedState extends InternetState {
  final String message;

  ConnectedState({required this.message});
}

class NotConnectedState extends InternetState {
  final String message;

  NotConnectedState({required this.message});
}

@immutable
sealed class DataBaseState {}

final class DataBaseInitial extends DataBaseState {}

final class DataBaseLoaded extends DataBaseState {
  final List<UsersInformationModel> UserData;
  final UsersInformationModel My_Data;
  DataBaseLoaded({required this.UserData, required this.My_Data});
  // List<Object> get props => [MyData, MyData];
}

class MyDataState extends DataBaseState {
  final UsersInformationModel My_Data;
  MyDataState({required this.My_Data});
}

class MyInformationState extends DataBaseState {
  final UsersInformationModel MyInfo;
  final int MyImagesNumber;
  final List<AllMyImage> MyImages;
  final String MyUserId;

  MyInformationState(
      {required this.MyInfo,
      required this.MyImagesNumber,
      required this.MyImages,
      required this.MyUserId});
}

class ConnectionError extends DataBaseState {
  final String message;
  ConnectionError({required this.message});
}

class DidIAddTheFriendState extends DataBaseState {
  final bool isMyFriend;
  final bool isConfirmed;

  final bool isMyFavorite;
  DidIAddTheFriendState(
      {required this.isMyFriend,
      required this.isConfirmed,
      required this.isMyFavorite});
}

class GetALLMessagesState extends DataBaseState {
  final List<GetALLMessages> AllMessages;
  final String? MyEmail;
  GetALLMessagesState({
    required this.AllMessages,
    required this.MyEmail,
  });
}

class GetALLNotificationsState extends DataBaseState {
  List<GetALLNotifications> AllNotifications;

  GetALLNotificationsState({
    required this.AllNotifications,
  });
}

class GetVisitorsState extends DataBaseState {
  List<VisitorsModel> AllVisitors;
  List<int> RepeatingNumbers;
  GetVisitorsState({
    required this.AllVisitors,
    required this.RepeatingNumbers,
  });
}

class ALLRequestState extends DataBaseState {
  final List<GetALLMessages> AllMessages;
  ALLRequestState({required this.AllMessages});
}

@immutable
abstract class OfflineDataState {}

class OfflineDataInitial extends OfflineDataState {}

class DataState extends OfflineDataState {
  final UsersInformationModel My_Data;
  MyDataModle MyData;
  DataState({
    required this.MyData,
    required this.My_Data,
  });
}
