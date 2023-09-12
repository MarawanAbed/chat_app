import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  static MessageCubit get(context) => BlocProvider.of(context);

  List<MessageModel> messageModel = [];
  bool dataLoaded = false;

  getMessage(String receiverId) {
    emit(MessageLoading());
    if (!dataLoaded) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .orderBy('sendTime', descending: false)
          .snapshots(includeMetadataChanges: true)
          .listen((messageModel) {
        this.messageModel = messageModel.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();
        if (!dataLoaded) {
          dataLoaded = true;
          emit(MessageSuccess());
        }
      }).onError((error) {
        emit(MessageFailure(Utils.showSnackBar(error.toString())));
      });
    }
  }


}
