import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListInitial());
}
