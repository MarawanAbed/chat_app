part of 'email_verification_cubit.dart';

@immutable
abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationSent extends EmailVerificationState {}

class EmailVerificationComplete extends EmailVerificationState {}

class EmailVerificationError extends EmailVerificationState {
  final String errorMessage;

  EmailVerificationError(this.errorMessage);
}