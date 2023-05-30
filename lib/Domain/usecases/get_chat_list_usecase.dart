import 'package:dartz/dartz.dart';
import 'package:simple_chat/Data/models/chat_model.dart';

import '../repositories/chat_repository.dart';

class GetChatListUseCase {
  final ChatRepository chatRepository;

  GetChatListUseCase({required this.chatRepository});

  Future<Either<Exception, List<ChatModel>>> call() async {
    return await chatRepository.getChatList();
  }
}
