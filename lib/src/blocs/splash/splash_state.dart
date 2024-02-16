part of 'splash_bloc.dart';

@immutable
abstract class SplashState {
  // static late Data? appbarlocation =
  //     Data(); //This is the global location for the App
  static late List<LocationData> allNearbyLocations =
      []; //This is list of all location nearby(if any)
}

class Initial extends SplashState {}
//
// class LoadingSplash extends SplashState {}

class SkipLogin extends SplashState {
  final String email;
  final String pwd;
  // final Data? currentLocation;
// GoToHome([this.magazinePublishedGetLastWithLimit, this.location, this.futureFunc]);
  SkipLogin(this.email, this.pwd) : super();
}

class SkipLoginIncomplete extends SplashState {
  final String email;
  final String pwd;
  // final Data? currentLocation;
// GoToHome([this.magazinePublishedGetLastWithLimit, this.location, this.futureFunc]);
  SkipLoginIncomplete(this.email, this.pwd) : super();
}

class Loaded extends SplashState {
  // final Position? position;
  // final Data? currentLocation;
  // Loaded([this.position]) : super();
  Loaded();
}

// class GoToLocationSelection extends SplashState {
//   final List<Data>? locations_GoToLocationSelection;
//   GoToLocationSelection(this.locations_GoToLocationSelection) : super();
//
//   @override
//   List<Object> get props => [];
// }

class SplashError extends SplashState {
  final String error;
  final Position? position;

  SplashError(this.error, [this.position]) : super();
}