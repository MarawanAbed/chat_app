import 'package:chat_app/chat_app/cubit/message_cubit.dart';
import 'package:chat_app/chat_app/widget/message_bubble.dart';
import 'package:chat_app/model/message_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key, required this.receiverId,});

  final String receiverId;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {


  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          var cubit = MessageCubit.get(context);
          return ListView.builder(
            itemCount: cubit.messageModel.length,
            itemBuilder: (context, index) {
              //description: check if the message is sent by me or not
              //why i make equal ?
              //because i want to make the message sent by me on the right side
              //and the message sent by the other on the left side if not equal it will be on the left side
              final isMe = cubit.messageModel[index].senderId ==
                  widget.receiverId;
              final isTextMessage = cubit.messageModel[index].messageType ==
                  MessageType.textType;
              return isTextMessage
                  ? MessageBubble(
                messageModel: cubit.messageModel[index],
                isMe: isMe,
                isImage: false,
              )
                  : MessageBubble(
                messageModel: cubit.messageModel[index],
                isMe: isMe,
                isImage: true,
              );
            },
          );
        },
      );
}
