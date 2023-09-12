import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  static SignInCubit get(context) => BlocProvider.of(context);
  bool isVisible = true;
  IconData suffix = Icons.visibility_outlined;

  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoading());
    try {
       await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .update({'isOnline': true, 'lastActive': DateTime.now()});
        emit(SignInSucessfull());
       }).catchError((er)
       {
         emit(SignInError(Utils.showSnackBar(er.toString())));
       });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SignInError(Utils.showSnackBar('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        emit(SignInError(
            Utils.showSnackBar('Wrong password provided for that user.')));
      }
      emit(SignInError(Utils.showSnackBar(e.toString())));
    }
  }
  updateUserData(Map<String,dynamic>data)async
  {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }
  void changePasswordVisibility() {
    isVisible = !isVisible;
    suffix =
    isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SignInChangePasswordVisibility());
  }
}
