import 'package:chat_app/model/model.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  List<UserModel> userModel = [];

  final currentUser = FirebaseAuth.instance.currentUser;

  // Add a flag to track if data has been loaded
  bool dataLoaded = false;

  getUserData(){
    emit(HomeGetLoading());
    if (!dataLoaded) {
      FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastActive', descending: true)
          .where('uId', isEqualTo: currentUser!.uid)
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        userModel =
            users.docs.map((e) => UserModel.fromJson(e.data())).toList();

        // Emit success state only if data is loaded
        if (!dataLoaded) {
          dataLoaded = true;
          emit(HomeGetSuccess());
        }
      }).onError((error) {
        emit(HomeGetFailure(Utils.showSnackBar(error.toString())));
      });
    }
  }

  updateUserData(Map<String,dynamic>data)async
  {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }
}
