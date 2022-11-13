part of 'map_bloc.dart';

@immutable
abstract class MapState extends Equatable {}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class LoadingMap extends MapState {
  @override
  List<Object?> get props => [];
}

class Loaded extends MapState {
  @override
  List<Object?> get props => [];
}