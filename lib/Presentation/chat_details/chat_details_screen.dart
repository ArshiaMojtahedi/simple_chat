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

class _ChatDetailsScreen extends StatefulWidget {
  final arguments;
  _ChatDetailsScreen(this.arguments);

  @override
  _ChatDetailsScreenState createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<_ChatDetailsScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = context.read();
    _bloc.fetchChatDetails('999${widget.arguments[0]['index'] + 1}');

    ChatModel chatItem = widget.arguments[1]['chatItem'];

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
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
                builder: (context, state) {
                  if (state is ChatDetailsLoading) {
                    return CircularProgressIndicator();
                  } else if (state is ChatDetailsLoaded) {
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    return Container(
                      margin: EdgeInsets.all(16),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final isSender = message.sender == 'Me';

                          return ChatBubble(
                            message: message.message,
                            isSender: isSender,
                          );
                        },
                      ),
                    );
                  } else if (state is ChatDetailsError) {
                    return Text(state.message);
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                      ),
                      maxLines: null, // Allow multiple lines
                      keyboardType:
                          TextInputType.multiline, // Enable multiline keyboard
                      textInputAction:
                          TextInputAction.send, // Set return key to send
                      onSubmitted: (message) {
                        if (message.isNotEmpty) {
                          _bloc.sendMessage(message);
                          _textEditingController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = _textEditingController.text.trim();
                      if (message.isNotEmpty) {
                        _bloc.sendMessage(message);
                        _textEditingController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
