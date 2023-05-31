import 'package:dartz/dartz.dart';

import '../../Data/models/chat_model.dart';
import '../../Data/models/message_model.dart';

abstract class ChatRepository {
  Future<Either<Exception, List<ChatModel>>> getChatList();
  Future<Either<Exception, List<MessageModel>>> getChatDetails(String chatId);
}
