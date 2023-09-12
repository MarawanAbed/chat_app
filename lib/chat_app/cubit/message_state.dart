part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}
class MessageScrollDown extends MessageState {}
class MessageLoading extends MessageState {}
class MessageSuccess extends MessageState {}
class MessageFailure extends MessageState {
  final String error;

  MessageFailure(this.error);
}
