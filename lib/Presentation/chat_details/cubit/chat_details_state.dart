part of 'chat_details_cubit.dart';

@immutable
abstract class ChatDetailsState {}

class ChatDetailsInitial extends ChatDetailsState {}

class ChatDetailsLoading extends ChatDetailsState {}

class ChatDetailsLoaded extends ChatDetailsState {
  final List<MessageModel> messages;

  ChatDetailsLoaded(this.messages);
}

class ChatDetailsError extends ChatDetailsState {
  final String message;

  ChatDetailsError(this.message);
}
