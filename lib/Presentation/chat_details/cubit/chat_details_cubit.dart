import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_chat/Data/models/message_model.dart';

import '../../../Domain/usecases/get_chat_details_usecase.dart';

part 'chat_details_state.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  final GetChatDetailsUseCase getChatDetailsUseCase;

  ChatDetailsCubit({required this.getChatDetailsUseCase})
      : super(ChatDetailsInitial());

  Future<void> fetchChatDetails(String chatId) async {
    emit(ChatDetailsLoading());
    final result = await getChatDetailsUseCase(chatId);
    result.fold(
      (exception) => emit(ChatDetailsError(exception.toString())),
      (messages) => emit(ChatDetailsLoaded(messages)),
    );
  }
}
