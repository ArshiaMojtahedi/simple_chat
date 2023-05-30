import 'package:dartz/dartz.dart';
import 'package:simple_chat/Data/models/message_model.dart';

import '../repositories/chat_repository.dart';

class GetChatDetailsUseCase {
  final ChatRepository chatRepository;

  GetChatDetailsUseCase({required this.chatRepository});

  Future<Either<Exception, List<MessageModel>>> call(String chatId) async {
    return await chatRepository.getChatDetails(chatId);
  }
}
