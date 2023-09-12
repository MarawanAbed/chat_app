import 'dart:io';
import 'package:chat_app/chat_app/cubit/message_cubit.dart';
import 'package:chat_app/chat_app/widget/chat_message.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var messageController = TextEditingController();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userModel.image),
            ),
            const SizedBox(
              width: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.userModel.name),
                Text(
                  widget.userModel.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.userModel.isOnline
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocProvider(
                create: (context) => MessageCubit()..getMessage(widget.userModel.uId),
                child: ChatMessage(
                  receiverId: widget.userModel.uId,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    _sendText(context);
                  },
                  child: const Icon(Icons.send),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    _sendImage(context);
                  },
                  child: const Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendText(context) async {
    final messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty) {
      await addTextMessage(
        receiverId: widget.userModel.uId,
        content: messageContent,
      );
      messageController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _sendImage(context) async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      setState(() {
        file = imageFile;
      });
      await addImageMessage(
        receiverId: widget.userModel.uId,
        content: await imageFile.readAsBytes(),
      );
    }
  }

  Future<void> addTextMessage({
    required String receiverId,
    required String content,
  }) async {
    final message = MessageModel(
      senderId: FirebaseAuth.instance.currentUser!.uid,
      receiverId: receiverId,
      content: content,
      sendTime: DateTime.now(),
      messageType: MessageType.text,
    );
    await _addMessage(receiverId, message);
  }

  Future<void> addImageMessage({
    required String receiverId,
    required List<int> content,
  }) async {
    final image = await uploadImage(content, 'chat_images/${DateTime.now()}');
    final message = MessageModel(
      senderId: FirebaseAuth.instance.currentUser!.uid,
      receiverId: receiverId,
      content: image,
      sendTime: DateTime.now(),
      messageType: MessageType.image,
    );
    await _addMessage(receiverId, message);
  }

  Future<void> _addMessage(String receiverId, MessageModel message) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<String> uploadImage(List<int> file, String storagePath) async {
    final task = await FirebaseStorage.instance
        .ref()
        .child(storagePath)
        .putData(Uint8List.fromList(file));
    return await task.ref.getDownloadURL();
  }
}
