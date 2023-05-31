part of 'chat_list_cubit.dart';

@immutable
abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatModel> chatList;

  ChatListLoaded(this.chatList);
}

class ChatListError extends ChatListState {
  final String message;

  ChatListError(this.message);
}
