part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class Initial extends SplashState {}

class Loading extends SplashState {}

class Loaded extends SplashState {}
