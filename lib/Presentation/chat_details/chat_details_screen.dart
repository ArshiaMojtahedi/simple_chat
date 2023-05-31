import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_chat/Data/models/chat_model.dart';
import 'package:simple_chat/Data/models/message_model.dart';
import 'package:simple_chat/Presentation/chat_details/cubit/chat_details_cubit.dart';

import '../../App/date_time_convertor.dart';

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
        backgroundColor: const Color(0xffF0F0F0),
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatItem.topic,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    chatItem.members
                        .toString()
                        .substring(1, chatItem.members.toString().length - 1),
                    style: const TextStyle(fontSize: 14),
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
                    return const SizedBox(
                        width: 500,
                        height: 207,
                        child: CircularProgressIndicator());
                  } else if (state is ChatDetailsLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    return Container(
                      margin: const EdgeInsets.all(16),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final isSender = message.sender == 'Me';

                          return ChatBubble(
                            message: message,
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
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                            top: 20, right: 20, left: 12, bottom: 12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffCCCBC9),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        fillColor: Color(0xffF8F8F8),
                        filled: true,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black26,
                            fontSize: 16),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black45, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
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
  final MessageModel message;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !isSender
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    message.sender + ":",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                )
              : SizedBox(),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  isSender ? const Color(0xffFDCF8C6) : const Color(0xffECE5DD),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              DateTimeUtils.formatTime(message.modifiedAt),
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
