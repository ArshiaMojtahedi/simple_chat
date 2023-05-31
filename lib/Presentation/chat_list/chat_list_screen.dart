import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_chat/Data/models/chat_model.dart';
import 'package:simple_chat/Presentation/chat_details/chat_details_screen.dart';
import 'package:simple_chat/Presentation/chat_list/cubit/chat_list_cubit.dart';

import '../../App/date_time_convertor.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListCubit>(
      create: (ctx) => GetIt.instance.get(),
      child: _ChatListScreen(),
    );
  }
}

late ChatListCubit _bloc;

class _ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _bloc = context.read();
    _bloc.fetchChatList();

    return Scaffold(
      appBar: AppBar(
        title: Header(),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<ChatListCubit, ChatListState>(
                builder: (context, state) {
                  if (state is ChatListLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ChatListLoaded) {
                    return Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) =>
                            ChatListItem(state.chatList[index], index),
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(),
                        ),
                        itemCount: state.chatList.length,
                      ),
                    );
                  } else if (state is ChatListError) {
                    return Text(state.message);
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  ChatModel chatItem;
  int index;
  ChatListItem(this.chatItem, this.index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(ChatDetailsScreen(), arguments: [
        {"index": index},
        {"chatItem": chatItem}
      ]),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.red.shade400,
            child: Text(chatItem.topic.substring(0, 1).toUpperCase()),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatItem.members
                    .toString()
                    .substring(1, chatItem.members.toString().length - 1),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                chatItem.lastMessage +
                    " - " +
                    DateTimeUtils.formatTime(chatItem.modifiedAt),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            const CircleAvatar(
              radius: 20,
              backgroundImage: (kIsWeb)
                  ? AssetImage('profile.jpeg')
                  : AssetImage('assets/profile.jpeg'),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              'Chats',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Colors.white),
            ),
          ],
        ),
        Image.asset(
          'assets/new_message.png',
          width: 40,
        )
      ],
    );
  }
}
