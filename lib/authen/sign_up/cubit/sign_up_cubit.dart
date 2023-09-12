import 'package:chat_app/model/model.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  bool isVisible = true;
  IconData suffix = Icons.visibility_outlined;

  void userRegister(
      {required String email,
      required String password,
      required String userName}) async {
    emit(SignUpLoading());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        name: userName,
        email: email,
        uId: value.user!.uid,
      );
      emit(SignUpSuccess());
    }).catchError((error) {
      emit(SignUpFailure(Utils.showSnackBar(error.toString())));
    });
  }

  void changePasswordVisibility() {
    isVisible = !isVisible;
    suffix =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SignUpChangePasswordVisibility());
  }

  void userCreate({
    required String name,
    required String email,
    required String uId,
  }) {
    UserModel model = UserModel(
      uId: uId,
      name: name,
      email: email,
      image:
          'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
      lastActive: DateTime.now(),
      isOnline: true,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toJson())
        .then((value) {
      emit(SignUpCreateUserSuccessState());
    }).catchError((error) {
      emit(SignUpCreateUserFailureState(Utils.showSnackBar(error.toString())));
    });
  }
}
