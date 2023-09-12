
import 'package:chat_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit() : super(EmailVerificationInitial());
  static EmailVerificationCubit get(context) => BlocProvider.of(context);

  void sendEmailVerification() async {
    try {
      emit(EmailVerificationSent());
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      emit(EmailVerificationComplete());
    } on FirebaseAuthException catch (e) {
      emit(EmailVerificationError(Utils.showSnackBar(e.toString())));
    }
  }

  void checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      emit(EmailVerificationComplete());
    }
  }



}
