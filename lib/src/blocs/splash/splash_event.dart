part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

// class Initialize extends SplashEvent {
//   Initialize();
// }

class NavigateToHomeEvent extends SplashEvent {}

class LocationSelection extends SplashEvent {
  final List<LocationData>? locations;
  LocationSelection({required this.locations});
  List<Object> get props => [];
}