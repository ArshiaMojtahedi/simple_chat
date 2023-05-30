import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_chat/Data/models/chat_model.dart';
import 'package:simple_chat/Presentation/chat_details/chat_details_screen.dart';
import 'package:simple_chat/Presentation/chat_list/cubit/chat_list_cubit.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Header(),
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
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
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
          (chatItem.members.length == 1)
              ? const CircleAvatar(
                  radius: 28,
                  child: Text('A'),
                )
              : AvatarStack(
                  height: 33,
                  width: 56,
                  avatars: [
                    for (var n = 0; n < chatItem.members.length; n++)
                      NetworkImage('https://i.pravatar.cc/150?img=$n'),
                  ],
                ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatItem.topic,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                chatItem.lastMessage,
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
            const CircleAvatar(
              radius: 20,
              child: Text('A'),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              'Chats',
              style: Theme.of(context).textTheme.labelLarge,
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
