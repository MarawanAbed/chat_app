import 'package:chat_app/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);
  List<UserModel> users = [];
  searchUser(String name) async {
    emit(SearchLoading());
    // Clear the existing search results
    users.clear();

    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        final userData = element.data();
        final userUid = userData['uId'];

        // Exclude the current user locally
        if (userUid == currentUserUid) {
          users.add(UserModel.fromJson(userData));
        }
      });
      emit(SearchSuccess());
    }).catchError((error) {
      emit(SearchFailure(error.toString()));
    });
  }



}
