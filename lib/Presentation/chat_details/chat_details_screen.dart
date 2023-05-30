import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_chat/Data/models/chat_model.dart';
import 'package:simple_chat/Presentation/chat_details/cubit/chat_details_cubit.dart';

class ChatDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments;

    return BlocProvider<ChatDetailsCubit>(
      create: (ctx) => GetIt.instance.get(),
      child: _ChatDetailsScreen(arguments),
    );
  }
}

late ChatDetailsCubit _bloc;

class _ChatDetailsScreen extends StatelessWidget {
  var arguments;
  _ChatDetailsScreen(this.arguments);
  @override
  Widget build(BuildContext context) {
    _bloc = context.read();
    _bloc.fetchChatDetails('999${arguments[0]['index'] + 1}');

    ChatModel chatItem = arguments[1]['chatItem'];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                child: Text('A'),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatItem.topic,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    chatItem.members
                        .toString()
                        .substring(1, chatItem.members.toString().length - 1),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
          builder: (context, state) {
            if (state is ChatDetailsLoading) {
              return const CircularProgressIndicator();
            } else if (state is ChatDetailsLoaded) {
              return Container(
                margin: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: state.messages[index].message,
                      isSender: false,
                    );
                  },
                ),
              );
            } else if (state is ChatDetailsError) {
              return Text(state.message);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({
    required this.message,
    required this.isSender,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
