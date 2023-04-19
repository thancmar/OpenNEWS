part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class Initial extends SplashState {}

class LoadingSplash extends SplashState {}

class SkipLogin extends SplashState {
  final String email;
  final String pwd;

// GoToHome([this.magazinePublishedGetLastWithLimit, this.location, this.futureFunc]);
  SkipLogin(this.email, this.pwd) : super();
}

class Loaded extends SplashState {
  final Position? position;

  Loaded([this.position]) : super();
}