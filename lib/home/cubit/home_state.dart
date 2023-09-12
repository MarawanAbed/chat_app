part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeGetLoading extends HomeState {}
class HomeGetSuccess extends HomeState {


}
class HomeGetFailure extends HomeState {
  final String message;

  HomeGetFailure(this.message);

}
