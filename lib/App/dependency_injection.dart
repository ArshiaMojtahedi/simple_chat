import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../Data/data_provider.dart';
import '../Data/models/chat_model.dart';
import '../Data/models/message_model.dart';
import '../Data/repositories/chat_repository_impl.dart';
import '../Domain/repositories/chat_repository.dart';
import '../Domain/usecases/get_chat_details_usecase.dart';
import '../Domain/usecases/get_chat_list_usecase.dart';
import '../Presentation/chat_details/cubit/chat_details_cubit.dart';
import '../Presentation/chat_list/cubit/chat_list_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Register data provider
  sl.registerLazySingleton<DataProvider>(
    () => DataProvider(),
  );

  // Register repositories
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<DataProvider>()),
  );

  // Register use cases
  sl.registerLazySingleton<GetChatListUseCase>(
    () => GetChatListUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton<GetChatDetailsUseCase>(
    () => GetChatDetailsUseCase(chatRepository: sl<ChatRepository>()),
  );

  // Register cubits
  sl.registerFactory<ChatListCubit>(
    () => ChatListCubit(getChatListUseCase: sl<GetChatListUseCase>()),
  );
  sl.registerFactory<ChatDetailsCubit>(
    () => ChatDetailsCubit(getChatDetailsUseCase: sl<GetChatDetailsUseCase>()),
  );
}
