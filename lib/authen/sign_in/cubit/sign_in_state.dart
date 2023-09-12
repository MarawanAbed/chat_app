part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}



class SignInChangePasswordVisibility extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSucessfull extends SignInState {}

class SignInError extends SignInState {
  final String error;

  SignInError(this.error);

}

class SignInUpdateUserSuccess extends SignInState {}
class SignInUpdateUserFailure extends SignInState {
  final String message;

  SignInUpdateUserFailure(this.message);

}
