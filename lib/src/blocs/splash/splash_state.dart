part of 'splash_bloc.dart';

@immutable
abstract class SplashState {
  static late Data? appbarlocation = null;
}

class Initial extends SplashState {}

class LoadingSplash extends SplashState {}

class SkipLogin extends SplashState {
  final String email;
  final String pwd;
  final Data? currentLocation;
// GoToHome([this.magazinePublishedGetLastWithLimit, this.location, this.futureFunc]);
  SkipLogin(this.email, this.pwd, this.currentLocation) : super();
}

class Loaded extends SplashState {
  // final Position? position;
  final Data? currentLocation;
  // Loaded([this.position]) : super();
  Loaded({required this.currentLocation});
}

class GoToLocationSelection extends SplashState {
  final List<Data>? locations_GoToLocationSelection;
  GoToLocationSelection(this.locations_GoToLocationSelection) : super();

  @override
  List<Object> get props => [];
}

class SplashError extends SplashState {
  final Position? position;

  SplashError([this.position]) : super();
}