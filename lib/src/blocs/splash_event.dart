part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

// class Initialize extends SplashEvent {
//   Initialize();
// }

class NavigateToHomeEvent extends SplashEvent {}