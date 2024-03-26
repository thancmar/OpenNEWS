part of 'splash_bloc.dart';

@immutable
abstract class SplashState {
  // static late List<LocationData> allNearbyLocations =
  //     []; //This is list of all location nearby(if any)
}

class Initial extends SplashState {}


class SkipLogin extends SplashState {
  final String email;
  final String pwd;
  SkipLogin(this.email, this.pwd) : super();
}

class SkipLoginIncomplete extends SplashState {
  final String email;
  final String pwd;
  SkipLoginIncomplete(this.email, this.pwd) : super();
}

class Loaded extends SplashState {
  Loaded();
}

class SplashError extends SplashState {
  final String error;
  final Position? position;
  SplashError(this.error, [this.position]) : super();
}