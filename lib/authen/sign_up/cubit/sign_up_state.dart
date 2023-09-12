part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}


class SignUpChangePasswordVisibility extends SignUpState {}

class SignUpCreateUserSuccessState extends SignUpState {}
class SignUpCreateUserFailureState extends SignUpState {
  final String message;

  SignUpCreateUserFailureState(this.message);

}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure(this.error);

}
