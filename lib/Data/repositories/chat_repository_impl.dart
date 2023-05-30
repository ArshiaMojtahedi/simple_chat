import 'package:dartz/dartz.dart';

import '../../Domain/repositories/chat_repository.dart';
import '../data_provider.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final DataProvider dataProvider;

  ChatRepositoryImpl(this.dataProvider);

  @override
  Future<Either<Exception, List<ChatModel>>> getChatList() async {
    try {
      final List<Map<String, dynamic>> chatListData =
          await dataProvider.fetchChatList();
      final List<ChatModel> chatList =
          chatListData.map((data) => ChatModel.fromJson(data)).toList();
      return Right(chatList);
    } catch (e) {
      return Left(Exception('Failed to get chat list: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MessageModel>>> getChatDetails(
      String chatId) async {
    try {
      final Map<String, dynamic> chatDetailsData =
          await dataProvider.fetchChatDetails(chatId);
      final List<MessageModel> messages = [
        MessageModel.fromJson(chatDetailsData)
      ];
      return Right(messages);
    } catch (e) {
      return Left(Exception('Failed to get chat details: $e'));
    }
  }
}
