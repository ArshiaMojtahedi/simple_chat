import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_chat/Data/models/chat_model.dart';

import '../../../Domain/usecases/get_chat_list_usecase.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatListUseCase getChatListUseCase;

  ChatListCubit({required this.getChatListUseCase}) : super(ChatListInitial());

  Future<void> fetchChatList() async {
    emit(ChatListLoading());
    final result = await getChatListUseCase();
    result.fold(
      (exception) => emit(ChatListError(exception.toString())),
      (chatList) => emit(ChatListLoaded(chatList)),
    );
  }
}
