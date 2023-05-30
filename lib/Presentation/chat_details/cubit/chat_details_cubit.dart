import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_details_state.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  ChatDetailsCubit() : super(ChatDetailsInitial());
}
