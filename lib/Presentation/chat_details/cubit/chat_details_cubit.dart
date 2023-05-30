import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_chat/Data/models/message_model.dart';

import '../../../Domain/usecases/get_chat_details_usecase.dart';

part 'chat_details_state.dart';

//There are comments on this screen to show how the detail cubit is working :)

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  final GetChatDetailsUseCase getChatDetailsUseCase;

  ChatDetailsCubit({required this.getChatDetailsUseCase})
      : super(ChatDetailsInitial());

  List<MessageModel> messages = [];

  Future<void> fetchChatDetails(String chatId) async {
    emit(ChatDetailsLoading());

    // Fetch chat details
    final result = await getChatDetailsUseCase(chatId);
    result.fold(
      (exception) => emit(ChatDetailsError(exception.toString())),
      (fetchedMessages) {
        // Add fetched messages to the list
        messages.addAll(fetchedMessages);
        emit(ChatDetailsLoaded(messages));
      },
    );
  }

  void sendMessage(String message) {
    // Create a new MessageModel object
    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      modifiedAt: DateTime.now().millisecondsSinceEpoch,
      sender: 'Me',
    );

    // Add the new message to the list
    messages.add(newMessage);

    // Emit the updated state with the messages list
    emit(ChatDetailsLoaded(messages));

    // Simulate receiving a response after a short delay
    Future.delayed(Duration(seconds: 2), () {
      final response = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Received: $message',
        modifiedAt: DateTime.now().millisecondsSinceEpoch,
        sender: 'Chat Bot', // Assuming the sender is 'Chat Bot'
      );

      // Add the response message to the list
      messages.add(response);

      // Emit the updated state with the messages list
      emit(ChatDetailsLoaded(messages));
    });
  }
}
