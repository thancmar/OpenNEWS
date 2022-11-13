part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class Initial extends SplashState {}

class LoadingSplash extends SplashState {}

class Loaded extends SplashState {
  final Position? position;

  Loaded([this.position]) : super();
}